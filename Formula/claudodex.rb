class Claudodex < Formula
  desc "Claude Code routed through your OpenAI Codex subscription"
  homepage "https://github.com/bassner/claudodex"
  url "https://github.com/bassner/claudodex/releases/download/v0.5.13/claudodex-0.5.13-source.tar.gz"
  version "0.5.13"
  sha256 "77451c5e7f62e89eaf2b4e22097fe04e84e689866aa748ac5e6d76596b9de0c4"
  license "MIT"

  bottle do
    root_url "https://github.com/bassner/claudodex/releases/download/v0.5.13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4190bb26b9ad2a667f0e1e6f03ee3b3ae40796513f81be0694c655316d4f59d4"
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
