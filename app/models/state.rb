class State < ActiveRecord::Base
    has_many :trails

    extend Slug::ClassMethods
    include Slug::InstanceMethods
end
