require 'uri'
require 'base64'
require 'json'
require 'pp'
require 'yaml'
require 'uri'
require 'faraday'

module Inator
  
  class Connector
    attr_reader :base_url, :user, :password, :connection, :debug
    def initialize(config={})
      @base_url   = config['base_url']
      @user       = config['user']
      @password   = config['password']
      credentials = Base64.encode64("%s:%s" % [@user, @password])
      @basic_auth = "Basic %s" % credentials
      @debug = config['debug'] || false
      
      @connection = Faraday.new(:url => @base_url) do |faraday|
        Faraday.request :url_encoded
        faraday.adapter Faraday.default_adapter
      end
    end
    def make_request(method, endpoint, options={}, data=nil, extra_headers=nil)
      response = @connection.send(method) do |req|
        if !options.empty?
          option_items = options.collect {|key, value| "#{key}=#{value}"}
          endpoint << "?" << option_items.join("&")
          
        end
                      
        puts "issuing a #{method.to_s.upcase} request for endpoint: #{endpoint}"
                      
        req.url(endpoint)
        req.headers['Content-Type'] = 'application/json'
        req.headers['Authorization'] = @basic_auth
        if data
          req.body = data.to_json
        end
      end
      begin
        if self.debug
          puts '_'*20
          puts response.inspect
          puts '_'*20
        end
      rescue => e
        puts e.message
      end
        return response.status, response.headers, response.body
    end
  end
  
end
