from contextlib import contextmanager
from dataclasses import dataclass
from pathlib import Path as FsPath
from typing import Iterator


@dataclass
class Cache:
    path: FsPath
    items: dict[str, int]

    def set(self, key: str, value: int) -> None:
        self.items[key] = value

    def get(self, key: str, default: int | None = None) -> int:
        if key in self.items:
            return self.items[key]
        if default is not None:
            return default
        raise KeyError(key)

    @property
    def size(self) -> int:
        return len(self.items)


@contextmanager
def opened(path: FsPath) -> Iterator[str]:
    with path.open() as handle:
        yield handle.read()


async def load(value: object) -> object:
    return await value


def summarize(cache: Cache) -> list[str]:
    return [f"{key}={value}" for key, value in cache.items.items() if value is not None]


cache = Cache(path=FsPath("."), items={})
cache.set("a", 1)
print(cache.size, len("abc"))
