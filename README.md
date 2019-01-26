.vim
---
This is my vim setup. It relies on
[`vim-plug`] to manage external plugins.
All other modular configuration is managed via pathogen to allow for easier
enable/disable via symlinks.

I tend to try out many plugins and only prune them once in a blue moon. Current
startup time is around 0.5s which is fast enough for me.

**Note:** What works for me might not work for you…

Setup
---
For a quick installation procedure there is a quick install script cloning
[`vim-plug`], installing all plugins as well as symlinking the needed binaries
from vimpager.
```
$ PREFIX=$HOME/.local ./install.sh # symlinks to the appropriate places under
                                   # $PREFIX
```

[`vim-plug`]: (https://github.com/junegunn/vim-plug)
