# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)

# Action Cable requires that all classes are loaded in advance
Rails.application.eager_load!

run Rails.application
if Rails.env.production?
  DelayedJobWeb.use Rack::Auth::Basic do |username, password|
    username == 'diningcity' && password == 'dinghsiju88'
  end
end
