![Red Hat AI](assets/RHAI-logo.png)

# Red Hat AI Examples

Unlock the Power of AI with Red Hat AI: Practical Examples for Real-World Solutions.

## Overview

### Welcome to Red Hat OpenShift AI Examples!

This repository provides a curated collection of runnable, well-documented Jupyter notebooks, pipelines, and code samples. These resources are designed to demonstrate how to effectively build, customize, evaluate, deploy, and manage Artificial Intelligence (AI) and Machine Learning (ML) models and applications on Red Hat AI. The focus is on practical application and learning, enabling users to explore the full potential of AI for meaningful customer use cases.

## CI/CD Pipeline

This repository includes a comprehensive CI/CD pipeline with automated code quality checks, testing, and inline PR comments. See [CI_SETUP.md](docs/CI_SETUP.md) for detailed documentation.

### Quick Start for Contributors

```bash
# Install development dependencies and pre-commit hooks
make install-dev

# Format code before committing
make format

# Run all quality checks
make check-all
```

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed contribution guidelines.

### Features

- ✅ **Automated Code Quality**: Black, isort, Ruff, Flake8, MyPy
- ✅ **Pre-commit Hooks**: Catch issues before they reach CI
- ✅ **Inline PR Comments**: Automated code review with inline feedback
- ✅ **Security Scanning**: Bandit and Safety dependency checks
- ✅ **Jupyter Notebook Support**: Specialized formatting and linting for notebooks
- ✅ **Multi-Python Testing**: Tests on Python 3.9, 3.10, and 3.11
