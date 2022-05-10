" {{{ Preamble
" Misc stuff first
let s:hostname = hostname()

call plug#begin('~/.vim/plugged')

Plug 'junegunn/vim-plug'

" needed to add local folders to the rtp
Plug 'tpope/vim-pathogen'
" }}}

" {{{ common
Plug 'AndrewRadev/id3.vim'
Plug 'AndrewRadev/linediff.vim'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'PeterRincker/vim-argumentative'
Plug 'Raimondi/delimitMate'
Plug 'Twinside/vim-haskellConceal'
Plug 'aquach/vim-http-client'
Plug 'caio/querycommandcomplete.vim'
Plug 'christoomey/vim-sort-motion'
Plug 'idbrii/textobj-word-column.vim' " active fork 'coderifous/textobj-word-column.vim'
Plug 'dyng/ctrlsf.vim'
Plug 'ehamberg/vim-cute-python'
Plug 'godlygeek/tabular'
Plug 'groenewege/vim-less'
Plug 'guns/xterm-color-table.vim'
Plug 'honza/vim-snippets'
Plug 'jamessan/vim-gnupg'
Plug 'jceb/vim-orgmode'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-user'
Plug 'majutsushi/tagbar'
Plug 'mantiz/vim-plugin-dirsettings'
Plug 'michaeljsmith/vim-indent-object'
" Plug 'mileszs/ack.vim'
Plug 'obreitwi/ack.vim' " Use own fork until https://github.com/mileszs/ack.vim/pull/276 is merged
Plug 'nathanaelkane/vim-indent-guides'
Plug 'nathangrigg/vim-beancount'
Plug 'prendradjaja/vim-vertigo'
Plug 'qpkorr/vim-renamer'
Plug 'rhysd/vim-clang-format'
Plug 'rkitover/vimpager'
Plug 'rust-lang/rust.vim'
Plug 'sanjayankur31/sli.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'sickill/vim-pasta'
Plug 'sjbach/lusty'
Plug 'tmhedberg/SimpylFold'
Plug 'tommcdo/vim-exchange'
Plug 'trapd00r/vim-syntax-vidir-ls'
Plug 'powerman/vim-plugin-AnsiEsc'
Plug 'vim-scripts/DirDiff.vim'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'vimwiki/vimwiki'
Plug 'w0rp/ale'
Plug 'terryma/vim-expand-region'
Plug 'tkhren/vim-fake'
if has('nvim-0.5')
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
  let g:use_treesitter = 1
else
  let g:use_treesitter = 0
endif
" }}}

" {{{ To evaluate
" {{{ diffchar:
" Expectations:
" * Should improve diff readability.
" Possible Problems:
" * Might slow down larger diffs.
" Realizations:
" * So far no problems found --obreitwi, 08-11-21 10:44:05 
Plug 'rickhowe/diffchar.vim'
" }}}
" {{{ vim-titlecase
" Expectations:
" * Should not slow done text handling in large LaTeX files
Plug 'christoomey/vim-titlecase'
" }}}
" {{{ hop as faster easymotion
" Expections:
" * Easy of use
" * Actually gets used
let g:use_easymotion = 0
if has('nvim') && !g:use_easymotion
  Plug 'phaazon/hop.nvim'
else
  Plug 'Lokaltog/vim-easymotion'
  Plug 'justinmk/vim-sneak'
endif
" }}}
" {{{ venn.nvim
" Expectations: Draw useful boxes
if has('nvim')
  Plug 'jbyuki/venn.nvim'
endif
" }}}
" {{{ vim-gh-line
" Expectations: Useful to quickly share codelines.
Plug 'ruanyl/vim-gh-line'
" }}}
" {{{ vim-move
" Expectations: is actually used
Plug 'matze/vim-move'
" }}}
" {{{ surround-funk
" Expectations: useful during coding
Plug 'Matt-A-Bennett/surround-funk.vim'
" }}}
" {{{ splitjoin
" Expectations: Actually used to split up long function calls  
Plug 'AndrewRadev/splitjoin.vim'
" "}}}
" }}}

" {{{ mundo
" Expectations:
" * Should be faster than gundo
" Notes:
" * It is as slow to open as gundo for large histories
" * Seems faster on subsequent openings
" Verdict:
" * Is faster than gundo → accepted
Plug 'simnalamburt/vim-mundo'
" }}}

" {{{ black
if has("python3")
python3 << endpython3
import vim
try:
  import pip
  import venv
  vim.command("let g:use_black = 1")
except Exception:
  vim.command("let g:use_black = 0")
endpython3

  if g:use_black == 1
    Plug 'psf/black', { 'tag': '*' }
  endif
endif
" }}}
"
" {{{ pr pending
" Plug 'ivyl/vim-bling' " temporarily disabled till PR merged:
" https://github.com/ivyl/vim-bling/pull/16
Plug 'obreitwi/vim-bling'
" }}}

" {{{ browser addons

" revisit this with more time
let s:firenvim_hosts=["mucku", "mimir"]
if index(s:firenvim_hosts, s:hostname) >= 0 && has('nvim')
  Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
endif

" }}}

" {{{ highlighting
if has('nvim-0.5')
  Plug 'lukas-reineke/indent-blankline.nvim'
  " nvim-ts-rainbow requires nightly, so periodically check for a version
  " working with stable or remove plugin
  Plug 'p00f/nvim-ts-rainbow', { 'commit': '5fa662e85f736f7ffce0e75b9d98a99f9aca0e4f' }
endif
" }}}

" {{{ fzf

if executable('fzf')
  let g:fzf_found = 1
  " We rely on fzf being installed system-wide -> no call to #install()
  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim'

  if executable('rg')
    Plug 'yazgoo/yank-history'
  endif
else
  let g:fzf_found = 0
  " Fallback onto ctrlp
  Plug 'ctrlpvim/ctrlp.vim'
endif

" }}}

" {{{ latex
" Insert unicode symbols based on their latex names
Plug 'joom/latex-unicoder.vim'

let s:latex_hosts=["abed", "mucku", "mimir"]
let s:latex_enabled = index(s:latex_hosts, s:hostname) >= 0

if s:latex_enabled
  Plug 'lervag/vimtex'
  " Plug 'dpelle/vim-LanguageTool' Does not work!
  Plug 'rhysd/vim-grammarous'
endif
" }}}

" {{{ CoC
let s:coc_hosts=["abed", "mucku", "helvetica.kip.uni-heidelberg.de", "mimir"]
let s:coc_enabled = (has('nvim') || v:version >= 802) && index(s:coc_hosts, s:hostname) >= 0
if s:coc_enabled
  " Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'}
  if executable('python')
    Plug 'fannheyward/coc-pyright', {'do': 'yarn install --frozen-lockfile'}
  endif
  if executable('java')
    Plug 'neoclide/coc-java', {'do': 'yarn install --frozen-lockfile'}
  endif
  if executable('rustc')
    Plug 'fannheyward/coc-rust-analyzer', {'do': 'yarn install --frozen-lockfile'}
    " Plug 'neoclide/coc-rls', {'do': 'yarn install --frozen-lockfile'}
  endif

  if s:latex_enabled
    Plug 'neoclide/coc-vimtex', {'do': 'yarn install --frozen-lockfile'}
    Plug 'fannheyward/coc-texlab', {'do': 'yarn install --frozen-lockfile'}
  endif

  if g:fzf_found
    Plug 'antoinemadec/coc-fzf'
  endif

  let g:using_coc=1
  " Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  " TODO: this check is very very slow!
  if has("pythonx")
    source $HOME/.vim/compatibility/check_pynvim.pythonx.vim
  elseif has("python3")
    source $HOME/.vim/compatibility/check_pynvim.python3.vim
  elseif has("python")
    source $HOME/.vim/compatibility/check_pynvim.python.vim
  else
    let g:pynvim_available=0
  endif

  if g:pynvim_available
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
  endif
endif

let g:deoplete#enable_at_startup = 1

" }}}


" {{{ syntax
Plug 'cespare/vim-toml'
if s:coc_enabled
  Plug 'jackguo380/vim-lsp-cxx-highlight'
endif

Plug 'hashivim/vim-terraform'
" }}}

" {{{ snippets
if v:version >= 703
      " Plug 'chrisbra/histwin.vim'
endif
if v:version >= 704
  Plug 'SirVer/ultisnips'
endif
" }}}

" {{{ statusline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
" }}}

" {{{ audio stuff
let s:tidal_hosts=["abed"]
if index(s:tidal_hosts, s:hostname) >= 0
  Plug 'tidalcycles/vim-tidal'
  Plug 'supercollider/scvim'
endif
" }}}

" {{{ colors
Plug 'icymind/NeoSolarized'
Plug 'morhetz/gruvbox'

" tigrana: Tried it, fold headings blend in with the background -> not nice
" Plug 'iKarith/tigrana'
" }}}

" {{{ dart
if executable('dart')
  Plug 'dart-lang/dart-vim-plugin'
  " Using CoC as client instead
  " Plug 'natebosch/vim-lsc'
  " Plug 'natebosch/vim-lsc-dart'
  let g:lsc_auto_map = v:true
endif

if executable('flutter')
  Plug 'thosakwe/vim-flutter'
  Plug 'iamcco/coc-flutter', {'do': 'yarn install --frozen-lockfile'}
  " Plug 'theniceboy/coc-flutter-tools', {'do': 'yarn install --frozen-lockfile'} 
endif
" }}}

" {{{ git
" See also fugitive and vim-git under tpope
Plug 'airblade/vim-gitgutter'
" Faster gitv replacment
Plug 'junegunn/gv.vim'
" Plug 'mhinz/vim-signify'
Plug 'rbong/vim-flog'
" }}}

" {{{ golang
if executable('go')
  Plug 'josa42/coc-go', {'do': 'yarn install --frozen-lockfile'}
  " Plug 'darrikonn/vim-gofmt'
  Plug 'fatih/vim-go'
  Plug 'buoto/gotests-vim'
endif

if executable('dlv')
  Plug 'sebdah/vim-delve'
endif
" }}}

" {{{ disabled stuff:
" {{{ plugin detox 
" {{{ 2019
" temoporarily disabled plugins to see if I really miss them
" Plug 'kana/vim-textobj-line'
" Plug 'vim-scripts/L9'
" Plug 'kana/vim-operator-user'
" if has('nvim') && executable('stack')
  " Plug 'parsonsmatt/intero-neovim'
" endif
" }}}
" {{{ 2020
" {{{ youcompleteme
" function! BuildYCM(info)
"   " info is a dictionary with 3 fields
"   " - name:   name of the plugin
"   " - status: 'installed', 'updated', or 'unchanged'
"   " - force:  set on PlugInstall! or PlugUpdate!
"   if a:info.status != 'unchanged' || a:info.force
"     !git submodule update --init --recursive
"     let l:args = []
"     if executable("go")
"       call add(l:args, "--go-completer")
"     endif
"     if executable("clang")
"       call add(l:args, "--clang-completer")
"       " call add(l:args, "--clangd-completer")
"       " try upstream pre-built clang with built clangd because system clangd
"       " is not working....
"       call add(l:args, "--system-libclang")
"     endif
"     let l:update_command = "!./install.py " . join(l:args, " ")
"     exec l:update_command
"   endif
" endfunction
" 
" " Since YCM requires manual installation, dont enable it by default everywhere
" let g:hosts_ycm=["dopamine", "lark", "helvetica", "beli"]
" let g:hosts_no_jedi=["gordon"]
" let g:ycm_requirements_met = v:version >= 704 || (v:version == 703 && has('patch584'))
" if 0 && g:ycm_requirements_met && index(g:hosts_ycm, hostname()) >= 0
"     Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
"     Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
" elseif 0 && index(g:hosts_no_jedi, hostname()) == -1
"     Plug 'davidhalter/jedi-vim'
" endif
" }}}
" {{{ 2021
" Replaced by mundo:
" Plug 'sjl/gundo.vim'
" }}}
" }}}
" {{{ other
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
" Plug 'mattn/webapi-vim'
" Plug 'mattn/gist-vim'
" Plug 'vim-scripts/DrawIt'
" Plug 'nelstrom/vim-visual-star-search' " Suspect errors when searching
" Plug 'scrooloose/syntastic'
" Plug 'LaTeX-Box-Team/LaTeX-Box' " not async
" Plug 'gyim/vim-boxdraw' " does not play well with vim-plug
" Plug 'gregsexton/gitv' " Superseeded by 'junegunn/gv.vim/
" }}}
" }}}
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

" }}}

" {{{ language server client
" currently not used because in favor of coc
if has('nvim') && 0
  Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': './install.sh'
    \ }
endif
" }}}

" {{{ ledger 
if executable('ledger')
    Plug 'ledger/vim-ledger'
endif
" }}}

" {{{ misc
let s:sonicpi_hosts=["lark"]
if index(s:sonicpi_hosts, s:hostname) >= 0
    Plug 'dermusikman/sonicpi.vim'
endif

" For standalone only (see
" https://github.com/Lokaltog/powerline/blob/develop/docs/source/overview.rst)
" Plug 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
" }}}

" {{{ my stuff
Plug 'obreitwi/vim-sort-folds'
" }}}

" {{{ neovim

if has('nvim')
  " Needed because :SudoWrite does not work in neovim
  Plug 'lambdalisue/suda.vim'
  " TODO: Evaluate against fire-nvim
  " Plug 'raghur/vim-ghost', {'do': ':GhostInstall'}
endif

" }}}

" {{{ taskwarrior
" only use taskwarrior where we use task
if executable('task')
    Plug 'farseer90718/vim-taskwarrior'
endif
" }}}

" {{{ tpope plugins
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
" }}}

" {{{ unite

let g:unite_enabled = 0
if !s:coc_enabled || !g:fzf_found
  let g:unite_enabled = 1
  Plug 'Shougo/unite.vim'
  Plug 'Shougo/neomru.vim'
  Plug 'Shougo/vimproc.vim'
  Plug 'shougo/unite-outline'
  Plug 'shougo/neoyank.vim'
  Plug 'Shougo/vimfiler.vim'
  Plug 'Shougo/neossh.vim'
endif

" }}}

" {{{ Postscript
call plug#end()

" Update vim-plug via vim-plug and no special command
delc PlugUpgrade
" vim: fdm=marker
" }}}
