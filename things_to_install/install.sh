#!/bin/bash
# Should be run from dotfiles repo root

cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd)
SCRIPT_DIR="$DOTFILES_ROOT/things_to_install"

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install brew dependencies
if [ ! -z $(which brew) ]; then
  brew update
  brew bundle --file $SCRIPT_DIR/Brewfile
else
  echo "Brew installation not found.  Skipping Brewfile installation."
  echo "To install brew, see https://brew.sh/"
fi

# TODO: Add equivalent apt-get dependencies

# Install pip dependencies
if [ ! -z $(which pip) ]; then
  pip install -r "$SCRIPT_DIR/requirements.txt"
else
  echo "Pip installation not found.  Skipping pip installation."
fi
