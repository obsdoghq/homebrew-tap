"""Keep the terminal upgrade handoff aligned with the public setup guide."""
import re
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

    def test_schema_transition_precedes_restart_and_pins_this_release(self):
        formula = (ROOT / "Formula" / "obsdog.rb").read_text()
        caveat = formula.split("  def caveats\n", 1)[1].split("    EOS\n", 1)[0]
        version = re.search(r"releases/download/(v\d+\.\d+\.\d+)/", formula)
        self.assertIsNotNone(version)
        guide = (
            "https://github.com/obsdoghq/obsdog-releases/blob/"
            + version.group(1)
            + "/guides/local-schema-migration.md"
        )
        self.assertIn(guide, caveat)
        self.assertIn("Installation does not migrate them or stop writers", caveat)
        self.assertIn("Pause that library's writers", caveat)
        self.assertLess(caveat.index("backup-first"), caveat.index("After upgrading"))


if __name__ == "__main__":
    unittest.main()
