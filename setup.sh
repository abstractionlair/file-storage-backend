#!/bin/bash
# Setup script for file-storage-backend
# Installs git hooks and creates necessary directories

set -e

echo "🔧 Setting up file-storage-backend..."
echo ""

# Install pre-push hook
if [ -f ".git-hooks/pre-push" ]; then
    echo "Installing pre-push hook..."
    cp .git-hooks/pre-push .git/hooks/pre-push
    chmod +x .git/hooks/pre-push
    echo "✅ Pre-push hook installed"
else
    echo "⚠️  Warning: .git-hooks/pre-push not found"
fi

echo ""

# Create reviews directory if it doesn't exist
if [ ! -d "reviews/pre-push" ]; then
    echo "Creating reviews directory..."
    mkdir -p reviews/pre-push
    echo "✅ Reviews directory created"
else
    echo "✅ Reviews directory already exists"
fi

echo ""

# Check for codex CLI
if command -v codex &> /dev/null; then
    echo "✅ codex CLI found: $(which codex)"
else
    echo "⚠️  Warning: codex CLI not found in PATH"
    echo "   Install it for pre-push reviews to work"
    echo "   See: .git-hooks/README.md"
fi

echo ""

# Check for AGENTS.md
if [ -f "AGENTS.md" ]; then
    echo "✅ AGENTS.md found (will be used for review context)"
else
    echo "⚠️  Warning: AGENTS.md not found"
fi

echo ""
echo "✨ Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Ensure codex CLI is installed and configured"
echo "  2. Try a test push: git push (will trigger review)"
echo "  3. Read .git-hooks/README.md for more info"
echo ""
