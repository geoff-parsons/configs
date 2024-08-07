
[ -z "$ZPROF" ] || zmodload zsh/zprof

#######################
##       Paths       ##
#######################

export PATH=".:${HOME}/bin:/usr/local/sbin:$PATH"

if [[ -f '/opt/homebrew/bin/brew' ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

export MANPATH="/opt/homebrew/share/man:/usr/local/share/man:/usr/share/man:/usr/local/man:$MANPATH"
# Developer tool's bin
export MANPATH="$MANPATH:/Applications/Xcode.app/Contents/Developer/usr/share/man"

#######################
##    zsh Options    ##
#######################

# User Oh-My-ZSH
export LANG=en_US.UTF-8
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="skhisma"
ZSH_PYENV_QUIET=true
plugins=(rails gem git-prompt gh jenv nvm pyenv rbenv colored-man-pages encode64 jira)
DISABLE_AUTO_UPDATE="true"
source $ZSH/oh-my-zsh.sh
if [[ -d '/opt/homebrew/share/zsh-syntax-highlighting' ]]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -d '/usr/local/share/zsh-syntax-highlighting' ]]; then
  source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

autoload -U add-zsh-hook

# Completion
zstyle ':completion:*' completer _expand _complete
autoload -Uz compinit
compinit
# Allow tab completion in the middle of a word
setopt COMPLETE_IN_WORD
# kubectl completion
source <(kubectl completion zsh)

autoload -Uz colors
colors

# Prompt Options
setopt prompt_subst

# Auto-cd: "/usr/bin" is the same as "cd /usr/bin"
setopt AUTO_CD

# beeps are annoying
setopt NO_BEEP

setopt EXTENDED_GLOB

#######################
##      Aliases      ##
#######################

if ls --color >/dev/null 2>/dev/null; then
  alias ls="ls --color -hp"
else
  alias ls="ls -phG"
fi
alias l="ls"
alias ll="ls -l"
alias la="ls -a"
alias lr="ls -r"
alias grep="grep --color"
alias df="df -H"

if ! (which pbcopy > /dev/null); then
  if which xsel > /dev/null; then
    alias pbcopy="xsel --clipboard"
  fi
fi

if [[ -d '/Applications/VLC.app' ]]; then
  alias vlc="/Applications/VLC.app/Contents/MacOS/VLC"
fi

#######################
##      History      ##
#######################

export HISTFILE=~/.history
export HISTSIZE=1000
export SAVEHIST=1000
export SHARE_HISTORY=1
export EXTENDED_HISTORY=1
export HIST_EXPIRE_DUPS_FIRST=1
setopt appendhistory


#######################
##      Editors      ##
#######################

if command -v subl 1>/dev/null 2>/dev/null; then
  export EDITOR="subl -nw"
  export SVN_EDITOR="subl -nw"
  export GIT_EDITOR="subl -nw"
elif command -v nano 1>/dev/null 2>/dev/null; then
  export EDITOR="nano"
  export SVN_EDITOR="nano"
  export GIT_EDITOR="nano"
else
  export EDITOR="pico"
  export SVN_EDITOR="pico"
  export GIT_EDITOR="pico"
fi

#######################
##    Key Bindings   ##
#######################

if [[ -f ~/.zkbd/$TERM-$VENDOR-$OSTYPE ]]; then
  bindkey "${key[Home]}" beginning-of-line
  bindkey "${key[End]}" end-of-line
fi

#######################
##        Ruby       ##
#######################

alias bx="bundle exec"
# allows square brackts for rake task invocation
alias rake="noglob rake"
unsetopt nomatch

# Handled by the rbenv oh my zsh plugin...
# if command -v rbenv 1>/dev/null 2>&1; then
#   eval "$(rbenv init -)"
# fi

#######################
##       Python      ##
#######################

export PYENV_ROOT="$HOME/.pyenv"

alias px="pyenv exec"

# Handled by the pyenv oh my zsh plugin...
# if command -v pyenv 1>/dev/null 2>&1; then
#   eval "$(pyenv init -)"
# fi

#######################
##        Node       ##
#######################

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

zstyle ':omz:plugins:nvm' autoload yes

# # auto-run `nvm use` whenever .nvmrc is detected
# load-nvmrc() {
#   local node_version="$(nvm version)"
#   local nvmrc_path="$(nvm_find_nvmrc)"

#   if [ -n "$nvmrc_path" ]; then
#     local nvmrc_node_version="$(cat "${nvmrc_path}")"

#     if [ $(nvm version "$nvmrc_node_version") = "N/A" ]; then
#       echo "You do not have the version of node specified in .nvmrc installed ($nvmrc_node_version)"
#     elif [ "$nvmrc_node_version" != "$node_version" ]; then
#       nvm use --silent
#     fi
#   elif [ "$node_version" != "$(nvm version default)" ]; then
#     nvm use --silent default
#   fi
# }
# add-zsh-hook chpwd load-nvmrc
# load-nvmrc

#######################
##        Java       ##
#######################

# Set JAVA_HOME on OS X
export JAVA_HOME=$(/usr/libexec/java_home)
export ANT_HOME="/usr/share/ant"
export MAVEN_HOME="/usr/share/maven"

# Handled by the jenv oh my zsh plugin...
# if command -v jenv 1>/dev/null 2>&1; then
#   eval "$(jenv init -)"
# fi

#######################
##        Mac        ##
#######################

if [[ -x `which osascript` ]]; then
  function volume() {
    `osascript -e "set volume $1"`
  }
  alias mute='volume 0'
fi

if [[ -x `which qlmanage` ]]; then
  function quick-look() {
    (( $# > 0 )) && qlmanage -p $* &>/dev/null &
  }
  alias ql='quick-look'
fi

if [[ -x `which open` ]]; then
  function man-preview() {
    man -t "$@" | open -f -a Preview
  }
fi

[ -z "$ZPROF" ] || zprof
