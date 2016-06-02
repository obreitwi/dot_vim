
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
Plugin 'tpope/vim-git'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-unimpaired'
Plugin 'sjbach/lusty'
Plugin 'godlygeek/tabular'
Plugin 'sjl/gundo.vim'
Plugin 'gregsexton/gitv'
Plugin 'scrooloose/nerdcommenter'
Plugin 'vim-scripts/L9'
Plugin 'scrooloose/syntastic'
Plugin 'vim-scripts/FSwitch'
Plugin 'ehamberg/vim-cute-python'
Plugin 'Twinside/vim-haskellConceal'
Plugin 'trapd00r/vim-syntax-vidir-ls'
Plugin 'Raimondi/delimitMate'
Plugin 'vim-scripts/SudoEdit.vim'
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
Plugin 'tpope/vim-dispatch'
Plugin 'nelstrom/vim-visual-star-search'
Plugin 'prendradjaja/vim-vertigo'
Plugin 'PeterRincker/vim-argumentative'
Plugin 'sickill/vim-pasta'
Plugin 'Shougo/unite.vim'
Plugin 'Shougo/neomru.vim'
Plugin 'Shougo/vimproc.vim'
Plugin 'shougo/unite-outline'
Plugin 'shougo/neoyank.vim'
Plugin 'vimwiki/vimwiki'
Plugin 'mhinz/vim-signify'
Plugin 'Glench/Vim-Jinja2-Syntax'
Plugin 'groenewege/vim-less'
Plugin 'ivyl/vim-bling'
Plugin 'LaTeX-Box-Team/LaTeX-Box'
Plugin 'justinmk/vim-sneak'
Plugin 'mantiz/vim-plugin-dirsettings'
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

" {{{ Disabled stfuff:
" Plugin 'luochen1990/rainbow'
" Plugin 'tpope/vim-markdown'
" Plugin 'tpope/vim-speeddating'
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
" Plugin 'jceb/vim-orgmode'
" Plugin 'mattn/webapi-vim'
" Plugin 'mattn/gist-vim'
" Plugin 'vim-scripts/DrawIt'
" }}}


if executable('ghc')
    Plugin 'lukerandall/haskellmode-vim'
    Plugin 'eagletmt/ghcmod-vim'
    Plugin 'eagletmt/neco-ghc'
endif

if executable('ledger')
    Plugin 'ledger/vim-ledger'
endif

" only use taskwarrior where we use task
if executable('task')
    Plugin 'farseer90718/vim-taskwarrior'
endif

" Since YCM requires manual installation, dont enable it by default everywhere
let g:ycm_hosts=["dopamine", "lark"]
let g:ycm_requirements_met = v:version >= 704 || (v:version == 703 && has('patch584'))
if g:ycm_requirements_met && index(g:ycm_hosts, hostname()) >= 0
    Plugin 'Valloric/YouCompleteMe'
    Plugin 'rdnetto/YCM-Generator'
else
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
