#!/bin/bash

set -Eeuo pipefail

# prefer neovim over vim
VIM="$(command -v nvim || command -v vim)"

symlink () {
    ln -sfv "$@"
}

if [ "${PREFIX:+x}" != "x" ]; then
    PREFIX="$HOME/.local"
fi
SOURCE_FOLDER="$(dirname "$(readlink -m "$0")")"
VIMPLUG_FOLDER="${SOURCE_FOLDER}/plugged/vim-plug"
VIMPLUG_URL="https://github.com/junegunn/vim-plug"

if [ ! -d "${VIMPLUG_FOLDER}" ]; then
    # Quick install script to setup all symlinks
    git clone "${VIMPLUG_URL}" "${VIMPLUG_FOLDER}"
else
    pushd "${VIMPLUG_FOLDER}" >/dev/null
    if ! git remote -v | grep -q "junegunn/vim-plug"; then
        cat <<EOF >&2
ERROR: ${VIMPLUG_FOLDER} does not contain a checkout of ${VIMPLUG_URL}!
Please investigate and delete the folder before continuing! 
EOF
        exit 1
    fi
    popd >/dev/null
fi

# create autoload folder if not existing
mkdir -p "${SOURCE_FOLDER}/autoload" || true 

symlink "${VIMPLUG_FOLDER}/plug.vim"\
        "${SOURCE_FOLDER}/autoload/plug.vim"

"${VIM}" +PlugInstall +q! +q!

mkdir -p "${PREFIX}/bin" || true

if [ ! -e "${HOME}/.vim" ]; then
    symlink "${SOURCE_FOLDER}"                       "${HOME}/.vim"
fi
# vcat symlink is personal preference
symlink "${SOURCE_FOLDER}/vimrc"                     "${HOME}/.vimrc"
symlink "${SOURCE_FOLDER}/plugged/vimpager/vimcat"   "${PREFIX}/bin/vcat"
symlink "${SOURCE_FOLDER}/plugged/vimpager/vimcat"   "${PREFIX}/bin/vimcat"
symlink "${SOURCE_FOLDER}/plugged/vimpager/vimpager" "${PREFIX}/bin/vimpager"

symlink "${SOURCE_FOLDER}/utils/prev-day"            "${PREFIX}/bin/prev-day"
symlink "${SOURCE_FOLDER}/utils/next-day"            "${PREFIX}/bin/next-day"

# check if nvim exists
if command -v nvim >/dev/null; then
    mkdir -p "${HOME}/.config/nvim"
    cat <<EOF >"${HOME}/.config/nvim/init.vim"
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
EOF

ln -svf ~/.vim/coc-settings.json ~/.config/nvim
fi
