#!/bin/bash
# Script to install development tools for code quality and security scanning
# Usage: bash scripts/install-dev-tools.sh

set -e

echo "Installing development tools for code quality and security scanning..."

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}→ $1${NC}"
}

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "Error: Python 3 is required but not installed."
    exit 1
fi

print_info "Installing Python tools..."

# Install pre-commit
pip install --upgrade pre-commit

# Install Ruff (Python linter and formatter)
pip install --upgrade ruff

print_success "Python tools installed"

# Install pre-commit hooks
print_info "Installing pre-commit hooks..."
pre-commit install
pre-commit install --hook-type commit-msg

print_success "Pre-commit hooks installed"

# Install Node.js tools (markdownlint)
print_info "Checking for Node.js..."
if command -v npm &> /dev/null; then
    print_info "Installing markdownlint-cli..."
    npm install -g markdownlint-cli
    print_success "Markdownlint installed"
else
    print_info "Node.js not found. Skipping markdownlint installation."
    print_info "To install markdownlint, first install Node.js, then run: npm install -g markdownlint-cli"
fi

# Check for Gitleaks
print_info "Checking for Gitleaks..."
if ! command -v gitleaks &> /dev/null; then
    print_info "Gitleaks not found. Installing..."

    # Detect OS and install Gitleaks
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v brew &> /dev/null; then
            brew install gitleaks
            print_success "Gitleaks installed via Homebrew"
        else
            print_info "Please install Homebrew first, then run: brew install gitleaks"
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        print_info "To install Gitleaks on Linux, visit: https://github.com/gitleaks/gitleaks#installation"
    fi
else
    print_success "Gitleaks already installed"
fi

echo ""
print_success "Development tools installation complete!"
echo ""
echo "Next steps:"
echo "  1. Run 'pre-commit run --all-files' to check all files"
echo "  2. Run 'ruff check .' to lint Python code"
echo "  3. Run 'ruff format .' to format Python code"
echo "  4. Run 'markdownlint .' to check Markdown files"
echo ""
