import os
import threading

from satella.coding import DictDeleter

from tempsdb.exceptions import DoesNotExist, AlreadyExists
from .series cimport TimeSeries, create_series


cdef class Database:
    """
    A basic TempsDB object.

    :param path: path to the directory with the database

    :ivar path: path to  the directory with the database (str)
    """
    def __init__(self, path: str):
        self.path = path
        self.closed = False
        self.open_series = {}
        self.lock = threading.Lock()
        self.mpm = None

    cpdef list get_open_series(self):
        """
        Return all open series
        
        .. versionadded:: 0.2
        
        :return: open series
        :rtype: tp.List[TimeSeries]
        """
        cdef:
            list output = []
            TimeSeries series
            str name
        with self.lock:
            with DictDeleter(self.open_series) as dd:
                for name, series in dd.items():
                    if series.closed:
                        dd.delete()
                    else:
                        output.append(series)
        return series

    cpdef TimeSeries get_series(self, name: str, bint use_descriptor_based_access = False):
        """
        Load and return an existing series
        
        :param name: name of the series
        :type name: str
        
        .. versionadded:: 0.2
        
        :param use_descriptor_based_access: whether to use descriptor based access instead of mmap, 
            default is False
        :type use_descriptor_based_access: bool 
        :return: a loaded time series
        :rtype: TimeSeries
        :raises DoesNotExist: series does not exist
        """
        cdef:
            TimeSeries result
            str path
        if name in self.open_series:
            result = self.open_series[name]
        else:
            path = os.path.join(self.path, name)
            with self.lock:
                # Check a second time due to the lock
                if name in self.open_series:
                    if self.open_series[name].closed:
                        del self.open_series[name]
                        return self.open_series(name)
                    return self.open_series[name]
                if not os.path.isdir(path):
                    raise DoesNotExist('series %s does not exist' % (name, ))
                self.open_series[name] = result = TimeSeries(path, name,
                                                             use_descriptor_based_access=use_descriptor_based_access)
                if self.mpm is not None:
                    result.register_memory_pressure_manager(self.mpm)
        return result

    cpdef int close_all_open_series(self) except -1:
        """
        Closes all open series
                
        .. versionadded:: 0.2        
        """
        cdef TimeSeries series
        with self.lock:
            for series in self.open_series.values():
                series.close()
            self.open_series = {}
        return 0

    cpdef unsigned long long get_first_entry_for(self, str name):
        """
        Get first timestamp stored in a particular series without opening it
                        
        .. versionadded:: 0.2
        
        :param name: series name
        :type name: str
        :return: first timestamp stored in this series
        :rtype: int
        :raises DoesNotExist: series does not exist
        :raises ValueError: timestamp does not have any data
        """
        cdef str path = os.path.join(self.path, name)
        if not os.path.isdir(path):
            raise DoesNotExist('series does not exist')
        cdef:
            unsigned long long minimum_ts = 0xFFFFFFFFFFFFFFFF
            list files = os.listdir(path)
            unsigned long long candidate_ts
        if len(files) == 1:
            raise ValueError('Timestamp does not have any data')
        for name in files:
            try:
                candidate_ts = int(name)
            except ValueError:
                continue
            if candidate_ts < minimum_ts:
                minimum_ts = candidate_ts
        return minimum_ts

    cpdef list get_all_series(self):
        """
        Stream all series available within this database
                
        .. versionadded:: 0.2
        
        :return: a list of series names
        :rtype: tp.List[str]
        """
        return os.listdir(self.path)

    cpdef TimeSeries create_series(self, str name, int block_size,
                                   unsigned long entries_per_chunk,
                                   int page_size=4096,
                                   bint use_descriptor_based_access=False):
        """
        Create a new series
        
        :param name: name of the series
        :type name: str
        :param block_size: size of the data field
        :type block_size: int
        :param entries_per_chunk: entries per chunk file
        :type entries_per_chunk: int
        :param page_size: size of a single page. Default is 4096
        :type page_size: int
            
        .. versionadded:: 0.2
        
        :param use_descriptor_based_access: whether to use descriptor based access instead of mmap.
            Default is False
        :type use_descriptor_based_access: bool
        :return: new series
        :rtype: TimeSeries
        :raises ValueError: block size was larger than page_size plus a timestamp
        :raises AlreadyExists: series with given name already exists
        """
        if block_size > page_size + 8:
            raise ValueError('Invalid block size, pick larger page')
        if os.path.isdir(os.path.join(self.path, name)):
            raise AlreadyExists('Series already exists')
        cdef TimeSeries series = create_series(os.path.join(self.name, name), name,
                                               block_size,
                                               entries_per_chunk, page_size=page_size,
                                               use_descriptor_based_access=use_descriptor_based_access)
        self.open_series[name] = series
        return series

    cpdef int register_memory_pressure_manager(self, object mpm) except -1:
        """
        Register a satella MemoryPressureManager_ to close chunks if low on memory.
        
        .. _MemoryPressureManager: https://satella.readthedocs.io/en/latest/instrumentation/memory.html
        
        :param mpm: MemoryPressureManager to use
        :type mpm: satella.instrumentation.memory.MemoryPressureManager
        """
        self.mpm = mpm
        cdef TimeSeries series
        for series in self.open_series.values():
            series.register_memory_pressure_manager(mpm)    # no-op if already closed
        return 0

    def __del__(self):
        self.close()

    cpdef int close(self) except -1:
        """
        Close this TempsDB database
        """
        if self.closed:
            return 0
        cdef TimeSeries series
        with self.lock:
            for series in self.open_series.values():
                series.close()  # because already closed series won't close themselves
            self.open_series = {}
        self.closed = True
        return 0


cpdef Database create_database(str path):
    """
    Creates a new, empty database
    
    :param path: path where the DB directory will be put
    :type path: str
    :return: a Database object
    :rtype: Database
    :raises AlreadyExists: the directory exists
    """
    if os.path.exists(path):
        raise AlreadyExists('directory already exists')
    os.mkdir(path)
    return Database(path)
