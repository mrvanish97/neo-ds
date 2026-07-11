import os
from pathlib import Path as FsPath


class Cache:
    def set(self, key, value):
        return None

    def get(self, key, default=None):
        if key is not None and key in self:
            return True
        raise KeyError(key)


async def load(value):
    return await value


cache = Cache()
cache.set("a", 1)
print(len("abc"))
