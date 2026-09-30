class Mrk < Formula
  desc "Render Markdown beautifully in the terminal: syntax highlighting, tables, themes, and Mermaid diagrams as images."
  homepage "https://github.com/vmeyet/mrk-cli"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vmeyet/mrk-cli/releases/download/v0.3.1/mrk-cli-aarch64-apple-darwin.tar.xz"
      sha256 "b95bc8c41e110d5f3e719813e4a2dc83d43094f2d5797d2aa9c7740c92d9dc76"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vmeyet/mrk-cli/releases/download/v0.3.1/mrk-cli-x86_64-apple-darwin.tar.xz"
      sha256 "f7be39aa6b9e14f0059d82775a199d7f07e291455b4da40ded8e7a1ae30a7287"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vmeyet/mrk-cli/releases/download/v0.3.1/mrk-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "05ad304a2384ca041b8929bfc769bd71a2683d74ae6efa3076a89baf29d9b6a3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vmeyet/mrk-cli/releases/download/v0.3.1/mrk-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5f781845dbac9f215469d275cdd74e7766619380c7d7f4f53a434b4eefbdbacc"
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
