class ElmWrap < Formula
  desc "Elm package management wrapper with custom registry support"
  homepage "https://github.com/dsimunic/elm-wrap"
  version "0.5.0-preview.1"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dsimunic/elm-wrap/releases/download/v0.5.0-preview.1/elm-wrap-macos-arm64"
      sha256 "a170be9ef871b5f44a691f93ce36e681c1a2bf20b1e9d4622a4c5ab97f5b732e"
    else
      url "https://github.com/dsimunic/elm-wrap/releases/download/v0.5.0-preview.1/elm-wrap-macos-amd64"
      sha256 "72c6bb2243071c9e1d162cf00a984cc35804122c00f51779101d211060af2708"
    end
  else
    url "https://github.com/dsimunic/elm-wrap/archive/refs/tags/v0.5.0-preview.1.tar.gz"
    sha256 "0f11b10085704965be75eb7ff19088870f631680c61e09678a9aea6dd7490a68"
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
    output = shell_output("#{bin}/elm-wrap --help")
    assert_match "elm-wrap", output
  end
end
