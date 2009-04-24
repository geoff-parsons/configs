
#######################
##    zsh Options    ##
#######################

setopt PROMPT_SUBST
export PROMPT="(%{$reset_color%}%n@%m%) (%1c%) %# "

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

alias ls="ls -pG"
alias ll="ls -l"
alias la="ls -a"
alias lr="ls -r"
alias grep="grep --color"
alias calc="open /Applications/Calculator.app"


#######################
##      History      ##
#######################

export HISTFILE=~/.history
export HISTSIZE=1000
export SAVEHIST=1000
export SHARE_HISTORY=1
export EXTENDED_HISTORY=1
export HIST_EXPIRE_DUPS_FIRST=1


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

_rake_does_task_list_need_generating () {
  if [ ! -f .rake_tasks ]; then return 0;
  else
    accurate=$(stat -f%m .rake_tasks)
    changed=$(stat -f%m Rakefile)
    return $(expr $accurate '>=' $changed)
  fi
}
 
_rake () {
  if [ -f Rakefile ]; then
    if _rake_does_task_list_need_generating; then
      echo "\nGenerating .rake_tasks..." > /dev/stderr
      rake --silent --tasks | cut -d " " -f 2 > .rake_tasks
    fi
    compadd `cat .rake_tasks`
  fi
}

compctl -K _rake rake


#######################
##        Java       ##
#######################

export CLASSPATH="."
# JUnit (aliased to the latest version)
export CLASSPATH="$CLASSPATH:/Library/Java/Extensions/junit.jar"
# HTTPUnit
export CLASSPATH="$CLASSPATH:/Library/Java/Extensions/httpunit.jar"


#######################
##      Editors      ##
#######################

export EDITOR="mate"
export SVN_EDITOR="pico"

