" the following code will produce an error if pythonx is not available so it
" has to be sourced seperately
pythonx << EOF
import vim
try:
    import neovim
    vim.command("let g:pynvim_available=1")
except:
    vim.command("let g:pynvim_available=0")
EOF

