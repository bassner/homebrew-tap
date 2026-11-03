class Claudodex < Formula
  desc "Claude Code routed through your OpenAI Codex subscription"
  homepage "https://github.com/bassner/claudodex"
  url "https://github.com/bassner/claudodex/releases/download/v0.5.5/claudodex-0.5.5-source.tar.gz"
  version "0.5.5"
  sha256 "ddcec27c9eb2d50ba05b1681592f7c7f04216861e38812fd00b6e1bd3e4c324f"
  license "MIT"

  bottle do
    root_url "https://github.com/bassner/claudodex/releases/download/v0.5.5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c97a0be1ef02fcb1560abcede1339e42d4f78dc50b7d1cb2ca1cce9a0978282"
  end

  depends_on "go" => :build
  depends_on :macos
  depends_on arch: :arm64

  def install
    ENV["GOPROXY"] = "off"
    ENV["GOTOOLCHAIN"] = "local"
    ENV["GOWORK"] = "off"
    ENV["GOFLAGS"] = "-mod=vendor"
    # Go issue 52372: -trimpath removes the recorded -ldflags used to verify
    # version/install method before an update handoff. Keep those settings.
    system "go", "build", "-mod=vendor",
           "-ldflags", "-s -w -X main.version=#{version} -X main.installMethod=homebrew",
           "-o", bin/"claudodex", "./cmd/claudodex"
  end

  test do
    ENV["CLAUDODEX_NO_AUTO_UPDATE"] = "1"
    assert_equal "claudodex #{version}",
                 shell_output("#{bin}/claudodex clx:version").strip
  end
end
