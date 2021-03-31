module Slug
    module InstanceMethods

        def slug
            self.name.strip.split.join("-")
        end

    end

    module ClassMethods
        
        def find_by_slug(slug)
            to_find = slug.split("-").collect do |name|
                name
            end.join(" ")
            self.find_by(name: to_find)
        end
    end

end