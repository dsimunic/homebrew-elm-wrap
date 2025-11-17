class ElmWrap < Formula
  desc "Elm package management wrapper with custom registry support"
  homepage "https://github.com/dsimunic/elm-wrap"
  version "1.0.1"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dsimunic/elm-wrap/releases/download/v1.0.1/elm-wrap-macos-arm64"
      sha256 "1c6baee0def03a458458d27eb7fdb2b1265bf252fd820b00e6177f434e935833"
    else
      url "https://github.com/dsimunic/elm-wrap/releases/download/v1.0.1/elm-wrap-macos-amd64"
      sha256 "661366d09935771af46d4550f0e2d6aa0539f0b0ae9ef2c57fa14cfb34b2ce2b"
    end
  else
    url "https://github.com/dsimunic/elm-wrap/archive/refs/tags/v1.0.1.tar.gz"
    sha256 "385595cfda8d66d17148ceb4f86a1dd4a0582c9d7e9b90e8c33d7a0959c60997"
  end

  def install
    if OS.mac?
      if Hardware::CPU.arm?
        bin.install "elm-wrap-macos-arm64" => "elm-wrap"
      else
        bin.install "elm-wrap-macos-amd64" => "elm-wrap"
      end
    else
      system "make"
      bin.install "bin/elm-wrap"
    end
  end

  test do
    output = shell_output("#{bin}/elm-wrap --help")
    assert_match "elm-wrap", output
  end
end
