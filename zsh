
#######################
##    zsh Options    ##
#######################

# Completion
zstyle ':completion:*' completer _expand _complete
autoload -Uz compinit
compinit
# Allow tab completion in the middle of a word
setopt COMPLETE_IN_WORD

autoload -Uz colors
colors

# Prompt Options
setopt prompt_subst
export PROMPT=$'%{$reset_color%}(%n@%m) (%2c) %{$(git-prompt)%}%% '

# Auto-cd: "/usr/bin" is the same as "cd /usr/bin"
setopt AUTO_CD

# beeps are annoying
setopt NO_BEEP

setopt EXTENDED_GLOB


#######################
##        Path       ##
#######################

export PATH=".:${HOME}/bin"
# /usr/local
export PATH="$PATH:/usr/local/bin:/usr/local/sbin"
# User Gems
export PATH="$PATH:${HOME}/.gem/ruby/1.8/bin"
# Ports installs
export PATH="$PATH:/opt/local/bin:/opt/local/sbin"
# Default path
export PATH="$PATH:/usr/bin:/usr/sbin:/bin:/sbin"
# Developer tool's bin
export PATH="$PATH:/Developer/usr/bin"
# MySQL
export PATH="$PATH:/usr/local/mysql/bin"
# Postgres
export PATH="$PATH:/usr/local/pgsql/bin"
# X11
export PATH="$PATH:/usr/X11/bin"


#######################
##      Man Path     ##
#######################

export MANPATH="/usr/local/man"
# Ports
export MANPATH="$MANPATH:/opt/local/share/man:/opt/local/man"
# default path
export MANPATH="$MANPATH:/usr/share/man"
# Developer tool's bin
export MANPATH="$MANPATH:/Developer/usr/share/man"
# MySQL
export MANPATH="$MANPATH:/usr/local/mysql/man"
# X11
export MANPATH="$MANPATH:/usr/X11/man"


#######################
##      Aliases      ##
#######################

alias ls="ls -hG"
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

if [[ -e '/Applications/GitX.app' ]]; then
  alias gitx="/Applications/GitX.app/Contents/Resources/gitx"
fi
if [[ -e '/Applications/Calculator.app' ]]; then
  alias calc="open /Applications/Calculator.app"
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

if which mate > /dev/null; then
  export EDITOR="mate -w"
  export LESSEDIT='mate -l %lm %f'
else
  export EDITOR="pico"
fi
export SVN_EDITOR="pico"
export GIT_EDITOR="pico"


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

# capistrano
alias cap1="cap _1.4.1_"

# RVM
if [[ -s ~/.rvm/scripts/rvm ]] ; then
  source ~/.rvm/scripts/rvm
fi


#######################
##        Java       ##
#######################

if [ -d /usr/lib/jvm/java-6-sun/jre ]; then
  # Ubuntu with Java 6
  export JAVA_HOME="/usr/lib/jvm/java-6-sun/jre"
elif [ -d /System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home ]; then
  # OS X
  export JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home"
fi
export ANT_HOME="/usr/share/ant"
export MAVEN_HOME="/usr/share/maven"

#######################
##        Git        ##
#######################

if [[ -x `which git` ]]; then
  
  function git-branch-name() {
    git branch 2> /dev/null | grep "^\*" | sed "s/^\*\ //"
  }
  
  function git-dirty() {
    git status | grep "nothing to commit (working directory clean)"
    echo $?
  }
  
  function git-prompt() {
    branch=$(git-branch-name)
    if [[ x$branch != x && $branch != '' ]]; then
      dirty_color=$fg[green]
      if [[ $(git-dirty) = 1 ]] { dirty_color=$fg[red] }
      [ x$branch != x ] && echo "[%{$dirty_color%}$branch$(git-stash-count)%{$reset_color%}] "
    fi
  }
  
  function git-stash-count() {
    branch=$(git-branch-name)
    count=$(git stash list | grep "${branch}" | wc -l | awk '{print $1}')
    [ $count != 0 ] && echo " ($count)"
  }

fi


#######################
##        Mac        ##
#######################

function volume() {
  `osascript -e "set volume $1"`
}
alias mute='volume 0'
