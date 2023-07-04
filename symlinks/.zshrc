#!/bin/zsh
# Mark's custom zsh config
# Executed at zsh startup

echo "ASIJDIASJ"
###############################################################################
# Debugging utils
###############################################################################
STARTUP_DEBUG=true

# Map `date` cmd to gdate on mac if available
if [ -x "$(command -v gdate)" ]; then
  alias date="gdate"
fi

# Log a debug message if STARTUP_DEBUG is true
debug_msg() {
  if [ "$STARTUP_DEBUG" = true ]; then
    echo "[$(date +'%T.%N')]: " $@
  fi
}

###############################################################################
# Common Loader
###############################################################################
# Don't expand equals because that's annoying for bash scripts
#https://www.zsh.org/mla/users/2011/msg00161.html
setopt noequals

if [ -f ${HOME}/.rc_common ]; then
    source ${HOME}/.rc_common
fi


###############################################################################
# ZSH configs
###############################################################################
debug_msg "start - zsh configs"
## History command configuration
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS=true

debug_msg "end - zsh configs"

###############################################################################
# Antigen configs
###############################################################################
debug_msg "start - antigen configs"
source $(brew --prefix)/share/antigen/antigen.zsh

antigen use oh-my-zsh
antigen bundle git
antigen bundle command-not-found
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle virtualenv

debug_msg "end - antigen configs"

####################################
# Powerlevel10k configs
####################################
debug_msg "start - powerlevel10k configs"

custom_virtualenv() {
  local virtualenv_path="$VIRTUAL_ENV"

  # Early exit; $virtualenv_path must always be set.
  [[ -z "$virtualenv_path" ]] && return

  echo -n "🐍 ${virtualenv_path:t} 🐍"
}

POWERLEVEL9K_CUSTOM_VENV="custom_virtualenv"
POWERLEVEL9K_CUSTOM_VENV_BACKGROUND="grey70"
POWERLEVEL9K_CUSTOM_VENV_FOREGROUND="black"

POWERLEVEL9K_INSTALLATION_PATH=$ANTIGEN_BUNDLES/bhilburn/powerlevel9k
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(custom_venv context dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status history time)
POWERLEVEL9K_PROMPT_ON_NEWLINE=true

# You can't apply an antigen theme twice, so only call it if the theme isn't already applied
# https://github.com/zsh-users/antigen/issues/675
THEME="romkatv/powerlevel10k"
antigen list 2>&1 | grep -q $THEME; if [ $? -ne 0 ]; then antigen theme $THEME; fi

# TODO: Change this to use antigen init since it's theoretically faster
# Tell Antigen that you're done.
antigen apply

# Aliases to temporarily deactivate Powerlevel10K
deactivate_theme() {
  prompt_powerlevel9k_teardown
  export PROMPT='$ '
}
activate_theme() {
  prompt_powerlevel9k_setup
}
alias untheme=deactivate_theme
alias retheme=activate_theme

debug_msg "end - powerlevel10k configs"

###############################################################################
# Basic shell setup
###############################################################################
debug_msg "start - basic shell configs"

# fzf: Command-line fuzzy-fetcher setup <3
# If bindings aren't working, run `$(brew --prefix)/opt/fzf/install`
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

debug_msg "end - basic shell configs"

