require 'fileutils'
require 'etc' 

home_dir = Etc.getpwuid.dir
dir = File.dirname(__FILE__)

# zsh
FileUtils.copy(dir + '/zsh', home_dir + '/.zshrc')
FileUtils.ln_s(home_dir + '/.zshrc', home_dir + '/.zshenv', :force => true)

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
