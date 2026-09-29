class Slack < Formula
  desc "Slack in your terminal, as yourself: a TUI plus scriptable commands."
  homepage "https://github.com/vmeyet/slack-tui"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vmeyet/slack-tui/releases/download/v0.1.0/slack-aarch64-apple-darwin.tar.xz"
      sha256 "deac7f9ef2a887166902dcc7a175902a767989802d13acc4d9eec02d44c5dfdb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vmeyet/slack-tui/releases/download/v0.1.0/slack-x86_64-apple-darwin.tar.xz"
      sha256 "69141e06db5ca1670fce5d68bae7bd37782f8d93916c8364625156167c8d3f55"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin":  {},
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
      bin.install "slack"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "slack"
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
