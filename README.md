Various config files to keep from having to manage them separately. Fairly heavily MacOS-oriented.

## Prerequisites

* Ruby
* zsh
* [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
* (Optional) [Homebrew](https://brew.sh) - Highly recommended if on MacOS.



## Setup


1. Clone this repository:

  ```git clone git://github.com/skhisma/configs.git ~/Configs```

2. Run the copy_configs.rb script:
  
  ```ruby ~/Configs/copy_configs.rb```

And you should be good to go.


## Notes

The `copy_configs` script does its best to only copy needed configs over and in some cases will recommend installing various packages. It's not perfect.

Please review `copy_configs` before running as it does _a lot_ up to and including installing Homebrew packages if required. Not everything may be desired.