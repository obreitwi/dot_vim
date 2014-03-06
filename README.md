.vim
---
This is my vim setup. It relies on Vundle to manage external plugins. All other modular configuration is managed via pathogen to allow for easier enable/disable via symlinks.

I tend to try out many plugins and only prune them once in a blue moon. Current startup time is around 0.5s which is fast enough for me. 

**Note:** What works for me might not work for you..

Setup
---

Just clone Vundle:
```
$ git clone https://github.com/gmarik/vundle.git bundle/vundle
$ ./install.sh # symlinks to the appropriate local places
$ vim +BundleInstall +qall
```
