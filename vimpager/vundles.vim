
" Misc stuff first
set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc("~/.vim/bundle-vimpager")
Bundle 'gmarik/vundle'


" plugins needed for vimparger
let s:base_path = 'file://' . expand('%:p:h') . '/'
let s:path_own = s:base_path . 'bundles-own/'
Bundle s:path_own . 'various-colors'
Bundle s:path_own . 'various-syntax'
