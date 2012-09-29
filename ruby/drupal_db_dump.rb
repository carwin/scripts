#!/usr/bin/ruby

# Check out which sites are in vhosts, we'll need all these databases
# Stick to drupal sites.
vhosts = '/var/www/vhosts/'
directories =  Dir["#{vhosts}/*/"].map { |dir|
  File.basename(dir)
}

# info_arr will contain all the settings from the configs.
info_arr = []

# Iterate over each directory
directories.each do |site|
  Dir.foreach("#{vhosts}#{site}/") do |entry|

    # If there's an httpdocs directory, proceed.
    if entry.match(/httpdocs$/)
      Dir.chdir("#{vhosts}#{site}/#{entry}")

      # If there's a `sites` directory, we're probably
      # looking at a Drupal site, so proceed into
      # `sites/default/files`.
      if File.directory?("#{Dir.pwd}/sites/")
        Dir.chdir("#{Dir.pwd}/sites/default/")

        # Output each line of `settings.php` into content
        content = IO.readlines("settings.php")

        # Check every line of content for the line that
        # starts out `$databases = array`
        # Once we find it, grab the next 9 lines which
        # contain this site's database settings and
        # store them in a site[] array.
        content.each_with_index do |line, index|
          if line.match(/^\$databases = array \($/)
            config = content[index,9]
            site = []
            config.each do |line|
              site << line
            end

            # Add every site array to the info_arr array
            info_arr << site
          end
        end
      end
    end
  end
end

# Iterate over info_arr, drop the lines we don't need
# and extrapolate the database connection information.
info_arr.each do |lines|
  
  # delete_at always drops the key down
  # so we'll always delete_at(0) - set up
  # an array of the keys we want gone 
  # and iterate over that.
  del = [0,1,2,3,4]
  del.each do |line|
    lines.delete_at(0)
  end

  # Now we have this format for every drupal
  # site config:
  #   'database' => 'drupal_database',
  #   'username' => 'drupal_username',
  #   'password' => 'some password',
  #   'host'     => 'localhost',

  # Break out the values into variables
  # @todo: Write a better regex
  database = lines[0].split('=>').pop.gsub(/\'|\'?$/, '').gsub(/\,/,'').strip
  username = lines[1].split('=>').pop.gsub(/\'|\'?$/, '').gsub(/\,/,'').strip
  password = lines[2].split('=>').pop.gsub(/\'|\'?$/, '').gsub(/\,/,'').strip

  # Dump these bad boys
  time = Time.now.getutc.to_i # get timestamp in utc
  system "mysqldump -u #{username} -p#{password} #{database} > /var/www/vhosts/sql_bak/#{database}.#{time}.sql" 
  puts 'done!'

end
