# SVG Me tools for AI agents

[SVG Me](https://svgme.app) converts PNG, JPG and WebP images, including ones made by AI image generators, into clean SVG, PDF, EPS or DXF files. Image models only make rasters, and hand-written SVG markup only approximates the artwork; SVG Me traces it.

This repository holds two ways for agents to use it.

## Remote MCP server (chat apps and agents)

```
https://svgme.app/mcp
```

Sign in with your SVG Me account when your app asks. No install or API key needed.

- **Claude (claude.ai, Desktop):** Settings → Connectors → Add custom connector → paste the URL.
- **Claude Code:** `claude mcp add --transport http svgme https://svgme.app/mcp`
- **Cursor, VS Code and others:** add it as a remote (Streamable HTTP) MCP server.

Tools: `convert_image` (from an image URL or an upload), `create_upload`, `export_svg` (free re-export to PDF, EPS, DXF or layers) and `get_balance`.

## Agent skill (Claude Code and other agents with a shell)

The `svgme-convert` skill calls the [SVG Me API](https://svgme.app/image-to-svg-api) with curl.

**Claude Code plugin:**

```
/plugin marketplace add vchiapaikeo/svgme-tools
/plugin install svgme@svgme
```

**claude.ai / Claude Desktop:** download [svgme-convert.zip](https://svgme.app/skills/svgme-convert.zip) and upload it under Settings → Skills.

**Other agents:** copy [`plugins/svgme/skills/svgme-convert`](plugins/svgme/skills/svgme-convert) into your agent's skills folder.

The skill needs an API key in `SVGME_API_KEY`: sign in at [svgme.app/account](https://svgme.app/account), verify your email and create a key. New here? Redeem the code `AGENTS` on your account page for 5 free credits while it lasts.

## Pricing

Each conversion uses 1 credit; re-exports are free. See [svgme.app](https://svgme.app) for credit packs.

## Files

| Path | What it is |
| --- | --- |
| `.claude-plugin/marketplace.json` | Claude Code plugin marketplace |
| `plugins/svgme/` | The plugin, holding the `svgme-convert` skill |
| `server.json` | Listing for the [official MCP Registry](https://registry.modelcontextprotocol.io) |
| `sync.sh` | Copies the skill from the app repo, where it's maintained |
