#!/usr/bin/env ruby

#Bring OptionParser into the namespace
require 'optparse'

options = {}
servers = { 'dev' => 'localhost',
              'qa' => 'qa001.example.com',
                'prod' => 'www.example.com'}
option_parser = OptionParser.new do |opts|

  #create a switch
  opts.on("--i","--iteration") do
    options[:iteration] = true
  end

  #create a flag
  opts.on("-u USER") do |user|
    options[:user] = user
  end

  opts.on("-p PASSWORD") do |password|
    options[:password] = password
  end

  opts.on('-s SERVER --server', servers) do |address|
    options[:address] = address
  end

  opts.on('--verbosity LEVEL -v', Integer) do |verbosity|
    options[:verbosity] = verbosity
  end
end

option_parser.parse!
puts options.inspect

database = ARGV.shift

if options[:iteration].nil?
  backup_file = database + '_' + Time.now.strftime('%Y%m%d')
else
  backup_file = database + '_' + options[:iteration]
end

mysqldump = "mysqldump -u#{options[:user]} -p#{options[:password]} #{database}"
puts mysqldump

`#{mysqldump} > #{backup_file}.sql`
`gzip #{backup_file}.sql`
