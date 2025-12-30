class ElmWrap < Formula
  desc "Elm package management wrapper with custom registry support"
  homepage "https://github.com/dsimunic/elm-wrap"
  version "0.5.1"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dsimunic/elm-wrap/releases/download/v0.5.1/elm-wrap-macos-arm64"
      sha256 "a4d0f0d3db447da0d24d6aad82009565f4be733042cb0e9330a1ad5c119e3439"
    else
      url "https://github.com/dsimunic/elm-wrap/releases/download/v0.5.1/elm-wrap-macos-amd64"
      sha256 "36d616e12afdc5540da3e329c56e83ecc71a20b275c2de7d8ee3f9abed669f71"
    end
  else
    url "https://github.com/dsimunic/elm-wrap/archive/refs/tags/v0.5.1.tar.gz"
    sha256 "7c4cbb1e205cdb90138092883cb3402081627c06b3729b662e475fcb4a3bac1e"
  end

  def install
    if OS.mac?
      if Hardware::CPU.arm?
        bin.install "elm-wrap-macos-arm64" => "wrap"
      else
        bin.install "elm-wrap-macos-amd64" => "wrap"
      end
    else
      system "make"
      bin.install "bin/wrap"
    end
  end

  test do
    output = shell_output("#{bin}/wrap --help")
    assert_match "wrap", output
  end
end
