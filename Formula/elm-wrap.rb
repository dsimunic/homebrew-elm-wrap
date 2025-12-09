class ElmWrap < Formula
  desc "Elm package management wrapper with custom registry support"
  homepage "https://github.com/dsimunic/elm-wrap"
  version "0.5.0-preview.2"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dsimunic/elm-wrap/releases/download/v0.5.0-preview.2/elm-wrap-macos-arm64"
      sha256 "3131d36178f4ca15ae34f98ae802e28b50c8e3ee4418184bb7f84e3457187c3f"
    else
      url "https://github.com/dsimunic/elm-wrap/releases/download/v0.5.0-preview.2/elm-wrap-macos-amd64"
      sha256 "7406dfce689bc072e14ed741d1810c44b017d9f2b655dc4d2c5899a500d814d6"
    end
  else
    url "https://github.com/dsimunic/elm-wrap/archive/refs/tags/v0.5.0-preview.2.tar.gz"
    sha256 "f6bbf161181f406a870159abde212d8f854fae3465652ee5a3888b3a08a22003"
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
