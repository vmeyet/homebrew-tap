class Pgbg < Formula
  desc "Read your PostgreSQL databases from the terminal: local, staging, and production behind a tunnel."
  homepage "https://github.com/vmeyet/pgbg-tui"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vmeyet/pgbg-tui/releases/download/v0.1.0/pgbg-aarch64-apple-darwin.tar.xz"
      sha256 "375dc93ec015c664d9101845917b8aa3400188388e36fc81dd4888209df0f014"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vmeyet/pgbg-tui/releases/download/v0.1.0/pgbg-x86_64-apple-darwin.tar.xz"
      sha256 "e627a4b510078f6b1693f6f5242684090b500e089fd10c830efa4822fb6d6e0b"
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
      bin.install "pgbg"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "pgbg"
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
