class Claudodex < Formula
  desc "Claude Code routed through your OpenAI Codex subscription"
  homepage "https://github.com/bassner/claudodex"
  url "https://github.com/bassner/claudodex/releases/download/v0.5.3/claudodex-0.5.3-source.tar.gz"
  version "0.5.3"
  sha256 "d7a0792361fdb8738865269dcc92875d9373ae04226f7030a838f2f78a5480f3"
  license "MIT"

  bottle do
    root_url "https://github.com/bassner/claudodex/releases/download/v0.5.3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2317dee4c12e8d504e91652b513f672b249d6137fee7e1bf6f0c961a61f5b82"
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
