RSpec.describe DouyinDownload::Parser do
  let(:invalid_url) { "https://invalidurl.com/invalidurl"}
  let(:valid_url){ "https://v.douyin.com/T4Sjhd/" }
  let(:valid_url_but_not_exists){ "https://v.douyin.com/T4Sjhdnotexists/"}
  let(:parser){ DouyinDownload::Parser.new(valid_url) }

  describe ".new" do
    it "should raise error when new with a invalid url" do
      expect{
        DouyinDownload::Parser.new(valid_url)
      }.to_not raise_error(DouyinDownload::Parser::InvalidDouyinUrlError)
    end

    it "should not raise error when new with a valid url" do
      expect{
        DouyinDownload::Parser.new(invalid_url)
      }.to raise_error(DouyinDownload::Parser::InvalidDouyinUrlError)
    end
  end

  describe "#download_url" do
    it do
      download_url = parser.download_url
      expect(download_url).to eq "https://aweme.snssdk.com/aweme/v1/play/?video_id=v0200f030000bqge9rd9688lo1e83ob0&line=0&ratio=540p&watermark=1&media_type=4&vr_type=0&improve_bitrate=0&logo_name=aweme_search_suffix&is_support_h265=0&source=PackSourceEnum_PUBLISH"
    end
  end

  describe "#description" do
    it do
      expect(parser.description).to eq '年纪大了就是这样，没有特别挚爱的东西，没有非做不可的事，更没有过不去的事'
    end
  end

  describe "#play_url" do
    it do
      play_url = parser.play_url
      expect(play_url).to eq 'https://aweme.snssdk.com/aweme/v1/play/?video_id=v0200f030000bqge9rd9688lo1e83ob0&line=0&ratio=540p&media_type=4&vr_type=0&improve_bitrate=0&is_play_url=1&is_support_h265=0&source=PackSourceEnum_PUBLISH'
    end
  end

end
