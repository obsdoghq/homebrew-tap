"""Keep the terminal upgrade handoff aligned with the public setup guide."""
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CHECKLIST_URL = (
    "https://github.com/obsdoghq/skills/blob/main/docs/SETUP.md"
    "#updating-cli-and-agent-guidance"
)


class UpgradeGuidanceTests(unittest.TestCase):
    def test_caveat_links_to_instruction_and_process_update_checklist(self):
        formula = (ROOT / "Formula" / "obsdog.rb").read_text()
        caveat = formula.split("  def caveats\n", 1)[1].split("    EOS\n", 1)[0]
        self.assertIn(CHECKLIST_URL, caveat)
        self.assertIn("AGENTS.md / CLAUDE.md", caveat)
        self.assertIn("obsdog mcp and dashboard serve", caveat)
        self.assertIn("reconnect", caveat)
        self.assertIn("The AI plugin is separate", caveat)

    def test_upgrade_guide_preserves_user_owned_instructions(self):
        readme = (ROOT / "README.md").read_text()
        self.assertIn(CHECKLIST_URL, readme)
        self.assertIn("AGENTS.md", readme)
        self.assertIn("CLAUDE.md", readme)
        self.assertIn("does not overwrite these files", readme)
        self.assertIn("host-owned MCP sessions", readme)


if __name__ == "__main__":
    unittest.main()
