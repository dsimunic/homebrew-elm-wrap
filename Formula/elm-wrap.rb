class ElmWrap < Formula
  desc "Elm package management wrapper with custom registry support"
  homepage "https://github.com/dsimunic/elm-wrap"
  version "1.0.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/dsimunic/elm-wrap/releases/download/v1.0.0/elm-wrap-macos-arm64"
      sha256 "6495b31b964a8561f4fda5cb4b23bd00479ac8d6538c873e17c0cf48b285a5c1"
    else
      url "https://github.com/dsimunic/elm-wrap/releases/download/v1.0.0/elm-wrap-macos-amd64"
      sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "elm-wrap-macos-arm64" => "elm-wrap"
    else
      bin.install "elm-wrap-macos-amd64" => "elm-wrap"
    end
  end

  test do
    output = shell_output("#{bin}/elm-wrap --help")
    assert_match "elm-wrap", output
  end
end

