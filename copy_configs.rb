require 'fileutils'
require 'etc' 

home_dir = Etc.getpwuid.dir
dir = File.dirname(__FILE__)

# Ruby
if `which gem`.length == 0
  puts "You appear to not have ruby gems installed:"
  puts "  IRB config will not work without removing the line \"require 'rubygems'\""
  puts "  Some config files may be irrelevant."
end
FileUtils.copy(dir + '/irb', home_dir + '/.irbrc')
FileUtils.copy(dir + '/ruby_gems', home_dir + '/.gemrc')
FileUtils.copy(dir + '/autotest', home_dir + '/.autotest')

# Git
FileUtils.copy(dir + '/git', home_dir + '/.gitconfig')
FileUtils.copy(dir + '/git_ignores', home_dir + '/.gitignore')
# see if we have lynx, if so set it as the default web browser for git help --web
system('git config --global web.browser lynx') if `which lynx`.length > 0

# Subversion
FileUtils.mkdir(home_dir + '/.subversion') unless File.exists?(home_dir + '/.subversion')
FileUtils.copy(dir + '/subversion', home_dir + '/.subversion/config')

# Scripts
FileUtils.mkdir(home_dir + '/bin') unless File.exists?(home_dir + '/bin')
FileUtils.copy(dir + '/scripts/battery-status.rb', home_dir + '/bin/battery')
FileUtils.chmod(0755, home_dir + '/bin/battery')
FileUtils.copy(dir + '/scripts/webkit2png.py', home_dir + '/bin/webkit2png')
FileUtils.chmod(0755, home_dir + '/bin/webkit2png')

# zsh
if `which mate`.length == 0
  puts "You appear to not have TextMate installed or don't have the shell script installed with it:"
  puts "  Some settings in ~/.zshrc will not work."
end
FileUtils.copy(dir + '/zsh', home_dir + '/.zshrc')
FileUtils.ln_s(home_dir + '/.zshrc', home_dir + '/.zshenv', :force => true)

if `which pbcopy`.length == 0 and `which xsel`.length == 0
  puts "You do not appear to have the pbcopy command; consider install xsel."
end
