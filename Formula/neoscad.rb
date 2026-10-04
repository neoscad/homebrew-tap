class Neoscad < Formula
  desc "The neoscad command-line tool (OpenSCAD-compatible flags)"
  homepage "https://neoscad.org"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/neoscad/neoscad/releases/download/v0.4.0/neoscad-cli-aarch64-apple-darwin.tar.xz"
      sha256 "837d693c07968f595e23a9f2b6593c16853a1cde62c1c0917f8a3a9962c3f3bd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/neoscad/neoscad/releases/download/v0.4.0/neoscad-cli-x86_64-apple-darwin.tar.xz"
      sha256 "a1df909ce8608c4e9cff321d8699037f9f3c7405c032a43caf67c2227f8a00d3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/neoscad/neoscad/releases/download/v0.4.0/neoscad-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "21790404e8bc84f9e41d8c01090e9ba293377a7899130bd2c6f9bbd2fa3c8275"
    end
    if Hardware::CPU.intel?
      url "https://github.com/neoscad/neoscad/releases/download/v0.4.0/neoscad-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a8e9bfe6f46c4ad31d7250f05cb35e9218b6e04bd9faba0e057b9ab32c62194b"
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
