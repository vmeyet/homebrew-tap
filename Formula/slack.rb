class Slack < Formula
  desc "Slack in your terminal, as yourself: a TUI plus scriptable commands."
  homepage "https://github.com/vmeyet/slack-tui"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vmeyet/slack-tui/releases/download/v0.2.0/slack-aarch64-apple-darwin.tar.xz"
      sha256 "1d2cf64411d6be8abe7b1867fc3dc3024722987535d67dafa0b7848ba5c01961"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vmeyet/slack-tui/releases/download/v0.2.0/slack-x86_64-apple-darwin.tar.xz"
      sha256 "f78a807e10fcbe279f50c41e63f4f4406a18eaf54e6c68e26544d1ea3de5bd58"
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
