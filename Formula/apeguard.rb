# typed: false
# frozen_string_literal: true

# ApeGuard — One-command security posture assessment
# Homebrew formula. Install with:
#   brew tap pirateape/tap
#   brew install apeguard

class Apeguard < Formula
  desc "One-command security posture assessment — layered scans, Zero Trust mapping, multi-audience reports"
  homepage "https://github.com/pirateape/ape-guard"
  url "https://github.com/pirateape/ape-guard/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "e59785c6832ffa9add4dca11ecd74aa7a58cef4b2dbb70fbbc547c09f9cec800"
  license "Elastic-2.0"
  head "https://github.com/pirateape/ape-guard.git", branch: "main"

  depends_on "rust" => :build
  depends_on "gitleaks" => :recommended
  depends_on "semgrep" => :recommended
  depends_on "trivy" => :recommended
  depends_on "nuclei" => :optional

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/apeguard version 2>&1")
    assert_match "ApeGuard v", output
    assert_match "License: Elastic-2.0", output
  end
end
