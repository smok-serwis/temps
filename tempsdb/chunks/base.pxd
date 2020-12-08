from ..series cimport TimeSeries

cdef class BaseChunk:
    cdef:
        TimeSeries parent
        readonly str path
        readonly unsigned long long min_ts
        readonly unsigned long long max_ts
        readonly unsigned long entries
        unsigned long file_size

    cpdef object iterate_indices(self, unsigned long starting_entry, unsigned long stopping_entry)
    cpdef int close(self) except -1
    cdef tuple get_piece_at(self, unsigned int index)
    cpdef int append(self, unsigned long long timestamp, bytes data) except -1
    cdef int sync(self) except -1
    cpdef unsigned int find_left(self, unsigned long long timestamp)
    cpdef unsigned int find_right(self, unsigned long long timestamp)
    cdef int extend(self) except -1
    cpdef int delete(self) except -1
    cpdef int switch_to_descriptor_based_access(self) except -1
    cpdef unsigned long get_mmap_size(self)

    cdef inline unsigned long long name(self):
        """
        :return: the name of this chunk
        :rtype: int 
        """
        return self.min_ts

    cdef inline int length(self):
        """
        :return: amount of entries in this chunk
        :rtype: int 
        """
        return self.entries

    cdef unsigned long long get_timestamp_at(self, unsigned int index)

