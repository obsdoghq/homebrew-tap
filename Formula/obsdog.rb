class Obsdog < Formula
  desc "Local-first knowledge search, feedback, and dashboard CLI"
  homepage "https://obsdog.ai"
  url "https://github.com/obsdoghq/obsdog-releases/releases/download/v0.2.25/obsdog_v0.2.25_darwin_arm64.tar.gz"
  sha256 "4177965f6b739e105f5d65965a2052a879839595d70810da6eb08f1225397295"
  license :cannot_represent

  depends_on arch: :arm64
  depends_on :macos

  resource "binary-license" do
    url "https://github.com/obsdoghq/obsdog-releases/releases/download/v0.2.25/BINARY-LICENSE.txt"
    sha256 "103b5830a3f09e07dd74efbea8ad6352b4f14a1b7f67c1807f92cd6bd62ede9b"
  end

  resource "third-party-notices" do
    url "https://github.com/obsdoghq/obsdog-releases/releases/download/v0.2.25/THIRD_PARTY_NOTICES.txt"
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
      Existing schema-11 libraries need the separate backup-first 11-to-12
      transition tool. Installation does not migrate them or stop writers.
      Pause that library's writers and follow the guide before first use:
      https://github.com/obsdoghq/obsdog-releases/blob/v0.2.25/guides/local-schema-migration.md
      Old writers are not a supported downgrade of schema-12 data.
      After upgrading, restart any running obsdog mcp and dashboard serve
      processes. Existing agent sessions and browser refreshes keep their old
      processes; reconnect them to use newly installed commands and tools.
      Use obsdog dashboard status to compare the running viewer with this CLI.
      This package is the CLI, not the macOS desktop app.
      The AI plugin is separate. Verify obsdog version before using its skills.
      Review the ObsDog section in AGENTS.md / CLAUDE.md after upgrading:
      https://github.com/obsdoghq/skills/blob/main/docs/SETUP.md#updating-cli-and-agent-guidance
      Browse with obsdog document list or obsdog dashboard serve.
      Import creates a new document; use obsdog doctor to inspect exact duplicate candidates.
    EOS
  end

  test do
    require "json"
    ENV["OBSDOG_HOME"] = (testpath/"data").to_s
    ENV["OBSDOG_NO_UPDATE_NOTIFIER"] = "1"
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
    assert_equal "obsdog.search/compact-substring-v1", result.fetch("data").fetch("search_policy")
    assert_equal 1, result.fetch("data").fetch("page")
    assert_equal 1, result.fetch("data").fetch("hits").first.fetch("page_rank")
    miss_command = "#{bin}/obsdog search --query CometWorkerTasks " \
                   "--actor-type agent --actor package-test --format json"
    miss = JSON.parse(shell_output(miss_command))
    assert_equal 0, miss.fetch("data").fetch("returned_count")
    assert_equal 0, miss.fetch("data").fetch("candidate_count")
    assert_equal 1, miss.fetch("data").fetch("adjacent_hints").length
    runs = JSON.parse(shell_output("#{bin}/obsdog trace list --zero-only --format json"))
    miss_id = miss.fetch("data").fetch("retrieval_run_id")
    recorded_zero = runs.fetch("data").fetch("rows").any? do |row|
      row.fetch("retrieval_run_id") == miss_id &&
        row.fetch("candidate_count").zero? && row.fetch("lexical_pool_count").zero?
    end
    assert recorded_zero
    documents = JSON.parse(shell_output("#{bin}/obsdog document list --format json"))
    assert_equal 1, documents.fetch("data").length
    insights = JSON.parse(shell_output("#{bin}/obsdog insights show --format json"))
    assert_equal 2, insights.fetch("data").fetch("current").fetch("searches")
    assert_equal 0, insights.fetch("data").fetch("current").fetch("used_runs")
    assert_equal 2, insights.fetch("data").fetch("current").fetch("page_eligible")
    assert_equal 0, insights.fetch("data").fetch("current").fetch("first_page_used")
    probe = JSON.parse(shell_output("#{bin}/obsdog search --no-observe --query comet --format json"))
    assert probe.fetch("data").fetch("diagnostic")
    assert_equal "", probe.fetch("data").fetch("retrieval_run_id")
    assert_equal 1, probe.fetch("data").fetch("returned_count")
    counted = JSON.parse(shell_output("#{bin}/obsdog search --no-observe --count-total --query comet --format json"))
    assert_equal 1, counted.fetch("data").fetch("total_matches")
    after_probe = JSON.parse(shell_output("#{bin}/obsdog insights show --format json"))
    assert_equal 2, after_probe.fetch("data").fetch("current").fetch("searches")
    system bin/"obsdog", "document", "import", "--file", testpath/"fixture.md", "--fork",
           "--actor-type", "agent", "--actor", "package-test", "--format", "json"
    diagnosis = JSON.parse(shell_output("#{bin}/obsdog doctor --format json"))
    candidates = diagnosis.fetch("data").fetch("duplicate_candidates")
    assert_equal [], diagnosis.fetch("data").fetch("markdown_layout_issues", [])
    current_duplicate = candidates.any? do |group|
      group_documents = group.fetch("documents")
      visible = group_documents.all? do |document|
        document.fetch("created_at") != "" && document.fetch("default_visible_blocks").positive?
      end
      group.fetch("visibility_scope") == "current_pair" && group.fetch("current_visible_documents") == 2 &&
        group_documents.length == 2 && visible
    end
    assert current_duplicate
    original = documents.fetch("data").first
    doc_id = original.fetch("document_id")
    (testpath/"section.md").write("## Follow-up\n\nSynthetic append stays in the same document.\n")
    system bin/"obsdog", "document", "append", "--id", doc_id,
           "--base-revision", original.fetch("current_revision_id"), "--file", testpath/"section.md",
           "--reason", "Homebrew synthetic append check", "--actor-type", "agent",
           "--actor", "package-test", "--format", "json"
    read_cmd = "#{bin}/obsdog document read --id #{doc_id} --structure --format json"
    expanded = JSON.parse(shell_output(read_cmd))
    assert_match "Synthetic append stays in the same document.", expanded.fetch("data").fetch("markdown")
    assert_equal 4, expanded.fetch("data").fetch("blocks").length
    assert_match "47777", shell_output("#{bin}/obsdog dashboard --help")
    assert_match "care apply", shell_output("#{bin}/obsdog care --help")
    assert_match "prepare-care", shell_output("#{bin}/obsdog sync --help")

    assert_match "unknown command", shell_output("#{bin}/obsdog init 2>&1", 1)
    assert_match "flag provided but not defined", shell_output("#{bin}/obsdog space status --path #{project} 2>&1", 1)
    refute_path_exists project/".obsdog"

    digest = Digest::SHA256.file(bin/"obsdog").hexdigest
    update = JSON.parse(shell_output("#{bin}/obsdog update --format json", 1))
    refute update.fetch("ok")
    assert_match "this installation is owned by Homebrew", update.fetch("error")
    assert_match "brew upgrade obsdoghq/tap/obsdog", update.fetch("error")
    assert_equal digest, Digest::SHA256.file(bin/"obsdog").hexdigest
  end
end
