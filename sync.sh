#!/bin/bash
# Copies the agent skill from the svgme app repo, its single source of truth
# (client/public/skills/), so this copy never drifts. Run before committing.
set -euo pipefail
cd "$(dirname "$0")"
cp ../svgme/client/public/skills/svgme-convert/SKILL.md plugins/svgme/skills/svgme-convert/SKILL.md
git status --short
