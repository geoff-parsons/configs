require 'fileutils'

# zsh
FileUtils.copy('./zsh', '../.zshrc')

# Ruby
FileUtils.copy('./irb', '../.irbrc')
FileUtils.copy('./ruby_gems', '../.gemrc')
FileUtils.copy('./autotest', '../.autotest')

# Git
FileUtils.copy('./git', '../.gitconfig')

# Subversion
FileUtils.mkdir('../.subversion') unless File.exists?('../.subversion')
FileUtils.copy('./subversion', '../.subversion/config')