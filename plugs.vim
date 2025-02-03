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
" Plug 'obreitwi/lusty', {'branch': 'workaround/ensure_proper_height'}
Plug 'tommcdo/vim-exchange'
Plug 'trapd00r/vim-syntax-vidir-ls'
Plug 'powerman/vim-plugin-AnsiEsc'
Plug 'vim-scripts/DirDiff.vim'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'vimwiki/vimwiki'
Plug 'terryma/vim-expand-region'
if !g:nix_enabled
  " Replaced by vista.vim installed via nix
  Plug 'majutsushi/tagbar'
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
" {{{ venn.nvim
" Expectations: Draw useful boxes
" Reality: Often activated by accident -> keep disabled until actually used
let g:venn_enabled=1
if has('nvim') && g:venn_enabled > 0
  Plug 'jbyuki/venn.nvim'
endif
" }}}
" {{{ surround-funk
" Expectations: useful during coding
" Reality: Never used
" Plug 'Matt-A-Bennett/surround-funk.vim'
" }}}
" {{{ unicode
" Expectations: Actually used to insert unicode digraphs.
Plug 'chrisbra/unicode.vim'
" }}}
" }}}

" {{{ silicon
if has('nvim') && executable('silicon')
  Plug 'michaelrommel/nvim-silicon'
endif
" }}}

" {{{ lua-console
if has('nvim')
  Plug 'YaroSpace/lua-console.nvim'
endif
" }}}

" {{{ messages for easier debugging
if has('nvim')
  Plug 'AckslD/messages.nvim'
endif
" }}}

" {{{ dab debugging
if has('nvim')
  Plug 'mfussenegger/nvim-dap'
  Plug 'nvim-neotest/nvim-nio' " required by nvim-dap-ui
  Plug 'rcarriga/nvim-dap-ui'
  if executable('go')
    Plug 'leoluz/nvim-dap-go'
  endif
endif
" }}}

" {{{ terminal integration
if has('nvim')
  Plug 'akinsho/toggleterm.nvim', {'tag' : '*'} " installed with v2
endif
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

" {{{ lusty
let g:lusty_enabled=0
if g:lusty_enabled
  Plug 'sjbach/lusty'
endif
" }}}

" {{{ black
if has("python3")
python3 << endpython3
import vim
try:
  import pip
  import venv
  vim.command("let g:black_enabled = 1")
except Exception:
  vim.command("let g:black_enabled = 0")
endpython3

  if g:black_enabled == 1
    Plug 'psf/black', { 'tag': '*' }
  endif
endif
" }}}
"
" {{{ pr pending (done)
" Plug 'ivyl/vim-bling' " temporarily disabled till PR merged:
" https://github.com/ivyl/vim-bling/pull/16
" Disable for performance
" Plug 'obreitwi/vim-bling'
" }}}

" {{{ fast moving
" Expections:
" * Easy of use
" * Actually gets used
let g:hop_enabled = 1
let g:flash_enabled = 0
if has('nvim') && g:hop_enabled
  Plug 'smoka7/hop.nvim'
endif
if has('nvim') && g:flash_enabled
  Plug 'folke/flash.nvim'
endif
if !has('nvim')
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
if has('nvim-0.8')
  let g:treesitter_enabled = 1

  if !g:nix_enabled
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
    Plug 'nvim-treesitter/nvim-treesitter-context'
    Plug 'nvim-treesitter/nvim-treesitter-textobjects'
    Plug 'nvim-treesitter/playground'
    " Plug 'nvim-lua/plenary.nvim' | Plug 'nvim-telescope/telescope.nvim'
    " Plug 'HiPhish/nvim-ts-rainbow2' " no longer maintained, replaced by plugin below
    Plug 'https://gitlab.com/HiPhish/rainbow-delimiters.nvim'
    if !has('nvim-0.10')
      " pretty fold has incompatibilities with neovim 0.10
      Plug 'anuvyklack/pretty-fold.nvim'
    endif
    Plug 'windwp/nvim-autopairs'
    " Plug 'yioneko/nvim-yati'
    Plug 'abecodes/tabout.nvim'

    Plug 'Wansmer/treesj'
  endif
else
  let g:treesitter_enabled = 0

  " Replacement for treesitter auto-pair
  Plug 'Raimondi/delimitMate'
  Plug 'ehamberg/vim-cute-python' " not working with treesitter-conceal

  " fall-back for treesj
  Plug 'AndrewRadev/splitjoin.vim'
endif
" }}}

" {{{ highlighting
" if g:easymotion_enabled
  Plug 'lukas-reineke/indent-blankline.nvim'
" endif
" }}}

" {{{ jq
if has('nvim') && executable('jq')
  Plug 'bfrg/vim-jq'
endif
" }}}

" {{{ picker: fzf / telescope
let g:fzf_enabled = 1
let g:telescope_enabled = 1

let g:fzf_found = 0
if g:fzf_enabled && executable('fzf')
  let g:fzf_found = 1
  " We rely on fzf being installed system-wide -> no call to #install()
  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim'

  if executable('rg')
    Plug 'yazgoo/yank-history'
  endif
elseif !g:telescope_enabled
  " Fallback onto ctrlp
  Plug 'ctrlpvim/ctrlp.vim'
endif

if g:telescope_enabled
  " requirement:
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-tree/nvim-web-devicons'
  if !g:nix_enabled
    Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
    Plug 'nvim-neorg/neorg-telescope'
  endif

  if executable('sg')
    Plug 'Marskey/telescope-sg'
  endif
endif
" }}}

" {{{ registers
" Plug 'junegunn/vim-peekaboo'
Plug 'Gee19/vim-peekaboo' " fixes resize bug
" }}}

" {{{ latex
" Insert unicode symbols based on their latex names (disabled because not
" really used)
" Plug 'joom/latex-unicoder.vim'

let s:latex_hosts=["abed", "mucku", "mimir"]
let s:latex_enabled = index(s:latex_hosts, s:hostname) >= 0

if s:latex_enabled
  Plug 'lervag/vimtex'
  " Plug 'dpelle/vim-LanguageTool' Does not work!
  Plug 'rhysd/vim-grammarous'
endif
" }}}

" {{{ CoC
let s:coc_hosts=["mimir", "mucku"]
let g:lsp_enabled = has('nvim')
let g:coc_enabled = ((has('nvim') || v:version >= 802) && index(s:coc_hosts, s:hostname) >= 0)

let g:coc_enabled = 0

if g:coc_enabled
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
    " Plug 'josa42/coc-lua', {'do': 'yarn install --frozen-lockfile'} " not maintained
    Plug 'xiyaowong/coc-sumneko-lua', {'do': 'yarn install --frozen-lockfile'}
  endif

  if executable('sqlfluff')
    Plug 'yaegassy/coc-sqlfluff', {'do': 'yarn install --frozen-lockfile'}
  endif

  if executable('sg')
    Plug 'yaegassy/coc-ast-grep', {'do': 'yarn install --frozen-lockfile'}
  endif

  let g:using_coc=1
elseif !g:lsp_enabled
  " Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
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

if g:lsp_enabled
  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/cmp-nvim-lsp' " LSP source for nvim-cmp
  Plug 'hrsh7th/cmp-buffer' " LSP source for nvim-cmp
  Plug 'hrsh7th/nvim-cmp'
  Plug 'ray-x/lsp_signature.nvim'
  Plug 'quangnguyen30192/cmp-nvim-ultisnips'
  " Plug 'saadparwaiz1/cmp_luasnip' " Snippets source for nvim-cmp
  " Plug 'L3MON4D3/LuaSnip' " Snippets plugin
  " Plug 'L3MON4D3/LuaSnip', {'tag': 'v2.*', 'do': 'make install_jsregexp'}
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
if !has('nvim')
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'ryanoasis/vim-devicons'
  let g:airline_enabled = 1
else
  Plug 'nvim-lualine/lualine.nvim'
  let g:airline_enabled = 0
endif
" }}}

" {{{ icon picker
let g:icon_picker_enabled=1
if has('nvim') && g:icon_picker_enabled
Plug 'stevearc/dressing.nvim'
Plug 'ziontee113/icon-picker.nvim'
endif
" }}}

" {{{ file navigation
" Plug 'SidOfc/carbon.nvim' " NOTE: Should be AFTER airline
if has('nvim') && !g:nix_enabled
  Plug 'elihunter173/dirbuf.nvim' " replaced by oil.nvim in nix
endif

Plug 'wsdjeg/vim-fetch'
" }}}

" {{{ audio stuff
let s:tidal_hosts=["abed"]
if index(s:tidal_hosts, s:hostname) >= 0
  Plug 'tidalcycles/vim-tidal'
  Plug 'supercollider/scvim'
endif
let s:sonicpi_hosts=["lark"]
if index(s:sonicpi_hosts, s:hostname) >= 0
    Plug 'dermusikman/sonicpi.vim'
endif
" }}}

" {{{ colors
Plug 'icymind/NeoSolarized'
if has('nvim')
  Plug 'ellisonleao/gruvbox.nvim'
else
  Plug 'morhetz/gruvbox'
endif

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
  if g:coc_enabled
    Plug 'iamcco/coc-flutter', {'do': 'yarn install --frozen-lockfile'}
    " Plug 'theniceboy/coc-flutter-tools', {'do': 'yarn install --frozen-lockfile'}
  endif
endif
" }}}

" {{{ git
" See also fugitive and vim-git under tpope
if has('nvim-0.9')
  Plug 'lewis6991/gitsigns.nvim'
else
  Plug 'airblade/vim-gitgutter'
endif
" Faster gitv replacment
Plug 'junegunn/gv.vim'
" Plug 'mhinz/vim-signify'
Plug 'rbong/vim-flog'
" Useful to quickly share codelines.
" Plug 'ruanyl/vim-gh-line'
" Use fork until time found to push changes upstream
Plug 'obreitwi/vim-gh-line'
" Use two way diffs for conflict resolution
" (NOTE: Needs to define own diff tool in git)
Plug 'whiteinge/diffconflicts'
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
  if g:coc_enabled
    Plug 'josa42/coc-go', {'do': 'yarn install --frozen-lockfile'}
  endif
  " Plug 'yaegassy/coc-go', {'do': 'yarn install --frozen-lockfile', 'branch': 'feat/inlay-hints'}
  " Plug 'darrikonn/vim-gofmt'
  Plug 'fatih/vim-go'
  Plug 'buoto/gotests-vim'
endif

if executable('dlv') && 0
  Plug 'sebdah/vim-delve'
endif
" }}}

" {{{ haskell
if executable('ghc') && !has('nvim')
    Plug 'lukerandall/haskellmode-vim'
    Plug 'eagletmt/neco-ghc'
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
" For standalone only (see
" https://github.com/Lokaltog/powerline/blob/develop/docs/source/overview.rst)
" Plug 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
" }}}

" {{{ neorg
" Expectations: Possible replacement for diary files and vimwiki
if has('nvim-0.8') 
  if !g:nix_enabled
    " neorg does not support vim-plug after v8.0.0+ so stay on v7 
    Plug 'nvim-neorg/neorg', {'do': ':Neorg sync-parsers', 'tag': 'v7.0.0'}
    Plug 'nvim-lua/plenary.nvim'
  endif
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
Plug 'tpope/vim-eunuch'
if !has('nvim')
  Plug 'tpope/vim-vinegar' " replaced by dirbuf
endif
" }}}

" {{{ unite

let g:unite_enabled = 0
if !g:coc_enabled && !g:fzf_found && !g:lsp_enabled
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

" {{{ code coverage
if has('nvim')
  " needs to be done after gitgutter?
  Plug 'nvim-lua/plenary.nvim'
  Plug 'andythigpen/nvim-coverage'"
endif
" }}}

" {{{ disabled stuff / plugin detox 
" {{{ winbar
" BLOCKED: navic rquires lspconfig which clashes with coc.
" NOTE: Load AFTER colorscheme
" Plug 'SmiteshP/nvim-navic'
" Plug 'nvim-tree/nvim-web-devicons'
" Plug 'utilyre/barbecue.nvim'

" The coc-variant gives the same info as context-plugins -> not needed
" if g:using_coc
"   Plug 'xiyaowong/coc-symbol-line', {'do': 'yarn install --frozen-lockfile'}
" endif
" }}}

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
" }}}
" {{{ 2021
" Replaced by mundo:
" Plug 'sjl/gundo.vim'
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
" if g:coc_enabled
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
" {{{ windows.nvim
" " Expectations:
" " * Actually useful when dealing with windows
" " * Might even solve resize bug
" " Reality:
" " * Does not work on all cases and too inconsistent.
" " Requirements
" Plug 'anuvyklack/middleclass',
" Plug 'anuvyklack/animation.nvim'
" " Actual plugin
" Plug 'anuvyklack/windows.nvim'
" }}}
" }}}
" }}}

" {{{ Postscript
call plug#end()

" Update vim-plug via vim-plug and no special command
delc PlugUpgrade
" vim: fdm=marker foldminlines=0
" }}}
