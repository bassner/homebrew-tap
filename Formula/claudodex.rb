class Claudodex < Formula
  desc "Claude Code routed through your OpenAI Codex subscription"
  homepage "https://github.com/bassner/claudodex"
  url "https://github.com/bassner/claudodex/releases/download/v0.4.0/claudodex-0.4.0-source.tar.gz"
  version "0.4.0"
  sha256 "69863d44cf76145ba8475c975c8f1718dc17f6131cb059e66cf8d3da6a24d5c9"
  license "MIT"

  bottle do
    root_url "https://github.com/bassner/claudodex/releases/download/v0.4.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e36deb9f392ea336dec4b625062ea3a13761cbc8d6833e18f083e24a91805ce1"
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
