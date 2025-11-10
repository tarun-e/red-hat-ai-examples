"""
Example test file to demonstrate pytest setup.
Replace with actual tests for your project.
"""

import pytest


def test_example():
    """Example test that always passes."""
    assert True


def test_basic_math():
    """Example test with basic assertions."""
    assert 1 + 1 == 2
    assert 10 * 2 == 20


@pytest.mark.parametrize(
    "input_val,expected",
    [
        (1, 2),
        (2, 4),
        (3, 6),
        (4, 8),
    ],
)
def test_multiply_by_two(input_val, expected):
    """Example parameterized test."""
    assert input_val * 2 == expected


class TestExampleClass:
    """Example test class."""

    def test_method_one(self):
        """Example test method."""
        assert "hello".upper() == "HELLO"

    def test_method_two(self):
        """Another example test method."""
        assert len([1, 2, 3]) == 3
