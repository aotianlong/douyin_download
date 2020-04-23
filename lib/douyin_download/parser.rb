require "faraday"
require "json"
class DouyinDownload::Parser
  MOBILE_USER_AGENT = "Mozilla/5.0 (iPhone; CPU iPhone OS 12_1_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0 Mobile/15E148 Safari/604.1"
  class InvalidDouyinUrlError < Exception; end
  def initialize(url)
    @url = url
    regexp = /v\.douyin\.com\/[\w\d]+/
    unless  @url =~ regexp
      raise InvalidDouyinUrlError.new("Invalid douyin url: #{@url}")
    end
  end

  def douyin_id
    url = @url.gsub /https?:\/\/v\.douyin\.com\//,''
    url.gsub '/',''
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

  def api_play_url
    info.dig('item_list',0,'video','play_addr','url_list',0)
  end

  def play_url
    # 这个是终极的播放url
    # http://v9-dy-y.ixigua.com/390e2ef55562a7f85c79d98dc9814475/5ea127a5/video/tos/cn/tos-cn-ve-15/7131a6682c1040c1aa713f8405c34670/?a=1128&amp;br=0&amp;bt=907&amp;cr=0&amp;cs=0&amp;dr=0&amp;ds=6&amp;er=&amp;l=202004231229000100140472040B062432&amp;lr=&amp;qs=0&amp;rc=M3I7NG87PHVodDMzNmkzM0ApaTM2Ojc3Zzs8N2Y6ZTU7ZGdfMGJsNTNhNmRfLS0tLS9zcy40NDU0YDM2LWA2NC1eLzM6Yw%3D%3D&amp;vl=&amp;vr
    headers = Faraday.get(api_play_url,{},'User-Agent': MOBILE_USER_AGENT).headers
    headers['location']
  end

  def info
    # 用移动端设备ua访问该页面
    @info ||= begin
      result = {}
      ua = MOBILE_USER_AGENT
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

  def download(filename: nil)
    begin
      body = Faraday.get(play_url, {}, 'User-Agent': MOBILE_USER_AGENT).body
      # filename ||= [douyin_id, description].join("-") + ".mp4"
      filename ||= douyin_id + ".mp4"
      File.open(filename,"wb+"){|f|
        f.write body
      }
      filename
    rescue Exception
    end
  end

  private
  def parse_json(str)
    eval str
  end
end