class Revu < Formula
  desc "Review GitLab merge requests and GitHub pull requests from your terminal: a TUI plus scriptable commands."
  homepage "https://github.com/vmeyet/revu-tui"
  version "0.11.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vmeyet/revu-tui/releases/download/v0.11.0/revu-aarch64-apple-darwin.tar.xz"
      sha256 "452bb8c037cc1bf62e21bfa117dbc20388b65c5d89d31568d301c6910df40db4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vmeyet/revu-tui/releases/download/v0.11.0/revu-x86_64-apple-darwin.tar.xz"
      sha256 "6802bfc82ec3b91f1749c6198fdfaf22aa2172fa343e7f29d3c11d043f5d0a10"
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
      bin.install "revu"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "revu"
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
