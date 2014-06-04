
" {{{ Loading
" Misc stuff first
set rtp+=~/.vim/bundle/vundle/
call vundle#begin()

" let g:vundle_default_git_proto = 'git'

" let Vundle manage Vundle
" required! 
Plugin 'gmarik/vundle'

" Pathogen because Vundle is too sophisticated to add local folders to the rtp
Plugin 'tpope/vim-pathogen'
" }}}

" {{{ Github repositories
Plugin 'tpope/vim-git'
Plugin 'tpope/vim-markdown'
Plugin 'tpope/vim-speeddating'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-ragtag'
Plugin 'tpope/vim-haml'
Plugin 'sjbach/lusty'
Plugin 'godlygeek/tabular'
Plugin 'sjl/gundo.vim'
" Plugin 'vim-scripts/taglist.vim'
Plugin 'majutsushi/tagbar'
" Plugin 'gregsexton/VimCalc'
Plugin 'gregsexton/gitv'
Plugin 'int3/vim-extradite'
Plugin 'altercation/vim-colors-solarized'
" Plugin 'jeetsukumaran/vim-filesearch'
" Plugin 'vim-scripts/Highlight-UnMatched-Brackets'
" Plugin 'vim-scripts/xoria256.vim'
Plugin 'guns/xterm-color-table.vim'
" Plugin 'vim-scripts/TaskList.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
" Plugin 'vim-scripts/FuzzyFinder'
Plugin 'vim-scripts/L9'
" Plugin 'vim-scripts/bufexplorer.zip'
Plugin 'scrooloose/syntastic'
" Plugin 'om/theshadowhost/Clippo'
Plugin 'vim-scripts/FSwitch'
" Plugin 'vim-scripts/YankRing.vim'
Plugin 'ehamberg/vim-cute-python'
Plugin 'Twinside/vim-haskellConceal'
Plugin 'trapd00r/vim-syntax-vidir-ls'
" Plugin 'Rip-Rip/clang_complete'
" Plugin 'rkitover/vimpager'
" Plugin 'vim-scripts/calendar.vim--Matsumoto'
" Plugin 'msanders/snipmate.vim'
Plugin 'Raimondi/delimitMate'
" Plugin 'mikewest/vimroom'
Plugin 'vim-scripts/SudoEdit.vim'
Plugin 'kana/vim-textobj-line'
" Plugin 'jeffkreeftmeijer/vim-numbertoggle'
" Plugin 'noahfrederick/Hemisu'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'vim-scripts/DirDiff.vim'
Plugin 'chrisbra/csv.vim'
Plugin 'michaeljsmith/vim-indent-object'
Plugin 'ivanov/vim-ipython'
Plugin 'nathanaelkane/vim-indent-guides'
" Plugin 'fmoralesc/vim-pad'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'vim-scripts/AnsiEsc.vim'
Plugin 'coderifous/textobj-word-column.vim'
Plugin 'vim-scripts/LargeFile'
Plugin 'kana/vim-textobj-indent'
Plugin 'kana/vim-textobj-user'
Plugin 'caio/querycommandcomplete.vim'
" Plugin 'maxbrunsfeld/vim-yankstack'
Plugin 'benmills/vimux'
Plugin 'kien/ctrlp.vim'
Plugin 'kana/vim-textobj-entire'
" Plugin 'terryma/vim-expand-region' " does not work correctly
Plugin 'tpope/vim-dispatch'
Plugin 'nelstrom/vim-visual-star-search'
" Plugin 'jceb/vim-orgmode'
Plugin 'prendradjaja/vim-vertigo'
Plugin 'PeterRincker/vim-argumentative'
Plugin 'sickill/vim-pasta'
Plugin 'Shougo/unite.vim'
Plugin 'Shougo/neomru.vim'
Plugin 'Shougo/vimproc.vim'
Plugin 'shougo/unite-outline'
Plugin 'vimwiki/vimwiki'
Plugin 'mhinz/vim-signify'
Plugin 'Glench/Vim-Jinja2-Syntax'
Plugin 'groenewege/vim-less'
Plugin 'ivyl/vim-bling'
Plugin 'LaTeX-Box-Team/LaTeX-Box'
Plugin 'justinmk/vim-sneak'
Plugin 'mattn/webapi-vim'
Plugin 'mattn/gist-vim'
Plugin 'vim-scripts/DrawIt'
Plugin 'mantiz/vim-plugin-dirsettings'
Plugin 'tommcdo/vim-exchange'
Plugin 'tmhedberg/SimpylFold'
Plugin 'luochen1990/rainbow'
Plugin 'mileszs/ack.vim'
Plugin 'jamessan/vim-gnupg'

" only use taskwarrior where we use task
if executable('task')
    Plugin 'farseer90718/vim-taskwarrior'
endif

" Since YCM requires manual installation, dont enable it by default everywhere
let s:ycm_hosts=["dopamine"]
let s:ycm_requirements_met = v:version >= 704 || (v:version == 703 && has('patch584'))
if s:ycm_requirements_met && index(s:ycm_hosts, hostname()) >= 0
    Plugin 'Valloric/YouCompleteMe'
else
    Plugin 'davidhalter/jedi-vim'
endif

if v:version >= 703
      " Plugin 'chrisbra/histwin.vim'
endif

" For standalone only (see
" https://github.com/Lokaltog/powerline/blob/develop/docs/source/overview.rst)
" Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
" }}}

" {{{ Other repositories
" Only install atp on hosts where latex editing takes place
" let s:atp_hosts=["juno", "phaelon", "nurikum"]
let s:atp_hosts=[]
if index(s:atp_hosts, hostname()) >= 0
      " Plugin 'git://atp-vim.git.sourceforge.net/gitroot/atp-vim/atp-vim'
endif
" }}}

call vundle#end()

" vim: fdm=marker
