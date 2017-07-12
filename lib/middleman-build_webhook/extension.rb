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
    require 'uri'

    # set up your extension
    # puts options.my_option
  end

  def after_build
    puts "Posting webhook"
    url = URI.parse(options.url)
    req = Net::HTTP::Post.new(url.path)
    req.basic_auth options.username, options.password
    req.use_ssl = true
    resp = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }
    if resp.code == 200
      puts "Success! #{resp.code} - #{resp.message}"
    else
      puts "Failure! :( #{resp.code} - #{resp.message}"
    end
  end
end
