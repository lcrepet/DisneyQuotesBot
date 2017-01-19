module FacebookProfile
  class << self
    API_URL = ENV['API_FB_URL']
    ACCESS_TOKEN = ENV['FB_PAGE_TOKEN']

    def request(id, fields = nil)
      uri = URI(API_URL + id)
      params = { fields: (fields || all_fields).join(','), access_token: ACCESS_TOKEN }
      uri.query = URI.encode_www_form(params)

      response = Net::HTTP.get_response(uri)
      return unless response.is_a? Net::HTTPSuccess

      return JSON.parse(response.body)
    end

    private
    def all_fields
      ['first_name', 'last_name', 'profile_pic', 'locale', 'timezone', 'gender']
    end
  end
end
