require 'fileutils'
require 'etc'

HOME_DIR = Etc.getpwuid.dir
CONFIG_DIR = File.join( File.dirname(__FILE__), 'config' )
TEXT_BROWSER = %w[links lynx].find { |cmd| `which #{cmd}`.size > 0 }
OS = case `uname`
       when /linux/i
         :linux
       when /darwin/i
         :OSX
       else
         :WTF
     end

def set_xenv_global(command, version)
  if !system("command -v #{command} 1>/dev/null 2>/dev/null")
    return
  elsif `#{command} versions --bare`.split.include?(version)
    system("#{command} global #{version}")
  else
    puts "Configs wants to set global #{command} version to #{version} but it is not installed."
  end
end

##
## Ruby
##

set_xenv_global("rbenv", "2.6.5")

FileUtils.copy( File.join(CONFIG_DIR, 'ruby_gems'), File.join(HOME_DIR, '.gemrc') )
FileUtils.copy( File.join(CONFIG_DIR, 'irb'), File.join(HOME_DIR, '.irbrc') )

# Pow / Powder config
FileUtils.copy( File.join(CONFIG_DIR, 'pow'), File.join(HOME_DIR, '.powconfig') )


##
## Python
##

set_xenv_global("pyenv", "3.7.3")

##
## Java
##

set_xenv_global("jenv", "oracle64-11.0.1")

##
## Node / JS
##

unless File.exist?( File.join(HOME_DIR, '.nvm') )
  FileUtils.mkdir( File.join(HOME_DIR, '.nvm') )
end


##
## SublimeText
##

if File.exists?('/Applications/Sublime Text.app')
  FileUtils.ln_s('/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl', '/usr/local/bin/subl', :force => true)
  FileUtils.copy( File.join(CONFIG_DIR, 'sublime'), File.join(HOME_DIR, 'Library/Application Support/Sublime Text 3/Packages/User/Preferences.sublime-settings') )
end

##
## iTerm
##
if File.exists?('/Applications/iTerm.app/')
  FileUtils.mkdir( File.join(HOME_DIR, '.iterm2') ) unless File.exists?(File.join(HOME_DIR, '.iterm2'))
  FileUtils.copy( File.join(CONFIG_DIR, 'iterm2'), File.join(HOME_DIR, '.iterm2/com.googlecode.iterm2.plist') )
end


##
## Git
##

FileUtils.copy( File.join(CONFIG_DIR, 'git'), File.join(HOME_DIR, '.gitconfig') )
FileUtils.copy( File.join(CONFIG_DIR, 'git_ignores'), File.join(HOME_DIR, '.gitignore') )
# see if we have any text browsers, if so set it as the default web browser for git help --web
system('git config --global web.browser #{TEXT_BROWSER}') if TEXT_BROWSER


##
## Subversion
##

unless File.exists?( File.join(HOME_DIR, '.subversion') )
  FileUtils.mkdir( File.join(HOME_DIR, '.subversion') )
end
FileUtils.copy( File.join(CONFIG_DIR, 'subversion'), File.join(HOME_DIR, '.subversion/config') )


##
## tmux
##

FileUtils.copy( File.join(CONFIG_DIR, 'tmux'), File.join(HOME_DIR, '.tmux.conf') )


##
## zsh
##

FileUtils.copy( File.join(CONFIG_DIR, 'zsh'), File.join(HOME_DIR, '.zshrc') )
FileUtils.copy( File.join(CONFIG_DIR, 'skhisma.zsh-theme'), File.join(HOME_DIR, '.oh-my-zsh/themes/skhisma.zsh-theme') )

##
## ~/bin
##

FileUtils.mkdir(HOME_DIR + '/bin') unless File.exists?(HOME_DIR + '/bin')


##
## Warnings
##

if `which pbcopy`.length == 0 and `which xsel`.length == 0
  puts "You do not appear to have the pbcopy command; consider installing xsel."
end
