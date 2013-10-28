" {{{ Prelude
augroup vimrc
autocmd! vimrc *

set nocompatible
filetype off

if has("win16") || has("win32") || has("win64")
	let g:opsystem = "windows"
else
	let g:opsystem = substitute(system('uname'), "\n", "", "")
endif
" To make sure vim works with fish, adjust shell
if $SHELL =~ "/fish$"
	set shell="/bin/bash"
endif

" Load all own bundles
" let s:vundle_path = expand('<sfile>:p:h') . '/vundles.vim'
if g:opsystem == "windows"
	" No vundle on windows just snapshots of repos under bundle
	" We have pathogen for that
	runtime bundle/vim-pathogen/autoload/pathogen.vim
	execute pathogen#infect()
else
	source $HOME/.vim/vundles.vim
endif

" Have pathogen load the other local/non-git plugins
call pathogen#infect("bundle-pathogen/{}")

" }}}
" {{{ Functions
function! EnsureDirExists (dir)
	if !isdirectory(a:dir)
		if exists("*mkdir")
			call mkdir(a:dir,'p')
			echo "Created directory: " . a:dir
		else
			echo "Please create directory: " . a:dir
		endif
	endif
endfunction

" Run shell command and write output in new buffer
function! s:RunShellCommand(cmdline)
	echo a:cmdline
	let expanded_cmdline = a:cmdline
	for part in split(a:cmdline, ' ')
		if part[0] =~ '\v[%#<]'
			let expanded_part = fnameescape(expand(part))
			let expanded_cmdline = substitute(expanded_cmdline, part, expanded_part, '')
		endif
	endfor
	botright new
	setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
	call setline(1, 'You entered:    ' . a:cmdline)
	call setline(2, 'Expanded Form:  ' .expanded_cmdline)
	call setline(3,substitute(getline(2),'.','=','g'))
	execute '$read !'. expanded_cmdline
	setlocal nomodifiable
endfunction

" Capture output of vim command
function! Command(cmd)
	redir => message
	silent execute a:cmd
	redir END
	tabnew
	silent put=message
	set nomodified
endfunction

function! CreateTimestamp()
	normal! oCreated:
	normal! a TIMESTAMP
	" call EnhancedCommentify('', 'first')
	normal! oLast modified:
	" this is a comment to prevent TIMESTAMP from being evaluated
	normal! a TIME
	normal! aSTAMP
endfunction

" Jump to next closed fold
function! NextClosedFold(dir)
    let cmd = 'norm!z' . a:dir
    let view = winsaveview()
    let [l0, l, open] = [0, view.lnum, 1]
    while l != l0 && open
        exe cmd
        let [l0, l] = [l, line('.')]
        let open = foldclosed(l) < 0
    endwhile
    if open
        call winrestview(view)
    endif
endfunction

" Set the color column depending on what filetype is set
function! SetColorColumn()
	let l:tw = get(s:filetype_to_textwidth, &ft, 80) + 1
	call matchadd('ColorColumn', '\%'. l:tw . 'v', 100)
endfunction

" }}}
" {{{ Commands

" Enable folding
command! Folds set fdm=syntax

" Shell with output captured
command! -complete=shellcmd -nargs=+ Shell call s:RunShellCommand(<q-args>)

" Command with output captured
command! -nargs=+ -complete=command Command call Command(<q-args>)

command! SOvnorm let g:solarized_visibility="normal" | colorscheme solarized
command! SOvlow let g:solarized_visibility="low" | colorscheme solarized

command! -nargs=0 -complete=command TS call CreateTimestamp()

" Font settings
command! FIncon set guifont=Inconsolata\ Medium\ 10
command! FInconP set guifont=Inconsolata\ for\ Powerline\ Medium\ 10
command! FEnvy set guifont=Envy\ Code\ R\ 8

command! Vundles tabe $HOME/.vim/vundles.vim

" Open vimrc/tex in new tab
if g:opsystem != "windows"
	command! -nargs=0 -complete=command Vimrc tabe $MYVIMRC
	command! -nargs=0 -complete=command FTex tabe
\	~/.vim/bundle-own/various-ft-scripts/ftplugin/tex.vim
else 
	command! -nargs=0 -complete=command Vimrc tabe $VIM/vimfiles/vimrc
	command! -nargs=0 -complete=command FTex tabe
\	$VIM/vimfiles/bundle-own/various-ft-scripts/ftplugin/tex.vim
endif

" Spelling
command! -nargs=0 -complete=command Spde setlocal spelllang=de
command! -nargs=0 -complete=command Thde setlocal thesaurus=
\	/usr/share/mythes/th_de_DE.v2.dat
command! -nargs=0 -complete=command Spen setlocal spelllang=en
command! -nargs=0 -complete=command Then setlocal thesaurus=
\	/usr/share/mythes/th_en_US.v2.dat

" Lazy bunch
command! -nargs=0 -complete=command SA setf apache

" :Man command
if g:opsystem == "Linux"
	source $VIMRUNTIME/ftplugin/man.vim
end

" Grep helpers
command! -nargs=+ RGrep :grep -ri <q-args> .
" }}}
" {{{ General Mappings
" Plugin specific mappings are found in Plugins-section

" let mapleader=";"
let mapleader=" "
let maplocalleader=";"

noremap <Esc><Esc> <Esc>

map <f8> :setlocal spell!<CR>

" have Q reformat the current paragraph (or selected text if there is any):
nnoremap Q gqap
vnoremap Q gq

" Make Y work like C and D..
" changed for yankring
map Y y$ 

imap <silent> <C-D><C-E> <C-R>=strftime("%d.%m.%Y %H:%M:%S")<CR>
imap <silent> <C-D><C-D> <C-R> --obreitwi, <C-R>=strftime("%d-%m-%y %H:%M:%S")<CR>

nnoremap <silent> <c-u> :nohl<CR>
inoremap <silent> <c-u> <c-o>:nohl<CR>
nnoremap <c-q> <c-u>
inoremap <c-q> <c-u>
vnoremap <c-q> <c-u>
noremap M J
noremap J M
noremap j gj
noremap k gk

" Toggle relative numbers
nnoremap <leader>ss :set rnu!<CR>

" Toggle character listing
nmap <Leader>ll :set list!<CR>

" Lazy movement, for the few times it actually is faster than easymotion
nmap J 8j
vmap J 8j
nmap K 8k
vmap K 8k

" Disable annoying insert-mode bindings
imap <c-w> <nop>
imap <c-h> <nop>
" map K <nop>
map L <nop>
" imap <c-k> <nop>
imap <c-l> <nop>
imap <c-j> <c-x>

" omni completion (context)
imap <c-l> <c-x><c-o>
"
" Jump to next closed fold
nnoremap <silent> <leader>zj :call NextClosedFold('j')<cr>
nnoremap <silent> <leader>zk :call NextClosedFold('k')<cr>

" select put text, via http://stackoverflow.com/a/4775281/955926
nnoremap <expr> gV "`[".getregtype(v:register)[0]."`]"

nnoremap <c-e><c-h> :tabp<CR>
nnoremap <c-e><c-l> :tabn<CR>
" }}}
" {{{ Settings
set nocompatible
set hidden
set nowrap
" Wrap at word
set linebreak
set showbreak=↳\ 
set list
set virtualedit=all
" do not update screen while executing macros
set lazyredraw
" ttyfast: are we using a fast terminal? Let's try it for a while.
set ttyfast
set cul
" set timeoutlen=250
set timeoutlen=500
set cm=blowfish

" relative line numbers
set relativenumber
set number

" assume the /g flag on :s substitutions to replace all matches in a line:
set gdefault

set sessionoptions=blank,curdir,tabpages,folds,resize

set encoding=utf-8
"
"make backspace work
set backspace=indent,eol,start

set smarttab
set nu
set ai
set incsearch
set hlsearch
set ignorecase
" case only matters if search contains Upper case letters
set smartcase
set pastetoggle=<leader>tp " read as: toggle paste

set completeopt=menu,menuone,preview,longest

set wildmenu
set wildmode=list,full

" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
set shellslash

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" read files in automatically
set autoread

" Options for diff mode
set diffopt=filler,vertical,context:10

" No menu if we don't need it
if has("gui_running") 
    " No Pop Ups but console
	set go=c
end

" ack is called differently on debian
let s:true_ack_hosts = ["nurikum", "phaelon", "juno"]
if index(s:true_ack_hosts, hostname()) < 0
	let g:ackprg="ack-grep -H --nocolor --nogroup --column"
else
	let g:ackprg="ack -H --nocolor --nogroup --column"
endif

" Taken form: https://github.com/gregstallings/vimfiles/blob/master/vimrc
" Delete comment character when joining commented lines
if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j
endif
" Use only 1 space after "." when joining lines instead of 2
set nojoinspaces

let s:filetype_to_textwidth = {
\ "tex": 120
\}

" {{{ Backup settings
if g:opsystem != "windows"
	call EnsureDirExists( $HOME . '/.vimbackup' )
	set directory=~/.vimbackup//
endif
" }}}
" {{{ List Chars (Make sure they work on all platforms)

set listchars=tab:>\ ,trail:\ ,extends:>,precedes:<,nbsp:+
if (g:opsystem != "windows") && (&termencoding ==# 'utf-8' || &encoding ==# 'utf-8')
	" NOTE: These two lines are NOT the same characgters!
	" let &listchars = "tab:\u21e5 ,trail:\u2423,extends:\u21c9,precedes:\u21c7,nbsp:\u00b7"
	set listchars=tab:▸\ ,extends:⇉,precedes:⇇,nbsp:·,eol:¬,trail:␣
endif

" }}}
" }}}
" {{{ Filetype Settings
filetype plugin on
" autocmd FileType python set ofu=syntaxcomplete#Complete

filetype indent on

" Reload vimrc after writing
autocmd! vimrc BufWritePost .vimrc source $MYVIMRC
autocmd! vimrc BufWritePost vundles.vim source $MYVIMRC

autocmd vimrc FileType python setlocal omnifunc=pythoncomplete#Complete

autocmd vimrc BufNewFile,BufRead wscript* set filetype=python

autocmd filetype tex hi MatchParen ctermbg=black guibg=black

autocmd vimrc FileType python      setlocal tabstop=4 |     setlocal shiftwidth=4 |  setlocal expandtab
autocmd vimrc FileType yaml        setlocal tabstop=2 |     setlocal shiftwidth=2 |  setlocal expandtab
autocmd vimrc FileType matlab      setlocal tabstop=4 |     setlocal shiftwidth=4 |  setlocal expandtab
autocmd vimrc FileType vimwiki     setlocal tabstop=4 |     setlocal shiftwidth=4 |  setlocal expandtab | setlocal foldlevel=99
autocmd vimrc FileType html        setlocal tabstop=4 |     setlocal shiftwidth=4 |  setlocal softtabstop=4
autocmd vimrc FileType haskell     setlocal tabstop=4 |     setlocal shiftwidth=4
autocmd vimrc FileType cpp         setlocal tabstop=4 |     setlocal shiftwidth=4 |  setlocal softtabstop=4
autocmd vimrc FileType java        setlocal tabstop=4 |     setlocal shiftwidth=4 |  setlocal softtabstop=4
autocmd vimrc FileType c           setlocal tabstop=4 |     setlocal shiftwidth=4 |  setlocal softtabstop=4
autocmd vimrc FileType markdown    setlocal tabstop=4 |     setlocal shiftwidth=4 |  setlocal softtabstop=4
autocmd vimrc FileType javascript  setlocal tabstop=4 |     setlocal shiftwidth=4 |  setlocal softtabstop=4
autocmd vimrc FileType exim        setlocal tabstop=4 |     setlocal shiftwidth=4 |  setlocal softtabstop=4 | setlocal expandtab
autocmd vimrc FileType jinja       setlocal tabstop=2 |     setlocal shiftwidth=2 |  setlocal softtabstop=2 | setlocal expandtab
autocmd vimrc FileType mail        setlocal textwidth=72 |  setlocal wrapmargin=8 |  setlocal spell
autocmd vimrc FileType python let python_highlight_all = 1

" Autohotkey
autocmd vimrc BufNewFile,BufRead *.ahk setf autohotkey 
autocmd vimrc BufNewFile,BufRead *.txt setf txt 

" Apache config files
autocmd vimrc BufNewFile,BufRead /etc/apache2/* setf apache

" {{{ mutt
" au BufRead,BufNewFile /tmp/mutt-* set filetype=mail | nohl | set bg=dark | colo solarized | setlocal omnifunc=QueryCommandComplete
au BufRead,BufNewFile /tmp/mutt-* set filetype=mail | nohl | setlocal omnifunc=QueryCommandComplete
let g:qcc_query_command="nottoomuch-addresses-reformatted"
" }}}
" }}}
" {{{ Font config
" Nicer font in gvim for windows
if has("gui_running") && (g:opsystem == "windows")
	set guifont=Consolas:h10:cANSI
" elseif has("gui_running") && ( hostname() == "nurikum" )
elseif has("gui_running")
	FInconP
end
" }}}
" {{{ Color management
" Set really nice colors
syntax enable
if has( "gui_running" )
	set background=dark
	" let g:solarized_termtrans=0
	" let g:solarized_bold=1
	" let g:solarized_underline=1
	" let g:solarized_italic=1
	" let g:solarized_termcolors=16
	let g:solarized_contrast="normal"
	let g:solarized_visibility="low"
	let g:solarized_diffmode="high"
	" let g:solarized_hitrail=0
	" let g:solarized_menu=1
	colorscheme solarized
	call togglebg#map("<F5>")
elseif $TERM == "linux"
	colorscheme default
	" set nolist
else
	" let g:solarized_termcolors=256
	" let g:solarized_contrast="normal"
	" let g:solarized_visibility="low"
	" let g:solarized_diffmode="high"
	" let g:solarized_termtrans=1
	let g:solarized_termcolors=256
	set background=dark
	" let g:solarized_degrade=1
	" colorscheme solarized
	colorscheme xoria256
" This is a test of a line that will exceed 81 characters per line and should trigger the new setting
	" Highlight when a line exceeds 81 characters
	highlight ColorColumn ctermbg=magenta ctermfg=black
	autocmd Syntax * call SetColorColumn()
endif
" }}}
" {{{ Other
" Call par if availible
if executable("par") && system( "par help | wc -l" ) == 22
	" Width of 78, justified lines
	" set formatprg=PARPROTECT\=_x09\ par\ -w80qrg
	set formatprg=par\ -w80qrg
	autocmd FileType mail set formatprg=par\ -w72qrg
	" PARPROTECT prevents tabs from being converted!
	command! -nargs=0 -complete=command Parwide setlocal formatprg=par\ -w100
	autocmd FileType markdown  setlocal formatprg=PARQUOTE\=_x09\ par\ -w80T4
endif

" Setup ag to be ack
if executable('ag')
	let g:ackprg = 'ag --nogroup --nocolor --column'
endif

" Taken from tpope sensible
" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
	runtime! macros/matchit.vim
endif
" }}}
" {{{ Statusline
" Powerline
" disable on all machines unless specifically enabled
let s:powerline_hosts=["nurikum", "juno", "iminspace.zqnr.de", "phaelon", "ice"]
set laststatus=2
set noshowmode
if index(s:powerline_hosts, hostname()) < 0
	let g:powerline_loaded=1
	set showmode

	" Git branch
	" set statusline=%{GitBranch()}
	" Custom status line
	set statusline=                              " clear the statusline for when vimrc is reloaded
	set statusline+=%f\                          " file name
	set statusline+=[%{strlen(&ft)?&ft:'none'},  " filetype
	set statusline+=%{strlen(&fenc)?&fenc:&enc}, " encoding
	set statusline+=%{&fileformat}]              " file format
	set statusline+=%{fugitive#statusline()}
	set statusline+=%h%m%r%w                     " flags
	set statusline+=%#warningmsg#
	set statusline+=%{SyntasticStatuslineFlag()}
	set statusline+=%*
	set statusline+=%=                           " left/right separator
						     " set statusline+=%{synIDattr(synID(line('.'),col('.'),1),'name')}\ " highlight
	set statusline+=%b,0x%-6B                    " current char
	set statusline+=%c,%l/                       " cursor column/total lines
	set statusline+=%L\ %P                       " total lines/percentage in file
else
	python from powerline.vim import setup as powerline_setup
	python powerline_setup()
	python del powerline_setup
endif
" }}}
" {{{ Plugins
" {{{ AlignMaps
" Disable AlignMaps since they are not being used currently
let g:loaded_AlignMapsPlugin=1
" }}}
" {{{ ATP
" " For tex we need to use atp mappings
" autocmd vimrc FileType tex autocmd vimrc BufEnter inoremap <C-X><C-O> <silent> <C-R>=atplib#complete#TabCompletion(1)<CR>
" autocmd vimrc FileType tex autocmd vimrc BufEnter inoremap <C-X>o <silent> <C-R>=atplib#complete#TabCompletion(0)<CR>
" let g:atp_imap_leader_1 = ";"
" let g:atp_imap_leader_2 = "/"
" " au FileType tex au BufEnter imap <c-l> <c-x><c-o>
" "}}}
" {{{ BufferExplorer
let g:bufExplorerFindActive=0        " Do not go to active window.
" }}}
" {{{ Bling
let g:bling_time = 75
let g:bling_count = 2
" }}}
" {{{ Clang Complete

let g:clang_complete_auto=0
" let g:clang_debug = 1
" let g:clang_user_options="-v &1>2"
let g:clang_use_library=1
if hostname() == "phaelon" || hostname() == "nurikum"
	let g:clang_library_path="/usr/lib"
	" let g:atp_Compiler="python2"
endif
let g:clang_complete_copen = 1
let g:clang_snippets = 1
" let g:clang_snippets_engine = "ultisnips"
" let g:clang_user_options='|| exit 0'

" for c/c++ use clang completer
autocmd vimrc FileType c,cpp inoremap <c-l> <c-x><c-u>

" }}}
" {{{ Clewn
command! SourceClewn source /usr/share/vim/vimfiles/macros/clewn_mappings.vim
command! ResetClewn normal <F7>:source ~/.vimrc<CR>
" }}}
" {{{ CtrlP
map <Leader>cm :CtrlPMRU<CR>
let g:ctrlp_switch_buffer = 'et'
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*.pyc        " Linux/MacOSX
" set wildignore+=*\\.git\\*,*\\.hg\\*,*\\.svn\\*  " Windows ('noshellslash')

 " Sane Ignore 
let g:ctrlp_custom_ignore = {
	\ 'dir': '\.git$\|\.hg$\|\.svn$\|\.yardoc\|public\/images\|public\/system\|data\|log\|tmp$',
	\ 'file': '\.exe$\|\.so$\|\.dat$'
	\ }

" Set the max files
let g:ctrlp_max_files = 10000
 
" Optimize file searching
if has("unix")
	let g:ctrlp_user_command = {
	\ 'types': {
	\ 1: ['.git/', 'cd %s && git ls-files']
	\ },
	\ 'fallback': 'find %s -type f | head -' . g:ctrlp_max_files
	\ }
endif
" }}}
" {{{ DelimitMate
autocmd vimrc FileType tex let b:delimitMate_quotes = "\" ' $"
autocmd vimrc FileType django let b:delimitMate_quotes = "\" ' %"
autocmd vimrc FileType markdown let b:delimitMate_quotes = "\" ' *"
let g:delimitMate_expand_cr = 1
inoremap <C-Tab> <C-R>=delimitMate#JumpAny("\<C-Tab>")<CR>
imap <C-G><C-G> <Plug>delimitMateS-Tab
" }}}
" {{{ Easymotion
hi link EasyMotionTarget ErrorMsg
hi link EasyMotionShade Comment
let g:EasyMotion_leader_key = 'L'
" }}}
" {{{ Enhanced Commentify

let g:EnhCommentifyPretty = 'Yes'
let g:EnhCommentifyTraditionalMode = 'No'
let g:EnhCommentifyFirstLineMode = 'Yes'
" let g:EnhCommentifyRespectIndent = 'Yes'
let g:EnhCommentifyRespectIndent = 'No'
let g:EnhCommentifyBindInInsert = 'No'
let g:EnhCommentifyUserBindings = 'yes'
vmap <Leader>x <Plug>VisualFirstLine
nmap <Leader>x <Plug>FirstLine

" }}}
" {{{ FSwitch
au! BufEnter *.cpp let b:fswitchdst = 'hpp,h' | let b:fswitchlocs = './'
au! BufEnter *.hpp let b:fswitchdst = 'cpp,cxx,cc' | let b:fswitchlocs = './'
" }}}
" {{{ Fugitive
" Clean git objects when buffer is left
autocmd vimrc BufReadPost fugitive://* set bufhidden=delete
nnoremap <leader>f :Gstatus<CR>:on<CR>
" }}}
" {{{ Fuzzyfinder
" let g:fuf_modesDisable = []
" let g:fuf_mrufile_maxItem = 400
" let g:fuf_mrucmd_maxItem = 400
" nnoremap <silent> sj     :FufBuffer<CR>
" nnoremap <silent> sk     :FufFileWithCurrentBufferDir<CR>
" nnoremap <silent> sK     :FufFileWithFullCwd<CR>
" nnoremap <silent> s<C-k> :FufFile<CR>
" nnoremap <silent> sl     :FufCoverageFileChange<CR>
" nnoremap <silent> sL     :FufCoverageFileChange<CR>
" nnoremap <silent> s<C-l> :FufCoverageFileRegister<CR>
" nnoremap <silent> sd     :FufDirWithCurrentBufferDir<CR>
" nnoremap <silent> sD     :FufDirWithFullCwd<CR>
" nnoremap <silent> s<C-d> :FufDir<CR>
" nnoremap <silent> sn     :FufMruFile<CR>
" nnoremap <silent> sN     :FufMruFileInCwd<CR>
" nnoremap <silent> sm     :FufMruCmd<CR>
" nnoremap <silent> su     :FufBookmarkFile<CR>
" nnoremap <silent> s<C-u> :FufBookmarkFileAdd<CR>
" vnoremap <silent> s<C-u> :FufBookmarkFileAddAsSelectedText<CR>
" nnoremap <silent> si     :FufBookmarkDir<CR>
" nnoremap <silent> s<C-i> :FufBookmarkDirAdd<CR>
" nnoremap <silent> st     :FufTag<CR>
" nnoremap <silent> sT     :FufTag!<CR>
" nnoremap <silent> s<C-]> :FufTagWithCursorWord!<CR>
" nnoremap <silent> s,     :FufBufferTag<CR>
" nnoremap <silent> s<     :FufBufferTag!<CR>
" vnoremap <silent> s,     :FufBufferTagWithSelectedText!<CR>
" vnoremap <silent> s<     :FufBufferTagWithSelectedText<CR>
" nnoremap <silent> s}     :FufBufferTagWithCursorWord!<CR>
" nnoremap <silent> s.     :FufBufferTagAll<CR>
" nnoremap <silent> s>     :FufBufferTagAll!<CR>
" vnoremap <silent> s.     :FufBufferTagAllWithSelectedText!<CR>
" vnoremap <silent> s>     :FufBufferTagAllWithSelectedText<CR>
" nnoremap <silent> s]     :FufBufferTagAllWithCursorWord!<CR>
" nnoremap <silent> sg     :FufTaggedFile<CR>
" nnoremap <silent> sG     :FufTaggedFile!<CR>
" nnoremap <silent> so     :FufJumpList<CR>
" nnoremap <silent> sp     :FufChangeList<CR>
" nnoremap <silent> sq     :FufQuickfix<CR>
" nnoremap <silent> sy     :FufLine<CR>
" nnoremap <silent> sh     :FufHelp<CR>
" nnoremap <silent> se     :FufEditDataFile<CR>
" nnoremap <silent> sr     :FufRenewCache<CR>
" }}}
" {{{ Gundo
map <Leader>u :GundoToggle<CR>
" }}}
" {{{ Histwin
" map <Leader>u :Histwin<CR>
" }}}
" {{{ iPython
vmap <silent> <leader>ss :python dedent_run_these_lines()<CR>
" }}}
" {{{ Jedi
let g:jedi#documentation_command="<leader>k"
let g:jedi#popup_on_dot=1
let g:jedi#use_tabs_not_buffers=0
" }}}
" {{{ Latex-Box
let g:LatexBox_latexmk_async=1
let g:LatexBox_output_type="pdf"
let g:LatexBox_quickfix=2
let g:LatexBox_show_warnings=0
let g:LatexBox_latexmk_options="-pdf -pdflatex='pdflatex -synctex=1 \%O \%S'"
let g:LatexBox_viewer="okular"
let g:tex_flavor='latex'
" }}}
" {{{ Large Files
let g:LargeFile=100
" }}}
" {{{ Latex Journal
" (my very first plugin, utterly useless, but I keep the " config for
" sentimental sake)
if g:opsystem == "CYGWIN_NT-6.1-WOW64"
	let g:LatexNotesBase = "/cygdrive/c/Users/Desoxy/latexNotes/"
elseif g:opsystem == "Linux"
	let g:LatexNotesBase = "/home/obreitwi/.notes/"
elseif g:opsystem == "windows"
	let g:LatexNotesBase = "C:/Users/Desoxy/latexNotes"
endif
" }}}
" {{{ Lusty
let g:LustyJugglerSuppressRubyWarning = 1
let g:LustyExplorerSuppressRubyWarning = 1
map <leader>bg :LustyBufferGrep<CR>
" }}}
" {{{ NERDCommenter
let g:NERDCustomDelimiters = {
\ 'gitolite': { 'left': '#' },
\ 'jinja' : { 'left': '{#', 'right': '#}'},
\ 'less' : { 'left': '//' },
\ }
" \ 'ruby': { 'left': '#', 'leftAlt': 'FOO', 'rightAlt': 'BAR' },
" }}}
" {{{ NERDTree
let g:NERDTreeWinPos='right'
let g:NERDTreeChDirMode='2'
let g:NERDTreeIgnore=[ '\~$', '\.pyo$', '\.pyc$', '\.svn[\//]$', '\.swp$', '\.aux$' ]
let g:NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
let g:NERDTreeHighlightCursorline=1
let g:NERDSpaceDelims=1
" Mappings and commands
command! -nargs=0 -complete=command Nt NERDTree
map <c-f> :NERDTreeToggle<CR>
" }}}
" {{{ Sneak

" yankstack conflicts with its mappings and has to option to turn them off
" therefor we have to call setup and then overwrite the keys we need for the
" time being
call yankstack#setup()
nmap s <Plug>SneakForward
nmap S <Plug>SneakBackward
nmap , <Plug>SneakPrevious
nmap \ <Plug>SneakPrevious
xmap s <Plug>VSneakForward
xmap Z <Plug>VSneakBackward
xmap ; <Plug>VSneakNext
xmap , <Plug>VSneakPrevious
xmap \ <Plug>VSneakPrevious

" }}}
" {{{ Syntastic

let g:syntastic_error_symbol='✗'
" let g:syntastic_warning_symbol='⚠'
let g:syntastic_warning_symbol='⚐'
" let g:syntastic_warning_symbol='☇'
let g:syntastic_enable_signs=1
if hostname() == "phaelon"
	let g:syntastic_python_checkers = ['pylint2']
	let g:syntastic_python_pylint_args = '-d C0103,C0111,W0603'
endif

" }}}
" {{{ Tabularize 
map <Leader>tb :Tabularize/
map <Leader>tt :Tabularize<CR>
map <Leader>t<Leader> :Tabularize 
" map <Leader>t :Tabularize
" }}}
" {{{ Tagbar
nnoremap <c-y> :TagbarToggle<CR>
let g:tagbar_autofocus = 1
" }}}
" {{{ Taglist
map <Leader>tl <Plug>TaskList
nnoremap <c-s> :TlistToggle<CR>
command! -nargs=0 -complete=command TU :TlistUpdate

" }}}
" {{{ Tasklist
let g:tlRememberPosition = 1
" command! -nargs=0 -complete=command TL TaskList
" }}}
" {{{ Ultisnips
let g:UltiSnipsSnippetsDir="~/.vim/bundle-own/my-snippets/UltiSnips"
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-l>"
let g:UltiSnipsJumpBackwardTrigger="<c-h>"

map <leader>ls :call UltiSnips_ListSnippets()<CR>
" }}}
" {{{ Unite
let g:unite_enable_start_insert = 1
let g:unite_split_rule = "botright"

let g:unite_source_file_mru_long_limit = 3000
let g:unite_source_directory_mru_long_limit = 3000

nnoremap [unite] <Nop>
nmap <Leader>u [unite]

nmap <silent> [unite]b :Unite -start-insert buffer<CR>
nmap <silent> [unite]m :Unite -no-start-insert file_mru<CR>
nmap <silent> [unite]f :Unite -start-insert file<CR>

" {{{ Unite-Outline
nmap <Leader>uo :Unite outline<CR>
" }}}
" {{{ Vertigo
nnoremap <silent> <Space>j :<C-U>VertigoDown n<CR>
vnoremap <silent> <Space>j :<C-U>VertigoDown v<CR>
onoremap <silent> <Space>j :<C-U>VertigoDown o<CR>
nnoremap <silent> <Space>k :<C-U>VertigoUp n<CR>
vnoremap <silent> <Space>k :<C-U>VertigoUp v<CR>
onoremap <silent> <Space>k :<C-U>VertigoUp o<CR>
" }}}
" {{{ Vimpad
" if hostname() == "phaelon" || hostname() == "nurikum"
	" let g:pad_use_default_mappings = 0
	" " exec "au BufReadPre ".g:pad_dir."* setlocal directory = /tmp/"
	" let g:pad_dir = "~/.notes/"
	" autocmd vimrc BufReadPre,FileReadPre ~/.notes/* setlocal noswapfile | setlocal directory=~/tmp | setlocal swapfile | setlocal bufhidden=delete
	" nmap <Leader><esc> :ListPads<CR>
	" nmap <Leader>s :call pad#SearchPads()<CR>
	" nmap <Leader>n :OpenPad<CR>
	" autocmd vimrc BufReadPost __pad__ setlocal bufhidden=delete
" else
	" let g:loaded_pad = 1
" endif
" }}}
" {{{ Vimux
" Run the current file with rspec
map <Leader>rb :call VimuxRunCommand("clear; rspec " . bufname("%"))<CR>
" Prompt for a command to run
map <Leader>rp :VimuxPromptCommand<CR>
" Run last command executed by VimuxRunCommand
map <Leader>rl :VimuxRunLastCommand<CR>
" Inspect runner pane
map <Leader>ri :VimuxInspectRunner<CR>
" Close all other tmux panes in current window
map <Leader>rx :VimuxClosePanes<CR>
" Close vim tmux runner opened by VimuxRunCommand
map <Leader>rq :VimuxCloseRunner<CR>
" Interrupt any command running in the runner pane
map <Leader>rs :VimuxInterruptRunner<CR>
command! -nargs=+ -complete=file RR call VimuxRunCommand("clear; " . expand(<q-args>))
" }}}
" {{{ Vimwiki
let g:vimwiki_table_mappings = 0

let wiki_sync = {}
let wiki_sync.path = '~/.vimwiki/'
let wiki_sync.path_html = '~/doc/wiki_html/'
" let wiki_sync.html_template = '~/public_html/template.tpl'
let wiki_sync.nested_syntaxes = {'python': 'python', 'c++': 'cpp'}

let g:vimwiki_list = [wiki_sync]

" Folding
let g:vimwiki_folding=0
" }}}
" {{{ XPTemplate
" let g:xptemplate_key='<c-m>'
let g:xptemplate_brace_complete=1
let g:xptemplate_vars="$author=Oliver Breitwieser&$email=oliver.breitwieser@gmail.com"
let g:snips_author = 'Oliver Breitwieser'
autocmd vimrc FileType tex let g:xptemplate_brace_completes=0
autocmd vimrc FileType vim let g:xptemplate_brace_completes=0
" }}}
" {{{ Yank Stack
let g:yankstack_map_keys = 0
" call yankstack#setup() " currently called in sneak configuration
" Mappings
nmap <leader>y :Yanks<CR>
nmap <leader>p <Plug>yankstack_substitute_older_paste
nmap <leader>P <Plug>yankstack_substitute_newer_paste
" }}}
" }}}
" }}}
" {{{ Postscript
augroup end
" vim: fdm=marker ts=4 sw=4 sts=4
" }}}
