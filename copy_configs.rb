require 'fileutils'
require 'etc'
require './lib/string_colorize'
require './lib/command_helpers'

HOME_DIR = Etc.getpwuid.dir
CONFIG_DIR = File.join( File.dirname(__FILE__), 'config' )
TEXT_BROWSER = %w[links lynx].find { |cmd| cmd_exists?(cmd) }
OS = case `uname`
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

puts '[Ruby]'.bold

DEFAULT_RUBY_VERSION = "2.6.5"
if cmd_exists?('rbenv') && `rbenv versions`.include?(DEFAULT_RUBY_VERSION)
  run_cmd(message: "Setting default version with rbenv to #{DEFAULT_RUBY_VERSION.underline}") do
    set_xenv_global("rbenv", DEFAULT_RUBY_VERSION)
  end
end

run_cmd(message: "Copying ruby gems config") do
  FileUtils.copy( File.join(CONFIG_DIR, 'ruby_gems.yml'), File.join(HOME_DIR, '.gemrc') )
end
run_cmd(message: "Copying irb config") do
  FileUtils.copy( File.join(CONFIG_DIR, 'irb.rb'), File.join(HOME_DIR, '.irbrc') )
end
run_cmd(message: "Copying pow config") do
  FileUtils.copy( File.join(CONFIG_DIR, 'pow.sh'), File.join(HOME_DIR, '.powconfig') )
end
puts

##
## Python
##

puts '[Python]'.bold

DEFAULT_PYTHON_VERSION = "3.7.3"
if cmd_exists?('pyenv') && `pyenv versions`.include?(DEFAULT_PYTHON_VERSION)
  run_cmd(message: "Setting default version with pyenv to #{DEFAULT_PYTHON_VERSION.underline}") do
    set_xenv_global("pyenv", DEFAULT_PYTHON_VERSION)
  end
end
puts

##
## Java
##

puts '[Java]'.bold
DEFAULT_JAVA_VERSION = "oracle64-11.0.1"
if cmd_exists?('jenv') && `jenv versions`.include?(DEFAULT_JAVA_VERSION)
  run_cmd(message: "Setting default version with jenv to #{DEFAULT_JAVA_VERSION.underline}") do
    set_xenv_global("jenv", DEFAULT_JAVA_VERSION)
  end
end
puts

##
## Node / JS
##

unless File.exist?( File.join(HOME_DIR, '.nvm') )
  puts '[Node]'.bold
  run_cmd(message: "Creating nvm config directory") do
    FileUtils.mkdir( File.join(HOME_DIR, '.nvm') )
  end
  puts
end


##
## SublimeText
##

if File.exists?('/Applications/Sublime Text.app')
  puts '[SublimeText]'.bold
  run_cmd(message: "Linking #{'`subl`'.italic} command") do
    FileUtils.ln_s('/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl', '/usr/local/bin/subl', :force => true)
  end
  run_cmd(message: "Copying SublimeText config") do
    if File.exists?( File.join(HOME_DIR, 'Library/Application Support/Sublime Text/') )
      FileUtils.copy( File.join(CONFIG_DIR, 'sublime.json'), File.join(HOME_DIR, 'Library/Application Support/Sublime Text/Packages/User/Preferences.sublime-settings') )
    elsif File.exists?( File.join(HOME_DIR, 'Library/Application Support/Sublime Text 3/') )
      FileUtils.copy( File.join(CONFIG_DIR, 'sublime.json'), File.join(HOME_DIR, 'Library/Application Support/Sublime Text 3/Packages/User/Preferences.sublime-settings') )
    else
      raise "Sublime Text preferences directory could not be found."
    end
  end
  puts
end


##
## iTerm
##
if File.exists?('/Applications/iTerm.app/')
  puts '[iTerm]'.bold
  unless File.exists?(File.join(HOME_DIR, '.iterm2'))
    run_cmd(message: "Creating iTerm config directory") do
      FileUtils.mkdir( File.join(HOME_DIR, '.iterm2') )
    end
  end
  run_cmd(message: "Copying iTerm settings plist") do
    FileUtils.copy( File.join(CONFIG_DIR, 'iterm/settings.plist'), File.join(HOME_DIR, '.iterm2/com.googlecode.iterm2.plist') )
  end
  run_cmd(message: "Creating iTerm profile") do
    FileUtils.copy( File.join(CONFIG_DIR, 'iterm/profile.json'), File.join(HOME_DIR, '.iterm2/profile.json') )
  end
  puts
end


##
## Git
##

puts '[git]'.bold

run_cmd(message: "Copying git config") do
  FileUtils.copy( File.join(CONFIG_DIR, 'git'), File.join(HOME_DIR, '.gitconfig') )
end

if cmd_exists?('delta')
  run_cmd(message: "#{'`delta`'.italic} detected, setting as git diff tool") do
    system('git config --global core.pager delta')
    system('git config --global interactive.diffFilter "delta --color-only"')
    config = <<-GITCONFIG
[delta]
  features = side-by-side line-numbers decorations
  whitespace-error-style = 22 reverse

[delta "decorations"]
  commit-decoration-style = bold yellow box ul
  file-style = bold yellow ul
  file-decoration-style = none
GITCONFIG
    File.open(File.join(HOME_DIR, '.gitconfig'), 'a') do |file|
      file.puts "\n"
      file.puts config
    end
  end
end

if TEXT_BROWSER
  run_cmd(message: "#{('`' + TEXT_BROWSER + '`').italic} detected, setting as git browser") do
    system('git config --global web.browser #{TEXT_BROWSER}')
  end
end

run_cmd(message: "Copying default git ignores") do
  FileUtils.copy( File.join(CONFIG_DIR, 'git_ignores'), File.join(HOME_DIR, '.gitignore') )
end
puts


##
## Subversion
##

puts '[svn]'.bold
unless File.exists?( File.join(HOME_DIR, '.subversion') )
  run_cmd(message: "Creating svn config directory") do
    FileUtils.mkdir( File.join(HOME_DIR, '.subversion') )
  end
end
run_cmd(message: "Copying svn config") do
  FileUtils.copy( File.join(CONFIG_DIR, 'subversion'), File.join(HOME_DIR, '.subversion/config') )
end
puts


##
## tmux
##

puts '[tmux]'.bold
run_cmd(message: "Copying tmux config") do
  FileUtils.copy( File.join(CONFIG_DIR, 'tmux'), File.join(HOME_DIR, '.tmux.conf') )
end
puts


##
## zsh
##

puts '[zsh]'.bold
run_cmd(message: "Copying zsh config") do
  FileUtils.copy( File.join(CONFIG_DIR, 'zsh.sh'), File.join(HOME_DIR, '.zshrc') )
end
if File.exists?( File.join(HOME_DIR, '.oh-my-zsh') )
  run_cmd(message: "Copying zsh theme") do
    FileUtils.copy( File.join(CONFIG_DIR, 'skhisma.zsh-theme'), File.join(HOME_DIR, '.oh-my-zsh/themes/skhisma.zsh-theme') )
  end
end
puts


##
## ~/bin
##

puts '[scripts]'.bold

unless File.exists?( File.join(HOME_DIR, 'bin') )
  run_cmd(message: "Creating ~/bin") do
    FileUtils.mkdir( File.join(HOME_DIR, 'bin') )
  end
end

run_cmd(message: "Copying scripts to ~/bin") do
  FileUtils.cp_r(
    File.join(File.dirname(__FILE__), 'bin'),
    File.join(HOME_DIR, 'bin')
  )
  FileUtils.chmod_R("+x", File.join(HOME_DIR, 'bin'))
end
puts


##
## Warnings
##

puts
if !cmd_exists?('pbcopy') && !cmd_exists?('xsel')
  puts "#{'*'.bold.red} You do not appear to have the #{'`pbcopy`'.italic} command, consider installing #{'`xsel`'.italic}."
end
