class Neoscad < Formula
  desc "The neoscad command-line tool (OpenSCAD-compatible flags)"
  homepage "https://neoscad.org"
  version "0.2.1-rc.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/neoscad/neoscad/releases/download/v0.2.1-rc.2/neoscad-cli-aarch64-apple-darwin.tar.xz"
      sha256 "e9339fb40d24a6fb11198191a33d71f86670bd3d68c399759d8ac8b6687769f4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/neoscad/neoscad/releases/download/v0.2.1-rc.2/neoscad-cli-x86_64-apple-darwin.tar.xz"
      sha256 "b318433c582f81e3fc27138272bac36e2ff481b0117d3fb3c437b3381e3e74c0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/neoscad/neoscad/releases/download/v0.2.1-rc.2/neoscad-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bc084882d3df88292269afd1e2ac3b3533e9bc7e93279cc953908c3aac8375c5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/neoscad/neoscad/releases/download/v0.2.1-rc.2/neoscad-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "eddd3d147d40bba7233b2db8bdc434ff29b258e79160c1cae2d3bd4e75168e1f"
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
