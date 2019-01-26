
" {{{ Loading
" Misc stuff first
call plug#begin('~/.vim/plugged')

Plug 'junegunn/vim-plug'

" needed to add local folders to the rtp
Plug 'tpope/vim-pathogen'
" }}}

" {{{ Github repositories

" {{{ common
Plug 'sjbach/lusty'
Plug 'godlygeek/tabular'
Plug 'sjl/gundo.vim'
Plug 'gregsexton/gitv'
Plug 'scrooloose/nerdcommenter'
Plug 'vim-scripts/L9'
Plug 'ehamberg/vim-cute-python'
Plug 'Twinside/vim-haskellConceal'
Plug 'trapd00r/vim-syntax-vidir-ls'
Plug 'Raimondi/delimitMate'
Plug 'kana/vim-textobj-line'
Plug 'honza/vim-snippets'
Plug 'vim-scripts/DirDiff.vim'
Plug 'michaeljsmith/vim-indent-object'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'Lokaltog/vim-easymotion'
Plug 'vim-scripts/AnsiEsc.vim'
Plug 'coderifous/textobj-word-column.vim'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-user'
Plug 'caio/querycommandcomplete.vim'
Plug 'kien/ctrlp.vim'
Plug 'kana/vim-textobj-entire'
Plug 'prendradjaja/vim-vertigo'
Plug 'PeterRincker/vim-argumentative'
Plug 'sickill/vim-pasta'
Plug 'vimwiki/vimwiki'
Plug 'mhinz/vim-signify'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'groenewege/vim-less'
Plug 'ivyl/vim-bling'
Plug 'justinmk/vim-sneak'
Plug 'tommcdo/vim-exchange'
Plug 'tmhedberg/SimpylFold'
Plug 'mileszs/ack.vim'
Plug 'dyng/ctrlsf.vim'
Plug 'jamessan/vim-gnupg'
Plug 'AndrewRadev/linediff.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'majutsushi/tagbar'
Plug 'AndrewRadev/id3.vim'
Plug 'guns/xterm-color-table.vim'
Plug 'kana/vim-operator-user'
Plug 'rhysd/vim-clang-format'
Plug 'christoomey/vim-sort-motion'
Plug 'vim-scripts/ReplaceWithRegister' 
Plug 'nathangrigg/vim-beancount'
Plug 'qpkorr/vim-renamer'
Plug 'mantiz/vim-plugin-dirsettings'
Plug 'w0rp/ale'
Plug 'lervag/vimtex'
Plug 'jceb/vim-orgmode'
Plug 'aquach/vim-http-client'
Plug 'sanjayankur31/sli.vim'
Plug 'rkitover/vimpager'
" }}}

" {{{ tpope plugins
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
" }}}

" {{{ Unite

Plug 'Shougo/unite.vim'
Plug 'Shougo/neomru.vim'
Plug 'Shougo/vimproc.vim'
Plug 'shougo/unite-outline'
Plug 'shougo/neoyank.vim'
Plug 'Shougo/vimfiler.vim'
Plug 'Shougo/neossh.vim'

" }}}

" {{{ Disabled stuff:
" Plug 'vim-scripts/SudoEdit.vim'
" Plug 'vim-scripts/FSwitch'
" Plug 'luochen1990/rainbow'
" Plug 'tpope/vim-markdown'
" Plug 'tpope/vim-abolish'
" Plug 'tpope/vim-ragtag'
" Plug 'tpope/vim-haml'
" Plug 'vim-scripts/taglist.vim'
" Plug 'gregsexton/VimCalc'
" Plug 'int3/vim-extradite'
" Plug 'jeetsukumaran/vim-filesearch'
" Plug 'vim-scripts/Highlight-UnMatched-Brackets'
" Plug 'vim-scripts/xoria256.vim'
" Plug 'vim-scripts/TaskList.vim'
" Plug 'scrooloose/nerdtree'
" Plug 'vim-scripts/FuzzyFinder'
" Plug 'vim-scripts/bufexplorer.zip'
" Plug 'om/theshadowhost/Clippo'
" Plug 'vim-scripts/YankRing.vim'
" Plug 'Rip-Rip/clang_complete'
" Plug 'vim-scripts/calendar.vim--Matsumoto'
" Plug 'msanders/snipmate.vim'
" Plug 'mikewest/vimroom'
" Plug 'jeffkreeftmeijer/vim-numbertoggle'
" Plug 'noahfrederick/Hemisu'
" Plug 'chrisbra/csv.vim'
" Plug 'ivanov/vim-ipython'
" Plug 'fmoralesc/vim-pad'
" Plug 'vim-scripts/LargeFile'
" Plug 'maxbrunsfeld/vim-yankstack'
" Plug 'benmills/vimux'
" Plug 'terryma/vim-expand-region' " does not work correctly
" Plug 'mattn/webapi-vim'
" Plug 'mattn/gist-vim'
" Plug 'vim-scripts/DrawIt'
" Plug 'nelstrom/vim-visual-star-search' " Suspect errors when searching
" Plug 'scrooloose/syntastic'
" Plug 'LaTeX-Box-Team/LaTeX-Box' " not async
" Plug 'gyim/vim-boxdraw' " does not play well with vim-plug
" }}}

" {{{ language client
" currently not used because in favor of YouCompleteMe
if has('nvim') && 0
  Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': './install.sh'
    \ }
endif
" }}}


" {{{ haskell
if executable('ghc') && !has('nvim')
    Plug 'lukerandall/haskellmode-vim'
    Plug 'eagletmt/neco-ghc'
endif
if executable('hindent')
    Plug 'commercialhaskell/hindent'
endif
if executable('ghc-mod')
    Plug 'eagletmt/ghcmod-vim'
endif

if has('nvim') && executable('stack')
  Plug 'parsonsmatt/intero-neovim'
endif

" }}}

if has('nvim')
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
endif

if executable('ledger')
    Plug 'ledger/vim-ledger'
endif

" only use taskwarrior where we use task
if executable('task')
    Plug 'farseer90718/vim-taskwarrior'
endif

" {{{ Completion
" {{{ deoplete
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  if has("pythonx")
    source $HOME/.vim/compatibility/check_pynvim.pythonx.vim
  else
    source $HOME/.vim/compatibility/check_pynvim.python.vim
  endif

  if g:pynvim_available
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
  endif
endif
let g:deoplete#enable_at_startup = 1
" }}}

" {{{ YouCompleMe
function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.force
    !./install.py --clang-completer --system-libclang
  endif
endfunction

" Since YCM requires manual installation, dont enable it by default everywhere
let g:hosts_ycm=["dopamine", "lark", "hel", "abed", "beli"]
let g:hosts_no_jedi=["gordon"]
let g:ycm_requirements_met = v:version >= 704 || (v:version == 703 && has('patch584'))
if g:ycm_requirements_met && index(g:hosts_ycm, hostname()) >= 0
    Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
    Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
elseif index(g:hosts_no_jedi, hostname()) == -1
    Plug 'davidhalter/jedi-vim'
endif
" }}}
" }}}

if v:version >= 703
      " Plug 'chrisbra/histwin.vim'
endif
if v:version >= 704
    Plug 'SirVer/ultisnips'
endif


let s:atp_hosts=["lark"]
if index(s:atp_hosts, hostname()) >= 0
    Plug 'dermusikman/sonicpi.vim'
endif

" For standalone only (see
" https://github.com/Lokaltog/powerline/blob/develop/docs/source/overview.rst)
" Plug 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
" }}}

" {{{ My stuff
Plug 'obreitwi/vim-sort-folds'
" }}}

" {{{ Other repositories
" Only install atp on hosts where latex editing takes place
" let s:atp_hosts=["juno", "phaelon", "nurikum"]
let s:atp_hosts=[]
if index(s:atp_hosts, hostname()) >= 0
      " Plug 'git://atp-vim.git.sourceforge.net/gitroot/atp-vim/atp-vim'
endif
" }}}

" {{{ postscript
call plug#end()

" Update vim-plug via vim-plug and no special command
delc PlugUpgrade
" vim: fdm=marker
" }}}
