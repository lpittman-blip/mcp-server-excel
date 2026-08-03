# Cutline Industries integration

This fork wires **Excel MCP** to the [Cutline Industries](https://github.com/lpittman-g/Cutline-Industries) platform — Thermal Mission Control, revenue ops, and agent tooling.

## Sister project

| Project | Role |
|---------|------|
| **Excel MCP** (this repo) | Spreadsheet automation — revenue ledgers, deal desk exports, developer CRM packs, bounty metrics |
| **Cutline Industries** | Real-time media ops — heat detection, clips, Stripe checkout, Mission Control UI |

Use Excel for **offline analysis and outbound packets**; use Cutline API for **live ops data**.

## Cutline API (local / deployed)

Set `CUTLINE_API_URL` (default `http://127.0.0.1:8787`).

| Endpoint | Purpose |
|----------|---------|
| `GET /api/dashboard/summary` | KPIs, heat alerts, revenue cents |
| `GET /api/dashboard/revenue-timeline` | Sales by day and tier |
| `GET /api/sales` | Stripe ledger |
| `GET /api/clips` | Clip vault |
| `GET /api/streamers` | Live Twitch streamers |
| `GET /api/developers/pipeline` | Developer CRM stages |

Start Cutline locally:

```bash
git clone https://github.com/lpittman-g/Cutline-Industries.git
cd Cutline-Industries
npm install
DATABASE_URL=postgres://... npm run db:migrate
npm run start
```

## Example workflows

**Revenue workbook from live sales**

1. `GET /api/sales` from Cutline API
2. Excel MCP: create `Thermal-Revenue.xlsx`, load sales JSON into a table
3. Add PivotTable by tier (gateway $15, bounty $50, retainer)
4. Refresh on schedule via Squad autopilot workflow

**Developer outbound packet**

1. `GET /api/clips/top` + `GET /api/developers/pipeline`
2. Excel: attach clip metrics + pipeline stage to a pitch sheet
3. Export PDF for studio outreach

## MCP configuration

Team-shared config: [`.copilot/mcp-config.json`](../.copilot/mcp-config.json)

- `excel-mcp` — requires `mcp-excel` on PATH (see [INSTALLATION-MCP-SERVER.md](INSTALLATION-MCP-SERVER.md))
- `cutline-api` — fetch MCP; set `CUTLINE_API_URL` in environment

VS Code workspace override: [`.vscode/mcp.json`](../.vscode/mcp.json)

## Squad marketplace

Cutline is registered in [`.squad/plugins/marketplaces.json`](../.squad/plugins/marketplaces.json). When adding ops/revenue agents, browse `cutline-industries` marketplace for Thermal skills and agent tools.

## Upstream sync

Cutline-specific files live under `docs/cutline-integration.md`, `.copilot/`, and `.squad/plugins/`. When pulling from `sbroenne/mcp-server-excel`, prefer merging upstream first, then re-apply fork overlays.
