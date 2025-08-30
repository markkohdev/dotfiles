#!/usr/bin/env bash

# Copy all the fonts
if [[ "$machine" == "Mac" ]]; then
    printsection "Installing fonts"

    MAC_FONTS_ROOT=/Library/Fonts
    for f in $DOTFILES_ROOT/fonts/*.ttf; do
        fname=$(basename $f)
        if [[ "$machine" == "Mac" ]] && [[ ! -f "$MAC_FONTS_ROOT/$fname" ]]; then
            cp "$f" "$MAC_FONTS_ROOT"
        fi
    done

    success "Fonts installed successfully!"
fi