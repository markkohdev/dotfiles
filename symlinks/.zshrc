#!/bin/zsh
# Mark's custom zsh config
# Executed at zsh startup

###############################################################################
# Debugging utils
###############################################################################
STARTUP_DEBUG=false

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
# Powerlevel10k instant prompt
###############################################################################
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# Skip powerlevel10k instant prompt when running under Cursor agent to prevent hanging
if [[ "$CURSOR_AGENT" != "1" ]] && [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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
# Skip powerlevel10k theme when running under Cursor agent to prevent hanging
if [[ "$CURSOR_AGENT" != "1" ]]; then
  debug_msg "start - antigen configs"

  if command -v brew >/dev/null 2>&1 && [ -e "$(brew --prefix)/share/antigen/antigen.zsh" ]; then
      source $(brew --prefix)/share/antigen/antigen.zsh
  elif [ -e "/usr/share/zsh-antigen/antigen.zsh" ]; then
      source "/usr/share/zsh-antigen/antigen.zsh"
  fi

  # Load oh-my-zsh first
  antigen use oh-my-zsh

  # Load bundles
  antigen bundle git
  antigen bundle command-not-found
  antigen bundle zsh-users/zsh-syntax-highlighting
  antigen bundle virtualenv

  debug_msg "start - load theme"
  # You can't apply an antigen theme twice, so only call it if the theme isn't already applied
  # https://github.com/zsh-users/antigen/issues/675
  THEME="romkatv/powerlevel10k"
  if ! antigen list 2>&1 | grep -q $THEME; then 
      antigen theme $THEME
  fi

  debug_msg "start - configure powerlevel10k"
  # Load Powerlevel10k configuration
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
  debug_msg "end - configure powerlevel10k"

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

  debug_msg "end - antigen configs"
else
    debug_msg "skipping antigen setup (running under Cursor agent)"
    # Teardown the prompt if it is already loaded
    prompt_powerlevel9k_teardown
    # Use a simple `cursor-agent$` prompt
    export PS1='$ '
    export PROMPT=$PS1
fi

###############################################################################
# Basic shell setup
###############################################################################
debug_msg "start - basic shell configs"

# fzf: Command-line fuzzy-fetcher setup <3
# If bindings aren't working, run `$(brew --prefix)/opt/fzf/install`
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

debug_msg "end - basic shell configs"
