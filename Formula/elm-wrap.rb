class ElmWrap < Formula
  desc "Elm package management wrapper with custom registry support"
  homepage "https://github.com/dsimunic/elm-wrap"
  version "0.5.0"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dsimunic/elm-wrap/releases/download/v0.5.0/elm-wrap-macos-arm64"
      sha256 "3990cff0fa0c691bd0634766f4abeca4a4cea153a77c978bf153b0f73a61666c"
    else
      url "https://github.com/dsimunic/elm-wrap/releases/download/v0.5.0/elm-wrap-macos-amd64"
      sha256 "90227ebd7a84364e41e73836de8d58f97689fa1ed7a9361d8694536771730304"
    end
  else
    url "https://github.com/dsimunic/elm-wrap/archive/refs/tags/v0.5.0.tar.gz"
    sha256 "6734dc9ce743ebe0a1b90c83aa8d355bf7277e34ba2648252ad72b534a500916"
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
