require 'fileutils'
require 'etc'
require_relative 'lib/string_colorize'
require_relative 'lib/command_helpers'

CONFIG_DIR = File.join( File.dirname(__FILE__), 'config' )
DEFAULT_NODE_VERSION = "v21.2.0"
DEFAULT_PYTHON_VERSION = "3.10.4"
DEFAULT_RUBY_VERSION = IO.read(
  File.join(File.dirname(__FILE__), ".ruby-version")
).strip
HOME_DIR = Etc.getpwuid.dir
HOME_BIN_DIR = File.join(HOME_DIR, 'bin')
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

if cmd_exists?('brew') || File.exist?('/opt/homebrew')
  puts '[Homebrew]'.bold

  run_cmd(
    "brew update --system &> /dev/null",
    message: "Updating homebrew"
  )

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
## ~/bin
##

puts '[scripts]'.bold


unless File.exist?(HOME_BIN_DIR)
  run_cmd(message: "Creating ~/bin") do
    FileUtils.mkdir(HOME_BIN_DIR)
  end
end

run_cmd(message: "Copying scripts to ~/bin") do
  FileUtils.cp_r(
    Dir.glob( File.join(File.dirname(__FILE__), 'bin/*') ),
    HOME_BIN_DIR
  )
end

missing_img_scripts = %w[imgls imgcat]  - Dir.new(HOME_BIN_DIR).entries
if File.exist?('/Applications/iTerm.app/') && missing_img_scripts.size > 0
  missing_img_scripts.each do |script|
    run_cmd(
      "curl \"https://iterm2.com/utilities/#{script}\" --silent > #{File.join(HOME_BIN_DIR, script)} 2> /dev/null",
      message: "Downloading iTerm #{script.italic} script"
    )
  end
end

run_cmd(message: "Setting +x on scripts in ~/bin") do
  FileUtils.chmod_R("+x", HOME_BIN_DIR)
end

puts


##
## Ruby
##

puts '[Ruby]'.bold
if cmd_exists?('rbenv')

  if `rbenv versions 2> /dev/null | grep #{DEFAULT_RUBY_VERSION}`.strip == ''
    run_cmd(
      "rbenv install --skip-existing #{DEFAULT_RUBY_VERSION} &> /dev/null",
      message: "Installing ruby version #{DEFAULT_RUBY_VERSION.underline}"
    )
  end

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

  if `pyenv versions | grep #{DEFAULT_PYTHON_VERSION}`.strip == ''
    run_cmd(
      "pyenv install #{DEFAULT_PYTHON_VERSION} &> /dev/null",
      message: "Installing python version #{DEFAULT_PYTHON_VERSION.underline}"
    )
  end

  run_cmd(message: "Setting default version with pyenv to #{DEFAULT_PYTHON_VERSION.underline}") do
    set_xenv_global("pyenv", DEFAULT_PYTHON_VERSION)
  end

  puts
end

##
## Java
##

# if cmd_exists?('jenv')
#   puts '[Java]'.bold
#   run_cmd(message: "Setting default version with jenv to #{DEFAULT_JAVA_VERSION.underline}") do
#     set_xenv_global("jenv", DEFAULT_JAVA_VERSION)
#   end
#   puts
# end

##
## Node / JS
##

def nvm(cmd, message: nil)
  run_cmd(
    %{
      . #{File.join(HOME_DIR, '.nvm', 'nvm.sh')}
      #{cmd}
    },
    message: message
  )
end

if File.exist?( File.join(HOME_DIR, '.nvm', 'nvm.sh') )
  puts '[Node]'.bold

  if `. #{File.join(HOME_DIR, '.nvm', 'nvm.sh')}; nvm list --no-colors | grep #{DEFAULT_NODE_VERSION}`.strip == ''
    nvm(
      "nvm install --no-progress #{DEFAULT_NODE_VERSION} &> /dev/null",
      message: "Installing node version #{DEFAULT_NODE_VERSION.underline}"
    )
  end

  nvm(
    "nvm alias default #{DEFAULT_NODE_VERSION} &> /dev/null",
    message: "Setting default version with nvm to #{DEFAULT_NODE_VERSION.underline}"
  )

  puts
end


##
## SublimeText
##

sublime_config_dir = ['Sublime Text 3', 'Sublime Text', 'sublime-text-3'].map { |dir|
  File.join(APPDATA_DIR, dir)
}.find { |dir|
  File.exist?(dir)
}
if File.exist?('/Applications/Sublime Text.app') && sublime_config_dir
  puts '[SublimeText]'.bold

  run_cmd(message: "Linking #{'`subl`'.italic} command") do
    FileUtils.ln_s(
      '/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl',
      File.join(HOME_BIN_DIR, 'subl'),
      force: true
    )
  end unless cmd_exists?('subl')

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
## VS Code
##

if File.exist?('/Applications/Visual Studio Code.app')
  puts "[VSCode]".bold

  run_cmd(message: "Linking #{'`code`'.italic} command") do
    FileUtils.ln_s(
      '/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code',
      File.join(HOME_BIN_DIR, 'code'),
      force: true
    )
  end unless cmd_exists?('code')

  puts "   Installing extensions..."
  {
    'eamodio.gitlens' => 'Git Lens',
    'esbenp.prettier-vscode' => 'Prettier'
  }.each do |ext, name|
    run_cmd(
      "code --install-extension #{ext} 2> /dev/null &> /dev/null",
      message: name,
      indent: 2
    )
  end

  puts
end


##
## iTerm
##
if File.exist?('/Applications/iTerm.app/')
  puts '[iTerm]'.bold
  unless File.exist?(File.join(HOME_DIR, '.iterm2'))
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
if File.exist?( File.join(HOME_DIR, '.oh-my-zsh') )
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


