#!/bin/bash

symlink () {
ln -s -f -v "$@"
}

PREFIX=$HOME/.local
# SRCFLD=$(dirname $(realpath $0))
SRCFLD=$(dirname "$(readlink -m "$0")")

# Quick install script to setup all symlinks
git clone "https://github.com/junegunn/vim-plug" "${SRCFLD}/plugged/plug"
mkdir -p "${SRCFLD}/autoload"
symlink "${SRCFLD}/plugged/plug/plug.vim" "${SRCFLD}/autoload/plug.vim"
vim +PlugInstall +q!

mkdir -p "${PREFIX}/bin" "${PREFIX}/share/man"

if [ ! -e "${HOME}/.vim" ]; then
    symlink "${SRCFLD}"                         "${HOME}/.vim"
fi
symlink "${SRCFLD}/vimrc"                       "${HOME}/.vimrc"
symlink "${SRCFLD}/vimpager/vimpagerrc"         "${HOME}/.vimpagerrc"
symlink "${SRCFLD}/vimpager/repo/vimcat"        "${PREFIX}/bin/vcat"
symlink "${SRCFLD}/vimpager/repo/vimpager"      "${PREFIX}/bin/vimpager"
symlink "${SRCFLD}/vimpager/repo/vimpager.1"    "${PREFIX}/share/man"

# check if nvim exists
if which nvim; then
    mkdir -p "${HOME}/.config/nvim"
    cat <<EOF >"${HOME}/.config/nvim/init.vim"
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
EOF
fi
