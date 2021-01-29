" this is mostly a matter of taste. but LaTeX looks good with just a bit
" of indentation.
setlocal sw=2
setlocal tabstop=2
setlocal softtabstop=2
setlocal expandtab
setlocal textwidth=0
setlocal wrap
setlocal linebreak
setlocal wrapmargin=8
setlocal fo-=t
setlocal modelineexpr
" setlocal formatprg=par\ -w120qrg
" setlocal formatprg=PARPROTECT\=_x09\ par\ -w120qrg
" setlocal formatprg=PARQUOTE\=_x09\ par\ -w120qrgT2
setlocal formatprg=PARQUOTE\=_x09\ par\ w100T2
setlocal spell
" Apparently NERDTreeIngore cannot be a buffer variable
let g:NERDTreeIgnore+=[ "\._log$", "\._aux$", "\.bbl$", "\.blg$", "\.idx", "\.log$", "\.toc$", "\.out$" ]

setlocal iskeyword+=@-@
setlocal iskeyword+=:

function! TexFoldAcronyms()
  if getline(v:lnum) =~ '^\\DeclareAcronym{.*$'
    return ">1"
  elseif getline(v:lnum) =~ '^\\acro{.*$'
    return ">1"
  else
    return "="
  endif
endfunction
