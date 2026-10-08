class Neoscad < Formula
  desc "The neoscad command-line tool (OpenSCAD-compatible flags)"
  homepage "https://neoscad.org"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/neoscad/neoscad/releases/download/v0.5.0/neoscad-cli-aarch64-apple-darwin.tar.xz"
      sha256 "61b35abb26969d044d6422f6740ba4f8842ca3dd72b4daa3dd63a3f2c12f9a1a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/neoscad/neoscad/releases/download/v0.5.0/neoscad-cli-x86_64-apple-darwin.tar.xz"
      sha256 "ffb9d5d89c92078121f7ad082b2286da71d74b39222cabff4d2138dbd9a9f252"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/neoscad/neoscad/releases/download/v0.5.0/neoscad-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e4be4273865a9f244ab0ffed47aff362d3bb9746a7503b93936d46163598637d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/neoscad/neoscad/releases/download/v0.5.0/neoscad-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6d186d507815d94c98c33736407b340f39fa8c606eead97caa2805067a268fe9"
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
