#!/usr/bin/env ruby
require 'mechanize'

require_relative 'balance_scrapper'
require_relative 'company'

# Get rows from our table – these have ne meaning outside this script
class Nokogiri::XML::NodeSet
    # Return the list of lines whose head 'entry'
    def select entry
        xpath("./tr[ td[contains(@class, 'tdhead')]/text() = '#{entry}' ]")
    end

    # Some head have only one value
    def select_one entry
        select(entry).first
    end
end

# To get info from a row from our table - no use outside this script
class Nokogiri::XML::Element

    # Get the header from the row
    def header
        xpath("./td[contains(@class, 'tdhead')]/text()").text.strip
    end

    # Get the value from the row
    def value
        # Select all text which appears under the right hand of the table, get
        # rid of whitespace only text nodes
        xpath("./td[2]//text()").map(&:text).map(&:strip).reject{ |elt| elt == '' }.join(' ')
    end

end

class Company_scraper

    def self.scrape(company_name)
        source_url = "http://www.verif.com/societe/#{company_name}"

        agent = Mechanize.new
        page = agent.get(source_url)

        table = page.css("table.infoGen")
        directors_html = page.css("table.dirigeants")

        company = Hash.new
        table.xpath('./tr').each do |tr|
            company[tr.header] = tr.value
        end

        directors = Hash.new
        directors_html.xpath('./tr').each do |tr|
            if directors[tr.header].nil?
                directors[tr.header] = []
            end
            directors[tr.header] << tr.value
        end

        company["Dirigeants"] = directors

        company["Bilans"] = Balance_scraper.scrape(company_name)

        # Return company as a hash, not an object!
        company
    end

end
