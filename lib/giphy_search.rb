module GifSearch
  class << self
    API_URL = ENV['API_GIPHY_URL']
    API_KEY = ENV['API_GIPHY_KEY']

    def request(query)
      uri = URI(API_URL)
      params = { q: query , api_key: API_KEY }
      uri.query = URI.encode_www_form(params)

      response = Net::HTTP.get_response(uri)
      return unless response.is_a? Net::HTTPSuccess

      response_body = JSON.parse(response.body)
      return if response_body.empty?

      return { gif_url: response_body['data'].first['images']['original']['url'] }
    end
  end
end
