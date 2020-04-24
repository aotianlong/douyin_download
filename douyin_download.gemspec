
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "douyin_download/version"

Gem::Specification.new do |spec|
  spec.name          = "douyin_download"
  spec.version       = DouyinDownload::VERSION
  spec.authors       = ["aotianlong"]
  spec.email         = ["aotianlong@gmail.com"]

  spec.summary       = %q{download douyin video}
  spec.description   = %q{download douyin video without watermark}
  spec.homepage      = "https://www.aotianlong.com"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
=begin
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org'"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/aotianlong/douyin_download"
    spec.metadata["changelog_uri"] = "https://github.com/aotianlong/douyin_download/CHANGELOG.md"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end
=end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 1.0"
  spec.add_dependency "thor", "~> 1.0"
  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake",  "~> 12.3"
  spec.add_development_dependency "rspec", "~> 3.0"
end
