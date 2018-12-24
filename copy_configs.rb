require 'fileutils'
require 'etc'

home_dir = Etc.getpwuid.dir
config_dir = File.join( File.dirname(__FILE__), 'config' )
script_dir = File.join( File.dirname(__FILE__), 'scripts')

os = case `uname`
       when /linux/i
         :linux
       when /darwin/i
         :OSX
       else
         :WTF
     end

##
## Ruby
##

if `which gem`.length == 0
  puts "You appear to not have ruby gems installed:"
  puts "  IRB config will not work without removing the line \"require 'rubygems'\""
else
  FileUtils.copy( File.join(config_dir, 'ruby_gems'), File.join(home_dir, '.gemrc') )
end
FileUtils.copy( File.join(config_dir, 'irb'), File.join(home_dir, '.irbrc') )

# Pow / Powder config
FileUtils.copy( File.join(config_dir, 'pow'), File.join(home_dir, '.powconfig') )


##
## Node / JS
##

unless File.exist?( File.join(home_dir, '.nvm') )
  FileUtils.mkdir( File.join(home_dir, '.nvm') )
end


##
## Emacs
##

FileUtils.remove_dir( File.join(home_dir, '.emacs.d'), :force => true )
FileUtils.cp_r( File.join(config_dir, 'emacs'), File.join(home_dir, '.emacs.d'))


##
## SublimeText
##

if File.exists?('/Applications/Sublime Text.app')
  FileUtils.ln_s('/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl', '/usr/local/bin/subl', :force => true)
  FileUtils.copy( File.join(config_dir, 'sublime'), File.join(home_dir, 'Library/Application Support/Sublime Text 3/Packages/User/Preferences.sublime-settings') )
end

##
## iTerm
##
if File.exists?('/Applications/iTerm.app/')
  FileUtils.mkdir( File.join(home_dir, '.iterm2') ) unless File.exists?(File.join(home_dir, '.iterm2'))
  FileUtils.copy( File.join(config_dir, 'iterm2'), File.join(home_dir, '.iterm2/com.googlecode.iterm2.plist') )
end


##
## Git
##

FileUtils.copy( File.join(config_dir, 'git'), File.join(home_dir, '.gitconfig') )
FileUtils.copy( File.join(config_dir, 'git_ignores'), File.join(home_dir, '.gitignore') )
# see if we have lynx, if so set it as the default web browser for git help --web
system('git config --global web.browser lynx') if `which lynx`.length > 0


##
## Subversion
##

unless File.exists?( File.join(home_dir, '.subversion') )
  FileUtils.mkdir( File.join(home_dir, '.subversion') )
end
FileUtils.copy( File.join(config_dir, 'subversion'), File.join(home_dir, '.subversion/config') )


##
## Scripts
##

FileUtils.mkdir(home_dir + '/bin') unless File.exists?(home_dir + '/bin')

FileUtils.copy( File.join(script_dir, 'battery-status.rb'), File.join(home_dir, 'bin', 'battery') )
FileUtils.chmod(0755, File.join(home_dir, 'bin', 'battery') )

if os == :OSX
  FileUtils.copy( File.join(script_dir, 'webkit2png.py'), File.join(home_dir, 'bin', 'webkit2png') )
  FileUtils.chmod(0755, File.join(home_dir, 'bin', 'webkit2png') )
end

FileUtils.copy( File.join(script_dir, 'tmux-rails.rb'), File.join(home_dir, 'bin', 'tmux-rails') )
FileUtils.chmod(0755, File.join(home_dir, 'bin', 'tmux-rails') )

FileUtils.copy( File.join(script_dir, 'ssh-public-key.sh'), File.join(home_dir, 'bin', 'ssh-public-key') )
FileUtils.chmod(0755, File.join(home_dir, 'bin', 'ssh-public-key') )



##
## tmux
##

FileUtils.copy( File.join(config_dir, 'tmux'), File.join(home_dir, '.tmux.conf') )


##
## zsh
##

FileUtils.copy( File.join(config_dir, 'zsh'), File.join(home_dir, '.zshrc') )
FileUtils.ln_s(home_dir + '/.zshrc', home_dir + '/.zshenv', :force => true)
FileUtils.copy( File.join(config_dir, 'skhisma.zsh-theme'), File.join(home_dir, '.oh-my-zsh/themes/skhisma.zsh-theme') )


##
## Warnings
##

if `which pbcopy`.length == 0 and `which xsel`.length == 0
  puts "You do not appear to have the pbcopy command; consider installing xsel."
end
