# CAD Agent development

This fork packages the upstream AutoCAD MCP bridge with Russian workflows for as-built drawings and work quantity calculations.

- Keep upstream bridge behavior compatible. User workflows live in `skills/`; plugin metadata lives in `plugin.json`, `mcp.json` and `.agents/plugins/marketplace.json`.
- Use `npm ci`, `npm test` and `npm run check` to validate bridge changes. Validate plugin discovery with `codex plugin list --marketplace nazmeev-cad --available --json` after registering the marketplace.
- Preserve upstream MIT attribution. Keep real project drawings, survey data, local logs, credentials and generated dependencies out of Git commits.
- A successful MCP handshake proves server discovery. AutoCAD host loading, geometry edits and printed sheets require their own practical checks. Report which checks actually ran.
