class Trail < ActiveRecord::Base
    belongs_to :user
    belongs_to :state

   extend Slug::ClassMethods
   include Slug::InstanceMethods
end