require 'uri'
require 'net/http'
require 'openssl'
require 'json'

require 'pry'

class Forecast
  attr_reader :address, :forecast, :temp

  def initialize(address)
    @address = address
    @forecast = ""
    @temp = []
  end

  def get_location
    url = URI("https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/#{ARGV[0]}%20#{ARGV[1]}?unitGroup=us&elements=tempmax%2Ctempmin&include=days%2Cfcst&key=KNGPR64VNTB43UYTGC8BL8NVD&contentType=json")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE 
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    forecast<<response.read_body
  end

  def fetch_min_and_max_temp
    hash = JSON.parse forecast.gsub('=>', ':')
    temp<<hash.fetch("days")
  end

  def print_temp
    forecast = temp.shift
    forecast.each do |day|
    puts "High: #{day["tempmax"]} °F; Low: #{day["tempmin"]} °F"
    end

  end
end

user = Forecast.new(ARGV[0])
user.get_location
user.fetch_min_and_max_temp
user.print_temp
