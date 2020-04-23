require "faraday"
require "json"
class DouyinDownload::Parser
  class InvalidDouyinUrlError < Exception; end
  def initialize(url)
    @url = url
    regexp = /v\.douyin\.com\/[\w\d]+/
    unless  @url =~ regexp
      raise InvalidDouyinUrlError.new("Invalid douyin url: #{@url}")
    end
  end

  def long_url
    @long_url ||= begin
      # url = "https://v.douyin.com/T4Sjhd/"
      # body = Faraday.get(@url).body
      headers = Faraday.get(@url).headers
      headers['location']
    end
  end

  def download_url
    info.dig('item_list',0,'video','download_addr','url_list',0)
  end

  def description
    info.dig('item_list',0,'desc')
  end

  def play_url
    info.dig('item_list',0,'video','play_addr','url_list',0)
  end

  def info
    # 用移动端设备ua访问该页面
    @info ||= begin
      result = {}
      ua = "Mozilla/5.0 (iPhone; CPU iPhone OS 12_1_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0 Mobile/15E148 Safari/604.1"
      body = Faraday.get(long_url, {}, 'User-Agent': ua).body
      # puts body
      regexp = /\.init\(\{(.+)\}\)\;\s+\}\)\;/m
      api_url = nil
      if body =~ regexp
        json = "{#{$1}}"
        data = parse_json json
        # pp data

        # 构建api url
        item_ids = data[:itemId]
        dytk = data[:dytk]
        api_url = "https://www.iesdouyin.com/web/api/v2/aweme/iteminfo/?item_ids=#{item_ids}&dytk=#{dytk}"
      else
        # byebug
      end

      if api_url
        body = Faraday.get(api_url).body
        result = JSON.parse body
      end
      result
    end
  end

  private
  def parse_json(str)
    eval str
  end
end