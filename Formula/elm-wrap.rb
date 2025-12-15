class ElmWrap < Formula
  desc "Elm package management wrapper with custom registry support"
  homepage "https://github.com/dsimunic/elm-wrap"
  version "0.5.0-preview.4"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dsimunic/elm-wrap/releases/download/v0.5.0-preview.4/elm-wrap-macos-arm64"
      sha256 "d68cb8e1e1bf0d221df8fe2db0f6fddda8dceb417f859d35dbf49874a3d0ccbf"
    else
      url "https://github.com/dsimunic/elm-wrap/releases/download/v0.5.0-preview.4/elm-wrap-macos-amd64"
      sha256 "d23c96fdaa9016922b541ea86076ae18a9a7a1be036c735f91ca48a42489e2a6"
    end
  else
    url "https://github.com/dsimunic/elm-wrap/archive/refs/tags/v0.5.0-preview.4.tar.gz"
    sha256 "c841caac7569cc9d4eaef456813a53fdbd984041664731bfb502d0cc94cb8b84"
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
