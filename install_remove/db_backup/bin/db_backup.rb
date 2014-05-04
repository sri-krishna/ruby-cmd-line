#!/usr/bin/env ruby

#Bring OptionParser into the namespace
require 'optparse'
require 'English'
require 'open3'
require 'yaml'

options = {
  :gzip => true,
  :force => false,
  :'end-of-iteration' => false,
  :user => nil,
  :password => nil
}

CONFIG_FILE = File.join(ENV['HOME'], '.db_backup.rc.yaml')
if File.exists? CONFIG_FILE
  options_config = YAML.load_file(CONFIG_FILE)
  options.merge!(options_config)
else
  File.open(CONFIG_FILE,'w') { |file| YAML::dump(options, file)}
  STDERR.puts "Initialized configuration file in #{CONFIG_FILE}"
end

option_parser = OptionParser.new do |opts|
  executable_name = File.basename($PROGRAM_NAME)
  opts.banner = "Backup one or more mysql databases
  Usage: #{executable_name} [options] database_name"
  #create a switch
  opts.on("--i ITERATION","--end-of-iteration", 'Indicate that this backup is an "iteration"') do |iter|
    options[:iteration] = iter
  end

  #create a flag
  opts.on("-u USER", "--username", 'Database user name in certain format') do |user|
    options[:user] = user
  end

  opts.on("-p PASSWORD", "--password", 'Database password') do |password|
    options[:password] = password
  end

  opts.on("--no-gzip", "Do not compress the backup file") do
    opts[:gzip] = false
  end

  opts.on("--[no-]force", "Overwrite existing files") do |force|
    options[:force] = force
  end

end

option_parser.parse!
puts options.inspect

if ARGV.empty?
  puts "error: you must supply a database_name"
  puts
  puts option_parser.help
  exit(2)
else
  database_name = ARGV[0]
end

if options[:iteration].nil?
  backup_file = database_name + '_' + Time.now.strftime('%Y%m%d') + ".sql"
else
  backup_file = database_name + '_' + options[:iteration] + ".sql"
end

mysqldump = "mysqldump -u#{options[:user]} -p#{options[:password]} #{database_name}"
puts mysqldump

command = "#{mysqldump} > #{backup_file}"

if File.exists? backup_file
  if options[:force]
    STDERR.puts "Overwriting #{backup_file}"
  else
    STDERR.puts "error: #{backup_file} exists, use --force to overwrite"
    exit 1
  end
end
puts "Running '#{command}'"
stdout_str, stderr_str, status = Open3.capture3(command)

unless status.exitstatus == 0
  STDERR.puts "There was a problem running #{command}"
  STDERR.puts stderr_str.gsub(/^mysqldump: /,'')
  exit -1
end

command = "gzip #{backup_file}"
system(command)

unless $CHILD_STATUS.exitstatus == 0
  puts "There was a problem running #{command}"
  exit 3
end
