require 'sinatra'
require 'line/bot'
require './weather'

def client
  @client ||= Line::Bot::Client.new { |config|
    config.channel_id = ENV["LINE_CHANNEL_ID"]
    config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
  }
end

post '/callback' do
  body = request.body.read

  signature = request.env['HTTP_X_LINE_SIGNATURE']
  unless client.validate_signature(body, signature)
    error 400 do 'Bad Request' end
  end

  events = client.parse_events_from(body)
  events.each do |event|
    case event
    when Line::Bot::Event::Message
      case event.type
      when Line::Bot::Event::MessageType::Text
        if event.message['text'] == '今日の天気'
          weather = Weather.new()
          message_text = weather.message('today')
        elsif event.message['text'] == '明日の天気'
          weather = Weather.new()
          message_text = weather.message('tomorrow')
        else
          message_text = event.message['text']
        end
        message = {
          type: 'text',
          text: message_text
        }
        client.reply_message(event['replyToken'], message)
      when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
        message = {
          type: 'text',
          text: '画像,動画はまだ未対応なり'
        }
        client.reply_message(event['replyToken'], message)
      end
    end
  end

  # Don't forget to return a successful response
  "OK"
end
