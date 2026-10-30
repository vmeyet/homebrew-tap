class Pgbg < Formula
  desc "Read your PostgreSQL databases from the terminal: local, staging, and production behind a tunnel."
  homepage "https://github.com/vmeyet/pgbg-tui"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vmeyet/pgbg-tui/releases/download/v0.2.0/pgbg-aarch64-apple-darwin.tar.xz"
      sha256 "618eb836925d738735a8f89d1dad97c34884486de135370beee0b20846fa6e97"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vmeyet/pgbg-tui/releases/download/v0.2.0/pgbg-x86_64-apple-darwin.tar.xz"
      sha256 "4395be5af0f5887b7e7947bf15934e837bf1263f237766af5db1a34f8c8fd62a"
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
