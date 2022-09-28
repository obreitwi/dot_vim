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
Plug 'Twinside/vim-haskellConceal'
Plug 'caio/querycommandcomplete.vim'
Plug 'christoomey/vim-sort-motion'
Plug 'idbrii/textobj-word-column.vim' " active fork 'coderifous/textobj-word-column.vim'
Plug 'godlygeek/tabular'
Plug 'honza/vim-snippets'
Plug 'jamessan/vim-gnupg'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-user'
Plug 'majutsushi/tagbar'
Plug 'mantiz/vim-plugin-dirsettings'
Plug 'michaeljsmith/vim-indent-object'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'nathangrigg/vim-beancount'
Plug 'qpkorr/vim-renamer'
Plug 'rhysd/vim-clang-format'
Plug 'rkitover/vimpager'
Plug 'rust-lang/rust.vim'
Plug 'sanjayankur31/sli.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'sjbach/lusty'
Plug 'tommcdo/vim-exchange'
Plug 'trapd00r/vim-syntax-vidir-ls'
Plug 'powerman/vim-plugin-AnsiEsc'
Plug 'vim-scripts/DirDiff.vim'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'vimwiki/vimwiki'
Plug 'terryma/vim-expand-region'
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
" {{{ venn.nvim
" Expectations: Draw useful boxes
" Reality: Often activated by accident -> keep disabled until actually used
if 0 && has('nvim')
  Plug 'jbyuki/venn.nvim'
endif
" }}}
" {{{ surround-funk
" Expectations: useful during coding
Plug 'Matt-A-Bennett/surround-funk.vim'
" }}}
" {{{ splitjoin
" Expectations: Actually used to split up long function calls
Plug 'AndrewRadev/splitjoin.vim'
" "}}}
" {{{ unicode
" Expectations: Actually used to insert unicode digraphs.
Plug 'chrisbra/unicode.vim'
" }}}
" {{{ windows.nvim
" Expectations:
" * Actually useful when dealing with windows
" * Might even solve resize bug
" Requirements
Plug 'anuvyklack/middleclass',
Plug 'anuvyklack/animation.nvim'
" Actual plugin
Plug 'anuvyklack/windows.nvim'
" }}}
" {{{ messages for easier debugging
if has('nvim')
  Plug 'AckslD/messages.nvim'
endif
" }}}
" {{{ should speed up startuptime
Plug 'nathom/filetype.nvim'
" }}}
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
" Disable for performance
" Plug 'obreitwi/vim-bling'
" }}}

" {{{ easymotion (or hop as faster alternative)
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

" {{{ browser addons

" revisit this with more time
let s:firenvim_hosts=["mucku", "mimir"]
if index(s:firenvim_hosts, s:hostname) >= 0 && has('nvim')
  Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
endif

" }}}
"
" {{{ treesitter
if has('nvim-0.5')
  let g:use_treesitter = 1

  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
  Plug 'nvim-treesitter/nvim-treesitter-context'
  Plug 'nvim-treesitter/nvim-treesitter-textobjects'
  Plug 'nvim-treesitter/playground'
  " Plug 'nvim-lua/plenary.nvim' | Plug 'nvim-telescope/telescope.nvim'
  Plug 'p00f/nvim-ts-rainbow'
  Plug 'anuvyklack/pretty-fold.nvim'
  Plug 'windwp/nvim-autopairs'
  Plug 'yioneko/nvim-yati'
else
  let g:use_treesitter = 0

  " Replacement for treesitter auto-pair
  Plug 'Raimondi/delimitMate'
  Plug 'ehamberg/vim-cute-python' " not working with treesitter-conceal
endif
" }}}

" {{{ highlighting
" if g:use_easymotion
  " Plug 'lukas-reineke/indent-blankline.nvim'
" endif
" }}}

" {{{ jq
if has('nvim') && executable('jq')
  Plug 'bfrg/vim-jq'
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

  Plug 'yaegassy/coc-marksman', {'do': 'yarn install --frozen-lockfile'}

  if g:fzf_found
    Plug 'antoinemadec/coc-fzf'
  endif

  if has('nvim')
    Plug 'josa42/coc-lua', {'do': 'yarn install --frozen-lockfile'}
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

Plug 'hashivim/vim-terraform'
" }}}

" {{{ snippets
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

" Enable via
" :lua require'nvim-highlight-colors'.setup()
" Plug 'brenoprata10/nvim-highlight-colors'

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
" Useful to quickly share codelines.
" Plug 'ruanyl/vim-gh-line'
" Use fork until time found to push changes upstream
Plug 'obreitwi/vim-gh-line'
" }}}

" {{{ Octo (disabled since moving away from github)
" if has('nvim')
" " {{{ Requirements
" Plug 'nvim-lua/plenary.nvim',
" Plug 'nvim-telescope/telescope.nvim',
" Plug 'kyazdani42/nvim-web-devicons',
" " }}}
" Plug 'pwntester/octo.nvim',
" endif
" }}}

" {{{ golang
if executable('go')
  Plug 'josa42/coc-go', {'do': 'yarn install --frozen-lockfile'}
  " Plug 'yaegassy/coc-go', {'do': 'yarn install --frozen-lockfile', 'branch': 'feat/inlay-hints'}
  " Plug 'darrikonn/vim-gofmt'
  Plug 'fatih/vim-go'
  Plug 'buoto/gotests-vim'
endif

if executable('dlv')
  Plug 'sebdah/vim-delve'
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

" {{{ neorg
" Expectations: Possible replacement for diary files and vimwiki
if has('nvim-0.8')
  Plug 'nvim-neorg/neorg' | Plug 'nvim-lua/plenary.nvim'
  Plug 'max397574/neorg-contexts'
endif
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
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
" Plug 'tpope/vim-repeat'
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

" {{{ disabled stuff / plugin detox 
" {{{ used at some point
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
" {{{ 2022
" Plug 'sickill/vim-pasta' " Disabled to see if it is actually used
" currently not used because in favor of coc
" if has('nvim') && 0
"   Plug 'autozimu/LanguageClient-neovim', {
"     \ 'branch': 'next',
"     \ 'do': './install.sh'
"     \ }

" {{{ vim-move
" Expectations: is actually used
" Actual: Cause more accidents than intentional move of code.
" Plug 'matze/vim-move'
" }}}
" Plug 'tkhren/vim-fake' " Not really used after finishing thesis
" if v:version >= 703
      " Plug 'chrisbra/histwin.vim'
" endif
" Plug 'tmhedberg/SimpylFold' " replaced by treesitter folding
" {{{ vim-lsp-cxx-hightlight replaced by treesitter
" if s:coc_enabled
"   Plug 'jackguo380/vim-lsp-cxx-highlight'
" endif
" }}}
" Plug 'tpope/vim-eunuch' " clashes with coc
" Plug 'ehamberg/vim-cute-python' " not working with treesitter-conceal
" " Plug 'mileszs/ack.vim'
" Plug 'obreitwi/ack.vim' " Use own fork until https://github.com/mileszs/ack.vim/pull/276 is merged
" {{{ simply not used
" Plug 'dyng/ctrlsf.vim'
" Plug 'aquach/vim-http-client'
" Plug 'prendradjaja/vim-vertigo'
" Plug 'groenewege/vim-less'
" Plug 'jceb/vim-orgmode'
" Plug 'guns/xterm-color-table.vim'
" }}}
" Plug 'w0rp/ale' " Disabled to see if missed
" }}}
" }}}

" {{{ Postscript
call plug#end()

" Update vim-plug via vim-plug and no special command
delc PlugUpgrade
" vim: fdm=marker foldminlines=0
" }}}
