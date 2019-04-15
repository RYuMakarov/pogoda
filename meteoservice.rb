require 'net/http'
require 'uri'
require 'rexml/document'

if (Gem.win_platform?)
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

CLOUDINESS = {0 => 'ясно', 1 => 'малооблачно', 2 => 'облачно', 3 => 'пасмурно'}

uri = URI.parse("https://xml.meteoservice.ru/export/gismeteo/point/114.xml")

response = Net::HTTP.get_response(uri)

doc = REXML::Document.new(response.body)

city_name = URI.unescape(doc.root.elements['REPORT/TOWN'].attributes['sname'])

current_forecast = doc.root.elements['REPORT/TOWN'].elements.to_a[0]


min_temp = current_forecast.elements['TEMPERATURE'].attributes['min']
max_temp = current_forecast.elements['TEMPERATURE'].attributes['max']

max_wind = current_forecast.elements['WIND'].attributes['max']


clouds_index = current_forecast.elements['PHENOMENA'].attributes['cloudiness'].to_i

clouds = CLOUDINESS[clouds_index]

puts city_name
puts "Температура от: #{min_temp} до #{max_temp} градусов"
puts "Ветер до #{max_wind} м/с"
puts clouds
