class Obsdog < Formula
  desc "Local-first knowledge search, feedback, and Wiki CLI"
  homepage "https://obsdog.ai"
  url "https://github.com/obsdoghq/obsdog-releases/releases/download/v0.1.9/obsdog_v0.1.9_darwin_arm64.tar.gz"
  sha256 "7a3f1d14b13b2fe3ae22a52f220815fee40211287c98852e8a10b41d4005b320"
  license :cannot_represent

  depends_on arch: :arm64
  depends_on :macos

  resource "binary-license" do
    url "https://github.com/obsdoghq/obsdog-releases/releases/download/v0.1.9/BINARY-LICENSE.txt"
    sha256 "103b5830a3f09e07dd74efbea8ad6352b4f14a1b7f67c1807f92cd6bd62ede9b"
  end

  resource "third-party-notices" do
    url "https://github.com/obsdoghq/obsdog-releases/releases/download/v0.1.9/THIRD_PARTY_NOTICES.txt"
    sha256 "d582b979400481f83bb06be5409dc6d66a07f19549aa03888d725f779bdcba8a"
  end

  def install
    bin.install "obsdog"
    resource("binary-license").stage { pkgshare.install "BINARY-LICENSE.txt" }
    resource("third-party-notices").stage { pkgshare.install "THIRD_PARTY_NOTICES.txt" }
  end

  def caveats
    <<~EOS
      Local use needs no account. Run obsdog init inside your project.
      Space data is stored in ~/.obsdog and survives brew uninstall.
      Use brew upgrade obsdoghq/tap/obsdog for Homebrew-owned updates.
      This package is the CLI, not the macOS desktop app.
    EOS
  end

  test do
    require "json"
    ENV["OBSDOG_HOME"] = (testpath/"data").to_s
    assert_equal "v#{version}", shell_output("#{bin}/obsdog version").strip
    assert_match "Usage", shell_output("#{bin}/obsdog --help")
    assert_match "Third-party notices", shell_output("#{bin}/obsdog --licenses")

    project = testpath/"project"
    project.mkpath
    (testpath/"fixture.md").write("# Package evidence\n\nComet knowledge survives package installation.\n")
    system bin/"obsdog", "init", "--path", project, "--format", "json"
    system bin/"obsdog", "document", "import", "--path", project,
           "--file", testpath/"fixture.md", "--format", "json"
    result = JSON.parse(shell_output("#{bin}/obsdog search --path #{project} --query comet --format json"))
    assert result.fetch("ok")
    assert_equal 1, result.fetch("data").fetch("hits").length

    digest = Digest::SHA256.file(bin/"obsdog").hexdigest
    assert_match "Homebrew", shell_output("#{bin}/obsdog update --check 2>&1", 1)
    assert_equal digest, Digest::SHA256.file(bin/"obsdog").hexdigest
  end
end
