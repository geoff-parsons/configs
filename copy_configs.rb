require 'fileutils'
require 'etc' 

home_dir = Etc.getpwuid.dir
dir = File.dirname(__FILE__)
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
  FileUtils.copy(dir + '/ruby_gems', home_dir + '/.gemrc')
end
FileUtils.copy(dir + '/irb', home_dir + '/.irbrc')
FileUtils.copy(dir + '/autotest', home_dir + '/.autotest')


##
## Git
##

FileUtils.copy(dir + '/git', home_dir + '/.gitconfig')
FileUtils.copy(dir + '/git_ignores', home_dir + '/.gitignore')
# see if we have lynx, if so set it as the default web browser for git help --web
system('git config --global web.browser lynx') if `which lynx`.length > 0


##
## Subversion
##

FileUtils.mkdir(home_dir + '/.subversion') unless File.exists?(home_dir + '/.subversion')
FileUtils.copy(dir + '/subversion', home_dir + '/.subversion/config')


##
## Scripts
##

FileUtils.mkdir(home_dir + '/bin') unless File.exists?(home_dir + '/bin')

FileUtils.copy(dir + '/scripts/battery-status.rb', home_dir + '/bin/battery')
FileUtils.chmod(0755, home_dir + '/bin/battery')

if os == :OSX
  FileUtils.copy(dir + '/scripts/webkit2png.py', home_dir + '/bin/webkit2png')
  FileUtils.chmod(0755, home_dir + '/bin/webkit2png')
end

FileUtils.copy(dir + '/scripts/tmux-rails.sh', home_dir + '/bin/tmux-rails')
FileUtils.chmod(0755, home_dir + '/bin/tmux-rails')


##
## tmux
##

FileUtils.copy(dir + '/tmux', home_dir + '/.tmux.conf')


##
## zsh
##

FileUtils.copy(dir + '/zsh', home_dir + '/.zshrc')
FileUtils.ln_s(home_dir + '/.zshrc', home_dir + '/.zshenv', :force => true)


##
## Warnings
##

if `which pbcopy`.length == 0 and `which xsel`.length == 0
  puts "You do not appear to have the pbcopy command; consider installing xsel."
end
