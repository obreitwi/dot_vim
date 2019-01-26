.vim
---
This is my vim setup. It relies on [`vim-plug`] to manage external plugins.
Other modular configuration is managed via pathogen to allow for easier
enable/disable via symlinks.

The main configuration (as well as plugin-specific settings) is organized via
folds in [`vimrc`](vimrc) (so it is best viewed using nvim/vim directly).

Plugins are defined in [plugs.vim](plugs.vim). Please note that I tend to try
out many plugins and only prune them once in a blue moon. Current startup time
is around 0.5s which is fast enough for me but might be too long for others.
Just mix and match and see which plugins suit you.

Additionally, this setup also installs [`vimpager`] binaries because sometimes
it is convenient to `vcat` some smaller files with vim coloring on the
terminal.

Setup
---
For a quick installation procedure there is a quick install script cloning
[`vim-plug`], installing all plugins as well as symlinking the needed binaries
from [`vimpager`].
```
$ PREFIX=$HOME/.local ./install.sh # symlinks to the appropriate places under
                                   # $PREFIX
```

[`vim-plug`]: https://github.com/junegunn/vim-plug
[`vimpager`]: https://github.com/rkitover/vimpager
