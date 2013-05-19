# This class handles the HTTP interactions with the Yummly API calls.
class Yummly::Connection

  attr_accessor :connection

  def self.get(command, params = {})
    params['_app_id'] = Yummly.configuration.app_id
    params['_app_key'] = Yummly.configuration.app_key
    response = self.api_connection.get("/#{self.api_version}/api/#{command}?#{Rack::Utils.build_query(params)}")
    JSON.parse(response.body)
  end

  def self.api_connection
    Faraday.new(:url => "#{self.protocol}://api.yummly.com") do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  end

  def self.protocol
    Yummly.configuration.use_ssl? ? 'https' : 'http'
  end

  def self.api_version
    Yummly::API_VERSION
  end

end