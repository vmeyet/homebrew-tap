class Mrk < Formula
  desc "Render Markdown beautifully in the terminal: syntax highlighting, tables, themes, and Mermaid diagrams as images."
  homepage "https://github.com/vmeyet/mrk-cli"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vmeyet/mrk-cli/releases/download/v0.4.0/mrk-cli-aarch64-apple-darwin.tar.xz"
      sha256 "ae9f72eab1093cd119597dc0dcdffcc44976ed058132b82d51ceeae1422fd2c4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vmeyet/mrk-cli/releases/download/v0.4.0/mrk-cli-x86_64-apple-darwin.tar.xz"
      sha256 "6fb77d4c48403470f11a310a473bd2802f5da306398df6f91db2fb880467a746"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vmeyet/mrk-cli/releases/download/v0.4.0/mrk-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bf48edf61b0c15ecdccf6dde711288dd40e874cb70bd4aac61c68a65aa2d1b97"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vmeyet/mrk-cli/releases/download/v0.4.0/mrk-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "482192d4b169337a6853892e076544831e1c8c1b68fcc44750096a8bd665fd22"
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
