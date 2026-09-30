#!/bin/bash
# Sourced by bootstrap. Use return, not exit, so a skip does not abort bootstrap.

printsection "Installing python and uv"

# Check if the user wants to set up uv and python

read -p "Do you want to set up uv and python? (y/n): " response
case "$response" in
  [yY][eE][sS]|[yY])
    ;;
  *)
    info "Skipping uv and python installation."
    return
    ;;
esac

# Install uv, or update an existing install to the current release.
if ! command -v uv >/dev/null 2>&1; then
  info "uv installation not found.  Installing now..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="$HOME/.local/bin:$PATH"
  success "uv installed!"
else
  info "Updating uv..."
  uv self update
  success "uv is up to date."
fi

PYTHON_VERSION="3.12"

info "Installing Python $PYTHON_VERSION and default python/python3 shims..."
uv python install "$PYTHON_VERSION" --default --preview-features python-install-default
uv python pin --global "$PYTHON_VERSION"
success "Python $PYTHON_VERSION pinned globally."

# uv tool install accepts one package per invocation.
if [ -f "$DOTFILES_ROOT/python/tools.txt" ]; then
  info "Installing uv tools..."
  while IFS= read -r package || [ -n "$package" ]; do
    case "$package" in
      ''|\#*) continue ;;
    esac
    package="${package#"${package%%[![:space:]]*}"}"
    package="${package%"${package##*[![:space:]]}"}"
    [ -z "$package" ] && continue
    info "Installing $package..."
    uv tool install "$package"
  done < "$DOTFILES_ROOT/python/tools.txt"
  success "uv tools installed."
else
  info "No python/tools.txt found. Skipping uv tool installs."
fi

# A ~/.venv directory is discovered by uv from every directory under $HOME.
rename_home_venv() {
  local dest="$HOME/.venv.bak"
  if [ -e "$dest" ]; then
    dest="$HOME/.venv.bak.$(date +%Y%m%d%H%M%S)"
  fi
  mv "$HOME/.venv" "$dest"
  success "Renamed ~/.venv to $dest"
}

if [ -d "$HOME/.venv" ]; then
  read -r -p $'\nExisting ~/.venv directory found. Rename it so uv stops discovering it? ([Y/n]): ' response
  case "$response" in
    [nN]|[nN][oO])
      info "Leaving ~/.venv in place. uv will keep discovering it from directories under your home directory."
      ;;
    *)
      rename_home_venv
      ;;
  esac
fi
