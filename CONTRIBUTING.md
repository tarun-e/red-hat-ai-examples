# Contributing to Red Hat AI Examples

Thank you for your interest in contributing! This document provides guidelines and instructions for contributing to this project.

## Table of Contents

- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Code Quality Standards](#code-quality-standards)
- [Testing](#testing)
- [Pull Request Process](#pull-request-process)
- [Jupyter Notebooks](#jupyter-notebooks)

## Getting Started

### Prerequisites

- Python 3.9 or higher
- Git
- pip

### Setup Development Environment

1. **Clone the repository**:
   ```bash
   git clone https://github.com/red-hat-data-services/red-hat-ai-examples.git
   cd red-hat-ai-examples
   ```

2. **Install development dependencies**:
   ```bash
   make install-dev
   ```

   Or manually:
   ```bash
   pip install -r requirements-dev.txt
   pre-commit install
   ```

3. **Verify setup**:
   ```bash
   make check-all
   ```

## Development Workflow

### 1. Create a Feature Branch

```bash
git checkout -b feature/your-feature-name
```

Branch naming conventions:
- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation updates
- `refactor/` - Code refactoring

### 2. Make Your Changes

- Write clean, readable code
- Follow Python best practices (PEP 8)
- Add docstrings to functions and classes
- Keep commits focused and atomic

### 3. Format Your Code

Before committing, format your code:

```bash
make format
```

This runs:
- Black (code formatter)
- isort (import sorter)
- nbQA (for notebooks)

### 4. Run Quality Checks

```bash
make lint
```

This runs:
- Ruff (linting)
- Flake8 (style checks)
- MyPy (type checking)

### 5. Run Tests

```bash
make test
```

Ensure all tests pass and coverage is maintained.

### 6. Commit Your Changes

Pre-commit hooks will run automatically:

```bash
git add .
git commit -m "feat: add new feature description"
```

**Commit Message Format**:
```
<type>: <short summary>

<optional longer description>
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

### 7. Push and Create Pull Request

```bash
git push origin feature/your-feature-name
```

Then create a pull request on GitHub.

## Code Quality Standards

### Code Formatting

- **Line length**: Maximum 100 characters
- **Formatter**: Black with isort for imports
- Configuration in [pyproject.toml](pyproject.toml)

### Linting

All code must pass:
- **Ruff**: Fast Python linter
- **Flake8**: Style guide enforcement
- **MyPy**: Type checking (recommended but not strictly enforced)

### Type Hints

Type hints are encouraged but not mandatory:

```python
def process_data(input_data: list[str]) -> dict[str, int]:
    """Process input data and return results."""
    ...
```

### Docstrings

Use Google-style docstrings:

```python
def example_function(param1: str, param2: int) -> bool:
    """
    Short description of function.

    Args:
        param1: Description of param1
        param2: Description of param2

    Returns:
        Description of return value

    Raises:
        ValueError: When input is invalid
    """
    ...
```

## Testing

### Writing Tests

- Place tests in the `tests/` directory
- Name test files as `test_*.py`
- Use descriptive test names: `test_function_name_expected_behavior`

Example:

```python
import pytest

def test_process_data_returns_dict():
    """Test that process_data returns a dictionary."""
    result = process_data(["a", "b", "c"])
    assert isinstance(result, dict)

@pytest.mark.parametrize("input_val,expected", [
    (1, 2),
    (2, 4),
])
def test_multiply_by_two(input_val, expected):
    """Test multiplication by two."""
    assert input_val * 2 == expected
```

### Running Tests

```bash
# Run all tests
make test

# Run specific test file
pytest tests/test_example.py

# Run with verbose output
pytest -v

# Run with coverage report
pytest --cov=. --cov-report=html
```

### Coverage Requirements

- Aim for >80% code coverage
- All new features should include tests
- Critical paths should have comprehensive test coverage

## Pull Request Process

### Before Submitting

1. ✅ All tests pass (`make test`)
2. ✅ Code is formatted (`make format`)
3. ✅ Linting passes (`make lint`)
4. ✅ Pre-commit hooks pass
5. ✅ Documentation is updated if needed
6. ✅ Commit messages are clear and descriptive

### PR Guidelines

1. **Title**: Clear, concise description of changes
2. **Description**:
   - What changes were made?
   - Why were they made?
   - How were they tested?
3. **Scope**: Keep PRs focused on a single feature/fix
4. **Size**: Prefer smaller, incremental PRs

### PR Template

```markdown
## Description
Brief description of changes

## Changes Made
- Change 1
- Change 2

## Testing
- [ ] Added unit tests
- [ ] Existing tests pass
- [ ] Manual testing completed

## Checklist
- [ ] Code follows style guidelines
- [ ] Documentation updated
- [ ] Tests added/updated
- [ ] All CI checks pass
```

### Review Process

1. **Automated Checks**: CI pipeline runs automatically
   - Code quality checks
   - Inline comments for issues
   - Test execution
   - Security scanning

2. **Code Review**: At least one approval required
   - Reviewers check code quality
   - Verify tests are adequate
   - Ensure documentation is clear

3. **Inline Comments**: Address all automated inline comments
   - Fix linting issues
   - Resolve type errors
   - Address security warnings

4. **Merging**:
   - All checks must pass
   - All review comments addressed
   - Squash and merge preferred

## Jupyter Notebooks

### Best Practices

1. **Clear outputs before committing**:
   ```bash
   make notebooks
   ```

2. **Use meaningful cell execution order**:
   - Number cells sequentially
   - Avoid out-of-order execution

3. **Add markdown cells for documentation**:
   - Explain what each section does
   - Include examples and expected outputs

4. **Keep notebooks focused**:
   - One topic per notebook
   - Break complex workflows into multiple notebooks

5. **Test notebook execution**:
   ```bash
   jupyter nbconvert --to notebook --execute your_notebook.ipynb
   ```

### Notebook Quality Checks

The CI pipeline automatically:
- Formats code cells with Black
- Sorts imports with isort
- Lints code with Ruff
- Validates notebook structure
- Checks for outputs (should be stripped)

## Security

### Reporting Security Issues

DO NOT open public issues for security vulnerabilities. Instead:
1. Email the maintainers privately
2. Include detailed description
3. Provide steps to reproduce if possible

### Security Best Practices

- Never commit secrets, API keys, or credentials
- Use environment variables for sensitive data
- Run `make security` to check for vulnerabilities
- Keep dependencies up to date

## Getting Help

- **Documentation**: See [docs/CI_SETUP.md](docs/CI_SETUP.md)
- **Issues**: Open a GitHub issue for bugs or feature requests
- **Discussions**: Use GitHub Discussions for questions

## Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Focus on the code, not the person
- Help create a welcoming environment

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.

---

Thank you for contributing to Red Hat AI Examples! 🎉
