require 'open-uri'
require 'json'

class Weather
  WEATHER_API_URL = 'http://weather.livedoor.com/forecast/webservice/json/v1'

  def message(datelabel)
    weather = if datelabel == 'today'
                today()
              elsif datelabel == 'tomorrow'
                tomorrow()
              else
                {}
              end
    temp_max = weather['temperture']['max']['celsius'] || '不明'
    temp_min = weather['temperture']['min']['celsius'] || '不明'

    message = "#{weather['datelabel']}の東京の天気: #{weather['telop']}\n最高気温: #{temp_max}度\n最低気温: #{temp_min}"
  end

  def today
    get_weather.find { |e| e['dateLabel'] == '今日' }
  end

  def tomorrow
    get_weather.find { |e| e['dateLabel'] == '明日' }
  end

  private

  def get_weather
    response = URI.open(city_url())
    parse_text = JSON.parse(response.read)

    parse_text['forecasts']
  end

  def city_url
    WEATHER_API_URL + '?city=130010'
  end
end
