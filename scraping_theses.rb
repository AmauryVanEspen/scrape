require 'mechanize'

# ruby scraping_theses.rb "http://theses.fr/" output_theses
# initial_url & filename to run the script
initial_url = ARGV[0]
filename    = ARGV[1]

#Block for checking argument's validity
  #Is there an initial_url
  if initial_url.nil?
    puts "No URL found. You must specify an URL containing http://theses.fr/"
    exit
  end

  #Does the url include the correct path
  unless initial_url.include? "http://theses.fr/"
    puts "The URL must match with http://theses.fr/"
    puts "Example : http://theses.fr/"
    exit
  end

  #Specify an output filename
  if filename.nil?
    puts "Please specify a filename for the output file."
    exit
  end
