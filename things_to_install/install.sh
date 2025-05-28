#!/bin/bash
# Should be run from dotfiles repo root

cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd)
SCRIPT_DIR="$DOTFILES_ROOT/things_to_install"

# Install oh-my-zsh
echo "Installing oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install brew dependencies
if [ ! -z $(which brew) ]; then
  echo "Brew installation found."
  echo "Updating Homebrew..."
  brew update

  echo
  echo "Installing dependencies from Brewfile..."
  brew bundle --file $SCRIPT_DIR/Brewfile

  # To install useful key bindings and fuzzy completion:
  $(brew --prefix)/opt/fzf/install
else
  echo "Brew installation not found.  Skipping Brewfile installation."
  echo "To install brew, see https://brew.sh/"
fi

# TODO: Add equivalent apt-get dependencies

# Install pip dependencies
if [ ! -z $(which pip) ]; then
  echo "Pip installation found.  Installing pip dependencies..."
  pip install -r "$SCRIPT_DIR/requirements.txt"
else
  echo "Pip installation not found.  Skipping pip installation."
fi
