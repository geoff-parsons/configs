require 'fileutils'
require 'etc' 

home_dir = Etc.getpwuid.dir
dir = File.dirname(__FILE__)

# zsh
puts "Existing zsh profile (.zshenv) may conflict with new profile." if File.exists?(home_dir + '/.zshenv')
FileUtils.copy(dir + '/zsh', home_dir + '/.zshrc')

# Ruby
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
