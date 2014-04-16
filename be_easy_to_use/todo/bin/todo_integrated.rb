#!/usr/bin/env ruby
require 'gli'
begin # XXX: Remove this begin/rescue before distributing your app
require 'todo'
#rescue LoadError
#  STDERR.puts "In development, you need to use `bundle exec bin/todo` to run your app"
#  STDERR.puts "At install-time, RubyGems will make sure lib, etc. are in the load path"
#  STDERR.puts "Feel free to remove this message from bin/todo now"
#  exit 64
#end

include GLI::App

program_desc 'Describe your application here'

version Todo::VERSION

desc 'Describe some flag here'
default_value 'the default'
arg_name 'The name of the argument'
flag [:f,:flagname]

desc 'Describe new here'
arg_name 'Describe arguments to new here'
command :new do |c|
  c.flag :priority
  c.switch :f

  c.action do |global_options,options,args|
    puts "Global:"    
    puts "-f - #{global_options[:f]}"
    puts "Command:"
    puts "-f #{options[:f] ? 'true' : 'false'}"
    puts "--priority - #{options[:priority]}"
    puts "args - #{args.join(',')}"
    # Your command logic here
     
    # If you have any errors, just raise them
    # raise "that command made no sense"

    puts "new command ran"
  end
end

desc 'Describe list here'
arg_name 'Describe arguments to list here'
command :list do |c|
  c.flag :s
  c.action do |global_options,options,args|
    puts "Global:"
    puts "-f - #{global_options[:f]}"
    puts "Command:"
    puts "-s - #{options[:s]}"

    #todos = read_todos(global_options[:filename])
    todos = File.readlines()
    if options[:s] == 'name'
      todos = todos.sort { |a,b| a <=> b}
    end
    todos.each do |todo|
      puts todo
    end
  end
end

desc 'Describe done here'
arg_name 'Describe arguments to done here'
command :done do |c|
  c.action do |global_options,options,args|
    puts "Global:"
    puts "-f - #{global_options[:f]}"
  end
end

pre do |global,command,options,args|
  # Pre logic here
  # Return true to proceed; false to abort and not call the
  # chosen command
  # Use skips_pre before a command to skip this block
  # on that command only
  true
end

post do |global,command,options,args|
  # Post logic here
  # Use skips_post before a command to skip this
  # block on that command only
end

on_error do |exception|
  # Error logic here
  # return false to skip default error handling
  true
end

exit run(ARGV)
