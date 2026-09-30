class Mrk < Formula
  desc "Render Markdown beautifully in the terminal: syntax highlighting, tables, themes, and Mermaid diagrams as images."
  homepage "https://github.com/vmeyet/mrk-cli"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vmeyet/mrk-cli/releases/download/v0.3.0/mrk-cli-aarch64-apple-darwin.tar.xz"
      sha256 "a131e669fb52bc0f07b3aed6e81dabb829b702b526b61d2578dc93d88d130186"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vmeyet/mrk-cli/releases/download/v0.3.0/mrk-cli-x86_64-apple-darwin.tar.xz"
      sha256 "c07b4e436b20ea07472f30e86afe36097a7dc572f93c15f9471d5b98420c7654"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vmeyet/mrk-cli/releases/download/v0.3.0/mrk-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "116de955ec540ad0bf22d032e0cade5c794267858d5b1297d612aa8c95fc869b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vmeyet/mrk-cli/releases/download/v0.3.0/mrk-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2de94904141aca3bf5d354f80c4ce0ca3a2399cdd1a6fafb05e7619865af508a"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
