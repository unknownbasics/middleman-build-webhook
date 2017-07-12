# Require core library
require 'middleman-core'

# Extension namespace
class MiddlemanBuildWebhook < ::Middleman::Extension
  # All the options for this extension
  option :url, nil, 'URL to post the webhook to'
  option :username, nil, 'HTTP basic auth username'
  option :password, nil, 'HTTP basic auth password'

  def initialize(app, options_hash={}, &block)
    # Call super to build options from the options_hash
    super

    # Require libraries only when activated
    # require 'necessary/library'
    require 'net/http'
    require 'net/https'
    require 'uri'

    # set up your extension
    # puts options.my_option
  end

  def after_build
    puts "Posting webhook"
    url = URI.parse(options.url)

    if url.scheme == 'http'
      # http
      req = Net::HTTP::Post.new(url.path)
      req.basic_auth options.username, options.password
      resp = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }
    else
      # https
      Net::HTTP.start(url.host, url.port,
      :use_ssl => url.scheme == 'https',
      :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|

      request = Net::HTTP::Post.new url.request_uri
      request.basic_auth options.username, options.password

      resp = http.request request # Net::HTTPResponse object
    end
    end

    puts resp.code

    if resp.code === '200'
      puts "Success! #{resp.code} - #{resp.message}"
    else
      puts "Failure! :( #{resp.code} - #{resp.message}"
    end
  end
end
