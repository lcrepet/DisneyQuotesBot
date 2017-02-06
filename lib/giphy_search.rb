module GifSearch
  class << self
    API_URL = ENV['API_GIPHY_URL']
    API_KEY = ENV['API_GIPHY_KEY']
    NB_MAX_GIF = 15

    def get_random_gif_from(query)
      gif_list = request(query)['data']
      return unless gif_list

      gif_index = rand([gif_list.count, NB_MAX_GIF].min)
      gif_list[gif_index].dig('images', 'original', 'url')
    end

    def request(query)
      uri = URI(API_URL)
      params = { q: query , api_key: API_KEY }
      uri.query = URI.encode_www_form(params)

      response = Net::HTTP.get_response(uri)
      return unless response.is_a? Net::HTTPSuccess

      return JSON.parse(response.body) rescue {}
    end
  end
end
