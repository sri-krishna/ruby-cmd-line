#!/usr/bin/env ruby

database = ARGV.shift
username = ARGV.shift
password = ARGV.shift

end_of_iter = ARGV.shift

if end_of_iter.nil?
  backup_file = database + '_' + Time.now.strftime('%Y%m%d')
else
  backup_file = database + '_' + end_of_iter
end

mysqldump = "mysqldump -u#{username} -p#{password} #{database}"

`#{mysqldump} > #{backup_file}.sql`
`gzip #{backup_file}.sql`