#!/usr/bin/ruby
require 'mysql'

# Check out which sites are in vhosts, we'll need all these databases
# Stick to drupal sites.
vhosts = '/var/www/vhosts/'
directories =  Dir["#{vhosts}/*/"].map { |dir|
  File.basename(dir)
}

info_arr = []
directories.each do |site|
  Dir.foreach("#{vhosts}#{site}/") do |entry|
    if entry.match(/httpdocs$/)
      Dir.chdir("#{vhosts}#{site}/#{entry}")
      if File.directory?("#{Dir.pwd}/sites/")
        Dir.chdir("#{Dir.pwd}/sites/default/")
        content = IO.readlines("settings.php")

        content.each_with_index do |line, index|
          if line.match(/^\$databases = array \($/)
            #info_arr << content[index,9]
            #puts content[index,9].join('')
            config = content[index,9]
            config.each do |line|
              puts line
            end
          end
        end
      end
    end
  end
end
info_arr.each do |lines|
  lines.split('\n')
end
#puts info_arr
#puts directories

#mysqlUser = 'root'
#conn = Mysql.real_connect('localhost',mysqlUser,'','')
#showDBs = 'show databases'

#puts conn
