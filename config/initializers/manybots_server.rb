module Manybots

  class Server
  
    attr_accessor :server_name, :schema_url, :host
  
    def initialize
      raw_config = File.read(RAILS_ROOT + "/config/manybots_config.yml")
      app_config = YAML.load(raw_config)[RAILS_ENV].symbolize_keys
      @server_name = app_config[:server_name]
      @schema_url = app_config[:schema_url]
      @host = app_config[:host]
    end
  
  end

end

ManybotsServer = Manybots::Server.new