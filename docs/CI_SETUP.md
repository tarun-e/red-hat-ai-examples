# CI/CD Pipeline Documentation

This document describes the CI/CD pipeline setup for the red-hat-ai-examples repository.

## Overview

The repository includes a comprehensive CI/CD pipeline with the following features:

- **Code Quality Checks**: Automated linting, formatting, and type checking
- **Pre-commit Hooks**: Local validation before commits
- **Automated Testing**: Unit tests with coverage reporting
- **Security Scanning**: Dependency and code security checks
- **Jupyter Notebook Support**: Specialized checks for notebooks
- **Inline PR Comments**: Automated code review with inline comments on pull requests

## Quick Start

### 1. Install Development Dependencies

```bash
# Install all development dependencies
make install-dev

# Or manually
pip install -r requirements-dev.txt
pre-commit install
```

### 2. Run Pre-commit Hooks

Pre-commit hooks will automatically run on every commit. To run them manually:

```bash
# Run on all files
make pre-commit

# Or manually
pre-commit run --all-files
```

### 3. Format Code

```bash
# Format Python files and notebooks
make format
```

### 4. Run Linters

```bash
# Run all linters
make lint
```

### 5. Run Tests

```bash
# Run tests with coverage
make test
```

### 6. Run All Checks

```bash
# Run all checks (format, lint, test, security)
make check-all
```

## Tools and Technologies

### Code Formatting

- **Black**: Python code formatter (line length: 100)
- **isort**: Import statement sorter
- **nbQA**: Applies Black and isort to Jupyter notebooks

### Linting

- **Ruff**: Fast Python linter (replaces flake8, pylint, and more)
- **Flake8**: Python style guide enforcement
- **MyPy**: Static type checker

### Security

- **Bandit**: Security issue scanner for Python code
- **Safety**: Dependency vulnerability checker

### Testing

- **Pytest**: Testing framework
- **pytest-cov**: Coverage plugin for pytest

### Jupyter Notebooks

- **nbQA**: Quality assurance for Jupyter notebooks
- **nbstripout**: Strips output from notebooks before committing
- **nbconvert**: Validates notebook syntax

## GitHub Actions Workflows

### 1. CI Pipeline (`.github/workflows/ci.yml`)

Runs on every push and pull request to main branches.

**Jobs:**

- **code-quality**: Runs all linting and formatting checks
  - Black formatting check
  - isort import sorting check
  - Ruff linting
  - nbQA checks for notebooks
  - MyPy type checking
  - Bandit security scanning

- **test**: Runs tests on multiple Python versions (3.9, 3.10, 3.11)
  - Executes pytest with coverage
  - Uploads coverage to Codecov

- **notebook-validation**: Validates Jupyter notebooks
  - Checks notebook syntax
  - Attempts to execute notebooks

- **dependency-check**: Scans dependencies for vulnerabilities
  - Runs Safety on all requirements files

### 2. PR Code Review (`.github/workflows/pr-code-review.yml`)

Runs on pull requests and provides inline comments.

**Features:**

- **Reviewdog Integration**: Provides inline PR comments for:
  - Ruff linting issues
  - MyPy type errors
  - Flake8 style violations
  - Black formatting issues
  - Bandit security warnings
  - Shellcheck for shell scripts

- **PR Summary**: Generates a comprehensive quality report as a PR comment

## Pre-commit Hooks

The pre-commit configuration includes:

1. **General Checks**:
   - Trailing whitespace removal
   - End of file fixing
   - YAML syntax validation
   - Large file detection
   - Merge conflict detection

2. **Python Formatting**:
   - Black code formatting
   - isort import sorting

3. **Linting**:
   - Ruff linting with auto-fix

4. **Notebook Checks**:
   - nbQA Black formatting
   - nbQA isort
   - nbQA Ruff linting
   - nbstripout (removes outputs)

5. **Type Checking**:
   - MyPy static type analysis

6. **Security**:
   - Bandit security scanning

## Configuration Files

### `pyproject.toml`

Central configuration for all tools:

- Black: Line length 100, Python 3.9+ target
- isort: Black-compatible profile
- Ruff: Selected rules, ignore patterns
- MyPy: Type checking settings
- Bandit: Security check configuration
- Pytest: Test discovery and coverage settings

### `.pre-commit-config.yaml`

Defines all pre-commit hooks and their versions.

### `requirements-dev.txt`

Lists all development and CI/CD dependencies.

## Makefile Commands

| Command | Description |
|---------|-------------|
| `make help` | Show all available commands |
| `make install` | Install project dependencies |
| `make install-dev` | Install development dependencies |
| `make format` | Format code with black and isort |
| `make lint` | Run all linters |
| `make test` | Run tests with pytest |
| `make security` | Run security checks |
| `make pre-commit` | Install and run pre-commit hooks |
| `make notebooks` | Format and lint Jupyter notebooks |
| `make check-all` | Run all checks |
| `make clean` | Clean cache and temporary files |

## Inline PR Comments

When you create a pull request, the CI pipeline will automatically:

1. Run all quality checks
2. Post inline comments on specific lines where issues are found
3. Generate a summary comment with overall quality metrics
4. Update the comment on subsequent pushes

### Example PR Comment Features:

- **Ruff**: Linting issues with suggested fixes
- **MyPy**: Type errors with line numbers
- **Flake8**: Style violations
- **Black**: Formatting issues with diffs
- **Bandit**: Security warnings with severity levels

## Best Practices

### Before Committing

1. Run `make format` to auto-format your code
2. Run `make lint` to check for issues
3. Run `make test` to ensure tests pass
4. Pre-commit hooks will run automatically

### Working with Notebooks

1. Strip outputs before committing: `make notebooks`
2. Format notebook code cells: `nbqa black .`
3. Check notebook linting: `nbqa ruff .`

### Fixing Common Issues

#### Black formatting errors
```bash
black --line-length=100 .
```

#### Import sorting errors
```bash
isort --profile black --line-length 100 .
```

#### Ruff linting errors
```bash
ruff check --fix .
```

#### Type errors (MyPy)
- Add type hints to function signatures
- Use `# type: ignore` for unavoidable errors

#### Notebook output not stripped
```bash
nbstripout **/*.ipynb
```

## Continuous Improvement

The CI pipeline is designed to evolve with the project. Consider:

1. Adding more specific tests as the project grows
2. Adjusting linting rules in `pyproject.toml`
3. Adding custom pre-commit hooks
4. Integrating additional security scanners
5. Setting up automated deployments

## Troubleshooting

### Pre-commit hooks failing

```bash
# Update hooks to latest versions
pre-commit autoupdate

# Clear cache and retry
pre-commit clean
pre-commit run --all-files
```

### CI failing but local checks pass

- Ensure you're using the same Python version
- Check that all dependencies are installed
- Review the GitHub Actions logs for specific errors

### Performance issues

- Use `pre-commit run --files <specific-files>` for targeted checks
- Skip slow hooks temporarily with `SKIP=mypy git commit`

## Additional Resources

- [Pre-commit Documentation](https://pre-commit.com/)
- [Black Documentation](https://black.readthedocs.io/)
- [Ruff Documentation](https://docs.astral.sh/ruff/)
- [Pytest Documentation](https://docs.pytest.org/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Reviewdog Documentation](https://github.com/reviewdog/reviewdog)
