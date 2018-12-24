Various config files to keep from having to manage them separately. Fairly heavily OS X-oriented.

Setup
============

1. Install [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh).

2. Clone this repository:

  ```git clone git://github.com/skhisma/configs.git ~/Configs```
3. Run the copy_configs.rb script:
  
  ```ruby ~/Configs/copy_configs.rb```

And you should be good to go.


Notes
=====

The `copy_configs` script does its best to only copy needed configs over and in some cases will recommend installing various packages. It's not perfect however.
