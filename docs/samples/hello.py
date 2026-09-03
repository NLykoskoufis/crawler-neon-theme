"""Greetings in a few languages, with enough Python in it to show a colour theme."""
from __future__ import annotations

import sys
from dataclasses import dataclass
from enum import Enum
from functools import cached_property

DEFAULT_TARGET = "World"
MAX_WIDTH = 42


class Language(Enum):
    ENGLISH = "en"
    GREEK = "el"
    FRENCH = "fr"


@dataclass(frozen=True)
class Greeting:
    language: Language
    template: str

    def render(self, target: str) -> str:
        return self.template.format(target=target)


class Greeter:
    """Formats greetings and keeps count of how many it has produced."""

    def __init__(self, greetings: list[Greeting], width: int = MAX_WIDTH) -> None:
        self._greetings = greetings
        self._width = width
        self.count = 0

    @cached_property
    def languages(self) -> set[Language]:
        return {greeting.language for greeting in self._greetings}

    def greet(self, target: str = DEFAULT_TARGET) -> list[str]:
        lines = [greeting.render(target) for greeting in self._greetings]
        self.count += len(lines)
        if any(len(line) > self._width for line in lines):
            raise ValueError(f"a greeting exceeds {self._width} characters")
        return lines


def main(argv: list[str]) -> int:
    target = argv[1] if len(argv) > 1 else DEFAULT_TARGET
    greeter = Greeter([
        Greeting(Language.ENGLISH, "Hello, {target}!"),
        Greeting(Language.GREEK, "Γεια σου, {target}!"),
        Greeting(Language.FRENCH, "Bonjour, {target} !"),
    ])
    for index, line in enumerate(greeter.greet(target), start=1):
        print(f"{index:>2}. {line}")
    print(f"-- {greeter.count} greetings in {len(greeter.languages)} languages")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
