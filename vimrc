" {{{ Prelude
augroup vimrc
autocmd! vimrc *

set nocompatible
filetype off

if !exists("g:nix_enabled")
    let g:nix_enabled = 0
endif

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
    source $HOME/.vim/plugs.vim
endif

call dirsettings#Install("init.vim")

" Have pathogen load the other local/non-git plugins
call pathogen#infect("bundle/{}")

filetype on

" }}}
" {{{ Helper variables
let s:ac_file="/sys/class/power_supply/AC/online"
if filereadable(s:ac_file)
    let s:power_online = readfile(s:ac_file)[0]
else
    " if there is no battery we are on AC power
    let s:power_online = '1'
endif
" }}}
" {{{ Fixes
" {{{ Workaround for neovim not reszing itself, see https://github.com/neovim/neovim/issues/11330
if has("nvim-0.7.2")
lua <<EOF
vim.api.nvim_create_autocmd({"VimEnter"}, {
  callback = function()
    local pid, WINCH = vim.fn.getpid(), vim.loop.constants.SIGWINCH
    vim.defer_fn(function() vim.loop.kill(pid, WINCH) end, 20)
  end
})
EOF
endif
" }}}
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

function! OpenCustomFT(folder)
    if g:opsystem != "windows"
        let basefolder = "~/.vim/bundle-own/various-ft-scripts"
    else
        let basefolder = "$VIM/vimfiles/bundle-own/various-ft-scripts/"
    endif
    execute "tabe ".basefolder."/".a:folder."/".&ft.".vim"
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

" Copy the name of a task in personal time tracking
function! CopyTaskName()
    let l:save_cursor = getcurpos()
    normal! 0Ely$
    call setpos('.', l:save_cursor)
endfunction

" Paste the name of a task in personal time tracking
function! PasteTaskName()
    let l:save_cursor = getcurpos()
    normal! 0$p
    call setpos('.', l:save_cursor)
endfunction

" Replace the name of a task in personal time tracking
function! ReplaceTaskName()
    let l:save_cursor = getcurpos()
    normal! 0El"_D$p
    call setpos('.', l:save_cursor)
    normal! zO
endfunction

function InsertTaskName(name)
    call append(line('.'), a:name)
    normal! J
endfunction

function InsertTaskDetails(title_details)
    let l:split=split(a:title_details, '	')
    let l:title=l:split[0]
    let l:details=l:split[1]
    call append(line('.'), l:title . ' #STORY ' . l:details)
    normal! J
    normal! zO
endfunction

function InsertGitIDs(link)
    let l:lines_id=systemlist(["rev-git-ids", split(a:link, "	")[1]])
    for line in l:lines_id
        call append(line('.'), line)
    endfor
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
function! SetCustomColorColumn()
    if get(w:, "currentcolorcolumn") > 0
        call matchdelete(w:currentcolorcolumn)
        let w:currentcolorcolumn = 0
    endif
    if exists("g:colorcolumn_custom") && has_key(g:colorcolumn_custom, &ft)
        let l:linewidth = g:colorcolumn_custom[&ft]
    elseif &textwidth > 0
        let l:linewidth = &textwidth
    else
        let l:linewidth = 80
    endif
    let w:currentcolorcolumn=matchadd("CustomColorColumn", "\%" . l:linewidth+1 . "v")
endfunction

" Dynamically adjust guifontsize
function! GuifontsizeModify(adjustment)
    let l:split = split(&guifont, "h")
    let l:fontsize = l:split[-1]
    let l:fontname = join(l:split[:-2], "h")
    let l:new_font = join([l:fontname, (l:fontsize + a:adjustment)], "h")
    let &guifont=l:new_font
endfunction

" Search for the ... arguments separated with whitespace (if no '!'),
" or with non-word characters (if '!' added to command).
function! SearchMultiLine(bang, ...)
  if a:0 > 0
    let sep = (a:bang) ? '\_W\+' : '\_s\+'
    let @/ = join(a:000, sep)
  endif
endfunction

if !exists(":RgFromSearch")
" TODO: Push upstream
function! RgFromSearch() "{{{
  let search = getreg('/')
  " translate vim word boundaries
  let search = substitute(search, '\(\\<\|\\>\)', '\\b', 'g')
  call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case -- ".shellescape(search), 1, fzf#vim#with_preview(), 0)
endfunction "}}}
endif
" }}}
" {{{ Commands
command! -bang -nargs=* -complete=tag S call SearchMultiLine(<bang>0, <f-args>)|normal! /<C-R>/<CR

command! RgFromSearch call RgFromSearch()

" Enable folding
command! Folds set fdm=syntax

" Shell with output captured
command! -complete=shellcmd -nargs=+ Shell call s:RunShellCommand(<q-args>)

" Command with output captured
command! -nargs=+ -complete=command Command call Command(<q-args>)

command! SOvnorm let g:neosolarized_visibility="normal" | colorscheme NeoSolarized
command! SOvlow let g:neosolarized_visibility="low" | colorscheme NeoSolarized

command! Plugs tabe $HOME/.vim/plugs.vim

command! -nargs=0 MakeTags !ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .

" Open vimrc/tex in new tab
if g:opsystem != "windows"
    if has('nvim')
        command! -nargs=0 Vimrc tabe $HOME/.vimrc
    else
        command! -nargs=0 Vimrc tabe $MYVIMRC
    endif
else
    command! -nargs=0 Vimrc tabe $VIM/vimfiles/vimrc
endif

" command! -nargs=0 ReadOldTimeTable read ~/wiki/template_timelog.md
command! -nargs=0 ReadTimeTable         read ~/wiki/neorg/template_timelog.norg
command! -nargs=0 ReadJournalTemplate   read ~/wiki/neorg/template_journal.norg

command! -nargs=0 FT  call OpenCustomFT("ftplugin")
command! -nargs=0 FTA call OpenCustomFT("after")

" Spelling
command! -nargs=0 Spde setlocal spelllang=de
command! -nargs=0 Thde setlocal thesaurus=
\   /usr/share/mythes/th_de_DE.v2.dat
command! -nargs=0 Spen setlocal spelllang=en
command! -nargs=0 Then setlocal thesaurus=
\   /usr/share/mythes/th_en_US.v2.dat

" Compute how often each item appears in time log
command! TimeStats exec '0/^\(\*\|#\) Time log$/+2,$w !grep "^[0-9]\{2\}:[0-9]\{2\}" | sed -e "s/[0-9][0-9]:[0-9][0-9] \?//g" -e "/^$/d" -e "/^\s*\*/d" -e "s:\s*\#STORY.*$::g" | sort | uniq -c | gawk -f ~/.vim/utils/transform_time.awk'
command! TS TimeStats

" Lazy bunch
command! -nargs=0 SA setf apache

" :Man command
if g:opsystem == "Linux"
    source $VIMRUNTIME/ftplugin/man.vim
end

command! -nargs=0 GoLines % !golines %

" }}}
" {{{ General Mappings
" Plugin specific mappings are found in Plugins-section

" {{{ prefixes
nmap <leader>d [dbg]
nmap [dbg] <nop>
" }}}

" let mapleader=";"
let mapleader=" "
let maplocalleader=";"

" noremap <Esc><Esc> <Esc>

map <f8> :setlocal spell!<CR>

" have Q reformat the current paragraph (or selected text if there is any):
nnoremap Q gqap
vnoremap Q gq

" Use <c-s> as prefix for <S>et-font related commands
" TODO: Use hydra for this
nnoremap <silent> <c-s><c-=> :call GuifontsizeModify(1)<cr>
nnoremap <silent> <c-s><c--> :call GuifontsizeModify(-1)<cr>

" reset windows (Great Reset)
nnoremap <silent> gr :resize 200<CR><c-w>=

" Make bulletin
nnoremap <silent> <leader>bt :keeppattern s:^\s*\zs:* :<CR>
" Make todo
nnoremap <silent> <leader>td :keeppattern s:^\s*\zs:* [ ] :<CR>

" Make Y work like C and D..
" changed for yankring
map Y y$ 

imap <silent> <C-D><C-E> <C-R>=strftime("%d.%m.%Y %H:%M:%S")<CR>
imap <silent> <C-D><C-D> <C-R> --obreitwi, <C-R>=strftime("%d-%m-%y %H:%M:%S")<CR>
imap <silent> <C-D><C-F> <C-R>=strftime("%Y-%m-%d %H:%M:%S")<CR>
imap <silent> <C-D><C-R> <C-R>=strftime("%Y/%m/%d")<CR>
imap <silent> <C-D><C-W> <C-R>=strftime("%Y-%m-%d")<CR>

nnoremap <silent> <c-u> :nohl<CR>
inoremap <silent> <c-u> <c-o>:nohl<CR>

" center after these jumps
" <c-q> is more comfortable to reach on regular keyboards
nnoremap <c-q> <c-u>zz
inoremap <c-q> <c-u>zz
xnoremap <c-q> <c-u>zz
" <c-f> is easier to reach on model 100
nnoremap <c-f> <c-u>zz
inoremap <c-f> <c-u>zz
xnoremap <c-f> <c-u>zz
nnoremap <c-d> <c-d>zz
xnoremap <c-d> <c-d>zz
inoremap <c-d> <c-d>zz
nnoremap n nzz
nnoremap N Nzz

noremap M J
noremap J M
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

if v:version >= 703
    " Toggle relative numbers
    nnoremap <leader>ss :set rnu!<CR>
endif

" copy current filename to clipboard
nnoremap <leader>cp :let @" = expand("%")<CR>

" copy full current filename to clipboard
nnoremap <leader>cP :let @" = expand("%:p")<CR>

" Toggle character listing (col in unimpaired)w
" nmap <Leader>ll :set list!<CR>

" Lazy movement, for the few times it actually is faster than easymotion
nmap J 8j
vmap J 8j
nmap K 8k
vmap K 8k

" Disable annoying insert-mode bindings
imap <c-w> <nop>
imap <c-h> <nop>
map L <nop>

" Jump to next closed fold
nnoremap <silent> <leader>zj :call NextClosedFold('j')<cr>
nnoremap <silent> <leader>zk :call NextClosedFold('k')<cr>

" Use <leader>y/<leader>p to yank/paste to/from system clipboard
vnoremap <silent> <leader>y "+y
vnoremap <silent> <leader>p "+p
nnoremap <silent> <leader>y "+y
nnoremap <silent> <leader>p "+p

" Use <leader>Y to copy with surrounding backticks for quick markdown pasting
vnoremap <silent> <leader>Y "+y<CR>:let @+ = "```\n" . @+ . "```"<CR>

" select put text, via http://stackoverflow.com/a/4775281/955926
nnoremap <expr> gV "`[".getregtype(v:register)[0]."`]"

nnoremap <c-e><c-h> :tabp<CR>
nnoremap <c-e><c-l> :tabn<CR>


" decode quoted printable
nnoremap <Leader>Q :%s/=\(\x\x\<BAR>\n\)/\=submatch(1)=='\n'?'':nr2char('0x'.submatch(1))/ge<CR>
vnoremap <Leader>Q :s/=\(\x\x\<BAR>\n\)/\=submatch(1)=='\n'?'':nr2char('0x'.submatch(1))/ge<CR>

" TODO: The following mapping deletes the whole buffer
" -> figure out which text-object is called here, for now: disable
nmap cie <NOp>

" }}}
" {{{ Filetype Mappings
autocmd vimrc FileType markdown,norg    nmap <silent> <localleader>y        :call CopyTaskName()<CR>
autocmd vimrc FileType markdown,norg    nmap <silent> <localleader>p        :call PasteTaskName()<CR>
autocmd vimrc FileType markdown,norg    nmap <silent> <localleader>r        :call ReplaceTaskName()<CR>0
autocmd vimrc FileType markdown,norg    nmap <silent> <localleader>s        :call fzf#run(fzf#wrap({'source': 'revcli stories --list --title', 'sink': function("InsertTaskName")}))<CR>
autocmd vimrc FileType markdown,norg    nmap <silent> <localleader>t        :call fzf#run(fzf#wrap({'source': 'revcli tasks --list --title --json', 'sink': function("InsertTaskDetails"), 'options': '-d "	" --with-nth 1'}))<CR>

autocmd vimrc FileType norg             nmap <silent> ]d             :e =system(["neorg-existing-day", expand("%:t:r"), "+1"])<CR><CR>
autocmd vimrc FileType norg             nmap <silent> [d             :e =system(["neorg-existing-day", expand("%:t:r"), "-1"])<CR><CR>

autocmd vimrc FileType dart             nmap <silent> <leader>gc     :call jobstart([expand("~/.vim/utils/flutter-pub-get-recursive"), expand("%")])<CR>
autocmd vimrc BufRead *.dart            call jobstart([expand("~/.vim/utils/flutter-pub-get-ensure-recursive"), expand("%")])

autocmd vimrc BufNewFile,BufRead *.yaml.tpl   set filetype=yaml

autocmd vimrc FileType gitcommit        nmap <silent> <localleader>c :call fzf#run(fzf#wrap({'source': 'revcli stories --list --title', 'sink': function("InsertGitIDs"), 'options': '-d "	" --with-nth 1'}))<CR>

if !g:lsp_enabled
    autocmd vimrc FileType terraform        nmap <silent> <leader>cf :!terraform fmt %<CR>
endif
" }}}
" {{{ Settings
set nocompatible
set encoding=utf-8

" Adjust number of recent files to 1000
set shada=!,'1000,<50,s10,h

set foldlevelstart=99

set splitright
"
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
set scrolloff=4

if v:version >= 703 && !has('nvim')
set cm=blowfish2
endif

" relative line numbers
set relativenumber

set number

" assume the /g flag on :s substitutions to replace all matches in a line:
set gdefault

set sessionoptions=blank,curdir,tabpages,folds,resize

"make backspace work
set backspace=indent,eol,start

set smarttab
set number
set noautoindent
set smartindent
set incsearch
set hlsearch
set ignorecase
" case only matters if search contains Upper case letters
set smartcase
set pastetoggle=<leader>tp " read as: toggle paste

set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround

set completeopt=menu,menuone,preview,noinsert,noselect

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
set diffopt=filler,vertical,context:10,internal,indent-heuristic

" disable diff mode on close 
set diffopt+=closeoff

" improve linematching
set diffopt+=linematch:100

" No menu if we don't need it
if has("gui_running") || exists('g:neovide')
    " No Pop Ups but console
    set guioptions=ck
    set termguicolors
end

" Taken form: https://github.com/gregstallings/vimfiles/blob/master/vimrc
" Delete comment character when joining commented lines
set formatoptions+=c

" set current comment leader when using o/O
set formatoptions+=o

" format comments using gq
set formatoptions+=q

" Format 
set formatoptions+=n
set formatlistpat=^\\s*\\d\\+[\\]:.)}\\t\ ]\\s*\\\|^\\s*\\*\\s\\?

if v:version > 703 || v:version == 703 && has("patch541")
  " Remove comment leader when joining commented lines
  set formatoptions+=j
endif
" Use only 1 space after "." when joining lines instead of 2
set nojoinspaces

" {{{ Backup/undo settings
if g:opsystem != "windows"
    " keep .vim repository free from temporary files
    call EnsureDirExists( $HOME . '/.vimbackup' )
    call EnsureDirExists( $HOME . '/.vimbackup/writebackup' )
    set directory=~/.vimbackup//
    set backupdir=~/.vimbackup/writebackup//
endif
set backup
" persistent undo
if g:opsystem != "windows"
    " keep .vim repository free from temporary files
    if has("nvim-0.5.0")
        call EnsureDirExists( $HOME . '/.local/share/nvim/undo' )
        set undodir=~/.local/share/nvim/undo//
    else
        call EnsureDirExists( $HOME . '/.vimundo' )
        set undodir=~/.vimundo//
    endif
    set undofile
endif

" }}}
" {{{ List Chars (Make sure they work on all platforms)

set listchars=tab:>\ ,trail:\ ,extends:>,precedes:<,nbsp:+
if (g:opsystem != "windows") && (&termencoding ==# 'utf-8' || &encoding ==# 'utf-8')
    " NOTE: These two lines are NOT the same characgters!
    " let &listchars = "tab:\u21e5 ,trail:\u2423,extends:\u21c9,precedes:\u21c7,nbsp:\u00b7"
    set listchars=tab:▸·,extends:⇉,precedes:⇇,nbsp:·,eol:¬,trail:␣
endif

" }}}
" }}}
" {{{ Filetype Settings
" {{{ Common
filetype plugin on
filetype indent on
autocmd vimrc BufNewFile,BufRead wscript* set filetype=python
autocmd vimrc filetype tex hi MatchParen ctermbg=black guibg=black
" }}}

" Reload vimrc after writing (does not work as well as it used to)
" autocmd! vimrc BufWritePost .vimrc source $MYVIMRC
" autocmd! vimrc BufWritePost vundles.vim source $MYVIMRC

" autocmd vimrc FileType python setlocal omnifunc=pythoncomplete#Complete
" {{{ spell checking in comments only
if has('nvim-0.8')
    autocmd vimrc FileType go setlocal spelloptions+=noplainbuffer
endif
" }}}

" {{{ Tab-Settings
autocmd vimrc FileType arduino     setlocal tabstop=4    | setlocal shiftwidth=4  | setlocal softtabstop=4
autocmd vimrc FileType bash        setlocal tabstop=4    | setlocal shiftwidth=4  | setlocal softtabstop=4
autocmd vimrc FileType c           setlocal tabstop=4    | setlocal shiftwidth=4  | setlocal softtabstop=4
autocmd vimrc FileType cpp         setlocal tabstop=4    | setlocal shiftwidth=4  | setlocal softtabstop=4
autocmd vimrc FileType dart        setlocal tabstop=2    | setlocal shiftwidth=2  | setlocal softtabstop=2
autocmd vimrc FileType exim        setlocal tabstop=4    | setlocal shiftwidth=4  | setlocal softtabstop=4 | setlocal expandtab
autocmd vimrc FileType gitcommit   setlocal tabstop=2    | setlocal softtabstop=2 | setlocal shiftwidth=2  | setlocal expandtab
autocmd vimrc FileType go          setlocal tabstop=4    | setlocal softtabstop=4 | setlocal shiftwidth=4  | setlocal noexpandtab
autocmd vimrc FileType haskell     setlocal tabstop=2    | setlocal shiftwidth=2  | setlocal expandtab
autocmd vimrc FileType html        setlocal tabstop=4    | setlocal shiftwidth=4  | setlocal softtabstop=4
autocmd vimrc FileType java        setlocal tabstop=4    | setlocal shiftwidth=4  | setlocal softtabstop=4
autocmd vimrc FileType javascript  setlocal tabstop=4    | setlocal shiftwidth=4  | setlocal expandtab
autocmd vimrc FileType javascript  setlocal tabstop=4    | setlocal shiftwidth=4  | setlocal softtabstop=4
autocmd vimrc FileType jinja       setlocal tabstop=2    | setlocal shiftwidth=2  | setlocal softtabstop=2 | setlocal expandtab
autocmd vimrc FileType json        setlocal tabstop=4    | setlocal shiftwidth=4  | setlocal expandtab
autocmd vimrc FileType lua         setlocal tabstop=2    | setlocal shiftwidth=2  | setlocal expandtab
autocmd vimrc FileType mail        setlocal textwidth=72 | setlocal wrapmargin=8  | setlocal spell
autocmd vimrc FileType markdown    setlocal tabstop=2    | setlocal shiftwidth=2  | setlocal softtabstop=2 | setlocal expandtab
autocmd vimrc FileType matlab      setlocal tabstop=4    | setlocal shiftwidth=4  | setlocal expandtab
autocmd vimrc FileType norg        setlocal tabstop=2    | setlocal shiftwidth=2  | setlocal expandtab
autocmd vimrc FileType proto       setlocal tabstop=2    | setlocal shiftwidth=2  | setlocal softtabstop=2
autocmd vimrc FileType python      setlocal tabstop=4    | setlocal shiftwidth=4  | setlocal expandtab
autocmd vimrc FileType sh          setlocal tabstop=4    | setlocal softtabstop=4 | setlocal shiftwidth=4  | setlocal expandtab
autocmd vimrc FileType text        setlocal tabstop=2    | setlocal shiftwidth=2  | setlocal expandtab     | setlocal comments=fb:*,fb:#
autocmd vimrc FileType vim         setlocal tabstop=2    | setlocal shiftwidth=2  | setlocal expandtab
autocmd vimrc FileType vimwiki     setlocal tabstop=2    | setlocal shiftwidth=2  | setlocal expandtab     | setlocal foldlevel=0        | setlocal comments=fb:*,fb:# | setlocal foldminlines=0
autocmd vimrc FileType yaml        setlocal tabstop=2    | setlocal shiftwidth=2  | setlocal expandtab
autocmd vimrc FileType zsh         setlocal expandtab    | setlocal tabstop=4     | setlocal shiftwidth=4
" }}}

" {{{ cpp
autocmd vimrc FileType cpp         setlocal cinoptions=g0,hs,N-s,+0
" }}}
" {{{ Latex
" NOTE: If editing other tex-flavors, set locally..
let g:tex_flavor = "latex"
" "}}}
" {{{ Autohotkey
autocmd vimrc BufNewFile,BufRead *.ahk setf autohotkey
autocmd vimrc BufNewFile,BufRead *.txt setf text
" }}}
" {{{ Apache config files
autocmd vimrc BufNewFile,BufRead /etc/apache2/* setf apache
" }}}
" {{{ Jenkinfiles
autocmd vimrc BufNewFile,BufRead Jenkinsfile setf groovy
autocmd vimrc BufNewFile,BufRead *.Jenkinsfile setf groovy
autocmd vimrc BufNewFile,BufRead Jenkinsfile.* setf groovy
" }}}
" {{{ SLI
autocmd vimrc BufNewFile,BufRead *.sli setf sli
" }}}
" {{{ Haskell
" autocmd vimrc BufEnter *.hs compiler ghc
" }}}
" {{{ mutt
" au BufRead,BufNewFile /tmp/mutt-* set filetype=mail | nohl | set bg=dark | colo solarized | setlocal omnifunc=QueryCommandComplete
au vimrc BufRead,BufNewFile /tmp/*mutt-* set filetype=mail | nohl | setlocal omnifunc=QueryCommandComplete
let g:qcc_query_command="nottoomuch-addresses-reformatted"
" }}}
" {{{ rust
" Workaround for second line getting replaced by crate name on safe: Disable folding via expr
" NOTE: setlocal does _not_ work.
" au vimrc FileType rust             set foldmethod=manual | set foldexpr=0
" }}}
" }}}
" {{{ Font config
" Font settings
if g:opsystem == "windows"
    command! FIncon set guifont=Inconsolata\ Medium\ 8
    command! FInconP set guifont=Inconsolata\ for\ Powerline\ Medium\ 8
    command! FDejaP set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 6
    command! FInconL set guifont=Inconsolata\ Medium\ 10
    command! FInconPL set guifont=Inconsolata\ for\ Powerline\ Medium\ 10
    command! FDejaPL set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 10
    command! FEnvy set guifont=Envy\ Code\ R\ 8
else
    " These settings were found experimentally
    command! FIncon set guifont=Inconsolata\ Medium:h12
    command! FInconP set guifont=Inconsolata\ Nerd\ Font\ Mono\ Medium:h12
    command! FDejaP set guifont=DejaVuSansM\ Nerd\ Font:w57:h9
    command! FInconL set guifont=Inconsolata\ Medium:h16
    command! FDejaPS set guifont=DejaVuSansM\ Nerd\ Font:w57:h8
    command! FInconPL set guifont=Inconsolata\ Nerd\ Font\ M\ Medium:h14
    command! FDejaPL set guifont=DejaVuSansM\ Nerd\ Font:w57:h14
    command! FDejaPVL set guifont=DejaVuSansM\ Nerd\ Font:w57:h16
    command! FEnvy set guifont=Envy\ Code\ R:h11
endif

command! FMeslo set guifont=MesloLGS\ NF:h9
command! FMesloS set guifont=MesloLGS\ NF:h8
command! FMesloXS set guifont=MesloLGS\ NF:h6
command! FIosevka set guifont=IosevkaTerm\ NF:h10
command! FIosevkaS set guifont=IosevkaTerm\ NF:h9
command! FIosevkaXS set guifont=IosevkaTerm\ NF:h6

" Default font
if g:opsystem == "windows"
    set guifont=Consolas:h10:cANSI
elseif exists('g:started_by_firenvim')
    " FIosevkaS
    FMesloS
elseif exists("g:neovide")
    FMeslo
else
    FMeslo
    " FIosevka
end

if has('gui_running') && g:opsystem != "windows" && !exists("g:neovide")
    set clipboard=unnamedplus
endif
" }}}
" {{{ Clipboard settings
let s:hosts_clipboard_enabled = ["abed"]
if index(s:hosts_clipboard_enabled, hostname()) < 0 && !has('nvim')
    " disable clipboard if host not in list
    set clipboard=exclude:.*
end
" }}}
" {{{ Color management
let g:gitgutter_override_sign_column_highlight=1

" Put a linewidth indicator on a custom colum instead of the default 80
let g:colorcolumn_custom = {
\   'python': 88
\}

" {{{ gruvbox settings
" {{{ gruvbox.nvim
if has('nvim')
lua <<EOF
    -- Default options:
require("gruvbox").setup({
  terminal_colors = true, -- add neovim terminal colors
  undercurl = true,
  underline = true,
  bold = true,
  italic = {
    strings = true,
    emphasis = true,
    comments = true,
    -- operators = false,
    operators = true,
    folds = true,
  },
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "hard", -- can be "hard", "soft" or empty string
  palette_overrides = {},
  overrides = {},
  dim_inactive = false,
  transparent_mode = false,
})
vim.cmd("colorscheme gruvbox")
EOF
endif
" }}}
" These need to come prior to setting the colorscheme
if exists("g:neovide")
    let g:gruvbox_italic=1
    let g:gruvbox_undercurl=1
    let g:gruvbox_underline=1
    let g:gruvbox_inverse=1
endif
let g:gruvbox_contrast_dark='hard'
let g:gruvbox_guisp_fallback='bg'
" }}}

" {{{ Common / GUI-Term settings
" syntax enable " Disable to help with treesitter
if ($BG == "dark") || ($BG == "light")
    execute 'set background=' . $BG
else
    set background=dark
endif
if exists("g:neovide") || has("gui_running") || exists('g:started_by_firenvim')
    " colorscheme NeoSolarized
    " let g:airline_theme = 'solarized'
    " let g:neosolarized_contrast="normal"
    " let g:neosolarized_visibility="low"
    " let g:neosolarized_diffmode="high"
    " " let g:neosolarized_termtrans=0
    " " let g:neosolarized_bold=1
    " " let g:neosolarized_underline=1
    " " let g:neosolarized_italic=1
    " " let g:neosolarized_termcolors=16
    " " let g:neosolarized_hitrail=0
    " " let g:neosolarized_menu=1

    colorscheme gruvbox
    let g:airline_theme = 'gruvbox'
    " let g:airline_theme = 'base16_gruvbox_dark_hard'
elseif $TERM == "linux" && !exists('g:neovide')
    colorscheme default
    " set nolist
else
    " " let g:neosolarized_termcolors=256
    " " let g:neosolarized_contrast="normal"
    " " let g:neosolarized_visibility="low"
    " " let g:neosolarized_diffmode="high"
    " " let g:neosolarized_termtrans=1
    " let g:neosolarized_termcolors=256
    " " let g:neosolarized_degrade=1
    " " colorscheme NeoSolarized

    " colorscheme tigrana-256-dark

    " let g:airline_theme = 'powerlineish'
    " colorscheme xoria256

    colorscheme gruvbox
    let g:airline_theme = 'gruvbox'
    " let g:airline_theme = 'base16_gruvbox_dark_hard'
endif

if $COLORTERM == "truecolor" && has('nvim')
    " Set 24-bit colors if terminal supports it
    set termguicolors
endif
" }}}

" This is a test of a line that will exceed 81 characters per line and should trigger the new setting
" Highlight when a line exceeds 81 characters
" highlight CustomColorColumn ctermbg=magenta ctermfg=black
" autocmd Syntax * call SetCustomColorColumn()
" autocmd vimrc BufWinEnter * call SetCustomColorColumn()

" trailing whitespace (disable due to issues with completions)
" highlight default link ExtraWhitespace Error
" autocmd vimrc Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/
" }}}
" {{{ Digraphs
digraph el 8230   " …
digraph li 8212   " —
digraph al 8592   " ←
digraph au 8593   " ↑
digraph ar 8594   " →
digraph ad 8595   " ↓
digraph Al 8656   " ⇐
digraph Au 8657   " ⇑
digraph Ar 8658   " ⇒
digraph Ad 8659   " ⇓
digraph tm 8482   " ™
digraph pm 177    " ±
digraph cm 10003  " ✓
digraph tu 128077 " :thumbsup:
digraph td 128078 " :thumbdsdown:
" }}}
" {{{ neovide
if exists("g:neovide")
    " config options for neovide
    let g:neovide_cursor_vfx_mode = "railgun"
    " let g:neovide_cursor_animation_length=0.13
    let g:neovide_cursor_animation_length=0.08
    let g:neovide_cursor_trail_length=0.8
    let g:neovide_cursor_antialiasing=v:true
endif
" }}}
" {{{ Other
" Call par if availible
if executable("par") && system( "par help | wc -l" ) == 22
    " Width of 78, justified lines
    " set formatprg=PARPROTECT\=_x09\ par\ -w80qrg
    " set formatprg=par\ -w80qrg
    autocmd FileType mail set formatprg=par\ -w72qrg
    " PARPROTECT prevents tabs from being converted!
    command! -nargs=0 Parwide setlocal formatprg=par\ -w100
    " autocmd FileType markdown  setlocal formatprg=PARQUOTE\=_x09\ par\ -w80T4
endif

" Taken from tpope sensible
" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
    runtime! macros/matchit.vim
endif
" }}}
" {{{ Statusline
" {{{ lualine
if !g:airline_enabled
lua <<EOF
require('lualine').setup({
    options = { theme = 'gruvbox' },
    extensions = { "toggleterm" },
})
EOF
endif
" }}}
" Powerline
" disable on all machines unless specifically enabled
if has('nvim-0.7')
    set laststatus=3
else
    set laststatus=2
endif
set noshowmode

let g:powerline_available=1
if has('nvim') || (!has("python") && !has("python3"))
    let g:powerline_available=0
else
    if has("pythonx")
      source $HOME/.vim/compatibility/enable_powerline.pythonx.vim
    elseif has("python3")
      source $HOME/.vim/compatibility/enable_powerline.python3.vim
    elseif has("python")
      source $HOME/.vim/compatibility/enable_powerline.python.vim
    endif
endif

let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
      let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0

if 0 && !g:powerline_available
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
    if match(&runtimepath, 'syntastic') != -1
        set statusline+=%{SyntasticStatuslineFlag()}
    endif
    set statusline+=%*
    set statusline+=%=                           " left/right separator
                             " set statusline+=%{synIDattr(synID(line('.'),col('.'),1),'name')}\ " highlight
    set statusline+=%b,0x%-6B                    " current char
    set statusline+=%c,%l/                       " cursor column/total lines
    set statusline+=%L\ %P                       " total lines/percentage in file
endif
" }}}
" {{{ Plugins
" {{{ ALE
if s:power_online == '0'
    " disable power consuming features of ale when not running on AC power
    let g:ale_lint_on_text_changed = "never"
endif
let g:ale_echo_msg_format = '%linter%% (code)%: %s'

let g:ale_linters = {
\    "c": [],
\    "cpp": [],
\    "python" : ['black'],
\    "dart": [],
\    "go": []
\}

let g:ale_fixers = {
\   'python': ['black']
\}

" Note: Keep in sync with coc-settings.json
let g:ale_cpp_ccls_init_options = {
\   'cache': {
\       'directory': '/tmp/ccls'
\   }
\ }


nnoremap [ale] <Nop>
nmap <Leader>a [ale]

map <silent> [ale]d <Plug>(ale_detail)
map <silent> [ale]t <Plug>(ale_toggle)
map <silent> [ale]b <Plug>(ale_toggle_buffer)
nmap [ale]l :ALEPopulateQuickfix<CR>

" }}}
" {{{ ATP
" " For tex we need to use atp mappings
" autocmd vimrc FileType tex autocmd vimrc BufEnter inoremap <C-X><C-O> <silent> <C-R>=atplib#complete#TabCompletion(1)<CR>
" autocmd vimrc FileType tex autocmd vimrc BufEnter inoremap <C-X>o <silent> <C-R>=atplib#complete#TabCompletion(0)<CR>
" let g:atp_imap_leader_1 = ";"
" let g:atp_imap_leader_2 = "/"
" " au FileType tex au BufEnter imap <c-l> <c-x><c-o>
" "}}}
" {{{ Ack.vim
" Try to load alternatives in order of precedence
if executable('rg')
    let g:ackprg = 'rg --vimgrep'
elseif executable('ag')
    " Setup ag to be ack
    let g:ackprg = 'ag --nogroup --nocolor --column --follow --silent'
elseif executable('ack-grep')
    " ack is called differently on debian
    let g:ackprg="ack-grep -H --nocolor --nogroup --column"
else
    let g:ackprg="ack -H --nocolor --nogroup --column"
endif

" NOTE: <leader>a is also used for ale bindings
noremap <leader>af  :AckFromSearch!
noremap <leader>aff :AckFromSearch!
noremap <leader>ai  :Ack! --no-ignore
noremap <leader>afi :AckFromSearch! --no-ignore

" There is something iffy with the module environment
let s:no_dispatch_hosts = ["dopamine", "ice", "ignatz", "hel", "beli"]
if index(s:no_dispatch_hosts, hostname()) < 0
    let g:ack_use_dispatch=1
endif

" }}}
" {{{ AlignMaps
" Disable AlignMaps since they are not being used currently
let g:loaded_AlignMapsPlugin=1
" }}}
" {{{ Bling
let g:bling_time = 75
let g:bling_count = 2
" }}}
" {{{ BufferExplorer
let g:bufExplorerFindActive=0        " Do not go to active window.
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
" {{{ CtrlSF
vmap <Leader>csf <Plug>CtrlSFVwordPath
nmap <Leader>csf <Plug>CtrlSFPrompt
" }}}
" {{{ DelimitMate
" autocmd vimrc FileType tex let b:delimitMate_quotes = "\" ' $"
" autocmd vimrc FileType django let b:delimitMate_quotes = "\" ' %"
" autocmd vimrc FileType markdown let b:delimitMate_quotes = "\" ' * `"
" autocmd vimrc FileType vimwiki let b:delimitMate_quotes = "\" ' `"
" let g:delimitMate_expand_cr = 1
" inoremap <C-Tab> <C-R>=delimitMate#JumpAny("\<C-Tab>")<CR>
" imap <C-G><C-G> <Plug>delimitMateS-Tab
" }}}
" {{{ Dispatch
" Make on its own calls `cargo` -> typing 'build' is annoying
autocmd vimrc Filetype rust nnoremap <buffer><localleader>ll :Make build<CR>
" let g:dispatch_handlers = [
        " \ 'windows',
        " \ 'iterm',
        " \ 'x11',
        " \ 'headless',
        " \ 'tmux',
        " \ 'screen',
        " \ ]
" }}}
" {{{ Easymotion
if !has('nvim')
    hi link EasyMotionTarget ErrorMsg
    hi link EasyMotionShade Comment
endif
" TODO: Check for any errors when easymotion reverted to default setting
" let g:EasyMotion_leader_key = 'L'
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
nnoremap <leader>F :Git<CR>:on<CR>
nnoremap <leader>fa :Git add %<CR>
nnoremap <leader>fc q:iGit commit -m ""<Left>
nnoremap gb :G blame -CCCw<CR>
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
" if has('python3')
    " let g:gundo_prefer_python3=1
" endif
" map <Leader>gt :MundoToggle<CR>
" }}}
" {{{ Haskellmode
let g:haddock_browser="/usr/bin/firefox"
let g:haddock_docdir="/usr/share/doc/ghc/html/"
" }}}
" {{{ Histwin
" map <Leader>u :Histwin<CR>
" }}}
" {{{ Jedi
let g:jedi#documentation_command="<leader>k"
let g:jedi#popup_on_dot=1
let g:jedi#use_tabs_not_buffers=0
" }}}
" {{{ Languagetool
let g:languagetool_jar="/usr/share/java/languagetool/languagetool-commandline.jar"
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
" {{{ Latex-Box
let g:LatexBox_latexmk_async=1
let g:LatexBox_output_type="pdf"
let g:LatexBox_quickfix=2
let g:LatexBox_show_warnings=0
let g:LatexBox_latexmk_options="-pdf -pdflatex='pdflatex --shell-escape -synctex=1 \%O \%S'"
let g:LatexBox_viewer="zathura"
let g:LatexBox_fold_toc=0
let g:tex_flavor='latex'
" map <leader>ltt :LatexTOCToggle<CR>
let g:LatexBox_custom_inden=0
" }}}
" {{{ LineDiff
map <leader>dl :Linediff<CR>
map <leader>dr :LinediffReset<CR>
" }}}
" {{{ Lusty
let g:LustyJugglerSuppressRubyWarning = 1
let g:LustyExplorerSuppressRubyWarning = 1
map <leader>bg :LustyBufferGrep<CR>
" }}}
" {{{ Mundo
" decide which mapping to keep
" map gt :MundoToggle<CR>
map <leader>mt :MundoToggle<CR>
let g:mundo_inline_undo=1
" }}}
" {{{ NERDCommenter
let g:NERDCustomDelimiters = {
\ 'gitolite': { 'left': '#' },
\ 'jinja' : { 'left': '{#', 'right': '#}'},
\ 'less' : { 'left': '//' },
\ 'sli' : { 'left': '%' },
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
" Mappings and commands (not used anymore)
command! -nargs=0 Nt NERDTree
" map <c-f> :NERDTreeToggle<CR>
" }}}
" {{{ Octo (disabled since moving away from github)
" if has('nvim')
" lua <<EOF
" require"octo".setup({
    " default_remote = {"github", "upstream", "origin"},
" })
" EOF
" endif
" }}}
" {{{ ReplaceWithRegister
nmap <Leader>r  <Plug>ReplaceWithRegisterOperator
nmap <Leader>rl <Plug>ReplaceWithRegisterLine
xmap <Leader>r  <Plug>ReplaceWithRegisterVisual
xmap P          <Plug>ReplaceWithRegisterVisual
" }}}
" {{{ Signify
map <leader>st <Plug>(signify-toggle)
" }}}
" {{{ SimpylFold
" autocmd BufWinEnter *.py setlocal foldexpr=SimpylFold(v:lnum) foldmethod=expr
" autocmd BufWinLeave *.py setlocal foldexpr< foldmethod<
" }}}
" {{{ Sneak

" yankstack conflicts with its mappings and has to option to turn them off
" therefor we have to call setup and then overwrite the keys we need for the
" time being
" callc yankstack#setup()
" nmap s <Plug>SneakForward
" nmap S <Plug>SneakBackward
" nmap , <Plug>SneakPrevious
" nmap \ <Plug>SneakPrevious
" xmap s <Plug>VSneakForward
" xmap Z <Plug>VSneakBackward
" xmap ; <Plug>VSneakNext
" xmap , <Plug>VSneakPrevious
" xmap \ <Plug>VSneakPrevious

" }}}
" {{{ Syntastic

let g:syntastic_error_symbol='✗'
" let g:syntastic_warning_symbol='⚠'
let g:syntastic_warning_symbol='⚐'
" let g:syntastic_warning_symbol='☇'
let g:syntastic_enable_signs=1
if hostname() == "phaelon"
    let g:syntastic_python_checkers = ['pylint2']
endif
if hostname() == "dopamine"
    let g:syntastic_python_checkers = ['pyflakes']
endif
let g:syntastic_python_pylint_post_args = '-d C0103,C0111,W0603'

" }}}
" {{{ Tabularize 
map <Leader>tb :Tabularize/
map <Leader>tt :Tabularize<CR>
map <Leader>t<Leader> :Tabularize 
map <Leader>tm :tabe ~/.vim/bundle-own/tabular-maps/after/plugin/TabularMaps.vim<CR>
" map <Leader>t :Tabularize
" }}}
" {{{ Tagbar
nnoremap <c-y> :TagbarToggle<CR>
let g:tagbar_autofocus = 1
" }}}
" {{{ Taglist
" nnoremap <c-s> :TlistToggle<CR>
" command! -nargs=0 TU :TlistUpdate
" }}}
" {{{ TaskWarrior
let g:task_report_name="long"
" }}}
" {{{ Tasklist
map <Leader>tl <Plug>TaskList
let g:tlRememberPosition = 1
" command! -nargs=0 TL TaskList
" }}}
" {{{ Ultisnips
" ultisnips now finds snippets on its own
" let g:UltiSnipsSnippetDirectories=["~/.vim/bundle-own/my-snippets/UltiSnips"]
" let g:UltiSnipsListSnippets="<leader>ls"
" let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-l>"
let g:UltiSnipsJumpBackwardTrigger="<c-h>"
if !has('python3') && !has('pythonx')
    let g:UltiSnipsUsePythonVersion=2
endif

nnoremap [usnips] <Nop>
nmap <Leader>s [usnips]

map <silent> [usnips]l <Esc>:call UltiSnips#ListSnippets()<CR>
map <silent> [usnips]e :UltiSnipsEdit<CR>
let g:UltiSnipsSnippetStorageDirectoryForUltiSnipsEdit="~/.vim/bundle-own/my-snippets/UltiSnips"
" }}}
" {{{ Unite
let g:unite_enable_start_insert = 1

let g:unite_split_rule = "botright"

let g:neomru#file_mru_limit = 10000
let g:neomru#directory_mru_limit = 10000

" this causes a lot of stress for NFS systems
let g:neomru#do_validate = 0
" note: use :NeoMRUReload to update the mru files

let g:unite_source_rec_async_command = 'ag --nocolor --nogroup --hidden -f -g ""'

let g:unite_source_grep_max_candidates = 10000

" from unite doc :help unit-source-grep
if executable('ag')
  " Use ag (the silver searcher)
  " https://github.com/ggreer/the_silver_searcher
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts =
  \ '-f --vimgrep --smart-case --hidden --nocolor ' .
  \ '--ignore ''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
  let g:unite_source_grep_recursive_opt = ''
endif

nnoremap [unite] <Nop>
nmap <Leader>u [unite]

" nmap <silent> [unite]b :Unite -start-insert buffer<CR>
" backward compatible mapping to BufferExplorer
if g:unite_enabled
    nmap <silent> <leader>be :Unite -no-start-insert buffer<CR>
    nmap <silent> [unite]m :Unite -no-start-insert file_mru<CR>
    nmap <silent> [unite]f :Unite -start-insert file_rec/async<CR>
    nmap <silent> [unite]g :Unite -no-quit -no-start-insert grep:.<CR>
    nmap <silent> [unite]y :Unite -no-start-insert history/yank<CR>

    " Unite-Outline
    nmap <silent> [Unite]o :Unite outline<CR>
    " neoyank-specific
    let g:neoyank#save_registers = ['"', '1', '+']
    call neoyank#update()
endif
" }}}
" {{{ VimFiler
let g:vimfiler_as_default_explorer = 1
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
" " Run the current file with rspec
" map <Leader>rb :call VimuxRunCommand("clear; rspec " . bufname("%"))<CR>
" " Prompt for a command to run
" map <Leader>rp :VimuxPromptCommand<CR>
" " Run last command executed by VimuxRunCommand
" map <Leader>rl :VimuxRunLastCommand<CR>
" " Inspect runner pane
" map <Leader>ri :VimuxInspectRunner<CR>
" " Close all other tmux panes in current window
" map <Leader>rx :VimuxClosePanes<CR>
" " Close vim tmux runner opened by VimuxRunCommand
" map <Leader>rq :VimuxCloseRunner<CR>
" " Interrupt any command running in the runner pane
" map <Leader>rs :VimuxInterruptRunner<CR>
" command! -nargs=+ -complete=file RR call VimuxRunCommand("clear; " . expand(<q-args>))
" }}}
" {{{ Vimwiki
let g:vimwiki_table_mappings = 0
" No vimwiki syntax for markdown files outside of wiki path
let g:vimwiki_global_ext = 0

let wiki_sync = {}
let wiki_sync.path = '~/wiki/vimwiki'
let wiki_sync.path_html = '~/wiki/vimwiki/html/'
let wiki_sync.syntax = 'markdown'
let wiki_sync.ext = '.md'

" let wiki_sync.html_template = '~/public_html/template.tpl'
let wiki_sync.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'rust': 'rs', 'haskell': 'hs'}

let g:vimwiki_list = [wiki_sync]

map ]d <Plug>VimwikiDiaryNextDay
map [d <Plug>VimwikiDiaryPrevDay

" nmap <leader>ws :VimwikiSearch 

" Folding
let g:vimwiki_folding='expr'
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
" nmap <leader>y :Yanks<CR>
" nmap <leader>p <Plug>yankstack_substitute_older_paste
" nmap <leader>P <Plug>yankstack_substitute_newer_paste
" }}}
" {{{ YouCompleteMe (disabled)
if 0 && g:ycm_requirements_met && index(g:hosts_ycm, hostname()) >= 0
    let g:ycm_semantic_triggers = {'haskell' : ['.']}

    " mappings
    nnoremap [ycm] <Nop>
    nmap <Leader>y [ycm]
    nnoremap [ycm]y :YcmCompleter 
    nnoremap [ycm]g :YcmCompleter GoTo<CR>
    nnoremap [ycm]f :YcmCompleter GoToDefinition<CR>
    nnoremap [ycm]d :YcmCompleter GetDoc<CR>
    nnoremap [ycm]t :YcmCompleter GetType<CR>

    let g:ycm_confirm_extra_conf=0

    " Recommendations from https://clang.llvm.org/extra/clangd/Installation.html
    " Let clangd fully control code completion
    let g:ycm_clangd_uses_ycmd_caching = 0
    " Use installed clangd, not YCM-bundled clangd which doesn't get updates.
    let g:ycm_clangd_binary_path = exepath('clangd')
    " let g:ycm_clangd_binary_path = exepath('strace') . ' -o /tmp/clangd.log -e trace=%file ' . exepath('clangd')
    " let g:ycm_clangd_args=['-ferror-limit=0']
endif
" }}}
" {{{ barbecue
lua <<EOC
-- require("barbecue").setup({
--   -- attach_navic = false, -- prevent barbecue from automatically attaching nvim-navic
--   -- create_autocmd = false, -- prevent barbecue from updating itself automatically
-- })

-- Requires lspconfig, need a way to work with coc
-- require("lspconfig")[server].setup({
--   -- attach navic to each tab page
--   on_attach = function(client, bufnr)
--     if client.server_capabilities["documentSymbolProvider"] then
--       require("nvim-navic").attach(client, bufnr)
--     end
--   end,
-- })
--
-- vim.api.nvim_create_autocmd({
--   "WinResized",
--   "BufWinEnter",
--   "CursorHold",
--   "InsertLeave",
-- 
--   -- include these if you have set `show_modified` to `true`
--   "BufWritePost",
--   "TextChanged",
--   "TextChangedI",
-- }, {
--   group = vim.api.nvim_create_augroup("barbecue.updater", {}),
--   callback = function()
--     require("barbecue.ui").update()
--   end,
-- })
EOC
" }}}
" {{{ black
" Mnemonic is <c>ode-<f>ormat
autocmd vimrc Filetype python nnoremap <buffer><Leader>cf :Black<CR>
autocmd vimrc Filetype python vnoremap <buffer><Leader>cf :Black<CR>

" have one virtualenv setting for everything
let g:black_virtualenv="~/.vim/non-tracked/black"

let g:black_linelength = 79
" }}}
" {{{ clang-format
autocmd vimrc Filetype c,cpp nnoremap <buffer><Leader>cf :ClangFormat<CR>
autocmd vimrc Filetype c,cpp vnoremap <buffer><Leader>cf :ClangFormat<CR>
autocmd vimrc Filetype c,cpp map <buffer><Leader>x <Plug>(operator-clang-format)
" }}}
" {{{ cmp
if g:lsp_enabled
lua <<EOF
-- luasnip setup
-- local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
require("cmp_nvim_ultisnips").setup{}
local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")
cmp.setup {
  snippet = {
    expand = function(args)
        -- luasnip.lsp_expand(args.body)
        vim.fn["UltiSnips#Anon"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
    ['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
    -- C-b (back) C-f (forward) for snippet placeholder navigation.
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      -- elseif luasnip.expand_or_jumpable() then
      --   luasnip.expand_or_jump()
      else
        cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
        -- fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      -- elseif luasnip.jumpable(-1) then
      --   luasnip.jump(-1)
      else
        cmp_ultisnips_mappings.jump_backwards(fallback)
        -- fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    -- { name = 'luasnip' },
    { name = 'ultisnips' },
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
}
EOF
endif
" }}}
" {{{ coc
nnoremap [coc] <Nop>
nmap <Leader>g [coc]

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

if exists("g:using_coc") && g:using_coc == 1
    nnoremap [coc] <Nop>
    nmap <Leader>g [coc]
    " Better display for messages
    " set cmdheight=2

    " You will have bad experience for diagnostic messages when it's default 4000.
    set updatetime=300

    " don't give |ins-completion-menu| messages.
    set shortmess+=c

    " always show signcolumns
    set signcolumn=yes

    " disabled since context already gives the same info
    " set winbar=%{%get(b:,'coc_symbol_line','')%}

    " {{{ custom completion popup
    function! s:check_back_space() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~ '[\(\)\[\]\{\}\s]'
    endfunction

    " Insert <tab> when previous text is space, refresh completion if not.
    " inoremap <silent><expr> <TAB>
                " \ coc#pum#visible() ? coc#pum#next(1):
                " \ <SID>check_back_space() ? "\<Tab>" :
                " \ coc#refresh()
    " inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
    inoremap <silent><expr> <TAB>
                \ coc#pum#visible() ? coc#pum#next(1):
                \ <SID>check_back_space() ? "\<Plug>(Tabout)" :
                \ coc#refresh()
    inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<Plug>(TaboutBack)"

    " Use <c-space> to trigger completion:
    if has('nvim')
        inoremap <silent><expr> <c-space> coc#refresh()
    else
        inoremap <silent><expr> <c-@> coc#refresh()
    endif

    " Use <CR> to confirm completion, use (done in lua below)
    " inoremap <expr> <cr> coc#pum#visible() ? coc#_select_confirm() : "\<CR>"

    " To make <CR> to confirm selection of selected complete item or notify coc.nvim to format on enter, use:
    inoremap <silent><expr> <CR> coc#pum#visible() ? coc#_select_confirm()
	                \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

    " " Map <tab> for trigger completion, completion confirm, snippet expand and jump like VSCode:
    " inoremap <silent><expr> <TAB>
    "             \ coc#pum#visible() ? coc#_select_confirm() :
    "             \ coc#expandableOrJumpable() ?
    "             \ "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
    "             \ <SID>check_back_space() ? "\<TAB>" :
    "             \ coc#refresh()

    " function! s:check_back_space() abort
    "     let col = col('.') - 1
    "     return !col || getline('.')[col - 1]  =~# '\s'
    " endfunction

    " let g:coc_snippet_next = '<tab>'
    " Note: the `coc-snippets` extension is required for this to work.
    " }}}

    " Use `[g` and `]g` to navigate diagnostics
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)

    imap <silent> <c-w> <Plug>(coc-float-jump)
    nmap <silent> [coc]w <Plug>(coc-float-jump)
    " Remap keys for gotos
    nmap <silent> [coc]d <Plug>(coc-definition)
    nmap <silent> [coc]y <Plug>(coc-type-definition)
    nmap <silent> [coc]i <Plug>(coc-implementation)
    nmap <silent> [coc]r <Plug>(coc-references)

    nnoremap <silent> [coc]k :call <SID>show_documentation()<CR>

    function! s:show_documentation()
      if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
      else
        call CocAction('doHover')
      endif
    endfunction

    " Highlight symbol under cursor on CursorHold
    autocmd CursorHold * silent call CocActionAsync('highlight')

    " Remap for rename current word
    nmap [coc]rn <Plug>(coc-rename)

    " Remap for refactoring current word
    nmap [coc]rf <Plug>(coc-refactor)

    " Remap for format selected region
    xmap [coc]f  <Plug>(coc-format-selected)
    nmap [coc]f  <Plug>(coc-format-selected)
    nmap [coc]F  :<C-u>Format<CR>

    " augroup mygroup
      " autocmd!
      " " Setup formatexpr specified filetype(s).
      " autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
      " " Update signature help on jump placeholder
      " autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    " augroup end

    " Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
    xmap [coc]a  <Plug>(coc-codeaction-selected)
    " nmap [coc]a  <Plug>(coc-codeaction-cursor)

    " Remap for do codeAction of current line
    nmap [coc]a  <Plug>(coc-codeaction)
    " Fix autofix problem of current line
    nmap [coc]qf  <Plug>(coc-fix-current)

    " Create mappings for function text object, requires document symbols feature of languageserver.
    xmap if <Plug>(coc-funcobj-i)
    xmap af <Plug>(coc-funcobj-a)
    omap if <Plug>(coc-funcobj-i)
    omap af <Plug>(coc-funcobj-a)

    " Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
    nmap <silent> [coc]<C-d> <Plug>(coc-range-select)
    xmap <silent> [coc]<C-d> <Plug>(coc-range-select)

    " Use `:Format` to format current buffer
    command! -nargs=0 Format :call CocAction('format')

    " Use `:Fold` to fold current buffer
    command! -nargs=? Fold :call     CocAction('fold', <f-args>)

    " use `:OR` for organize import of current buffer
    command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

    command! -nargs=0 CocSettings tabe $HOME/.vim/coc-settings.json

    " Using CocList
    " Show all diagnostics
    nmap <silent> [coc]D  :<C-u>CocFzfList diagnostics<CR>
    nmap <silent> [coc]B  :<C-u>CocFzfList diagnostics --current-buf<CR>
    " Manage extensions
    nmap <silent> [coc]E  :<C-u>CocFzfList extensions<CR>
    " Show commands
    nmap <silent> [coc]C  :<C-u>CocFzfList commands<CR>
    " Find symbol of current document
    nmap <silent> [coc]O  :<C-u>CocFzfList outline<CR>
    " Search workspace symbols
    nmap <silent> [coc]s  :<C-u>CocFzfList symbols<CR>
    " Do default action for next item.
    nmap <silent> [coc]J  :<C-u>CocNext<CR>
    " Do default action for previous item.
    nmap <silent> [coc]K  :<C-u>CocPrev<CR>
    " Resume latest coc list
    nmap <silent> [coc]L  :<C-u>CocListResume<CR>
endif
" }}}
" {{{ dap
if has("nvim")

lua <<EOF
require("dapui").setup()

local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
vim.keymap.set('n', '<leader>db', function() dap.toggle_breakpoint() end)
vim.keymap.set('n', '<leader>dc', function() dap.continue() end)
vim.keymap.set('n', '<leader>dn', function() dap.step_over() end)
vim.keymap.set('n', '<leader>ds', function() dap.step_into() end)
vim.keymap.set('n', '<leader>do', function() dap.step_out() end)
vim.keymap.set('n', '<leader>dr', function() dap.repl_open() end)
vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
    require('dap.ui.widgets').hover()
end)
vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
    require('dap.ui.widgets').preview()
end)
vim.keymap.set('n', '<Leader>df', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.frames)
end)
vim.keymap.set('n', '<Leader>ds', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.scopes)
end)
EOF
if executable("go")
lua <<EOF
require('dap-go').setup({
  -- Additional dap configurations can be added.
  -- dap_configurations accepts a list of tables where each entry
  -- represents a dap configuration. For more details do:
  -- :help dap-configuration
  dap_configurations = {
    {
      -- Must be "go" or it will be ignored by the plugin
      type = "go",
      name = "Attach remote",
      mode = "remote",
      request = "attach",
    },
  },
  -- delve configurations
  delve = {
    -- the path to the executable dlv which will be used for debugging.
    -- by default, this is the "dlv" executable on your PATH.
    path = "dlv",
    -- time to wait for delve to initialize the debug session.
    -- default to 20 seconds
    initialize_timeout_sec = 20,
    -- a string that defines the port to start delve debugger.
    -- default to string "${port}" which instructs nvim-dap
    -- to start the process in a random available port
    port = "${port}",
    -- additional args to pass to dlv
    args = {},
    -- the build flags that are passed to delve.
    -- defaults to empty string, but can be used to provide flags
    -- such as "-tags=unit" to make sure the test suite is
    -- compiled during debugging, for example.
    -- passing build flags using args is ineffective, as those are
    -- ignored by delve in dap mode.
    build_flags = "",
  },
})
EOF
endif
if executable("flutter")
lua << EOF
local dap = require('dap')

-- dap.adapters.dart = {
--     type = "executable",
--     -- As of this writing, this functionality is open for review in https://github.com/flutter/flutter/pull/91802
--     command = "/home/obreitwi/fvm/default/bin/dart",
--     args = {"debug_adapter"}
-- }
dap.adapters.flutter = {
    type = "executable",
    -- As of this writing, this functionality is open for review in https://github.com/flutter/flutter/pull/91802
    command = "/home/obreitwi/fvm/default/bin/flutter",
    -- args = {"debug-adapter", "--dds-port", "${port}"}
    args = {"debug-adapter"}
}
dap.configurations.dart = {
    -- {
    --     type = "dart",
    --     request = "launch",
    --     name = "Launch dart",
    --     dartSdkPath = "/home/obreitwi/fvm/default/bin/cache/dart-sdk",
    --     flutterSdkPath = "/home/obreitwi/fvm/default",
    --     -- The nvim-dap plugin populates this variable with the filename of the current buffer
    --     -- program = "${file}",
    --     program = "${workspaceFolder}/lib/main.dart",
    --     -- The nvim-dap plugin populates this variable with the editor's current working directory
    --     cwd = "${workspaceFolder}",
    --     -- This gets forwarded to the Flutter CLI tool, substitute `linux` for whatever device you wish to launch
    --     toolArgs = {"-d", "chrome", "--profile", "--web-port", "8080"}
    -- },
    {
        type = "flutter",
        request = "launch",
        name = "Launch Flutter Program",
        dartSdkPath = "/home/obreitwi/fvm/default/bin/cache/dart-sdk",
        flutterSdkPath = "/home/obreitwi/fvm/default",
        -- The nvim-dap plugin populates this variable with the filename of the current buffer
        -- program = "${file}",
        program = "${workspaceFolder}/lib/main.dart",
        -- The nvim-dap plugin populates this variable with the editor's current working directory
        cwd = "${workspaceFolder}",
        -- This gets forwarded to the Flutter CLI tool, substitute `linux` for whatever device you wish to launch
        toolArgs = {"-d", "web-server", "--profile", "--web-port", "8080"}
    }
}
EOF
endif
endif
" }}}
" {{{ dart-vim-plugin
autocmd vimrc Filetype dart nnoremap <buffer><Leader>cf :DartFmt<CR>
" }}}
" {{{ delve
if executable('dlv') && 0
    " nnoremap <silent> [dbg]b :DlvAddBreakpoint<CR>
    " nnoremap <silent> [dbg]t :DlvAddTracepoint<CR>
    " :DlvAttach <PID> attach to process
    nnoremap <silent> [dbg]a :DlvAttach 
    nnoremap <silent> [dbg]ca :DlvClearAll<CR>
    " DlvCore <bin> <dump> [flags]	Debug core dumps using dlv core.
    " DlvConnect host:port [flags]	Connect to a remote Delve server on the given host:port.
    " DlvDebug [flags]	Run dlv debug for the current session. Use this to test main packages.
    nnoremap <silent> [dbg]d :DlvDebug<CR>
    " DlvExec <bin> [flags]	Start dlv on a pre-built executable.
    nnoremap <silent> [dbg]e :DlvExec 
    " nnoremap <silent> [dbg]rb DlvRemoveBreakpoint<CR>
    " nnoremap <silent> [dbg]rt DlvRemoveTracepoint<CR>
    nnoremap <silent> [dbg]t :DlvTest<CR>
    nnoremap <silent> [dbg]b :DlvToggleBreakpoint<CR>
    nnoremap <silent> [dbg]t :DlvToggleTracepoint<C>R
    " DlvVersion	Print the dlv version.
endif
" }}}
" {{{ diffchar
nmap [disableDiffchhar1] <Plug>GetDiffCharPair
nmap [disableDiffchhar2] <Plug>JumpDiffCharNextEnd
nmap [disableDiffchhar3] <Plug>JumpDiffCharNextStart
nmap [disableDiffchhar4] <Plug>JumpDiffCharPrevEnd
nmap [disableDiffchhar5] <Plug>JumpDiffCharPrevStart
nmap [disableDiffchhar6] <Plug>PutDiffCharPair
" }}}
" {{{ dirbuf
lua <<EOF
require('dirbuf').setup{}
EOF
if g:lusty_enabled == 0
    map <leader>lr :Dirbuf<CR>:BLines<CR>
endif
function! s:dirbuf_enter(line)
    let chunks = split(a:line, '\t', 1)
    let linenum = chunks[0]
    exec ':' . linenum
    lua require('dirbuf').enter('edit')
endfunction
function! s:fzf_dirbuf_enter()
    call fzf#vim#buffer_lines({
        \ 'sink': function('s:dirbuf_enter'),
        \ })
endfunction
function! s:fzf_dirbuf()
    Dirbuf
    call s:fzf_dirbuf_enter()
endfunction
command! DirbufFzf call s:fzf_dirbuf()
map <leader>lr :DirbufFzf<CR>
nmap <leader>lr :DirbufFzf<CR>
autocmd vimrc Filetype dirbuf command! DirbufFzfEnter call s:fzf_dirbuf_enter()
autocmd vimrc Filetype dirbuf nmap <buffer><Leader><Leader> :DirbufFzfEnter<CR>
" }}}
" {{{ eunuch
let g:eunuch_no_maps=1
" }}}
" {{{ fake
" let g:fake_bootstrap = 1
" " function! s:FakeInit()
" " Choose a random element from a list
" call fake#define('sex', 'fake#choice(["male", "female"])')
" 
" " Get a name of male or female
" call fake#define('name', 'fake#int(1) ? fake#gen("male_name")'
"             \ . ' : fake#gen("female_name")')
" 
" " Get a full name
" call fake#define('fullname', 'fake#gen("name") . " " . fake#gen("surname")')
" 
" " Get a nonsense text like Lorem ipsum
" call fake#define('sentense', 'fake#capitalize('
"             \ . 'join(map(range(fake#int(3,15)),"fake#gen(\"nonsense\")"))'
"             \ . ' . fake#chars(1,"..............!?"))')
" 
" " Generate a full paragraph
" call fake#define('paragraph', 'join(map(range(fake#int(3,10)),'
"             \ . '"fake#gen(\"sentense\")"))')
" 
" " Generate a uuid
" call fake#define('uuid', 'system("uuidgen")')
" 
" "" Alias
" call fake#define('lipsum', 'fake#gen("paragraph")')
" " endfunction
" " command! -nargs=0 FakeInit :call s:FakeInit()
" }}}
" {{{ firenvim
if exists('g:started_by_firenvim')
    let g:firenvim_config = {
        \ 'globalSettings': {
            \ 'alt': 'all',
        \  },
        \ 'localSettings': {
            \ '.*': {
                \ 'cmdline': 'neovim',
                \ 'content': 'text',
                \ 'priority': 0,
                \ 'selector': 'textarea',
                \ 'takeover': 'never',
            \ },
        \ }
    \ }
    if g:airline_enabled
        au! vimrc VimEnter * AirlineToggle
    endif
    set wrap
    set noshowmode
    set noruler
    set laststatus=0
    set noshowcmd
    set cmdheight=1
endif
" }}}
" {{{ flash
if has('nvim') && g:flash_enabled
lua <<EOF
    require('flash').setup()
EOF
endif
" }}}
" {{{ fzf
if g:fzf_found
    " nnoremap [fzf] <Nop>
    " nmap <leader>f [fzf]
    " Keep muscle memory from unite bindings
    nmap <silent> <c-p> :GFiles<CR>
    nmap <silent> <leader>be :Buffers<CR>
    nmap <silent> [unite]/ :History/<CR>
    nmap <silent> [unite]: :History:<CR>
    nmap <silent> [unite]f :Files<CR>
    nmap <silent> [unite]l :BLines<CR>
    nmap <silent> [unite]L :Lines<CR>
    nmap <silent> [unite]m :History<CR>
    nmap <silent> [unite]s :Snippets<CR>
    nmap <silent> [unite]r :RgFromSearch<CR>
    " Helptags shadowed by pathogen
    command! -bar -bang FzfHelptags call fzf#vim#helptags(<bang>0)
    nmap <silent> [unite]h :FzfHelptags<CR>

    function! s:copy_results(lines)
        let joined_lines = join(a:lines, "\n")
        if len(a:lines) > 1
            let joined_lines .= "\n"
        endif
        let @+ = joined_lines
    endfunction

    let g:fzf_action = {
                \ 'ctrl-t': 'tab split',
                \ 'ctrl-x': 'split',
                \ 'ctrl-v': 'vsplit',
                \ 'ctrl-y': function('s:copy_results')}

    let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all'
endif
" }}}
" {{{ fzf-yank-history
if g:fzf_found
    nmap <silent> [unite]y :YankHistoryRgYank<CR>
    let g:yank_history_dir = $HOME . '/.cache/vim/yank-history'
    let g:yank_history_max_size = 100
endif
" }}}
" {{{ lspconfig
if g:lsp_enabled
lua <<EOF
-- Setup language servers.
local lspconfig = require('lspconfig')

-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- copied from: https://neovim.discourse.group/t/using-eslint-language-server-as-a-formatter-fix-all-eslint-errors/1966/8
--- Neovim's LSP client does not currently support dynamic capabilities registration, so we need to set
--- the resolved capabilities of the eslint server ourselves!
---
---@param  allow_formatting boolean whether to enable formating
---
local function toggle_formatting(allow_formatting)
  return function(client)
    default_on_attach(client)
    client.resolved_capabilities.document_formatting = allow_formatting
    client.resolved_capabilities.document_range_formatting = allow_formatting
  end
end

-- Useful settings:
--   on_attach = function(client)
--     client.resolved_capabilties.rename = false -- no renaming
--   end,
local servers = {
    ['ast_grep'] = {},
    ['bashls'] = {},
    ['dartls'] = {},
    ['eslint'] = {
        -- on_attach = toggle_formatting(true),
        settings = {
            format = true,
        },
    },
    ['golangci_lint_ls'] = {},
    ['gopls'] = {},
    ['lua_ls'] = {},
    ['marksman'] = {},
    ['nixd'] = {},
    ['nushell'] = {},
    ['pyright'] = {},
    ['pylsp'] = {
        settings = {
            pylsp = {
                plugins = {
                    black = {
                        enabled = true,
                    },
                },
            },
        },
    },
    ['rust_analyzer'] = {},
    ['terraform_lsp'] = {},
    ['texlab'] = {},
    ['tsserver'] = {
        settings = {
            format = false,
        },
    },
}

for lsp, opts in pairs(servers) do
  lspconfig[lsp].setup {
    -- on_attach = my_custom_on_attach,
    capabilities = capabilities,
    opts or {}
  }
end

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
-- vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
-- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', '[coc]k', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '[coc]i', vim.lsp.buf.implementation, opts)
    vim.keymap.set({'n', 'i'}, '<C-k>', vim.lsp.buf.signature_help, opts)
    -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    -- vim.keymap.set('n', '<space>wl', function()
    --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, opts)
    -- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '[coc]n', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '[coc]a', vim.lsp.buf.code_action, opts)
    -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>cf', function()
      local find_lsp = function(name) 
           return table.getn(
               vim.lsp.get_active_clients({
                   bufnr = vim.fn.bufnr(),
                   name = name,
               })
           ) > 0
      end
      local found_eslint = find_lsp('eslint')
      local found_nixd = find_lsp('nixd')
      local found_alejandra = vim.fn.executable('alejandra') > 0

      if found_eslint then
        vim.cmd('EslintFixAll')
      elseif found_nixd and found_alejandra then
        vim.cmd "%!alejandra --quiet"
      else
        vim.lsp.buf.format { async = true }
      end
    end, opts)
  end,
})
EOF
endif
" }}}
" {{{ gh-line
let g:gh_open_command = 'fn() { echo -n "$@" | xclip -selection copy; }; fn '
" }}}
" {{{ gitgutter
nmap <leader>ggf :GitGutterFold<CR>
" }}}
" {{{ gofmt
if !g:lsp_enabled
    autocmd vimrc Filetype go nnoremap <buffer><Leader>cf :GoImports<CR>
endif
" }}}
" {{{ hop
if has('nvim') && g:hop_enabled
lua << EOF
require('hop').setup()
EOF

nnoremap [hop] <Nop>
nmap <leader><leader> [hop]
nmap [hop]w :HopWordAC<CR>
nmap [hop]b :HopWordBC<CR>
nmap [hop]/ :HopPatternAC<CR>
nmap [hop]? :HopPatternBC<CR>
nmap [hop]f :HopChar1AC<CR>
nmap [hop]F :HopChar1BC<CR>
nmap [hop]c :HopChar2AC<CR>
nmap [hop]C :HopChar2BC<CR>
endif
" }}}
" {{{ icon-picker
if has('nvim') && g:icon_picker_enabled
lua << EOF
-- disable input mapping because it does not work with 'cedit' as of right now
require("dressing").setup { input = { enabled = false } }
require("icon-picker").setup({ disable_legacy_commands = true })
EOF
nnoremap <silent> <leader>ip :IconPickerInsert emoji nerd_font_v3 symbols html_colors<CR>
endif
" }}}
" {{{ iPython
vmap <silent> <leader>ss :python dedent_run_these_lines()<CR>
" }}}
" {{{ indent-blankline
let g:indent_blankline_show_current_context = v:true
" Disable in some cases 
let g:indent_blankline_filetype_exclude = ['help', 'text']
nnoremap <leader>it :IndentBlanklineToggle<CR>
" }}}
" {{{ intero
" nnoremap [intero] <Nop>
" nmap <Leader>i [intero]
" " close is easier to remember than "hide"
" nnoremap <silent> [intero]c :InteroHide<CR>
" nnoremap <silent> [intero]g :InteroGoToDef<CR>
" nnoremap <silent> [intero]l :InteroLoadCurrentFile<CR>
" nnoremap <silent> [intero]o :InteroOpen<CR>
" nnoremap <silent> [intero]r :InteroReload<CR>
" nnoremap <silent> [intero]t :InteroGenericType<CR>
" nnoremap <silent> [intero]T :InteroType<CR>
" " nnoremap <silent> [intero]t <Plug>InteroGenericType
" }}}
" {{{ latex-unicoder
" let g:unicoder_cancel_normal = 1
" let g:unicoder_cancel_insert = 1
" let g:unicoder_cancel_visual = 1
" nnoremap <leader>li :call unicoder#start(0)<CR>
" " inoremap <C-l> <Esc>:call unicoder#start(1)<CR>
" " vnoremap <C-l> :<C-u>call unicoder#selection()<CR>
" }}}
" {{{ ledger
" let g:ledger_bin="hledger"
let g:ledger_maxwith = 80
let g:ledger_fillstring = "······"
let g:ledger_detailed_first = 1
" }}}
" {{{ messages
if has('nvim')
lua <<EOF
require"messages".setup {}
Msg = function(...)
    require('messages.api').capture_thing(...)
end
EOF
endif
" }}}
" {{{ neorg
if has('nvim-0.8') && g:treesitter_enabled
lua <<EOF
require'neorg'.setup {
    load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        ["core.dirman"] = {
            config = {
                default_workspace = "work",
                workspaces = {
                    work = "~/wiki/neorg",
                    home = "~/Nextcloud/wiki"
                    -- example_gtd = "~/sandboxes/2022-09-17_setup_neorg/example_workspaces/gtd",
                }
            }
        },
        ["core.export"] = {},
        ["core.journal"] = {
            config = {
                journal_folder = "journal",
                strategy = "flat",
                workspace = "work",
                template_name = "../template_journal.norg",
            },
        },
        ["core.integrations.telescope"] = {},
        -- ["core.gtd.base"] = {
        --     config = {
        --         workspace = "vimwiki",
        --         -- exclude = {
        --         --     "journal",
        --         -- },
        --         custom_tag_completion = true,
        --     },
        -- },
        -- ["external.context"] = {},
    }
}

local neorg_callbacks = require("neorg.core.callbacks")

neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)
    -- Map all the below keybinds only when the "norg" mode is active
    keybinds.map_event_to_mode("norg", {
        n = { -- Bind keys in normal mode
            { "<C-s>", "core.integrations.telescope.find_linkable" },
        },

        i = { -- Bind in insert mode
            { "<C-l>", "core.integrations.telescope.insert_link" },
        },
    }, {
        silent = true,
        noremap = true,
    })
end)
EOF
set conceallevel=2
autocmd vimrc Filetype norg setlocal nolist | setlocal foldminlines=0
endif
" }}}
" {{{ netrw
" Tweaks for browsing
" (taken from: https://github.com/mcantor/no_plugins/blob/master/no_plugins.vim)
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'
" }}}
" {{{ nvim-coverage
if has('nvim')
lua<<EOF
require("coverage").setup({
    auto_reload = true,
})
EOF
endif
" }}}
" {{{ rust
if !g:lsp_enabled
    autocmd vimrc Filetype rust nnoremap <buffer><Leader>cf :RustFmt<CR>
    autocmd vimrc Filetype rust vnoremap <buffer><Leader>cf :RustFmtRange<CR>
    let g:rustfmt_autosave = 1
endif
let g:rust_conceal = 1
" }}}
" {{{ silicon
if has('nvim') && executable('silicon')
lua <<EOF
require('silicon').setup {
    font = "IosevkaTerm NF=34;Noto Color Emoji=34",
    background = '#00000000',
    no_window_controls = true,
    to_clipboard = true,
}
EOF
endif
" }}}
" {{{ sort-folds
autocmd vimrc FileType bib let g:sort_folds_key_function="get_citekey"
" }}}
" {{{ splitjoin
nmap sj :SplitjoinSplit<cr>
nmap sk :SplitjoinJoin<cr>
" }}}
" {{{ tabout
if g:treesitter_enabled
lua <<EOF
require("tabout").setup({
  tabkey = "",
  backwards_tabkey = "",
})
EOF
inoremap <c-g><c-g> <Plug>(Tabout)
endif
" }}}
" {{{ telescope
if g:telescope_enabled
lua <<EOF
require('telescope').setup{
    extensions = {
        ast_grep = {
            command = {
                "sg",
                "--json=stream",
            }, -- must have --json=stream
            grep_open_files = false, -- search in opened files
            lang = nil, -- string value, specify language for ast-grep `nil` for default
        },
    },
}
require('telescope').load_extension('fzf')
if vim.fn.executable('sg') then
    require('telescope').load_extension('ast_grep')
end
EOF

nmap <silent> <c-p> :lua require'telescope.builtin'.git_files{}<CR>
nmap <silent> <leader>be :lua require'telescope.builtin'.buffers{}<CR>
nmap <silent> [unite]/ :lua require'telescope.builtin'.serach_history{}<CR>
nmap <silent> [unite]: :lua require'telescope.builtin'.command_history{}<CR>
nmap <silent> [unite]f :lua require'telescope.builtin'.find_files{}<CR>
nmap <silent> [unite]c :lua require'telescope.builtin'.commands{}<CR>
nmap <silent> [unite]u<leader> :lua require'telescope.builtin'.resume{}<CR>
nmap <silent> [unite]l :lua require'telescope.builtin'.current_buffer_fuzzy_find{}<CR>
" nmap <silent> [unite]L :Lines<CR>
nmap <silent> [unite]m :lua require'telescope.builtin'.oldfiles{}<CR>
" nmap <silent> [unite]s :Snippets<CR>
vmap <silent> [unite]r :lua require'telescope.builtin'.grep_string{initial_mode='select'}<CR>
nmap <silent> [unite]r :lua require'telescope.builtin'.grep_string{}<CR>
nmap <silent> [unite]g :lua require'telescope.builtin'.live_grep{}<CR>
nmap <silent> [unite]a :Telescope ast_grep<CR>

if 1 " bindings to enable once lsp has been configured
" coc bindings
nmap <silent> [coc]D   :lua require'telescope.builtin'.diagnostics{}<CR>
nmap <silent> [coc]d   :lua require'telescope.builtin'.lsp_definitions{}<CR>
nmap <silent> [coc]t   :lua require'telescope.builtin'.lsp_type_definitions{}<CR>
nmap <silent> [coc]r   :lua require'telescope.builtin'.lsp_references{}<CR>
nmap <silent> [coc]ci  :lua require'telescope.builtin'.lsp_incoming_calls{}<CR>
nmap <silent> [coc]co  :lua require'telescope.builtin'.lsp_outgoing_calls{}<CR>
nmap <silent> [coc]s   :lua require'telescope.builtin'.lsp_workspace_symbols{}<CR>
nmap <silent> [coc]I   :lua require'telescope.builtin'.lsp_document_symbols{}<CR>
" nmap <silent> [coc]B   :<C-u>CocFzfList diagnostics --current-buf<CR>
endif
endif
" }}}
" {{{ tidal
if has("nvim")
    let g:tidal_target = "terminal"
endif
" }}}
" {{{ titlecase
" Add support for repeat (does not work this easily unfortunately)
" silent! call repeat#set("\<Plug>Titlecase", v:count)
" silent! call repeat#set("\<Plug>TitlecaseLine", v:count)
" }}}
" {{{ toggleterm
if has('nvim')
lua <<EOF
require("toggleterm").setup()

function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
  -- vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  -- vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  -- vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  -- vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  -- vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
EOF

nnoremap <leader>T :ToggleTerm<CR>

endif
" }}}
" {{{ treesitter
if g:treesitter_enabled
lua << EOF
    local ensure_installed = nil;
    if vim.g.nix_enabled == 0 then 
        ensure_installed = "all"
    end
    require'nvim-treesitter.configs'.setup {
        -- A list of parser names, or "all"
        ensure_installed = ensure_installed,

        -- Automatically install missing parsers when entering buffer
        auto_install = vim.g.nix_enabled == 0,

        highlight = {
            enable = true,
        },

        indent = {
            enable = true,
            disable = {},
        },

        playground = {
            enable = true,
        },

        query_linter = {
            enable = true,
            use_virtual_text = true,
            lint_events = {"BufWrite", "CursorHold"},
        },

        -- rainbow = {
        --     enable = false, -- no longer maintained, causes issues in .tsx files
        --     extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        --     max_file_lines = nil, -- Do not enable for files with more than n lines, int
        -- },

        textobjects = {
            select = {
                enable = true,

                -- Automatically jump forward to textobj, similar to targets.vim
                lookahead = true,

                keymaps = {
                    -- You can use the capture groups defined in textobjects.scm
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    -- you can optionally set descriptions to the mappings (used in the desc parameter of nvim_buf_set_keymap
                    ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                },
                -- You can choose the select mode (default is charwise 'v')
                selection_modes = {
                    ['@parameter.outer'] = 'v', -- charwise
                    ['@function.outer'] = 'V', -- linewise
                    ['@class.outer'] = '<c-v>', -- blockwise
                },
                -- If you set this to `true` (default is `false`) then any textobject is
                -- extended to include preceding xor succeeding whitespace. Succeeding
                -- whitespace has priority in order to act similarly to eg the built-in
                -- `ap`.
                include_surrounding_whitespace = true,
            },
        },

        -- yati = {
        --     enable = false,
        -- },
    }

    require'pretty-fold'.setup {}

    local remap = vim.api.nvim_set_keymap
    local npairs = require'nvim-autopairs'

    if (vim.g.coc_enabled == nil) or (vim.g.coc_enabled == 0) then
        npairs.setup({ map_cr = true })
    else
        npairs.setup({ map_cr = false })

        _G.MUtils={}
        MUtils.completion_confirm=function()
            if vim.fn["coc#pum#visible"]() ~= 0 then
                return vim.fn["coc#pum#confirm"]()
            else
                return npairs.autopairs_cr()
            end
        end

        remap('i' , '<CR>','v:lua.MUtils.completion_confirm()', {expr = true , noremap = true})
    end

    local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
    parser_config.timesheet = {
        install_info = {
            url = "~/.vim/utils/treesitter-timesheet", -- local path or git repo
            files = {"src/parser.c"},
            -- optional entries:
            branch = "main", -- default branch in case of git repo if different from master
            generate_requires_npm = false, -- if stand-alone parser without npm dependencies
            requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
        },
        -- filetype = "zu", -- if filetype does not match the parser name
    }
EOF
set foldminlines=50
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
endif
" }}}
" {{{ treesj
if g:treesitter_enabled
lua <<EOF
require('treesj').setup({
    use_default_keymaps = false,
    max_join_length = 360,
})
EOF
nnoremap <leader>sj :TSJJoin<CR>
nnoremap <leader>ss :TSJSplit<CR>
nnoremap <leader>st :TSJToggle<CR>
endif
" }}}
" {{{ venn.nvim
if has('nvim') && g:venn_enabled > 0
lua <<EOF
-- venn.nvim: enable or disable keymappings
function _G.Toggle_venn()
    local venn_enabled = vim.inspect(vim.b.venn_enabled)
    if venn_enabled == "nil" then
        vim.b.venn_enabled = true
        vim.cmd[[setlocal ve=all]]
        -- draw a line on HJKL keystokes
        vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", {noremap = true})
        -- draw a box by pressing "f" with visual selection
        vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBoxO<CR>", {noremap = true})
    else
        -- vim.cmd[[setlocal ve=]]
        vim.cmd[[mapclear <buffer>]]
        vim.b.venn_enabled = nil
    end
end
-- toggle keymappings for venn using <leader>tv
vim.api.nvim_set_keymap('n', '<leader>tv', ":lua Toggle_venn()<CR>", { noremap = true})
-- vim.api.nvim_set_keymap('v', '<leader>v', ":VBox<CR>", { noremap = true})
EOF
endif
" }}}
" {{{ vim-flutter
" Enable Flutter menu (useless without gui)
" call FlutterMenu()

" Some of these key choices were arbitrary;
" it's just an example.
nnoremap <leader>fg :FlutterRun<cr>
nnoremap <leader>fq :FlutterQuit<cr>
nnoremap <leader>fr :FlutterHotReload<cr>
nnoremap <leader>fR :FlutterHotRestart<cr>
nnoremap <leader>fD :FlutterVisualDebug<cr>
" }}}
" {{{ vim-go
" Completion is handles by coc-go
let g:go_code_completion_enabled = 0

let g:go_metalinter_command = 'golangci-lint'

" not respected anyway?
" let g:go_mod_fmt_autosave = 0

" let g:go_fillstruct_mode = 'gopls'

" We want a custom mapping for GoDoc
let g:go_doc_keywordprg_enabled = 0
autocmd vimrc filetype go nmap <buffer> <silent> <leader>K <Plug>(go-doc)
autocmd vimrc filetype go nmap <buffer> <silent> [coc]e :GoIfErr<CR>
autocmd vimrc filetype go nmap <buffer> <silent> [coc]l :GoLines<CR>
autocmd vimrc filetype go nmap <buffer> <silent> [coc]m <Plug>(go-metalinter)
autocmd vimrc filetype go nmap <buffer> <silent> [coc]S :GoFillStruct<CR>
autocmd vimrc filetype go nmap <buffer> <silent> [coc]t <Plug>(go-test)
" }}}
" {{{ vimtex
if hostname() == "mimir" || hostname() == "mucku"
    let g:vimtex_view_general_viewer = 'zathura'
    let g:vimtex_view_method = 'zathura'
else
    let g:vimtex_view_general_viewer = 'okular'
endif
let g:vimtex_fold_enabled = 1
let g:vimtex_view_automatic = 0
" let g:tex_flavor='latex'

" Complete on cite= entries in acronyms
let g:vimtex_complete_bib = {}
let g:vimtex_complete_bib.custom_patterns = [ "\vcite=(\{[^\}]*|\a\w*)" ]
" let g:vimtex_compiler_latexmk = { 'continuous': 0 }
let g:vimtex_compiler_latexmk = {
    \ 'build_dir' : '',
    \ 'callback' : 1,
    \ 'continuous' : 1,
    \ 'executable' : 'latexmk',
    \ 'hooks' : [],
    \ 'options' : [
    \   '-verbose',
    \   '-file-line-error',
    \   '-synctex=1',
    \   '-interaction=nonstopmode',
    \   '-shell-escape',
    \ ],
    \}

let g:vimtex_view_use_temp_files = 1

if has('nvim')
    let g:vimtex_compiler_progname = 'nvr'
endif

if filereadable("/opt/textidote/textidote.jar")
    let g:vimtex_grammar_textidote = {
          \ 'jar': '/opt/textidote/textidote.jar',
          \ 'args': '',
          \}
    autocmd vimrc FileType tex      compiler textidote
endif

if executable('tectonic')
    let g:vimtex_compiler_method='tectonic'
endif
" }}}
" {{{ windows
if 0 &&  has('nvim')
lua <<EOF
vim.o.winwidth = 10
vim.o.winminwidth = 10
require'windows'.setup {}
vim.keymap.set('n', '<C-w>z', '<Cmd>WindowsMaximaze<CR>')
EOF
endif
" }}}
" }}}
" {{{ Postscript
" {{{ Fix airline sometimes not rendering when splitting
if g:airline_enabled
    au vimrc BufEnter * AirlineRefresh
endif
" }}}
" vim: fdm=marker ts=4 sw=4 sts=4 foldminlines=0
" }}}
