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
        @@links = @@links.take(51)
    end

    def self.create_states
        @@links.each do |hash|
            State.create_or_find_by(name: hash[:state])
        end
    end

    def self.scrape_state_trails(state)
        state_link = @@links.find {|h| h[:state] == state}[:link]
        state_page = Nokogiri::HTML(URI.open(state_link))
        table_of_trails = state_page.css('table.search-result-table tbody tr.search-result-card.hide-for-small-only')
    end

    def self.create_state_trails(state)
        self.scrape_state_trails(state).each do |state_trail|
            matching_state = State.find_by(name: state)
            trail = Trail.create(name: "#{state_trail.css('td.info div a h3').text.strip}", state_id: matching_state.id, info: state_trail.css("td.info div")[1].text, distance: "#{state_trail.css('td.length').text.strip.scan(/[^ mi]/).join}", surface: "#{state_trail.css('td.surface').text.strip}")
            matching_state.trails << trail
            matching_state.save
        end
    end

    def self.call
        self.scrape_page
        self.create_states
        State.all.each do |state|
            self.create_state_trails(state.name)
        end
    end


end