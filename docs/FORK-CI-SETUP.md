# Fork CI setup (lpittman-g/mcp-server-excel)

This fork adds Cutline Industries integration without changing Excel COM code. Some upstream CI workflows expect infrastructure that only exists on the upstream maintainer repo.

## What runs without extra setup

| Workflow | Fork behavior |
|----------|----------------|
| **CI Gate** | Runs on `windows-latest` — no Azure required |
| **Squad Autopilot** | Runs on `ubuntu-latest` — validates config JSON |
| **Changeset Check** | Pass with `skip-changelog` label on docs/CI-only PRs |
| **Dependency Review** | Best-effort; skips gracefully if Dependency graph is off |
| **Excel Integration Tests** | **Skipped** until Azure secrets are configured |

## Excel Integration Tests (optional)

Upstream uses a self-hosted Windows VM with Excel in Azure:

| Secret | Purpose |
|--------|---------|
| `AZURE_CLIENT_ID` | Service principal for `azure/login` |
| `AZURE_TENANT_ID` | Azure AD tenant |
| `AZURE_SUBSCRIPTION_ID` | Subscription hosting `vm-excel-runner` |

Without these secrets, PRs show **Excel integration tests skipped** (notice, not failure).

To enable full Excel integration tests on this fork:

1. Provision `rg-excel-runner` / `vm-excel-runner` (Windows + Excel + self-hosted runner labels `self-hosted`, `windows`, `excel`)
2. Add the three Azure secrets under **Settings → Secrets and variables → Actions**
3. Re-run **Excel Integration Tests** on the PR

## Dependency graph

If **Dependency Review** fails with "Dependency graph is not enabled":

**Settings → Code security and analysis → Dependency graph → Enable**

The workflow also attempts to enable vulnerability alerts via API on first run.

## Cutline-specific PRs

Docs / Squad / MCP config PRs (like Cutline integration) should use the **`skip-changelog`** label — no `.changeset` fragment required.
