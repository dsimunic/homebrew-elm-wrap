class ElmWrap < Formula
  desc "Elm package management wrapper with custom registry support"
  homepage "https://github.com/dsimunic/elm-wrap"
  version "0.6.0-preview.2"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dsimunic/elm-wrap/releases/download/v0.6.0-preview.2/elm-wrap-macos-arm64"
      sha256 "0bc6be378379b75b414144e3e42585b2234e1aee8d3039e0bca8f0af127ee9cd"
    else
      url "https://github.com/dsimunic/elm-wrap/releases/download/v0.6.0-preview.2/elm-wrap-macos-amd64"
      sha256 "d02cbdb4ad339b579e80a7911a935de0d73435259ccbae5fa2b8380318a2425c"
    end
  else
    url "https://github.com/dsimunic/elm-wrap/archive/refs/tags/v0.6.0-preview.2.tar.gz"
    sha256 "4bedeacfd982a0761bad2cf09dd7146ef5ebcb6524c22760677a6606912e9a10"
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
