#!/usr/bin/env bash

printsection "Installing dotfiles"

info "Setting up gitconfig"
if ! [ -f symlinks/.gitconfig ]; then
    info 'setup gitconfig'

    git_credential='cache'
    if [ "$(uname -s)" == "Darwin" ]; then
        git_credential='osxkeychain'
    fi

    user ' - What is your github author name?'
    read -e git_authorname
    user ' - What is your github author email?'
    read -e git_authoremail

    sed -e "s/AUTHORNAME/$git_authorname/g" -e "s/AUTHOREMAIL/$git_authoremail/g" -e "s/GIT_CREDENTIAL_HELPER/$git_credential/g" symlinks/.gitconfig.example > symlinks/.gitconfig

    success 'gitconfig'
fi


if [ ! -f ~/.bash_custom ]; then
    info "Creating .bash_custom file"
    cat << EOF >> ~/.bash_custom
#!/usr/bin/env bash

# Machine-specific bash commands here

EOF
fi

install_dotfiles () {
    info "Installing symlinks"
    local overwrite_all=false backup_all=false skip_all=false

    for src in $(ls -a $DOTFILES_ROOT/symlinks); do
        if [[ "$src" != "." ]] \
        && [[ "$src" != ".." ]] \
        && [[ "$src" != ".gitconfig.example" ]] \
        && [[ "$src" != "install.sh" ]]; then
            dst="$HOME/$(basename $src)"
            link_file "$DOTFILES_ROOT/symlinks/$src" "$dst"
        fi
    done
}

install_dotfiles
