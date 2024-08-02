# tempsdb

[![PyPI](https://img.shields.io/pypi/pyversions/tempsdb.svg)](https://pypi.python.org/pypi/tempsdb)
[![PyPI version](https://badge.fury.io/py/tempsdb.svg)](https://badge.fury.io/py/tempsdb)
[![PyPI](https://img.shields.io/pypi/implementation/tempsdb.svg)](https://pypi.python.org/pypi/tempsdb)
[![Build status](https://git.dms-serwis.com.pl/smokserwis/tempsdb/badges/master/pipeline.svg)](https://git.dms-serwis.com.pl/smokserwis/tempsdb)
[![coverage report](https://git.dms-serwis.com.pl/smokserwis/tempsdb/badges/master/coverage.svg)](https://git.dms-serwis.com.pl/smokserwis/tempsdb/-/commits/develop)
[![Wheel](https://img.shields.io/pypi/wheel/tempsdb.svg)](https://pypi.org/project/tempsdb/)
[![License](https://img.shields.io/pypi/l/tempsdb)](https://github.com/smok-serwis/tempsdb)

Embedded Cython library for time series that you need to upload somewhere.

Stored time series with a 8-byte timestamp and a data, which can be of
fixed length or variable.

# Installation

```bash
git clone https://github.com/smok-serwis/tempsdb
cd tempsdb
pip install snakehouse tempsdb
python setup.py install
```

You need both [snakehouse](https://pypi.org/project/snakehouse/1.2.2/)
and [tempsdb](https://pypi.org/project/tempsdb/) to compile it from the source,
though binary wheels are available for whatever you'd like.

If there's a binary wheel that you would like to have, 
just drop me an [issue](https://github.com/smok-serwis/tempsdb/issues/new)/
 
If you're installing it somewhere that you don't need both snakehouse
and tempsdb installed, compile your own binary wheel with

```
python setup.py bdist_wheel
```

Then copy your resulting wheel and install it via pip on the target system.

Be aware that tempsdb does logging. 
Consult the docs for how to disable it.

The [changelog](CHANGELOG.md) has been moved here.

Ah, and [requirements.txt](requirements.txt) contain all the build necessitites.
True few dependencies are kept in [setup.cfg](setup.cfg).