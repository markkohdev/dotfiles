#!/usr/bin/bash

# Custom bash aliases
alias example='echo "Your alias"'
alias lg='lazygit'

alias givemespace='sudo /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024; sudo /sbin/mkswap /var/swap.1; sudo /sbin/swapon /var/swap.1'
alias hibernate='sudo pm-hibernate'

alias master='git checkout master'
alias development='git checkout development'

alias please='sudo'

alias reload='source ~/.${SHELL##*/}rc'

alias ssh-reauth='export SSH_AUTH_SOCK=$(ls -t /tmp/ssh-**/* | head -1)'
