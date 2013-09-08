
" Misc stuff first
set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

" Github repositories
Bundle 'tpope/vim-pathogen.git'
Bundle 'tpope/vim-git.git'
Bundle 'tpope/vim-markdown.git'
Bundle 'tpope/vim-speeddating.git'
Bundle 'tpope/vim-fugitive.git'
Bundle 'tpope/vim-surround.git'
Bundle 'tpope/vim-repeat.git'
Bundle 'tpope/vim-abolish.git'
Bundle 'tpope/vim-unimpaired.git'
Bundle 'tpope/vim-ragtag.git'
Bundle 'sjbach/lusty.git'
Bundle 'godlygeek/tabular.git'
Bundle 'sjl/gundo.vim.git'
Bundle 'vim-scripts/taglist.vim.git'
Bundle 'majutsushi/tagbar.git'
" Bundle 'gregsexton/VimCalc.git'
Bundle 'gregsexton/gitv.git'
Bundle 'int3/vim-extradite.git'
Bundle 'altercation/vim-colors-solarized.git'
" Bundle 'jeetsukumaran/vim-filesearch.git'
" Bundle 'vim-scripts/Highlight-UnMatched-Brackets.git'
Bundle 'vim-scripts/xoria256.vim.git'
Bundle 'guns/xterm-color-table.vim.git'
" Bundle 'vim-scripts/TaskList.vim.git'
Bundle 'scrooloose/nerdtree.git'
Bundle 'scrooloose/nerdcommenter.git'
Bundle 'mileszs/ack.vim.git'
" Bundle 'vim-scripts/FuzzyFinder.git'
Bundle 'vim-scripts/L9.git'
Bundle 'vim-scripts/bufexplorer.zip.git'
Bundle 'scrooloose/syntastic.git'
" Bundle 'om/theshadowhost/Clippo.git'
Bundle 'vim-scripts/FSwitch.git'
" Bundle 'vim-scripts/YankRing.vim.git'
Bundle 'ehamberg/vim-cute-python.git'
Bundle 'Twinside/vim-haskellConceal.git'
Bundle 'trapd00r/vim-syntax-vidir-ls.git'
" Bundle 'Rip-Rip/clang_complete.git'
" Bundle 'rkitover/vimpager.git'
" Bundle 'vim-scripts/calendar.vim--Matsumoto.git'
" Bundle 'msanders/snipmate.vim.git'
Bundle 'Raimondi/delimitMate.git'
" Bundle 'mikewest/vimroom.git'
Bundle 'vim-scripts/SudoEdit.vim.git'
Bundle 'kana/vim-textobj-line.git'
" Bundle 'jeffkreeftmeijer/vim-numbertoggle.git'
" Bundle 'noahfrederick/Hemisu.git'
Bundle 'SirVer/ultisnips.git'
Bundle 'vim-scripts/DirDiff.vim.git'
Bundle 'chrisbra/csv.vim.git'
Bundle 'michaeljsmith/vim-indent-object.git'
Bundle 'ivanov/vim-ipython.git'
Bundle 'nathanaelkane/vim-indent-guides.git'
" Bundle 'fmoralesc/vim-pad.git'
Bundle 'Lokaltog/vim-easymotion.git'
Bundle 'vim-scripts/AnsiEsc.vim.git'
Bundle 'coderifous/textobj-word-column.vim.git'
Bundle 'vim-scripts/LargeFile.git'
Bundle 'kana/vim-textobj-indent.git'
Bundle 'kana/vim-textobj-user.git'
Bundle 'caio/querycommandcomplete.vim.git'
Bundle 'davidhalter/jedi-vim.git'
Bundle 'chrisbra/histwin.vim.git'
Bundle 'maxbrunsfeld/vim-yankstack.git'
Bundle 'benmills/vimux.git'
Bundle 'kien/ctrlp.vim.git'
Bundle 'Lokaltog/powerline.git'
Bundle 'kana/vim-textobj-entire.git'
Bundle 'terryma/vim-expand-region.git'
Bundle 'tpope/vim-dispatch.git'
Bundle 'nelstrom/vim-visual-star-search.git'
" Bundle 'jceb/vim-orgmode.git'
Bundle 'prendradjaja/vim-vertigo.git'
Bundle 'PeterRincker/vim-argumentative.git'


let s:base_path = 'file://' . expand('%:p:h') . '/'

" Locally installed submodules (because not pathogen compliant or whatnot)
let s:path_submodules = s:base_path . 'bundles-submodule/'

Bundle s:path_submodules . 'powerline/powerline/bindings/vim'


" Own bundles
let s:path_own = s:base_path . 'bundles-own/'

Bundle s:path_own . 'my-snippets'
Bundle s:path_own . 'pentadactyl'
Bundle s:path_own . 'tabular-maps'
Bundle s:path_own . 'various-colors'
Bundle s:path_own . 'various-ft-scripts'
Bundle s:path_own . 'various-syntax'
Bundle s:path_own . 'xpt-templates'

