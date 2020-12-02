class TempsDBError(Exception):
    """Base class for TempsDB errors"""
    ...

class DoesNotExist(TempsDBError):
    """The required resource does not exist"""
    ...

class Corruption(TempsDBError):
    """Corruption was detected in the dataset"""
    ...

class InvalidState(TempsDBError):
    """An attempt was made to write to a resource that's closed"""
    ...

class AlreadyExists(TempsDBError):
    """Provided object already exists"""
    ...
