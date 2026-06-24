class ElmWrap < Formula
  desc "Elm package management wrapper with custom registry support"
  homepage "https://github.com/dsimunic/elm-wrap"
  version "0.7.1-preview.2"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dsimunic/elm-wrap/releases/download/v0.7.1-preview.2/elm-wrap-macos-arm64"
      sha256 "b03b854a298999dc08e93069eb12cc7a6e6aba7c43347cb630331fe9c1a45fc4"
    else
      url "https://github.com/dsimunic/elm-wrap/releases/download/v0.7.1-preview.2/elm-wrap-macos-amd64"
      sha256 "7dc302699f7259643324ae1c6ec6c3e8b8de97b658e99c8ce62d6c36eece44d9"
    end
  else
    url "https://github.com/dsimunic/elm-wrap/archive/refs/tags/v0.7.1-preview.2.tar.gz"
    sha256 "32ce154b074519b1febfd2afd8e8e297b7b0874bc2e570686aed1a76a70abaa0"
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
