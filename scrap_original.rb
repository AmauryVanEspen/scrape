require 'mechanize'
require_relative 'cf_decode'


# ruby scrap.rb "http://www.homeowners-associations-florida.com/real_estate_agents_list.php?mastertable=real-estate-agents-city&masterkey1=Hallandale" output_Miami

# Check the argument
initial_url = ARGV[0]
filename    = ARGV[1]

if initial_url.nil?
  puts "No URL found. You must specify an URL containing http://www.homeowners-associations-florida.com/"
  exit
end

unless initial_url.include? "www.homeowners-associations-florida.com/real_estate_agents_list.php"
  puts "The URL must match with http://www.homeowners-associations-florida.com/"
  puts "Example : http://www.homeowners-associations-florida.com/real_estate_agents_list.php?masterkey1=Fort%20Lauderdale&mastertable=real-estate-agents-city"
  exit
end

if filename.nil?
  puts "Please specify a filename for the output file."
  exit
end



# Start

agent = Mechanize.new
agent2      = Mechanize.new
page  = agent.get(initial_url + "&goto=1")


# Get the last page
last_page     = page.at('a:contains("Last")').to_s.scan(/goto=([0-9]*)&/).first.first.to_i
current_page  = 0


# Stats
total_agents = 0


while current_page < last_page

  current_page += 1

  url   = initial_url + "&goto=#{current_page}"
  page  = agent.get(url)
  links = page.search("table.rnr-c.rnr-cont.rnr-c-grid.rnr-b-grid.rnr-gridtable.hoverable").css("a")

  links.each do |link|

    agent_url   = "http://www.homeowners-associations-florida.com/#{link["href"]}"
    agent_page  = agent2.get(agent_url)

    rows = agent_page.search("table.rnr-c.rnr-vrecord").css("tr")

    str = String.new

    rows.each do |row|

      if row.content.include?("[email")
        content = cf_decode(row.to_s.split.join(' ').scan(/data-cfemail="([0-9a-zA-Z]*)"/).first.first)
      else
        content = row.content.split.join(' ').gsub("\302\240", ' ').strip
      end

      str << content + ";"

    end

    File.open(filename + '.txt', 'a') { |file|
      file << str + "\n"
    }

    total_agents += 1

  end

  puts "Finished to scrap page #{current_page}/#{last_page} - Total agents scrapped : #{total_agents}"

end
