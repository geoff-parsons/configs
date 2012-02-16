#!/usr/bin/env ruby

require 'optparse'
require 'ostruct'
require 'fileutils'


##
## Helper Methods
##

def show_multiple_rvm_opts_message
  STDERR.puts "You have supplied values for --rvm and --ruby or --gemset; this is invalid!"
  STDERR.puts "Please use only --rvm OR --ruby / --gemset."
  exit!(1)
end

def build_rvm_string(options)
  rvm_string = options.ruby.dup
  rvm_string << "@#{options.gemset}" if options.gemset
  return rvm_string
end

def parse_rvm_string(string)
  string.match(/([\w\.\-_]+)@([\w\-_]+)$/).to_s.split('@')
end


##
## Command-Line Options
##

# Default options
options = OpenStruct.new
options.session_name = 'rails'
options.editor = `echo $EDITOR`.strip rescue 'emacs'
options.editor = 'emacs' if options.editor == ''
options.directory = '.'
options.run_server = true
options.guard = false
options.autotest = false
options.unicorn = false

opts = OptionParser.new do |opts|
  
  opts.banner = "Usage: #$0 [options] [directory]"
  
  opts.separator ''
  opts.separator 'Options'
  
  opts.on('-e', '--editor EDITOR', String, "Specify the editor you wish to run (default $EDITOR: #{options.editor})") do |editor|
    options.editor = editor
  end
  
  
  opts.separator ''
  opts.separator 'Server Options'
  opts.on("-p", "--port [PORT]", OptionParser::DecimalInteger, "Specify port on which to run server") do |port|
    options.port = port
  end
  
  opts.on("--no-server", "Do not run a rails server") do
    options.run_server = false
  end
  
  opts.on('--unicorn', "Use unicorn instead of webrick") do |unicorn|
    options.unicorn = unicorn
  end
  
  
  opts.separator ''
  opts.separator 'Testing Options'
  
  opts.on('--guard', "Use guard to run specs") do |guard|
    options.guard = guard
  end
  
  
  opts.separator ''
  opts.separator 'tmux Options'
  
  opts.on('-n', '--name NAME', String, "Specify a name for the tmux session (default #{options.session_name})") do |name|
    options.session_name = name
  end
  
  
  opts.separator ''
  opts.separator 'RVM Options:'
  
  opts.on('-r', '--ruby RUBY', String, 'Specify the version of ruby to use with RVM (default to .rvmrc in directory)') do |ruby|
    show_multiple_rvm_opts_message if options.ruby
    options.ruby = ruby
  end
  
  opts.on('-g', '--gemset GEMSET', String, 'Specify the RVM gemset to use (default to .rvmrc in directory)') do |gemset|
    show_multiple_rvm_opts_message if options.gemset
    options.gemset = gemset
  end
  
  opts.on('--rvm RVM_STRING', String, 'Specify the RVM (default to .rvmrc in directory)') do |rvm|
    show_multiple_rvm_opts_message if options.ruby || options.gemset
    options.ruby, options.gemset = parse_rvm_string(rvm)
  end
  
  opts.separator ''
  opts.separator 'Common Options:'
  opts.on_tail('-h', '--help', 'Show this message') do
    puts opts
    exit
  end
end

opts.parse!(ARGV)

options.directory = ARGV[0] unless ARGV.empty?

if !File.exist?(options.directory) || !File.directory?(options.directory)
  STDERR.puts "#{options.directory} does not exist or is not a directory!"
  exit!(1)
end

unless options.ruby
  begin
    rvm_string = IO.read(File.join(options.directory,".rvmrc"))
    options.ruby, options.gemset = parse_rvm_string(rvm_string)
  rescue
    STDERR.puts "Could not determine ruby version and gemset!"
    STDERR.puts "Please specify with --rvm or --ruby / --gemset or include a .rvmrc in #{options.directory}"
    exit!(1)
  end
end


##
## Run Some tmux Commands
##

unless system("tmux ls | grep -q #{options.session_name}")
  FileUtils.cd(options.directory) do
    system "tmux new-session -d -s #{options.session_name}"

    # Window 1: Editor
    system "tmux rename-window -t #{options.session_name}:1 \"#{options.editor}\""
    system "tmux send-keys -t #{options.session_name}:1 \"#{options.editor} .\" C-m"

    # Window 2: Specs
    system "tmux new-window -dt #{options.session_name}:2 -n \"spec\""
    system "tmux send-keys -t #{options.session_name}:2 \"rvm use #{build_rvm_string(options)}\" C-m"
    if options.guard
      system "tmux send-keys -t #{options.session_name}:2 \"guard\" C-m"
    end

    # Window 3: Rails Console
    system "tmux new-window -dt #{options.session_name}:3 -n \"console\""
    system "tmux send-keys -t #{options.session_name}:3 \"rvm use #{build_rvm_string(options)} && clear && rails console\" C-m"

    # Window 4: Server
    if options.run_server
      system "tmux new-window -dt #{options.session_name}:4 -n \"server\""
      system "tmux send-keys -t #{options.session_name}:4 \"rvm use #{build_rvm_string(options)} && clear\" C-m"
      port_argument = options.port.nil? ? '' : " -p #{options.port}"
      if options.unicorn
        system "tmux send-keys -t #{options.session_name}:4 \"unicorn_rails#{port_argument}\" C-m"
      else
        system "tmux send-keys -t #{options.session_name}:4 \"rails server#{port_argument}\" C-m"  
      end
    end
  end
end

system "tmux -2 attach-session -t #{options.session_name}"







