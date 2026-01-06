class ElmWrap < Formula
  desc "Elm package management wrapper with custom registry support"
  homepage "https://github.com/dsimunic/elm-wrap"
  version "0.6.0-preview.1"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dsimunic/elm-wrap/releases/download/v0.6.0-preview.1/elm-wrap-macos-arm64"
      sha256 "08db7e9d4e7c8ccadc0556073175468de0dca7a3cef55abb2331605a4ca0e6aa"
    else
      url "https://github.com/dsimunic/elm-wrap/releases/download/v0.6.0-preview.1/elm-wrap-macos-amd64"
      sha256 "2946ed7cb057ee78955b03b333cbe7ee5c5b347615a73536a20bb4b9e62de868"
    end
  else
    url "https://github.com/dsimunic/elm-wrap/archive/refs/tags/v0.6.0-preview.1.tar.gz"
    sha256 "faa2ba220f93dbf9a3fb268d2c7774b278440deb1a670fb63529a1e8d7767599"
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
