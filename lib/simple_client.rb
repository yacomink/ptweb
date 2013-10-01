require 'cgi'
require 'rest_client'
require 'json'

class SimpleClient

  class NoToken < StandardError; end

  attr_writer :use_ssl, :token, :tracker_host

  def initialize( api_number )
    @token = api_number
    @project = nil
  end

  # this is your connection for the entire module
  def connection(options={})
    raise NoToken if @token.to_s.empty?

    @connections ||= {}

    cached_connection? && !protocol_changed? ? cached_connection : new_connection
  end

  def clear_connections
    @connections = nil
  end

  def tracker_host
    @tracker_host ||= "www.pivotaltracker.com"
  end

  def api_ssl_url(user=nil, password=nil)
    user_password = (user && password) ? "#{user}:#{password}@" : ''
    "https://#{user_password}#{tracker_host}#{api_path}"
  end

  def notifications(options={})
    JSON.parse(connection["/my/notifications"].get )
  end

  def story(options={})
    JSON.parse(connection["/projects/#{options[:project_id]}/stories/#{options[:story_id]}"].get )
  end


  protected

    def cached_connection?
      !@connections[@token].nil?
    end

    def cached_connection
      @connections[@token]
    end

    def new_connection
      @connections[@token] = RestClient::Resource.new("#{api_ssl_url}", :headers => {'X-TrackerToken' => @token, 'Content-Type' => 'application/xml'})
    end

    def api_path
      '/services/v5'
    end
end