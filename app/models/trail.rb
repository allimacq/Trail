class Trail < ActiveRecord::Base
    belongs_to :user
    belongs_to :state

   extend Slug::ClassMethods
   inlclude Slug::InstanceMethods
end