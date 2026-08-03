# Cutline operations use case

This fork pairs **Excel MCP Server** with
[Cutline Industries](https://github.com/lpittman-g/Cutline-Industries) to run
approval-gated operational workflows.

## What the pairing does

- **Cutline Industries** handles operator approval and operational API calls.
- **Excel MCP Server** refreshes, reshapes, audits, and screenshots Excel
  workbooks.
- **Copilot/Squad autopilot** uses both tools together so approval-sensitive
  steps stay gated while workbook work stays automated.

## Repo-level Copilot MCP wiring

This repository now commits a shared `.copilot/mcp-config.json` with:

- `excel-mcp` → `mcp-excel`
- `cutline-api` → `scripts/start-cutline-api-mcp.ps1`

The launcher script resolves the Cutline repo from `CUTLINE_REPO_ROOT` or from
a sibling `../Cutline-Industries` checkout, then starts Cutline's
`tools/phone-approval-lite/mcp/server.js` bridge against `CUTLINE_API_URL`.

## Required environment variables

| Variable | Purpose | Example |
|----------|---------|---------|
| `CUTLINE_REPO_ROOT` | Local checkout of the Cutline repo | `C:\src\Cutline-Industries` |
| `CUTLINE_API_URL` | Base URL for the running Cutline API | `http://127.0.0.1:8787` |

## Recommended local setup

1. Check out the two repos side-by-side.
2. Start the Cutline API.
3. Let Copilot load the repo-level `.copilot/mcp-config.json`.
4. Run approval-gated workflows from this repo.

```powershell
cd C:\src\Cutline-Industries
npm install
npm run api
```

```powershell
$env:CUTLINE_REPO_ROOT = "C:\src\Cutline-Industries"
$env:CUTLINE_API_URL = "http://127.0.0.1:8787"
```

## Example autopilot loop

1. Ask Copilot to request Cutline approval for a runbook step.
2. After approval, refresh Power Query outputs or workbook calculations.
3. Capture screenshots or workbook artifacts for review.
4. Repeat the loop for the next gated step.

Example prompt:

> Request Cutline approval for the pricing refresh, then refresh the workbook,
> recalculate totals, and capture a screenshot of the summary sheet.

## Why this fork uses Cutline

Cutline adds an operator-in-the-loop control point for workflows that should not
run end-to-end without approval. Excel MCP Server remains the workbook engine,
while Cutline provides the approval and operational sidecar.
