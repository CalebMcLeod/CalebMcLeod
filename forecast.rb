require 'uri'
require 'net/http'
require 'openssl'
require 'json'

class Forecast
  attr_reader :whole_forecast, :temperature

  def initialize
    @whole_forecast = ""
    @temperature = []
  end

  def get_location
    url = URI("https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/#{ARGV[0]}%20#{ARGV[1]}?unitGroup=us&elements=tempmax%2Ctempmin&include=days%2Cfcst&key=KNGPR64VNTB43UYTGC8BL8NVD&contentType=json")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE 
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    whole_forecast<<response.read_body
  end

  def fetch_min_and_max_temperature
    forecast_as_hash = JSON.parse whole_forecast.gsub('=>', ':')
    temperature<<forecast_as_hash.fetch("days")
  end

  def print_temperature
    fifteen_day_forecast = temperature.shift
    fifteen_day_forecast.each do |day|
    puts "High: #{day["tempmax"]} °F; Low: #{day["tempmin"]} °F"
    end
  end
end

user = Forecast.new
user.get_location
user.fetch_min_and_max_temperature
user.print_temperature