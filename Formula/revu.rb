class Revu < Formula
  desc "Review GitLab merge requests and GitHub pull requests from your terminal: a TUI plus scriptable commands."
  homepage "https://github.com/vmeyet/revu-tui"
  version "0.15.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vmeyet/revu-tui/releases/download/v0.15.0/revu-aarch64-apple-darwin.tar.xz"
      sha256 "c7eedf3b8fa7f133a865cdbd91600631bc548f6f5f0665688c00b56450b0a13d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vmeyet/revu-tui/releases/download/v0.15.0/revu-x86_64-apple-darwin.tar.xz"
      sha256 "5572647b6323352a05b9a48d2779548e63535f2e86911550298eb28219f477a8"
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
