class ElmWrap < Formula
  desc "Elm package management wrapper with custom registry support"
  homepage "https://github.com/dsimunic/elm-wrap"
  version "0.5.2"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dsimunic/elm-wrap/releases/download/v0.5.2/elm-wrap-macos-arm64"
      sha256 "76d242771358ab0a602785d0f13245bd44196bd2d0086775324fcca3143c3ba6"
    else
      url "https://github.com/dsimunic/elm-wrap/releases/download/v0.5.2/elm-wrap-macos-amd64"
      sha256 "1e9b701605e40a1df61f74da4c58919b13ce016bdc10aa6b73a32061c53e2993"
    end
  else
    url "https://github.com/dsimunic/elm-wrap/archive/refs/tags/v0.5.2.tar.gz"
    sha256 "19f33c21b10278b46a98103feebf3af72abc0063db50f6c01b27aea75403e68d"
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
