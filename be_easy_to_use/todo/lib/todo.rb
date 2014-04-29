require 'todo/version.rb'

# Add requires for other files you add to your project here, so
# you just need to require this one file in your bin file
def read_todos(filename)
  File.readlines(filename)
end

def write_todo(file,name,created=Time.now, completed='')
  file.puts("#{name},#{created},#{completed}")
end

def todo_file(filename)
  if !filename.nil?
    filename
  else
    ENV['HOME'] + "/todo.txt"
  end
end
