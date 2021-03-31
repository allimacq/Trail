class Trail < ActiveRecord::Base
    belongs_to :user
    belongs_to :state

    def slug
        self.name.strip.split.join("-")
    end

    def self.find_by_slug(slug)
        to_find = slug.split("-").collect do |name|
            name
        end.join(" ")
        self.find_by(name: to_find)
    end
end