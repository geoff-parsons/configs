
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
PROMPT=$'%{$reset_color%}(%n@%m) (%2c) %{$(git-prompt)%}%% '

# Auto-cd: "/usr/bin" is the same as "cd /usr/bin"
setopt AUTO_CD

# beeps are annoying
setopt NO_BEEP

setopt EXTENDED_GLOB


#######################
##        Path       ##
#######################

export PATH=".:/Users/gparsons/bin:/usr/local/bin:/usr/local/sbin"
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

alias ls="ls -phG"
alias ll="ls -l"
alias la="ls -a"
alias lr="ls -r"
alias grep="grep --color"
alias calc="open /Applications/Calculator.app"
alias gitx='/Applications/GitX.app/Contents/Resources/gitx'


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

export EDITOR="mate"
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


#######################
##        Java       ##
#######################

export CLASSPATH="."
# JUnit (aliased to the latest version)
export CLASSPATH="$CLASSPATH:/Library/Java/Extensions/junit.jar"
# HTTPUnit
export CLASSPATH="$CLASSPATH:/Library/Java/Extensions/httpunit.jar"


#######################
##        Git        ##
#######################

if [[ -x `which git` ]]; then
  
  function git-branch-name () {
    git branch 2> /dev/null | grep ^\* | sed s/^\*\ //
  }
  
  function git-dirty () {
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
