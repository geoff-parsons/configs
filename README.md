Various config files to keep from having to manage them separately.

Installation
============

Clone this repository

```git clone git@github.com:skhisma/configs.git ~/Configs```

Run the copy_configs.rb script

```ruby ~/Configs/copy_configs.rb```

And you should be good to go.


Notes
=====

Emacs
-----

This config is designed around emacs 24. Currently to install this on a mac you will need to install from HEAD via homebrew:

```brew install emacs --HEAD```

The emacs config makes use of el-get; you will need to start emacs and wait for el-get to be cloned and then start emacs again and wait for all of the recipes to be installed before emacs will be ready to use.