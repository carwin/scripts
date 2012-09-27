#!/usr/bin/ruby

# Find and Replace text
# Usage:
#   run as a normal script ./strreplace
#   accepts input on the command line
#     arg0 = string to search for
#     arg1 = string to replace arg0 with
#     arg2 = string to look in

$find = ARGV[0]
$replace = ARGV[1]
$search = ARGV[2]

class FindReplace

  @@content = [] 
  @@found = []

  def Find(text)
    #
    # Add each word to the content array
    $search.split(/\s/).each do |item|
      @@content << [item]
      if item == ARGV[0]
        @@found << [item]
      end
    end
    instances = @@found.count 
    
    # String interpolation only works with double quotes.
    puts "#{instances} instances of \"" + $find + "\" found."

  end

  def Replace(text)
    originalstr = @@content.join(" ")
    $modified = originalstr.gsub($find, $replace) 
  end
  
end

finder = FindReplace.new
finder.Find($find)
finder.Replace($replace)
puts "ORIGINAL INPUT: #{$search}"
puts "REPLACED WITH: #{$modified}"
