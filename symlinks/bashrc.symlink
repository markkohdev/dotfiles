#!/usr/bin/bash
# To the extent possible under law, the author(s) have dedicated all
# copyright and related and neighboring rights to this software to the
# public domain worldwide. This software is distributed without any warranty.
# You should have received a copy of the CC0 Public Domain Dedication along
# with this software.
# If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.
#
# ~/.bashrc: executed by bash(1) for interactive shells.

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
# Common Loader
###############################################################################
if [ -f ${HOME}/.rc_common ]; then
    source ${HOME}/.rc_common
fi

###############################################################################
# Basic Shell Setup
###############################################################################
# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
shopt -s cdspell

# enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ] && [ "$SHELL" == "/bin/bash" ]; then
    . /etc/bash_completion
  fi
fi

# fzf: Command-line fuzzy-fetcher setup <3
# If bindings aren't working, run `$(brew --prefix)/opt/fzf/install`
[ -f ~/.fzf.bash ] && source ~/.fzf.bash


###############################################################################
# History
###############################################################################
# Make bash append rather than overwrite the history on disk
shopt -s histappend

# After each command, append to the history file and reread it
# (Basically "share history between tabs, windows, etc")
export PROMPT_COMMAND=${PROMPT_COMMAND:+"$PROMPT_COMMAND; "}"history -a; history -c; history -r"

# Don't put duplicate lines in the history.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups:erasedups

###############################################################################
# OS-Depdendent Configs
###############################################################################
# Assume we're on linux unless we have brew installed (below)
LINUX=true

# Also enable mac bash completion for git because it sucks by default
if [ ! -z $(which brew) ]; then
    # We're on mac!
    LINUX=false

    if [ -f $(brew --prefix)/etc/bash_completion ]; then
       . $(brew --prefix)/etc/bash_completion
    fi
fi

export LINUX


###############################################################################
# Bash Prompt and Title Setup
###############################################################################
# Some PS1 Colors
COLOR_RED="\033[0;31m"
COLOR_YELLOW="\033[0;33m"
COLOR_GREEN="\033[0;32m"
COLOR_OCHRE="\033[38;5;95m"
COLOR_BLUE="\033[0;34m"
COLOR_WHITE="\033[0;37m"
COLOR_RESET="\033[0m"

# If there are repos that shouldn't be git colored (i.e: large repos)
# then add them here
DONT_GIT_COLOR=("/Users/markkoh/spotify/android_client")

# Get the appropriate color for the git branch
function git_color {
	# Don't run this for large git repos (specified in the array above)
	if array_contains DONT_GIT_COLOR $(pwd); then
		echo -e $COLOR_OCHRE
	else
		local git_status="$(git status --ignore-submodules 2> /dev/null)"
		# Unclean tree says "directory" on unix but "tree" on mac
		[[ $LINUX ]] && local tree_jawn="directory" || local tree_jawn="tree"

		if [[ ! "$git_status" =~ "working $tree_jawn clean" ]]; then
			echo -e $COLOR_RED
		elif [[ "$git_status" =~ "Your branch is ahead of" ]]; then
			echo -e $COLOR_YELLOW
		elif [[ "$git_status" =~ "nothing to commit" ]]; then
			echo -e $COLOR_GREEN
		else
			echo -e $COLOR_OCHRE
		fi
	fi
}

function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# Build up the prompt
PS1="["  # Open square bracket
PS1+="\e[1;32m"  # GREEN
PS1+="\u@\h-$SYSTEM_ENV "  # user@hostname
PS1+="\e[m"  # WHITE
PS1+="\t "  # Time (padded)
PS1+="\e[1;33m"  # Yellow
PS1+="\w "  # Working dir (padded)
PS1+="\$(git_color)"  # Blue
PS1+="\$(parse_git_branch)"  # git branch (evaluated at expansion)
PS1+="\e[m"  # WHITE
PS1+="]\n $ "  # Close brachet, newline, prompt
export PS1

# Change the window title of X terminals
case ${TERM} in
    xterm*|rxvt*|Eterm|aterm|kterm|gnome)
            PROMPT_COMMAND=${PROMPT_COMMAND:+"$PROMPT_COMMAND; "}'echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'
            ;;
    screen)
            PROMPT_COMMAND=${PROMPT_COMMAND:+"$PROMPT_COMMAND; "}'echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"'
            ;;
esac


