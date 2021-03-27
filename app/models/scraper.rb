class Scraper

    @@links =[ ]

    def self.scrape_page
        site = 'http://www.traillink.com/activity/wheelchair-accessible-trails/'
        page = Nokogiri::HTML(URI.open(site))
        scrape = page.css("div.row.small-up-2.medium-up-3.large-up-4.block-grid div.column")

        scrape.each do |state|
            @@links << {
                state: state.css("a").text.strip,
                link: "http://traillink.com" + "#{state.css("a").attribute("href").value}"
              }
        end
        @@links.take!(51)
    end

    def self.create_states
        @@links.each do |state|
            State.create(name: "#{state.css('a').text.strip}")
        end
    end

    def self.scrape_state_trails
       @@links.collect do |state, link|
            state_page = Nokogiri::HTML(URI.open(link))
            @@links << {
            "{state}" => state_page.css('table.search-result-table tbody tr.search-result-card.hide-for-small-only')
            }
        end
    end

    def self.create_trails
        @@links.each do |state, state_page|
        #self.scrape_trails.each do |state, css|
            matching_state = State.find_by(name: state)
            trail = Trail.create(name: "#{state_page.css('td.info div a h3').text.strip}", state_id: state.id, info: results.css("td.info div")[1].text, distance: "#{results.css('td.length').text.strip.scan(/[^ mi]/).join}", surface: "#{results.css('td.surface').text.strip}")
            matching_state.trails << trail
        end
    end

    def self.call
        self.scrape_page
        self.create_states
        self.scrape_state_trails
        self.create_trails
    end


end