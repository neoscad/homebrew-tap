class Neoscad < Formula
  desc "The neoscad command-line tool (OpenSCAD-compatible flags)"
  homepage "https://neoscad.org"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/neoscad/neoscad/releases/download/v0.6.0/neoscad-cli-aarch64-apple-darwin.tar.xz"
      sha256 "f09a590399e60cb5c9bac1fba87c9515ecdcf434f26b6e751132397c929c2eb1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/neoscad/neoscad/releases/download/v0.6.0/neoscad-cli-x86_64-apple-darwin.tar.xz"
      sha256 "f533988323514c98bbaf214b909c1be7cfd5332668229b05a5bc5e70f22459c7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/neoscad/neoscad/releases/download/v0.6.0/neoscad-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "faa205635fcbff2b1b62bd36fd7da7795ccbabe8a413ff1c5f8ffc6f730883a6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/neoscad/neoscad/releases/download/v0.6.0/neoscad-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "70ea6d3b0b46df663dc21745d6d7248e967c8740738f4a51a2b03688d7c97f35"
    end
  end
  license "GPL-2.0-or-later"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-pc-windows-gnu":    {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "neoscad"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "neoscad"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "neoscad"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "neoscad"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
