class ElmWrap < Formula
  desc "Elm package management wrapper with custom registry support"
  homepage "https://github.com/dsimunic/elm-wrap"
  version "0.7.0-preview.2"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dsimunic/elm-wrap/releases/download/v0.7.0-preview.2/elm-wrap-macos-arm64"
      sha256 "0b32b8d2f094ad9643a37fb0fe0150447a1eaacdda2997f3eef44c4595561163"
    else
      url "https://github.com/dsimunic/elm-wrap/releases/download/v0.7.0-preview.2/elm-wrap-macos-amd64"
      sha256 "8b037fb4e33b530a74587cf61cf031fae0b4903f721590c73b85eb76823168d7"
    end
  else
    url "https://github.com/dsimunic/elm-wrap/archive/refs/tags/v0.7.0-preview.2.tar.gz"
    sha256 "30965a7b95f19b84f305b96f6f2c9eab8b3eaadb0c4a9243a519564bdcc63482"
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
