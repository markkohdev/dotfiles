#!/bin/bash
# Should be executed by script/bootstrap

printsection "Installing lazygit config"

# The default location for lazygit config is:
# Linux: ~/.config/lazygit/config.yml
# MacOS: ~/Library/Application\ Support/lazygit/config.yml
#Windows: %LOCALAPPDATA%\lazygit\config.yml (default location, but it will also be found in %APPDATA%\lazygit\config.yml

# Check if the user wants to set up lazygit config
read -p "Do you want to set up lazygit config? (y/n): " response
case "$response" in
  [yY][eE][sS]|[yY])
    ;;
  *)
    info "Skipping lazygit config installation."
    return
    ;;
esac

# Softlink the lazygit config to the default location based on the machine
if [ "$(uname -s)" == "Darwin" ]; then
  CONFIG_PATH="$HOME/Library/Application Support/lazygit/config.yml"
elif [ "$(uname -s)" == "Linux" ]; then
  CONFIG_PATH="$HOME/.config/lazygit/config.yml"
elif [ "$(uname -s)" == "Windows" ]; then
  CONFIG_PATH="$HOME/%LOCALAPPDATA%/lazygit/config.yml"
fi

local overwrite_all=false backup_all=false skip_all=false
link_file "$DOTFILES_ROOT/lazygit/config.yml" "$CONFIG_PATH"

success "lazygit config installed successfully!"
