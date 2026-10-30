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

# Nothing else in bootstrap depends on python/uv being set up (fonts, lazygit,
# and symlinks installers are all independent of this one), so a failure here
# shouldn't have to abort the whole run. On failure, let the user choose to
# skip the rest of python/uv setup and continue bootstrap, or abort entirely.
prompt_continue_or_abort() {
  local description="$1"
  echo ''
  info "$description"
  read -r -p "Continue with the rest of bootstrap? ([y]/n): " response
  case "$response" in
    [nN]|[nN][oO])
      fail "Aborting bootstrap."
      ;;
    *)
      info "Continuing bootstrap without a complete python/uv setup."
      ;;
  esac
}

# Install uv, or update an existing install to the current release.
if ! command -v uv >/dev/null 2>&1; then
  info "uv installation not found.  Installing now..."
  if ! curl -LsSf https://astral.sh/uv/install.sh | sh; then
    prompt_continue_or_abort "uv installation failed."
    return
  fi
  export PATH="$HOME/.local/bin:$PATH"
  success "uv installed!"
else
  info "Updating uv..."
  if ! uv self update; then
    prompt_continue_or_abort "uv self update failed."
    return
  fi
  success "uv is up to date."
fi

PYTHON_VERSION="3.12"

info "Installing Python $PYTHON_VERSION and default python/python3 shims..."
if ! uv python install "$PYTHON_VERSION" --default --preview-features python-install-default; then
  prompt_continue_or_abort "uv python install $PYTHON_VERSION failed."
  return
fi
if ! uv python pin --global "$PYTHON_VERSION"; then
  prompt_continue_or_abort "uv python pin --global $PYTHON_VERSION failed."
  return
fi
success "Python $PYTHON_VERSION pinned globally."

# uv tool install accepts one package per invocation.
# Day-to-day: `uv tool install <pkg>`, then add the name to tools.txt.
# Libraries belong in a project (`uv add --dev`), not in this list.
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
    if ! uv tool install "$package"; then
      # A single bad package shouldn't block the rest of tools.txt or
      # trigger the continue/abort prompt used for the setup steps above.
      printf "\r\033[2K  [\033[0;31mFAIL\033[0m] Failed to install %s. Skipping.\n" "$package"
    fi
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
