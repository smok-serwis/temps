# tempsdb

Further development of tempsdb has been moved to [our servers](https://git.dms-serwis.com.pl/smokserwis/tempsdb).

[![PyPI](https://img.shields.io/pypi/pyversions/tempsdb.svg)](https://pypi.python.org/pypi/tempsdb)
[![PyPI version](https://badge.fury.io/py/tempsdb.svg)](https://badge.fury.io/py/tempsdb)
[![PyPI](https://img.shields.io/pypi/implementation/tempsdb.svg)](https://pypi.python.org/pypi/tempsdb)
[![Documentation Status](https://readthedocs.org/projects/tempsdb/badge/?version=latest)](http://tempsdb.readthedocs.io/en/latest/?badge=latest)
[![Maintainability](https://api.codeclimate.com/v1/badges/657b03d115f6e001633c/maintainability)](https://codeclimate.com/github/smok-serwis/tempsdb/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/a0ff30771c71e43e8149/test_coverage)](https://codeclimate.com/github/smok-serwis/tempsdb/test_coverage)
[![Build Status](https://travis-ci.com/smok-serwis/tempsdb.svg)](https://travis-ci.com/smok-serwis/tempsdb)
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
