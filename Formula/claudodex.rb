class Claudodex < Formula
  desc "Claude Code routed through your OpenAI Codex subscription"
  homepage "https://github.com/bassner/claudodex"
  url "https://github.com/bassner/claudodex/releases/download/v0.5.12/claudodex-0.5.12-source.tar.gz"
  version "0.5.12"
  sha256 "28abe256f8556b87fbd58fb2b32886c4b5787810060e5453768802882f209428"
  license "MIT"

  bottle do
    root_url "https://github.com/bassner/claudodex/releases/download/v0.5.12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "510a5279f990a9c461e0563d8deedee46c0c306f9f3eabed59fa05f7959b3a0d"
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
