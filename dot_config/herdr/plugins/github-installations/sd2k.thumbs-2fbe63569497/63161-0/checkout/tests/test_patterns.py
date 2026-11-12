"""Tests for config/patterns.default.txt.

The patterns are Rust regexes, but these use only syntax Python's re shares.
"""

import pathlib
import re
import unittest

ROOT = pathlib.Path(__file__).resolve().parent.parent
PATTERNS = [
    re.compile(line)
    for line in (ROOT / "config" / "patterns.default.txt").read_text().splitlines()
    if line and not line.startswith("#")
]


def first_match(text):
    # Like thumbs: the leftmost match wins, earlier patterns break ties.
    found = [(m.start(), i, m) for i, p in enumerate(PATTERNS) if (m := p.search(text))]
    if not found:
        return None
    m = min(found, key=lambda f: f[:2])[2]
    return m.group("match")


class UrlTests(unittest.TestCase):
    def test_trailing_punctuation_is_dropped(self):
        for suffix in ".", ",", ";", ":", "!", "?", ")", "'", '"', "]", ">", ").":
            with self.subTest(suffix=suffix):
                self.assertEqual(
                    first_match(f"see https://herdr.dev/docs{suffix} next"),
                    "https://herdr.dev/docs",
                )

    def test_wrapped_in_parens(self):
        self.assertEqual(first_match("(https://herdr.dev/a)"), "https://herdr.dev/a")

    def test_balanced_parens_are_kept(self):
        url = "https://en.wikipedia.org/wiki/Foo_(bar)"
        self.assertEqual(first_match(f"read {url}."), url)

    def test_inner_punctuation_is_kept(self):
        url = "https://x.dev/a.b?c=1&d=e,f#g"
        self.assertEqual(first_match(url), url)


if __name__ == "__main__":
    unittest.main()
