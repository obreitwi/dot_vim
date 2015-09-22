#!/bin/bash

# Quick install script to setup all symlinks
git clone https://github.com/gmarik/vundle.git bundle/vundle
vim +BundleInstall +q!

PREFIX=$HOME/.local
# SRCFLD=$(dirname $(realpath $0))
SRCFLD=$(dirname $(readlink -m "$0"))

symlink () {
ln -s -f -v $*
}

mkdir -p $PREFIX/bin $PREFIX/share/man

symlink $SRCFLD $HOME/.vim
symlink $SRCFLD/vimrc $HOME/.vimrc
symlink $SRCFLD/vimpager/vimpagerrc $HOME/.vimpagerrc
symlink $SRCFLD/vimpager/repo/vimcat $PREFIX/bin/vcat
symlink $SRCFLD/vimpager/repo/vimpager $PREFIX/bin/vimpager
symlink $SRCFLD/vimpager/repo/vimpager.1 $PREFIX/share/man



