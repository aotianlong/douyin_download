
require "bundler/setup"
require "douyin_download"
require "thor"
class DouyinDownloadCli < Thor
  desc "download URL", "download a video from douyin shared url"
  def download(url)
    puts "download #{url}"
  end
end
DouyinDownloadCli.start(ARGV)