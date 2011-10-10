
require 'optparse'
require 'pp'

options = Hash.new
  
opts = OptionParser.new do |opts|
  
  opts.banner = "Usage: #$0 [options] directory"
  opts.separator ''
  opts.separator 'RVM Options:'
  
  opts.on('-r', '--ruby RUBY', String, 'Specify the version of ruby to use with RVM') do |ruby|
    options[:ruby] = ruby
  end
  
  opts.on('-g', '--gemset GEMSET', String, 'Specify the RVM gemset to use') do |gemset|
    option[:gemset] = gemset
  end
  
  opts.on('--rvm RVM_STRING', String, 'Specify the RVM ') do |rvm|
    options[:ruby] = rvm.split('@').first
    options[:gemset] = rvm.split('@').last
  end
  
  opts.separator ''
  opts.separator 'Common Options:'
  opts.on('-h', '--help', 'Show this message') do
    puts opts
    exit
  end
end

opts.parse!(ARGV)
pp options