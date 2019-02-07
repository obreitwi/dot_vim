" the following code will produce an error if pythonx is not available so it
" has to be sourced seperately

" this version defaults to :python command
python3 << EOF
try:
    from powerline.vim import setup as powerline_setup
    powerline_setup()
    del powerline_setup
except:
    import vim
    vim.command("let g:powerline_available=0")
EOF

