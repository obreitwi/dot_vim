" this is mostly a matter of taste. but LaTeX looks good with just a bit
" of indentation.
setlocal sw=2
setlocal tabstop=2
setlocal softtabstop=2
setlocal textwidth=0
setlocal wrap
setlocal linebreak
setlocal wrapmargin=8
setlocal fo-=t
" setlocal formatprg=par\ -w120qrg
" setlocal formatprg=PARPROTECT\=_x09\ par\ -w120qrg
" setlocal formatprg=PARQUOTE\=_x09\ par\ -w120qrgT2
setlocal formatprg=PARQUOTE\=_x09\ par\ -w100T2
setlocal spell
" Apparently NERDTreeIngore cannot be a buffer variable
let g:NERDTreeIgnore+=[ "\._log$", "\._aux$", "\.bbl$", "\.blg$", "\.idx", "\.log$", "\.toc$", "\.out$" ]

vmap <LocalLeader>bf :Wrap \left\lfloor\  \right\rfloor<CR>

set iskeyword+=:

" TIP: if you write your \label's as \label{fig:something}, then if you
" type in \ref{fig: and press <C-n> you will automatically cycle through
" all the figure labels. Very useful!

" ALL BELOW IS LATEXSUITE

" " new vim73 syntax file
" let g:tex_isk="48-57,a-z,A-Z,192-255,:"
" " Set anyway for older versions
" set iskeyword+=:

" set winaltkeys=no
" let g:Tex_Leader = ';'
" let g:Tex_MyLeader = '/'

" let g:Tex_GotoError = 0

" " Workaround for compilation not working
" nmap <Leader>lc :!pdflatex %<CR>
" vmap <Leader>lc :!pdflatex %<CR>

" " Make jumping work in insert mode again
" imap <c-j> <Plug>IMAP_JumpForward

" " Simply use F7!!!
" " function! InsertBS()
  " " " insert a backslash before the word and move to the end
  " " normal! bi\
  " " normal! 2w
" " endfunction

" " noremap <silent> <c-p> :call InsertBS()<CR>

" " General bindings (math)
" call IMAP('ISE', '\setlength{\itemsep}{Jex}<++>', 'tex')
" call IMAP('UUE', '\SI{<++>}{<++>}<++>', 'tex')
" call IMAP('UEE', '\SI{<++>(<++>)e<++>}{<++>}<++>', 'tex')
" call IMAP('URG', '\SIrange{<++>}{<++>}{<++>}<++>', 'tex')
" call IMAP('EFG', "\\begin{figure}[<+htbp!+>]\<CR>\\centering\<CR><++>\<CR>\\caption{<++>}\<CR>\\label{fig:<++>}\<CR>\<BS>\\end{figure}<++>", 'tex')
" call IMAP('EFK', "\\begin{figure}[<+htbp!+>]\<CR>\\centering\<CR><++>\<CR>\<BS>\\end{figure}<++>", 'tex')
" call IMAP('EFS', "\\subfloat[<++>]{%\<CR>\\includegraphics[width=<++>\\columnwidth]{<++>}}%<++>", 'tex')
" call IMAP('EFF', '\includegraphics[width=<++>\columnwidth]{<++>}%<++>', 'tex')
" call IMAP('TRM', 'trim=<+l+> <+b+> <+r+> <+t+>,clip=true,', 'tex')
" call IMAP('EMF', "\\begin{center}\<CR>\\missingfigure[figwidth=<++>\\columnwidth]{<++>}%\<CR>\\end{center}<++>", 'tex')
" call IMAP('ETA', "\\begin{table}[ht]\<CR>\\begin{center}\<CR>\\begin{tabular}{<++>}\<CR>\\toprule\<CR><++>\\\\\<CR>\\midrule\<CR><++>\\\\ \<CR><++>\<CR>\\bottomrule\<CR> \\end{tabular}\<CR>\\caption{<++>}\<CR>\\label{tab:<++>}\<CR>\\end{center}\<CR>\\end{table}<++>", 'tex')
" call IMAP(g:Tex_Leader.'i', '\cdot ', 'tex')
" call IMAP(g:Tex_MyLeader.'^', '^{<++>}<++>', 'tex')
" call IMAP(g:Tex_MyLeader.'_', '_{<++>}<++>', 'tex')
" call IMAP(g:Tex_MyLeader.'i', '\item', 'tex')
" call IMAP('\itemd', '\item[<++>]<++>', 'tex')
" call IMAP(g:Tex_MyLeader.'FN', '\footnote{<++>}<++>', 'tex')
" call IMAP(g:Tex_MyLeader.'~', '\approx', 'tex')
" call IMAP(g:Tex_MyLeader.'d', '\mathrm{d}', 'tex')

" " We need easier \ (NOT ANYMORE!)
" " call IMAP(g:Tex_MyLeader.g:Tex_MyLeader, '\', 'tex')

" " We need easier []{}
" " call IMAP('#;', '[', 'tex')
" " call IMAP('#:', ']', 'tex')
" " call IMAP('#,', '{', 'tex')
" " call IMAP('\##', '\\[<++>ex]<++>', 'tex')
" " #. does not work!
" " call IMAP('#+', '}', 'tex')
" call IMAP(g:Tex_MyLeader.'s', '\sum_{<++>}^{<++>}<++>', 'tex')
" call IMAP(g:Tex_MyLeader.'S', '\sum_{<++>}<++>', 'tex')
" call IMAP(g:Tex_MyLeader.'p', '\prod_{<++>}^{<++>}<++>', 'tex')

" " Further greek letters
" call IMAP(g:Tex_MyLeader.'gp', '\phi', 'tex')
" call IMAP(g:Tex_MyLeader.'gvp', '\varphi', 'tex')
" call IMAP(g:Tex_MyLeader.'gt', '\theta', 'tex')

" " Spaces
" call IMAP(g:Tex_MyLeader.'vs', '\vspace{<++>ex}<++>', 'tex')
" call IMAP(g:Tex_MyLeader.'hs', '\hspace{<++>ex}<++>', 'tex')

" " Text changes
" call IMAP(g:Tex_MyLeader.'tb', '\textbf{<++>}<++>', 'tex')
" call IMAP(g:Tex_MyLeader.'te', '\emph{<++>}<++>', 'tex')
" call IMAP(g:Tex_MyLeader.'tv', '\verb~<++>~<++>', 'tex')
" call IMAP(g:Tex_MyLeader.'tr', '\textrm{<++>}<++>', 'tex')
" call IMAP(g:Tex_MyLeader.'tt', '\texttt{<++>}<++>', 'tex')
" call IMAP(g:Tex_MyLeader.'tc', '\centering', 'tex')

" " Beamer bindings
" call IMAP('BCS', "\\begin{columns}[totalwidth=<++>\\textwidth]\<CR><++>\<CR>\\end{columns}<++>", 'tex')
" call IMAP('BFR', "\\begin{frame}<+[tb]+>{<++>}\<CR><++>\<CR>\\end{frame}<++>", 'tex')
" " call IMAP('BFT', '\frametitle{<++>}<++>', 'tex')
" call IMAP('BCC', '\column{<++>\textwidth}<++>', 'tex')
" call IMAP('BBX', "\\begin{block}{}\<CR><++>\<CR>\\end{block}<++>", 'tex')
" call IMAP('BAX', "\\begin{alertblock}{}\<CR><++>\<CR>\\end{alertblock}<++>", 'tex')
" call IMAP('BEX', "\\begin{exampleblock}{}\<CR><++>\<CR>\\end{exampleblock}<++>", 'tex')
" call IMAP('BBT', "\\begin{block}{<++>}\<CR><++>\<CR>\\end{block}<++>", 'tex')
" call IMAP('BAT', "\\begin{alertblock}{<++>}\<CR><++>\<CR>\\end{alertblock}<++>", 'tex')
" call IMAP('BET', "\\begin{exampleblock}{<++>}\<CR><++>\<CR>\\end{exampleblock}<++>", 'tex')
" " not needed due to F5
" " call IMAP('LST', "\\begin{lstlisting}\<CR><++>\<CR>\\end{lstlisting}<++>", 'tex')

" " Minipage
" call IMAP(g:Tex_MyLeader.'MIN', "\\begin{minipage}[<+hb+>]{<++>\textwidth}\<CR><++>\<CR>\\end{minipage}<++>", 'tex')

" " Include method for unaccounted subs
" call IMAP('SPS', "\<CR>\\begingroup\<CR>\\addtocontents{toc}{\\protect\\setcounter{tocdepth}{3}}\<CR>\\renewcommand{\\thesubsubsection}{\\alph{subsubsection})}\<CR><++>\<CR>\\endgroup", 'tex')

" " MATH
" " Make arrows very easy to write
" call IMAP(g:Tex_MyLeader.'->', '\rightarrow', 'tex')
" call IMAP(g:Tex_MyLeader.'=>', '\Rightarrow', 'tex')
" call IMAP('\rightarrow>', '\longrightarrow', 'tex')
" call IMAP('\Rightarrow>', '\Longrightarrow', 'tex')
" call IMAP(g:Tex_MyLeader.'<-', '\leftarrow', 'tex')
" call IMAP(g:Tex_MyLeader.'<=', '\Leftarrow', 'tex')
" call IMAP('\leftarrow-', '\longleftarrow', 'tex')
" call IMAP('\Leftarrow=', '\Longleftarrow', 'tex')
" call IMAP(g:Tex_MyLeader.'<>', '\leftrightarrow', 'tex')
" call IMAP(g:Tex_MyLeader.'<#>', '\Leftrightarrow', 'tex')
" call IMAP('\leftrightarrow>', '\longleftrightarrow', 'tex')
" call IMAP('\Leftrightarrow>', '\Longleftrightarrow', 'tex')

" " Brackets
" call IMAP(g:Tex_MyLeader.'lr(', '\left( <++> \right)<++>', 'tex')
" call IMAP(g:Tex_MyLeader.'lr[', '\left\[ <++> \right\]<++>', 'tex')
" call IMAP(g:Tex_MyLeader.'lr{', '\left\{ <++> \right\}<++>', 'tex')
" call IMAP(g:Tex_MyLeader.'lr<', '\left< <++> \right><++>', 'tex')
" call IMAP(g:Tex_MyLeader.'ub', '\underbrace{<++>}_{<++>}<++>', 'tex')

" " BA specific
" call IMAP(g:Tex_MyLeader.'NSIZE', '\num{<++>} \acp{HC} by \num{<++>} \acp{MC}<++>', 'tex')

" let g:Tex_CompileRule_pdf = 'pdflatex -interaction=nonstopmode -shell-escape $*'

" " multipletimes for pdf too
" let g:Tex_MultipleCompileFormats = "dvi pdf"

" " we usually compile pdfs
" let g:Tex_DefaultTargetFormat = "pdf"

" " Windoof only

" if g:opsystem == "CYGWIN_NT-6.1-WOW64" || g:opsystem == "windows"
  " let g:Tex_ViewRule_pdf = "SumatraPDF"
" else
  " let g:Tex_ViewRule_pdf = "evince"
" endif

