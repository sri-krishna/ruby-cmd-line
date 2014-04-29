#!/usr/bin/env ruby

#Bring OptionParser into the namespace
require 'optparse'

options = {}
servers = { 'dev' => 'localhost',
              'qa' => 'qa001.example.com',
                'prod' => 'www.example.com'}
option_parser = OptionParser.new do |opts|
  executable_name = File.basename($PROGRAM_NAME)
  opts.banner = "Backup one or more mysql databases
  Usage: #{executable_name} [options] database_name"
  #create a switch
  opts.on("--i ITERATION","--iteration", 'Indicate that this backup is an "iteration"') do |iter|
    options[:iteration] = iter
  end

  #create a flag
  opts.on("-u USER", 'Database user name in certain format') do |user|
    options[:user] = user
  end

  opts.on("-p PASSWORD", 'Database password') do |password|
    options[:password] = password
  end

#  opts.on('-s SERVER --server', servers) do |address|
#    options[:address] = address
#  end

#  opts.on('--verbosity LEVEL -v', Integer) do |verbosity|
#    options[:verbosity] = verbosity
#  end
end

option_parser.parse!
puts options.inspect

if ARGV.empty?
  puts "error: you must supply a database_name"
  puts
  puts option_parser.help
  exit(1)
else
  database_name = ARGV[0]
end

if options[:iteration].nil?
  backup_file = database_name + '_' + Time.now.strftime('%Y%m%d')
else
  backup_file = database_name + '_' + options[:iteration]
end

mysqldump = "mysqldump -u#{options[:user]} -p#{options[:password]} #{database_name}"
puts mysqldump

`#{mysqldump} > #{backup_file}.sql`
`gzip #{backup_file}.sql`
