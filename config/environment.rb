# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
ServerRails3::Application.initialize!

# oauth-plugin fixes
require 'oauth_server'
require 'oauth_controllers_application_controller_methods'

# oauth normal stuff
require 'oauth'
require 'oauth-plugin'

# for gravatar
require 'digest/md5'

# activity filters
require 'activity_filter'
