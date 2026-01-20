class ElmWrap < Formula
  desc "Elm package management wrapper with custom registry support"
  homepage "https://github.com/dsimunic/elm-wrap"
  version "0.6.0"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dsimunic/elm-wrap/releases/download/v0.6.0/elm-wrap-macos-arm64"
      sha256 "d5068050a64e1942d72b56889a958b2ea13420127ba5e50afcbd76b8561cf589"
    else
      url "https://github.com/dsimunic/elm-wrap/releases/download/v0.6.0/elm-wrap-macos-amd64"
      sha256 "9a621e391528a6c6f07e6f0e3fd56f2fd071643d9dfffb49d2a6ea70b324be89"
    end
  else
    url "https://github.com/dsimunic/elm-wrap/archive/refs/tags/v0.6.0.tar.gz"
    sha256 "d933e7e605ff8d93829cd7876f7c18e87a7a6a943c92a778c26a3e3f3804d8e4"
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
