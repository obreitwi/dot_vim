
" {{{ Loading
" Misc stuff first
set rtp+=~/.vim/bundle/vundle/
call vundle#begin()

" let g:vundle_default_git_proto = 'git'

" let Vundle manage Vundle
" required! 
Plugin 'VundleVim/Vundle.vim', {'name': 'vundle'}

" Pathogen because Vundle is too sophisticated to add local folders to the rtp
Plugin 'tpope/vim-pathogen'
" }}}

" {{{ Github repositories

Plugin 'sjbach/lusty'
Plugin 'godlygeek/tabular'
Plugin 'sjl/gundo.vim'
Plugin 'gregsexton/gitv'
Plugin 'scrooloose/nerdcommenter'
Plugin 'vim-scripts/L9'
Plugin 'ehamberg/vim-cute-python'
Plugin 'Twinside/vim-haskellConceal'
Plugin 'trapd00r/vim-syntax-vidir-ls'
Plugin 'Raimondi/delimitMate'
Plugin 'kana/vim-textobj-line'
Plugin 'honza/vim-snippets'
Plugin 'vim-scripts/DirDiff.vim'
Plugin 'michaeljsmith/vim-indent-object'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'vim-scripts/AnsiEsc.vim'
Plugin 'coderifous/textobj-word-column.vim'
Plugin 'kana/vim-textobj-indent'
Plugin 'kana/vim-textobj-user'
Plugin 'caio/querycommandcomplete.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'kana/vim-textobj-entire'
Plugin 'prendradjaja/vim-vertigo'
Plugin 'PeterRincker/vim-argumentative'
Plugin 'sickill/vim-pasta'
Plugin 'vimwiki/vimwiki'
Plugin 'mhinz/vim-signify'
Plugin 'Glench/Vim-Jinja2-Syntax'
Plugin 'groenewege/vim-less'
Plugin 'ivyl/vim-bling'
Plugin 'justinmk/vim-sneak'
Plugin 'tommcdo/vim-exchange'
Plugin 'tmhedberg/SimpylFold'
Plugin 'mileszs/ack.vim'
Plugin 'dyng/ctrlsf.vim'
Plugin 'jamessan/vim-gnupg'
Plugin 'AndrewRadev/linediff.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'majutsushi/tagbar'
Plugin 'AndrewRadev/id3.vim'
Plugin 'guns/xterm-color-table.vim'
Plugin 'kana/vim-operator-user'
Plugin 'rhysd/vim-clang-format'
Plugin 'christoomey/vim-sort-motion'
Plugin 'vim-scripts/ReplaceWithRegister' 
Plugin 'nathangrigg/vim-beancount'
Plugin 'qpkorr/vim-renamer'
Plugin 'mantiz/vim-plugin-dirsettings'
Plugin 'w0rp/ale'
Plugin 'lervag/vimtex'
Plugin 'jceb/vim-orgmode'

" {{{ tpope plugins

Plugin 'tpope/vim-dispatch'
Plugin 'tpope/vim-eunuch'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-git'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-speeddating'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-unimpaired'

" }}}

" {{{ Unite

Plugin 'Shougo/unite.vim'
Plugin 'Shougo/neomru.vim'
Plugin 'Shougo/vimproc.vim'
Plugin 'shougo/unite-outline'
Plugin 'shougo/neoyank.vim'
Plugin 'Shougo/vimfiler.vim'
Plugin 'Shougo/neossh.vim'

" }}}

" {{{ Disabled stuff:
" Plugin 'vim-scripts/SudoEdit.vim'
" Plugin 'vim-scripts/FSwitch'
" Plugin 'luochen1990/rainbow'
" Plugin 'tpope/vim-markdown'
" Plugin 'tpope/vim-abolish'
" Plugin 'tpope/vim-ragtag'
" Plugin 'tpope/vim-haml'
" Plugin 'vim-scripts/taglist.vim'
" Plugin 'gregsexton/VimCalc'
" Plugin 'int3/vim-extradite'
" Plugin 'jeetsukumaran/vim-filesearch'
" Plugin 'vim-scripts/Highlight-UnMatched-Brackets'
" Plugin 'vim-scripts/xoria256.vim'
" Plugin 'vim-scripts/TaskList.vim'
" Plugin 'scrooloose/nerdtree'
" Plugin 'vim-scripts/FuzzyFinder'
" Plugin 'vim-scripts/bufexplorer.zip'
" Plugin 'om/theshadowhost/Clippo'
" Plugin 'vim-scripts/YankRing.vim'
" Plugin 'Rip-Rip/clang_complete'
" Plugin 'rkitover/vimpager'
" Plugin 'vim-scripts/calendar.vim--Matsumoto'
" Plugin 'msanders/snipmate.vim'
" Plugin 'mikewest/vimroom'
" Plugin 'jeffkreeftmeijer/vim-numbertoggle'
" Plugin 'noahfrederick/Hemisu'
" Plugin 'chrisbra/csv.vim'
" Plugin 'ivanov/vim-ipython'
" Plugin 'fmoralesc/vim-pad'
" Plugin 'vim-scripts/LargeFile'
" Plugin 'maxbrunsfeld/vim-yankstack'
" Plugin 'benmills/vimux'
" Plugin 'terryma/vim-expand-region' " does not work correctly
" Plugin 'mattn/webapi-vim'
" Plugin 'mattn/gist-vim'
" Plugin 'vim-scripts/DrawIt'
" Plugin 'nelstrom/vim-visual-star-search' " Suspect errors when searching
" Plugin 'scrooloose/syntastic'
" Plugin 'LaTeX-Box-Team/LaTeX-Box' " not async
" }}}

Plugin 'sanjayankur31/sli.vim'

if executable('ghc')
    Plugin 'lukerandall/haskellmode-vim'
    Plugin 'eagletmt/neco-ghc'
    Plugin 'commercialhaskell/hindent'
endif
if executable('ghc-mod')
    Plugin 'eagletmt/ghcmod-vim'
endif

if executable('ledger')
    Plugin 'ledger/vim-ledger'
endif

" only use taskwarrior where we use task
if executable('task')
    Plugin 'farseer90718/vim-taskwarrior'
endif

" Since YCM requires manual installation, dont enable it by default everywhere
let g:hosts_ycm=["dopamine", "lark", "hel", "abed", "beli"]
let g:hosts_no_jedi=["gordon"]
let g:ycm_requirements_met = v:version >= 704 || (v:version == 703 && has('patch584'))
if g:ycm_requirements_met && index(g:hosts_ycm, hostname()) >= 0
    Plugin 'Valloric/YouCompleteMe'
    Plugin 'rdnetto/YCM-Generator'
elseif index(g:hosts_no_jedi, hostname()) == -1
    Plugin 'davidhalter/jedi-vim'
endif

if v:version >= 703
      " Plugin 'chrisbra/histwin.vim'
endif
if v:version >= 704
    Plugin 'SirVer/ultisnips'
endif


let s:atp_hosts=["lark"]
if index(s:atp_hosts, hostname()) >= 0
    Plugin 'dermusikman/sonicpi.vim'
endif

" For standalone only (see
" https://github.com/Lokaltog/powerline/blob/develop/docs/source/overview.rst)
" Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
" }}}

" {{{ My stuff
Plugin 'obreitwi/vim-sort-folds'
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
