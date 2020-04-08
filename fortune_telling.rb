require 'open-uri'
require 'json'
require 'date'

class FortuneTelling
  FORTUNE_TELLING_API_URL = 'http://api.jugemkey.jp/api/horoscope/free/'

  def self.fortune?(message)
    signs = ['牡羊', '牡牛', '双子', '蟹', '獅子', '乙女', '天秤', '蠍', '射手', '山羊', '水瓶', '魚']

    signs.each do |sign|
      if (sign + '座') == message
        return true
      end
    end

    false
  end

  def message(sign)
    result = sign(sign)

    "今日の#{sign}の運勢\n12位中: #{result['rank']}位\n総合点(5点満点): #{result['total']}点\n金運(5点満点): #{result['money']}点\n仕事運(5点満点): #{result['job']}点\n恋愛運(5点満点): #{result['love']}点\nラッキーアイテム:\n  #{result['item']}\nラッキーカラー:\n  #{result['color']}\n\n詳細: #{result['content']}"
  end

  def sign(sign)
    results = date_result()

    results.find { |n| n['sign'] == sign }
  end

  private

  def date_result
    today = Date.today
    url = FORTUNE_TELLING_API_URL + today.strftime('%Y/%m/%d')

    response = URI.open(url)
    parse_text = JSON.parse(response.read)

    parse_text['horoscope'][today.strftime('%Y/%m/%d')]
  end
end
