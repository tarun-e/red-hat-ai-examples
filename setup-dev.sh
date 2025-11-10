#!/bin/bash
# Setup script for development environment

set -e

echo "🚀 Setting up development environment for Red Hat AI Examples"
echo ""

# Check Python version
echo "📋 Checking Python version..."
python_version=$(python3 --version 2>&1 | awk '{print $2}')
required_version="3.9"

if ! python3 -c "import sys; exit(0 if sys.version_info >= (3, 9) else 1)"; then
    echo "❌ Python 3.9 or higher is required. Current version: $python_version"
    exit 1
fi
echo "✅ Python version: $python_version"
echo ""

# Upgrade pip
echo "📦 Upgrading pip..."
python3 -m pip install --upgrade pip --quiet
echo "✅ pip upgraded"
echo ""

# Install development dependencies
echo "📚 Installing development dependencies..."
if [ -f "requirements-dev.txt" ]; then
    pip install -r requirements-dev.txt --quiet
    echo "✅ Development dependencies installed"
else
    echo "⚠️  requirements-dev.txt not found"
fi
echo ""

# Install pre-commit hooks
echo "🔧 Installing pre-commit hooks..."
if command -v pre-commit &> /dev/null; then
    pre-commit install
    echo "✅ Pre-commit hooks installed"
else
    echo "❌ pre-commit not found. Please install it: pip install pre-commit"
    exit 1
fi
echo ""

# Install project requirements if they exist
echo "📦 Installing project requirements..."
for req_file in $(find . -name "requirements.txt" -not -path "*/.venv/*" -not -path "*/venv/*"); do
    echo "   Installing from: $req_file"
    pip install -r "$req_file" --quiet || echo "   ⚠️  Failed to install from $req_file"
done
echo "✅ Project requirements installed"
echo ""

# Run initial pre-commit on all files (optional)
read -p "🤔 Run pre-commit on all files now? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🔍 Running pre-commit on all files..."
    pre-commit run --all-files || echo "⚠️  Some pre-commit hooks failed. This is normal for first run."
fi
echo ""

# Summary
echo "✨ Development environment setup complete!"
echo ""
echo "📝 Next steps:"
echo "   1. Run 'make format' to format your code"
echo "   2. Run 'make lint' to check for linting issues"
echo "   3. Run 'make test' to run tests"
echo "   4. Run 'make check-all' to run all checks"
echo ""
echo "📖 For more information, see:"
echo "   - CONTRIBUTING.md"
echo "   - docs/CI_SETUP.md"
echo ""
echo "Happy coding! 🎉"
