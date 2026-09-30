class Neoscad < Formula
  desc "The neoscad command-line tool (OpenSCAD-compatible flags)"
  homepage "https://neoscad.org"
  version "0.1.0-rc.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/neoscad/neoscad/releases/download/v0.1.0-rc.3/neoscad-cli-aarch64-apple-darwin.tar.xz"
      sha256 "00d0da4677c09ae10c7fa49ca8495739ad74582f6ea6ccfccc2d06bb5d2bc051"
    end
    if Hardware::CPU.intel?
      url "https://github.com/neoscad/neoscad/releases/download/v0.1.0-rc.3/neoscad-cli-x86_64-apple-darwin.tar.xz"
      sha256 "9a5d5c2fedc0ae1c4a3e92739cbd86346917cb33fe8911918d18967888d5ab2c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/neoscad/neoscad/releases/download/v0.1.0-rc.3/neoscad-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "daa746fabde8deb5a9f62e3f8a7fd199ce6088b518fcfefb30e83c7fda2c804c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/neoscad/neoscad/releases/download/v0.1.0-rc.3/neoscad-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ec4e5750060a7a3babf1ecaddb3ee866fd3c7f82a6d59d39cacd7fd603d72415"
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
