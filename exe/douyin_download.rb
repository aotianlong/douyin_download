
require "bundler/setup"
require "douyin_download"
require "thor"
class DouyinDownloadCli < Thor
  desc "download URL", "download a video from douyin shared url"
  def download(url)
    puts "download #{url}"
    parser = DouyinDownload::Parser.new(url)
    play_url = parser.play_url
    description = parser.description
    filename = parser.download
    puts "download complete, file: #{filename}"
  end
end
DouyinDownloadCli.start(ARGV)