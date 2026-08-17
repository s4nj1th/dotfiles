#!/bin/sh

set -e

REPO="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

echo "Updating dotfiles from:"
echo "  $REPO"

cd "$REPO"

# Remove macOS metadata files
find . -name '.DS_Store' -delete

# Adopt existing files into the repo, then create/update symlinks
stow --adopt --target="$HOME" home

echo ""
echo "Dotfiles updated."
echo ""
echo "Git changes:"
git status --short
