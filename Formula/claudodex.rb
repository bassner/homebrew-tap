class Claudodex < Formula
  desc "Claude Code routed through your OpenAI Codex subscription"
  homepage "https://github.com/bassner/claudodex"
  url "https://github.com/bassner/claudodex/releases/download/v0.4.1/claudodex-0.4.1-source.tar.gz"
  version "0.4.1"
  sha256 "220d5ca034dc1b2306d4d7adf6ab68f5b1b24b1f99bb277f0b670c2f341e8dce"
  license "MIT"

  bottle do
    root_url "https://github.com/bassner/claudodex/releases/download/v0.4.1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c30b6c3965656e7d4c12559baf5a2f430dec203173345c291d40db453bf754fc"
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
