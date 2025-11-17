class ElmWrap < Formula
  desc "Elm package management wrapper with custom registry support"
  homepage "https://github.com/dsimunic/elm-wrap"
  version "1.0.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/dsimunic/elm-wrap/releases/download/v1.0.1/elm-wrap-macos-arm64"
      sha256 "1c6baee0def03a458458d27eb7fdb2b1265bf252fd820b00e6177f434e935833"
    else
      url "https://github.com/dsimunic/elm-wrap/releases/download/v1.0.1/elm-wrap-macos-amd64"
      sha256 "661366d09935771af46d4550f0e2d6aa0539f0b0ae9ef2c57fa14cfb34b2ce2b"
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

