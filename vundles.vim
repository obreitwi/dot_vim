
" {{{ Loading
" Misc stuff first
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let g:vundle_default_git_proto = 'git'

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

" Pathogen because Vundle is too sophisticated to add local folders to the rtp
Bundle 'tpope/vim-pathogen'
" }}}

" {{{ Github repositories
Bundle 'tpope/vim-git'
Bundle 'tpope/vim-markdown'
Bundle 'tpope/vim-speeddating'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-abolish'
Bundle 'tpope/vim-unimpaired'
Bundle 'tpope/vim-ragtag'
Bundle 'tpope/vim-haml'
Bundle 'sjbach/lusty'
Bundle 'godlygeek/tabular'
Bundle 'sjl/gundo.vim'
" Bundle 'vim-scripts/taglist.vim'
Bundle 'majutsushi/tagbar'
" Bundle 'gregsexton/VimCalc'
Bundle 'gregsexton/gitv'
Bundle 'int3/vim-extradite'
Bundle 'altercation/vim-colors-solarized'
" Bundle 'jeetsukumaran/vim-filesearch'
" Bundle 'vim-scripts/Highlight-UnMatched-Brackets'
" Bundle 'vim-scripts/xoria256.vim'
Bundle 'guns/xterm-color-table.vim'
" Bundle 'vim-scripts/TaskList.vim'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/nerdcommenter'
Bundle 'mileszs/ack.vim'
" Bundle 'vim-scripts/FuzzyFinder'
Bundle 'vim-scripts/L9'
" Bundle 'vim-scripts/bufexplorer.zip'
Bundle 'scrooloose/syntastic'
" Bundle 'om/theshadowhost/Clippo'
Bundle 'vim-scripts/FSwitch'
" Bundle 'vim-scripts/YankRing.vim'
Bundle 'ehamberg/vim-cute-python'
Bundle 'Twinside/vim-haskellConceal'
Bundle 'trapd00r/vim-syntax-vidir-ls'
" Bundle 'Rip-Rip/clang_complete'
" Bundle 'rkitover/vimpager'
" Bundle 'vim-scripts/calendar.vim--Matsumoto'
" Bundle 'msanders/snipmate.vim'
Bundle 'Raimondi/delimitMate'
" Bundle 'mikewest/vimroom'
Bundle 'vim-scripts/SudoEdit.vim'
Bundle 'kana/vim-textobj-line'
" Bundle 'jeffkreeftmeijer/vim-numbertoggle'
" Bundle 'noahfrederick/Hemisu'
Bundle 'SirVer/ultisnips'
Bundle 'honza/vim-snippets'
Bundle 'vim-scripts/DirDiff.vim'
Bundle 'chrisbra/csv.vim'
Bundle 'michaeljsmith/vim-indent-object'
Bundle 'ivanov/vim-ipython'
Bundle 'nathanaelkane/vim-indent-guides'
" Bundle 'fmoralesc/vim-pad'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'vim-scripts/AnsiEsc.vim'
Bundle 'coderifous/textobj-word-column.vim'
Bundle 'vim-scripts/LargeFile'
Bundle 'kana/vim-textobj-indent'
Bundle 'kana/vim-textobj-user'
Bundle 'caio/querycommandcomplete.vim'
Bundle 'davidhalter/jedi-vim'
" Bundle 'maxbrunsfeld/vim-yankstack'
Bundle 'benmills/vimux'
Bundle 'kien/ctrlp.vim'
Bundle 'kana/vim-textobj-entire'
" Bundle 'terryma/vim-expand-region' " does not work correctly
Bundle 'tpope/vim-dispatch'
Bundle 'nelstrom/vim-visual-star-search'
" Bundle 'jceb/vim-orgmode'
Bundle 'prendradjaja/vim-vertigo'
Bundle 'PeterRincker/vim-argumentative'
Bundle 'sickill/vim-pasta'
Bundle 'Shougo/unite.vim'
Bundle 'Shougo/neomru.vim'
Bundle 'Shougo/vimproc.vim'
Bundle 'h1mesuke/unite-outline'
Bundle 'vimwiki/vimwiki'
Bundle 'mhinz/vim-signify'
Bundle 'Glench/Vim-Jinja2-Syntax'
Bundle 'groenewege/vim-less'
Bundle 'ivyl/vim-bling'
Bundle 'LaTeX-Box-Team/LaTeX-Box'
Bundle 'justinmk/vim-sneak'
Bundle 'mattn/webapi-vim'
Bundle 'mattn/gist-vim'
Bundle 'vim-scripts/DrawIt'
Bundle 'mantiz/vim-plugin-dirsettings'
Bundle 'tommcdo/vim-exchange'
Bundle 'tmhedberg/SimpylFold'
Bundle 'luochen1990/rainbow'

" only use taskwarrior where we use task
if executable('task')
    Bundle 'farseer90718/vim-taskwarrior'
endif

if v:version >= 703
      " Bundle 'chrisbra/histwin.vim'
endif

" For standalone only (see
" https://github.com/Lokaltog/powerline/blob/develop/docs/source/overview.rst)
" Bundle 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
" }}}

" {{{ Other repositories
" Only install atp on hosts where latex editing takes place
" let s:atp_hosts=["juno", "phaelon", "nurikum"]
let s:atp_hosts=[]
if index(s:atp_hosts, hostname()) >= 0
      " Bundle 'git://atp-vim.git.sourceforge.net/gitroot/atp-vim/atp-vim'
endif
" }}}


" vim: fdm=marker
