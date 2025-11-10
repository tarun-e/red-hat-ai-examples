.PHONY: help install install-dev format lint test clean pre-commit check-all

# Default target
help:
	@echo "Available commands:"
	@echo "  make install        - Install project dependencies"
	@echo "  make install-dev    - Install development dependencies"
	@echo "  make format         - Format code with black and isort"
	@echo "  make lint           - Run linters (ruff, flake8, mypy)"
	@echo "  make test           - Run tests with pytest"
	@echo "  make security       - Run security checks (bandit, safety)"
	@echo "  make pre-commit     - Install and run pre-commit hooks"
	@echo "  make check-all      - Run all checks (format, lint, test, security)"
	@echo "  make clean          - Clean cache and temporary files"
	@echo "  make notebooks      - Format and lint Jupyter notebooks"

# Install project dependencies
install:
	pip install --upgrade pip
	find . -name "requirements.txt" -not -path "*/.venv/*" -exec pip install -r {} \;

# Install development dependencies
install-dev:
	pip install --upgrade pip
	pip install -r requirements-dev.txt
	pre-commit install

# Format code
format:
	@echo "Formatting Python files with black..."
	black --line-length=100 .
	@echo "Sorting imports with isort..."
	isort --profile black --line-length 100 .
	@echo "Formatting notebooks..."
	nbqa black --line-length=100 .
	nbqa isort --profile=black --line-length=100 .

# Run linters
lint:
	@echo "Running ruff..."
	ruff check .
	@echo "Running flake8..."
	flake8 --max-line-length=100 --extend-ignore=E203,W503 .
	@echo "Running mypy..."
	mypy --ignore-missing-imports --no-strict-optional .
	@echo "Checking notebooks..."
	nbqa ruff .

# Run tests
test:
	@echo "Running pytest..."
	pytest --cov=. --cov-report=term-missing --cov-report=html

# Run security checks
security:
	@echo "Running bandit..."
	bandit -r . -c pyproject.toml
	@echo "Checking dependencies for vulnerabilities..."
	find . -name "requirements*.txt" -not -path "*/.venv/*" -exec safety check -r {} \;

# Install and run pre-commit hooks
pre-commit:
	pre-commit install
	pre-commit run --all-files

# Format and lint notebooks
notebooks:
	@echo "Formatting notebooks..."
	nbqa black --line-length=100 .
	nbqa isort --profile=black --line-length=100 .
	@echo "Linting notebooks..."
	nbqa ruff .
	@echo "Stripping notebook outputs..."
	find . -name "*.ipynb" -not -path "*/.ipynb_checkpoints/*" -exec nbstripout {} \;

# Run all checks
check-all: format lint test security
	@echo "All checks completed!"

# Clean cache and temporary files
clean:
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name "*.egg-info" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".ruff_cache" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".mypy_cache" -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete
	find . -type f -name ".coverage" -delete
	rm -rf htmlcov/
	rm -rf .coverage
	rm -rf coverage.xml
	@echo "Cleaned cache and temporary files"
