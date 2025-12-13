class ElmWrap < Formula
  desc "Elm package management wrapper with custom registry support"
  homepage "https://github.com/dsimunic/elm-wrap"
  version "0.5.0-preview.3"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dsimunic/elm-wrap/releases/download/v0.5.0-preview.3/elm-wrap-macos-arm64"
      sha256 "f8140893c98b7d11d49bcdf59c71f4eb29213dad8a9a3ff4f0062b53aa54202c"
    else
      url "https://github.com/dsimunic/elm-wrap/releases/download/v0.5.0-preview.3/elm-wrap-macos-amd64"
      sha256 "55311c8f2a7437950dcad4fbc7349ce735e77c709920051310b7422cd4df52be"
    end
  else
    url "https://github.com/dsimunic/elm-wrap/archive/refs/tags/v0.5.0-preview.3.tar.gz"
    sha256 "b201111058ab6f9fecb9fb11f693784b7bb17b500addaaec1b184d5dd3c96199"
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
