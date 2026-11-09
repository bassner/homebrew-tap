class Claudodex < Formula
  desc "Claude Code routed through your OpenAI Codex subscription"
  homepage "https://github.com/bassner/claudodex"
  url "https://github.com/bassner/claudodex/releases/download/v0.5.9/claudodex-0.5.9-source.tar.gz"
  version "0.5.9"
  sha256 "62dfe22040a1f6b4e54e60954028e8fb64b0f32c2351d3bb6ebc505647a01cf5"
  license "MIT"

  bottle do
    root_url "https://github.com/bassner/claudodex/releases/download/v0.5.9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e865eb7b22e830ae4d8bf5e4c80e50131234d3790130ca40e2b75a67b693969"
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
