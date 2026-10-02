"""The public formula gate must not need a maintainer's machine or credentials."""
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


class FormulaWorkflowTests(unittest.TestCase):
    def setUp(self):
        self.workflow = (ROOT / ".github" / "workflows" / "formula.yml").read_text()

    def test_isolated_supported_host_and_read_only_checkout(self):
        self.assertIn("runs-on: macos-15", self.workflow)
        self.assertIn('[[ "$(uname -m)" == arm64 ]]', self.workflow)
        self.assertIn("contents: read", self.workflow)
        self.assertIn("persist-credentials: false", self.workflow)
        self.assertRegex(self.workflow, r"actions/checkout@[a-f0-9]{40}(?:\s|$)")
        self.assertNotIn("self" + "-hosted", self.workflow)
        self.assertNotIn("secrets.", self.workflow)
        self.assertNotRegex(self.workflow, r"contents:\s*write")

    def test_uses_reviewed_formula_without_publishing(self):
        self.assertIn('cmp "$GITHUB_WORKSPACE/Formula/obsdog.rb"', self.workflow)
        for command in ("brew style", "brew audit --strict", "brew install", "brew test"):
            self.assertIn(command + " obsdoghq/tap/obsdog", self.workflow)
        self.assertNotIn("gh release", self.workflow)
        self.assertNotIn("git push", self.workflow)
        self.assertNotIn("brew trust --tap", self.workflow)
        self.assertIn("HOMEBREW_NO_AUTO_UPDATE: '1'", self.workflow)

    def test_unchanged_formula_keeps_acceptance_synthetic(self):
        formula = (ROOT / "Formula" / "obsdog.rb").read_text()
        test_body = formula.split("  test do\n", 1)[1]
        self.assertIn('ENV["OBSDOG_HOME"] = (testpath/"data").to_s', test_body)
        self.assertIn('ENV["OBSDOG_NO_UPDATE_NOTIFIER"] = "1"', test_body)
        self.assertIn("search --no-observe", test_body)
        self.assertNotRegex(test_body, r"(?:login|sync push|sync pull|mcp)\s*[,\"]")

    def test_public_api_lookup_uses_only_a_step_scoped_ci_token(self):
        acceptance = self.workflow.split(
            "      - name: Install the public binary and run synthetic acceptance\n", 1
        )[1]
        self.assertIn("        env:\n", acceptance)
        self.assertIn("OBSDOG_GITHUB_TOKEN: ${{ github.token }}", acceptance)
        self.assertEqual(1, self.workflow.count("OBSDOG_GITHUB_TOKEN:"))
        self.assertIn("contents: read", self.workflow)
        self.assertNotIn("secrets.", self.workflow)
        self.assertIn("--max-time 15 --dump-header - --output /dev/null", self.workflow)
        self.assertIn("x-ratelimit-", self.workflow)
        self.assertNotIn("continue-on-error", acceptance)
        self.assertNotIn("|| true", acceptance)


if __name__ == "__main__":
    unittest.main()
