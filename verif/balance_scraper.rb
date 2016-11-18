require 'mechanize'

class Balance_scraper

    def self.scrape(company_name)
        source_url = "http://www.verif.com/bilans-gratuits/#{company_name}"
        agent = Mechanize.new
        page = agent.get(source_url)

        table = page.css("div.bilans > div.tab-content > table.table1")
        years = table.xpath('.//thead/tr/th[position() > 1]//a/text()').collect{ |content| content.text.to_i }

        balance = Hash.new
        table.xpath('./tbody/tr').each do |row|
            head = row.css('td.tdhead').text.strip

            # Get values from the row, using nil when value is empty
            values = row.css('td.chiffres').collect do |content|
                string = content.text.gsub(/\p{Space}*/ , '')
                if string.empty? then nil else string.to_i end
            end

            balance[head] = years.zip(values).sort_by{ |year, value| year }.to_h
        end

        balance
    end

end
