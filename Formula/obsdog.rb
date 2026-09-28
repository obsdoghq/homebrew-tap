class Obsdog < Formula
  desc "Local-first knowledge search, feedback, and dashboard CLI"
  homepage "https://obsdog.ai"
  url "https://github.com/obsdoghq/obsdog-releases/releases/download/v0.2.2/obsdog_v0.2.2_darwin_arm64.tar.gz"
  sha256 "81b3ef4c9c3c295c3552b15a8a125a090db332a183c15374945295be8f98f1ff"
  license :cannot_represent

  depends_on arch: :arm64
  depends_on :macos

  resource "binary-license" do
    url "https://github.com/obsdoghq/obsdog-releases/releases/download/v0.2.2/BINARY-LICENSE.txt"
    sha256 "103b5830a3f09e07dd74efbea8ad6352b4f14a1b7f67c1807f92cd6bd62ede9b"
  end

  resource "third-party-notices" do
    url "https://github.com/obsdoghq/obsdog-releases/releases/download/v0.2.2/THIRD_PARTY_NOTICES.txt"
    sha256 "d582b979400481f83bb06be5409dc6d66a07f19549aa03888d725f779bdcba8a"
  end

  def install
    bin.install "obsdog"
    resource("binary-license").stage { pkgshare.install "BINARY-LICENSE.txt" }
    resource("third-party-notices").stage { pkgshare.install "THIRD_PARTY_NOTICES.txt" }
  end

  def caveats
    <<~EOS
      Local use needs no account or init. Commands default to your Personal Space.
      Space data is stored in ~/.obsdog and survives brew uninstall.
      Use brew upgrade obsdoghq/tap/obsdog for Homebrew-owned updates.
      This package is the CLI, not the macOS desktop app.
      The AI plugin is separate. Verify obsdog version before using its skills.
      Browse with obsdog document list or obsdog dashboard serve.
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
    system bin/"obsdog", "document", "import", "--file", testpath/"fixture.md",
           "--actor-type", "agent", "--actor", "package-test", "--format", "json"
    result = Dir.chdir(project) do
      command = "#{bin}/obsdog search --query comet --actor-type agent --actor package-test --format json"
      JSON.parse(shell_output(command))
    end
    assert result.fetch("ok")
    assert_equal 1, result.fetch("data").fetch("hits").length
    assert_equal "lexical/compact-substring-v1", result.fetch("data").fetch("lexical_policy")
    documents = JSON.parse(shell_output("#{bin}/obsdog document list --format json"))
    assert_equal 1, documents.fetch("data").length
    insights = JSON.parse(shell_output("#{bin}/obsdog insights show --format json"))
    assert_equal 1, insights.fetch("data").fetch("current").fetch("searches")
    assert_equal 0, insights.fetch("data").fetch("current").fetch("used_runs")
    assert_match "47777", shell_output("#{bin}/obsdog dashboard --help")

    assert_match "unknown command", shell_output("#{bin}/obsdog init 2>&1", 1)
    assert_match "flag provided but not defined", shell_output("#{bin}/obsdog space status --path #{project} 2>&1", 1)
    refute_path_exists project/".obsdog"

    digest = Digest::SHA256.file(bin/"obsdog").hexdigest
    assert_match "Homebrew", shell_output("#{bin}/obsdog update --check 2>&1", 1)
    assert_equal digest, Digest::SHA256.file(bin/"obsdog").hexdigest
  end
end
