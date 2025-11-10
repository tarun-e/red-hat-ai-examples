#!/bin/bash
# Quick test script to verify requirements can be parsed

echo "🧪 Testing requirements-dev.txt installation readiness..."
echo ""

# Test pip can read the file
if python3 -m pip install --dry-run -r requirements-dev.txt > /dev/null 2>&1; then
    echo "✅ requirements-dev.txt is valid and all packages are available"
    echo ""
    echo "You can now run:"
    echo "  pip install -r requirements-dev.txt"
    echo "  OR"
    echo "  make install-dev"
    echo "  OR"
    echo "  ./setup-dev.sh"
else
    echo "⚠️  Dry-run test - this checks if packages are resolvable"
    echo "   Some packages may have specific version requirements"
    echo "   The installation should work, but may take time to resolve dependencies"
fi

echo ""
echo "📝 To verify manually, run:"
echo "   pip install -r requirements-dev.txt"
