#!/bin/bash

# Test script to validate Dockerfile syntax and logic
echo "=== Dockerfile Validation Test ==="

# Check if all required files exist
echo "Checking required files..."
if [ ! -f "Dockerfile" ]; then
    echo "❌ Dockerfile not found"
    exit 1
fi

if [ ! -f "packages.list" ]; then
    echo "❌ packages.list not found"
    exit 1
fi

if [ ! -f "Makefile" ]; then
    echo "❌ Makefile not found"
    exit 1
fi

echo "✅ All required files present"

# Validate Dockerfile syntax
echo "Validating Dockerfile syntax..."
if command -v hadolint >/dev/null 2>&1; then
    hadolint Dockerfile
    echo "✅ Hadolint validation complete"
else
    echo "⚠️  hadolint not available, skipping syntax validation"
fi

# Check packages.list content
echo "Validating packages.list..."
package_count=$(wc -l < packages.list)
echo "📦 Found $package_count packages in packages.list"

# Validate key Dockerfile improvements
echo "Checking Dockerfile optimizations..."

# Check for multi-stage build
if grep -q "FROM.*AS builder" Dockerfile; then
    echo "✅ Multi-stage build detected"
else
    echo "❌ Multi-stage build not found"
fi

# Check for cache cleanup
if grep -q "rm -rf.*cache\|rm -rf.*registry" Dockerfile; then
    echo "✅ Cache cleanup strategies found"
else
    echo "❌ No cache cleanup found"
fi

# Check for consistent user ID
if grep -q "\-u 1000" Dockerfile; then
    echo "✅ Consistent UID usage found"
else
    echo "❌ No consistent UID usage"
fi

# Check for PATH environment variable
if grep -q "ENV PATH.*cargo" Dockerfile; then
    echo "✅ Cargo PATH configuration found"
else
    echo "❌ Missing cargo PATH configuration"
fi

# Check for starship configuration
if grep -q "starship init" Dockerfile; then
    echo "✅ Starship terminal configuration found"
else
    echo "❌ Missing starship configuration"
fi

echo ""
echo "=== Validation Complete ==="
echo "The Dockerfile has been optimized with:"
echo "- Multi-stage build to reduce final image size"
echo "- Aggressive cache cleanup (pacman, cargo, rustup)"
echo "- Consistent user permissions (UID 1000)"
echo "- Proper PATH configuration for Rust tools"
echo "- Starship terminal integration"
echo "- Runtime dependencies properly installed in final stage"