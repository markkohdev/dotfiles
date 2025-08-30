#!/bin/bash
# Should be executed by script/bootstrap

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

# Install uv for python package management
if ! command -v uv >/dev/null 2>&1; then
  info "uv installation not found.  Installing now..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH=$HOME/.local/bin:$PATH
  success "uv installed!"
fi

PYTHON_VERSION="3.12"

create_uv_venv() {
  info "Creating global python virtual environment..."
  rm -fr ~/.venv
  uv python install $PYTHON_VERSION
  uv venv --python $PYTHON_VERSION --prompt "global-venv" ~/.venv

  source "$HOME"/.venv/bin/activate
  success "Python virtual environment installation completed."
  append_file ~/.venv/bin/activate 'VIRTUAL_ENV_PROMPT="global-venv"'
}

# Create new Python virtual environment with uv
if [ -d "$HOME/.venv" ]; then
  read -r -p $'\nExisting ~/.venv directory found. Do you want to delete it and install a fresh Python virtual environment? ([Y/n]): ' response
  case "$response" in
    [yY][eE][sS]|[yY])
      create_uv_venv
      ;;
    *)
      info "Skipping creating Python virtual environment with uv venv"
      ;;
  esac
else
  create_uv_venv
fi

# Set up global uv environment
if [ -d "$HOME/.venv" ]; then
  info "Installing uv dependencies in global venv..."
  source "$HOME"/.venv/bin/activate
  uv pip install -r "$DOTFILES_ROOT/python/requirements.txt"
else
  info "No global venv found.  Skipping uv dependencies installation."
fi
