class LinearCli < Formula
  desc "CLI for Linear - for terminal humans and AI agents"
  homepage "https://github.com/mlemley/linear-cli"
  url "https://github.com/mlemley/linear-cli/archive/refs/tags/v0.3.0.tar.gz"
  version "0.3.0"
  sha256 "864fad8262229aa15f2739ba71c64d7bae41baa454cffc3a779e0a9b3fdee136"
  license "Unlicense"

  depends_on "node"

  def install
    ENV["npm_config_cache"] = buildpath/"npm-cache"
    system "npm", "ci", "--no-audit", "--no-fund"
    system "npm", "run", "build"
    libexec.install "dist", "node_modules", "package.json", ".agents"
    (bin/"linear").write <<~EOS
      #!/bin/bash
      exec "#{Formula["node"].opt_bin}/node" "#{libexec}/dist/cli.js" "$@"
    EOS
    chmod 0755, bin/"linear"
  end

  def post_install
    target = File.expand_path("~/.agents/skills/linear")
    FileUtils.mkdir_p(target)
    FileUtils.cp_r("#{libexec}/.agents/skills/linear/.", target)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/linear --version")
  end
end
