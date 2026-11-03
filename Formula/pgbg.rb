class Pgbg < Formula
  desc "Read your PostgreSQL databases from the terminal: local, staging, and production behind a tunnel."
  homepage "https://github.com/vmeyet/pgbg-tui"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vmeyet/pgbg-tui/releases/download/v0.3.0/pgbg-aarch64-apple-darwin.tar.xz"
      sha256 "b99a6ac541231f26aa8257ddbcd6c7b38de9bea75d4fd24e1c4fc62203c3faaa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vmeyet/pgbg-tui/releases/download/v0.3.0/pgbg-x86_64-apple-darwin.tar.xz"
      sha256 "93707c265c924222afe72b311c3fe0eee47cbb963b4bd9059442a47b8ad5e5e1"
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
