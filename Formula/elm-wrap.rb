class ElmWrap < Formula
  desc "Elm package management wrapper with custom registry support"
  homepage "https://github.com/dsimunic/elm-wrap"
  version "0.7.0-preview.1"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dsimunic/elm-wrap/releases/download/v0.7.0-preview.1/elm-wrap-macos-arm64"
      sha256 "6d0d6ec910d384c9caa5b2c341de7d16a1c8e02f96b446c694bc4114eb158836"
    else
      url "https://github.com/dsimunic/elm-wrap/releases/download/v0.7.0-preview.1/elm-wrap-macos-amd64"
      sha256 "d4e7102e348712a155dd257e52c6e3576a217ab8b0269d51ba716cf3e83ba3df"
    end
  else
    url "https://github.com/dsimunic/elm-wrap/archive/refs/tags/v0.7.0-preview.1.tar.gz"
    sha256 "dc3f32caa3ec128a677df1f5667c74280b0d2a02321c2cd0a7453151ef528e1b"
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
