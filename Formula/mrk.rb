class Mrk < Formula
  desc "Render Markdown beautifully in the terminal: syntax highlighting, tables, themes, and Mermaid diagrams as images."
  homepage "https://github.com/vmeyet/mrk-cli"
  version "0.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vmeyet/mrk-cli/releases/download/v0.8.0/mrk-cli-aarch64-apple-darwin.tar.xz"
      sha256 "a0d191687e81194d841ef41d0607af3618c307c6caf2295c5298edeaa3431ec2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vmeyet/mrk-cli/releases/download/v0.8.0/mrk-cli-x86_64-apple-darwin.tar.xz"
      sha256 "a16ece92e034add53f97c5fe086398d8e3275165cef22c6ff15db9e410459128"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vmeyet/mrk-cli/releases/download/v0.8.0/mrk-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cf59a6e64d474614c42bbb89cbd8876bb99dd96b55f9b49def473736cb7606c8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vmeyet/mrk-cli/releases/download/v0.8.0/mrk-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "66a15c246a1910bae14a8d75b0e5b5d715b62d84e424ce82d7197e1a37975803"
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
