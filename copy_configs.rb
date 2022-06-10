require 'fileutils'
require 'etc'
require_relative 'lib/string_colorize'
require_relative 'lib/command_helpers'

CONFIG_DIR = File.join( File.dirname(__FILE__), 'config' )
DEFAULT_JAVA_VERSION = "oracle64-11.0.1"
DEFAULT_PYTHON_VERSION = "3.7.3"
DEFAULT_RUBY_VERSION = IO.read(
  File.join(File.dirname(__FILE__), ".ruby-version")
).strip
HOME_DIR = Etc.getpwuid.dir
OS = case `uname`
     when /linux/i
       :linux
     when /darwin/i
       :OSX
     else
       :WTF
     end
APPDATA_DIR = case OS
              when :linux
                File.join(HOME_DIR, '.config/')
              when :OSX
                File.join(HOME_DIR, 'Library/Application Support/')
              end

##
## Homebrew
##

if cmd_exists?('brew')
  puts '[Homebrew]'.bold

  run_cmd(message: "Copying Brewfile") do
    FileUtils.copy( File.join(CONFIG_DIR, 'Brewfile'), File.join(HOME_DIR, '.Brewfile') )
  end

  print "   Checking for Homebrew packages to install"
  if !system('brew bundle check --global &> /dev/null')
    puts " !".bold.yellow
    run_cmd(
      'brew bundle --quiet --global --no-lock &> /dev/null',
      message: "Installing brew bundle"
    )

    brews = `brew bundle list --global --quiet 2> /dev/null`.split(/\s/)
    if brews.size > 0
      puts "   The following Homebrew packages have been installed:"
      brews.sort.each do |brew|
        puts "      #{'-'.bold} #{brew}"
      end
    end
  else
    puts " ✔︎".bold.green
  end
  puts
end

##
## Ruby
##

puts '[Ruby]'.bold
if cmd_exists?('rbenv')
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

if cmd_exists?('pyenv')
  puts '[Python]'.bold
  run_cmd(message: "Setting default version with pyenv to #{DEFAULT_PYTHON_VERSION.underline}") do
    set_xenv_global("pyenv", DEFAULT_PYTHON_VERSION)
  end
  puts
end

##
## Java
##

if cmd_exists?('jenv')
  puts '[Java]'.bold
  run_cmd(message: "Setting default version with jenv to #{DEFAULT_JAVA_VERSION.underline}") do
    set_xenv_global("jenv", DEFAULT_JAVA_VERSION)
  end
  puts
end

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

  sublime_config_dir = ['Sublime Text 3', 'Sublime Text', 'sublime-text-3'].map { |dir|
    File.join(APPDATA_DIR, dir)
  }.find { |dir|
    File.exists?(dir)
  }
  raise "Sublime Text preferences directory could not be found." unless sublime_config_dir

  run_cmd(message: "Linking #{'`subl`'.italic} command") do
    FileUtils.ln_s('/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl', '/usr/local/bin/subl', force: true)
  end

  run_cmd(message: "Copying SublimeText configs") do
    FileUtils.copy(
      File.join(CONFIG_DIR, 'sublime/Package Control.sublime-settings'),
      File.join(sublime_config_dir, 'Packages/User/Package Control.sublime-settings')
    )

    FileUtils.copy(
      File.join(CONFIG_DIR, 'sublime/Preferences.sublime-settings'),
      File.join(sublime_config_dir, 'Packages/User/Preferences.sublime-settings')
    )

    FileUtils.copy(
      File.join(CONFIG_DIR, 'sublime/Bash.sublime-settings'),
      File.join(sublime_config_dir, 'Packages/User/Bash.sublime-settings')
    )

    FileUtils.copy(
      File.join(CONFIG_DIR, 'sublime/JavaProperties.sublime-settings'),
      File.join(sublime_config_dir, 'Packages/User/JavaProperties.sublime-settings')
    )
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
run_cmd(message: "Updating oh-my-zsh") do
  if cmd_exists?('omz')
    system('omz update')
  elsif cmd_exists?('upgrade_oh_my_zsh')
    system('upgrade_oh_my_zsh')
  end
end
puts


##
## ~/bin
##

puts '[scripts]'.bold

home_bin_dir = File.join(HOME_DIR, 'bin')
unless File.exists?(home_bin_dir)
  run_cmd(message: "Creating ~/bin") do
    FileUtils.mkdir(home_bin_dir)
  end
end

run_cmd(message: "Copying scripts to ~/bin") do
  FileUtils.cp_r(
    Dir.glob( File.join(File.dirname(__FILE__), 'bin/*') ),
    home_bin_dir
  )
end

missing_img_scripts = %w[divider imgls imgcat]  - Dir.new(home_bin_dir).entries
if File.exists?('/Applications/iTerm.app/') && missing_img_scripts.size > 0
  missing_img_scripts.each do |script|
    run_cmd(
      "curl \"https://iterm2.com/utilities/#{script}\" --silent > #{File.join(home_bin_dir, script)} 2> /dev/null",
      message: "Downloading iTerm #{script.italic} script"
    )
  end
end

run_cmd(message: "Setting +x on scripts in ~/bin") do
  FileUtils.chmod_R("+x", home_bin_dir)
end

puts
