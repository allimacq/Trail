require './config/environment'


#if defined?(ActiveRecord::Base.connection.migration_context) && ActiveRecord::Base.connection.migration_context.needs_migration?
    #raise 'Migrations are pending run `rake db:migrate` to resolve the issue.'
  #end
  if ActiveRecord::Base.connection.migration_context.needs_migration?
    raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
  end

use Rack::MethodOverride
use TrailsController
use UsersController
run ApplicationController 