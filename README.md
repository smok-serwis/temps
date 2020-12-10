# tempsdb

[![PyPI](https://img.shields.io/pypi/pyversions/tempsdb.svg)](https://pypi.python.org/pypi/tempsdb)
[![PyPI version](https://badge.fury.io/py/tempsdb.svg)](https://badge.fury.io/py/tempsdb)
[![PyPI](https://img.shields.io/pypi/implementation/tempsdb.svg)](https://pypi.python.org/pypi/tempsdb)
[![Documentation Status](https://readthedocs.org/projects/tempsdb/badge/?version=latest)](http://tempsdb.readthedocs.io/en/latest/?badge=latest)
[![Maintainability](https://api.codeclimate.com/v1/badges/657b03d115f6e001633c/maintainability)](https://codeclimate.com/github/smok-serwis/tempsdb/maintainability)
[![Build status](https://circleci.com/gh/smok-serwis/tempsdb.svg?style=shield)](https://app.circleci.com/pipelines/github/smok-serwis/tempsdb)
[![Wheel](https://img.shields.io/pypi/wheel/tempsdb.svg)](https://pypi.org/project/tempsdb/)

Embedded Cython library for time series that you need to upload somewhere.

Stored time series with a 8-bit timestamp and a fixed length of data.
So no variable encoding for you!

# Installation

```bash
git clone https://github.com/smok-serwis/tempsdb
cd tempsdb
pip install snakehouse satella
python setup.py install
```

You need both [snakehouse](https://pypi.org/project/snakehouse/1.2.2/)
and [satella](https://pypi.org/project/satella/) to compile it from the source,
though wheels for Linux x86_64 Python 3.7 and Python 3.8
and Linux ARMv7l Python 3.7 and Python 3.8 are available
on PyPI.

If you're installing it somewhere that you don't need both snakehouse
and satella installed, compile your own binary wheel with

```
python setup.py bdist_wheel
```

Then copy your resulting wheel and install it via pip on the target system.

# Changelog

## v0.4.5

* _TBA_

## v0.4.4

* more error conditions during mmap will be supported as well
* ENOMEM will be correctly handled during resize operation
* added `TimeSeries.descriptor_based_access`
* added `Chunk.switch_to_mmap_based_access`

## v0.4.3

* iterating and writing at the same time from multiple threads
    made safe
* added `TimeSeries.disable_mmap`
* `Iterator`'s destructor will emit a warning if you forget to close it explicitly.

## v0.4.2

* empty series will return an Iterator
* **bugfix release** fixed `Database.create_series`
* `Database` constructor will throw if no database is there
* changed `Iterator.next` to `Iterator.next_item`, 
  synce Cython guys said to not implement the method `next`
  on iterators.

## v0.4.1

* **bugfix release** fixed `get_open_series`

## v0.4

* can install from sdist now

## v0.3

* added `TimeSeries.get_current_value`
* added `Database.sync`

## v0.2

* added `get_open_series`
* added `get_all_series`
* added `get_first_entry_for`
* added `close_all_open_series`
* added `TimeSeries.name`
* added option to use descriptor based access instead of mmap
* added `TimeSeries.open_chunks_ram_size`

## v0.1

First release
