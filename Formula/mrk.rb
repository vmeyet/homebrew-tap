class Mrk < Formula
  desc "Render Markdown beautifully in the terminal: syntax highlighting, tables, themes, and Mermaid diagrams as images."
  homepage "https://github.com/vmeyet/mrk-cli"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vmeyet/mrk-cli/releases/download/v0.4.1/mrk-cli-aarch64-apple-darwin.tar.xz"
      sha256 "a994f80ce7ede5cd93d8f91ea8002f0e6d4d4b31c0f0b145550d88278d903802"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vmeyet/mrk-cli/releases/download/v0.4.1/mrk-cli-x86_64-apple-darwin.tar.xz"
      sha256 "02752f77e0bd842bc3bb6ee70f58c672c9a5affc25a3552448f483b98e72e0a7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vmeyet/mrk-cli/releases/download/v0.4.1/mrk-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5a370afc95a00768392ef3ee01c70824ac3437f9a02de45ecb219bf0e74c58c7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vmeyet/mrk-cli/releases/download/v0.4.1/mrk-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2a55a9bdc74b01a832a221ffb22c62aa7e143e8d5cd5e172bb205a0a9aa5283f"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
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
      bin.install "mrk"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "mrk"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "mrk"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "mrk"
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
