# typed: false
# frozen_string_literal: true

# ApeGuard — One-command security posture assessment
# Homebrew formula. Install with:
#   brew tap pirateape/tap
#   brew install apeguard

class Apeguard < Formula
  desc "One-command security posture assessment — layered scans, Zero Trust mapping, multi-audience reports"
  homepage "https://github.com/pirateape/ape-guard"
  url "https://github.com/pirateape/ape-guard/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "eae5711a4c1535ffa3fe4c4c4c10c767195dec0b37e6ef56d92857b694de176a"
  license "Elastic-2.0"
  head "https://github.com/pirateape/ape-guard.git", branch: "main"

  depends_on "rust" => :build
  depends_on "gitleaks" => :recommended
  depends_on "semgrep" => :recommended
  depends_on "trivy" => :recommended
  depends_on "nuclei" => :optional
  depends_on "checkov" => :optional
  depends_on "syft" => :optional

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/apeguard version 2>&1")
    assert_match "ApeGuard v", output
    assert_match "License: Elastic-2.0", output
  end
end
