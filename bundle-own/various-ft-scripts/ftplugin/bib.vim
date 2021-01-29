" Trick adapted from: https://johngodlee.github.io/2019/07/31/bibtex-fold.html
" Set folding function for bibtex entries
function! s:BibTeXFold()
  if getline(v:lnum) =~ '^@.*$'
    return ">1"
  endif
  return "="
endfunction
au BufEnter *.bib setlocal foldexpr=s:BibTeXFold()
au BufEnter *.bib setlocal foldmethod=expr
