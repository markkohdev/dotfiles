#!/bin/bash
# Should be run from dotfiles repo root

cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd)
SCRIPT_DIR="$DOTFILES_ROOT/things_to_install"

# Install oh-my-zsh
echo "Installing oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install brew dependencies
if command -v brew >/dev/null 2>&1; then
  echo "Brew installation found."
  echo "Updating Homebrew..."
  brew update

  echo
  echo "Installing dependencies from Brewfile..."
  brew bundle --file $SCRIPT_DIR/Brewfile

  # To install useful key bindings and fuzzy completion:
  # $(brew --prefix)/opt/fzf/install
else
  echo "Brew installation not found.  Skipping Brewfile installation."
  echo "To install brew, see https://brew.sh/"
fi

# Install apt packages if apt exists
if command -v apt >/dev/null 2>&1; then
  echo "Apt installation found.  Installing apt dependencies..."
  sudo apt update
  grep -vE '^\s*#|^\s*$' "$SCRIPT_DIR/apt-packages.txt" | xargs sudo apt -y install
elif command -v apt-get >/dev/null 2>&1; then
  echo "Apt-get installation found.  Installing apt-get dependencies..."
  sudo apt-get update
  grep -vE '^\s*#|^\s*$' "$SCRIPT_DIR/apt-packages.txt" | xargs sudo apt-get -y install
else
  echo "Apt installation not found.  Skipping apt installation."
fi

# Install pip dependencies
# if [ ! -z $(which pip) ]; then
#   echo "Pip installation found.  Installing pip dependencies..."
#   pip install -r "$SCRIPT_DIR/requirements.txt"
# else
#   echo "Pip installation not found.  Skipping pip installation."
# fi

# Install uv for python package management
if [ -z $(which uv) ]; then
  echo "uv installation not found.  Installing now..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  echo "uv installed!"
fi

# Set up global uv environment
echo "uv installation found.  Installing uv dependencies..."
uv pip install --system -r "$SCRIPT_DIR/requirements.txt"
