class ElmWrap < Formula
  desc "Elm package management wrapper with custom registry support"
  homepage "https://github.com/dsimunic/elm-wrap"
  version "0.6.1"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dsimunic/elm-wrap/releases/download/v0.6.1/elm-wrap-macos-arm64"
      sha256 "3716b18a9dc2840fd8f980a23a8d9cfa8e429d58838f560aa4fcc6d5e7ccd48d"
    else
      url "https://github.com/dsimunic/elm-wrap/releases/download/v0.6.1/elm-wrap-macos-amd64"
      sha256 "09007f2b8787a90bc92e87d419171a8a353c4c73ab2b1469608741a50a6f732f"
    end
  else
    url "https://github.com/dsimunic/elm-wrap/archive/refs/tags/v0.6.1.tar.gz"
    sha256 "1f0d741d044b9a83f5fc06c801f05309983e3d09376063080d64f84538dfaa0b"
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
