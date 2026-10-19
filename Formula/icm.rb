class Icm < Formula
  desc "ICM — the agent-context framework CLI: scaffold, adopt, sync, upgrade, doctor, uninstall"
  homepage "https://github.com/pirateape/ICM"
  # Git strategy: installs from the release tag with no hash bookkeeping.
  # For stricter audit-grade reproducibility, switch to the tarball url +
  # sha256 in the comment below and add the tag's commit as `revision`.
  url "https://github.com/pirateape/ICM.git",
      tag: "v2.0.0"
  version "2.0.0"
  license "MIT"

  # Stricter alternative (preferred if the tap is ever audited): pin the
  # release tarball + sha256 instead of the git strategy. After tagging
  # v2.0.0, fill both lines with:
  #   curl -sL https://github.com/pirateape/ICM/archive/refs/tags/v2.0.0.tar.gz | shasum -a 256
  #   git -C <checkout> rev-parse v2.0.0^{commit}
  # url "https://github.com/pirateape/ICM/archive/refs/tags/v2.0.0.tar.gz"
  # sha256 "REPLACE_WITH_RELEASE_TARBALL_SHA256"
  # revision "REPLACE_WITH_TAG_COMMIT_SHA"

  depends_on "git"

  def install
    # libexec layout: icm sits beside scripts/ and templates/ — the
    # dispatcher resolves everything from its own physical location, so
    # this is all the layout the CLI needs. The bin symlink resolves to
    # libexec via icm_readlink_f.
    libexec.install "icm", "scripts", "templates"
    chmod 0755, libexec/"icm"
    bin.install_symlink libexec/"icm"
  end

  test do
    # The full scaffold → hooks → doctor pipeline in a throwaway src root.
    ENV["ICM_SRC_ROOT"] = testpath/"src"
    (testpath/"src").mkpath
    system "git", "config", "--global", "user.name", "ICM Formula Test"
    system "git", "config", "--global", "user.email", "icm-formula-test@example.com"

    # version contract: git metadata is absent in a Homebrew install, so
    # this exercises the hardcoded fallback.
    assert_match(/^icm v\d+\.\d+\.\d+$/, shell_output("#{bin}/icm --version").strip)

    system bin/"icm", "new", "icm-formula-test", "blank"
    project = testpath/"src/icm-formula-test"
    assert_path project/"AGENTS.md"

    # Contract tests 7+8 (sync entry point + git hooks) and 13 (router
    # registration) are hard checks — provide them the documented way
    # before doctor.
    (testpath/"src/router.md").write(<<~EOS)
      # The Router (Global Map)

      ## Project Directory
      - **icm-formula-test:** `icm-formula-test/`
    EOS
    system bin/"icm", "hooks", project

    system bin/"icm", "doctor", project
  end
end
