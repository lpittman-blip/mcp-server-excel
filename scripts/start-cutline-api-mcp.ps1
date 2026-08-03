param(
    [switch]$ValidateOnly
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$candidateRoots = [System.Collections.Generic.List[string]]::new()

if (-not [string]::IsNullOrWhiteSpace($env:CUTLINE_REPO_ROOT)) {
    $candidateRoots.Add($env:CUTLINE_REPO_ROOT)
}

$candidateRoots.Add((Join-Path (Split-Path -Parent $repoRoot) "Cutline-Industries"))
$candidateRoots.Add((Join-Path $HOME "Cutline-Industries"))

$entryPoint = $null
$resolvedRepoRoot = $null

foreach ($candidateRoot in $candidateRoots | Select-Object -Unique) {
    if ([string]::IsNullOrWhiteSpace($candidateRoot)) {
        continue
    }

    $candidateEntry = Join-Path $candidateRoot "tools/phone-approval-lite/mcp/server.js"
    if (Test-Path $candidateEntry) {
        $resolvedRepoRoot = (Resolve-Path $candidateRoot).Path
        $entryPoint = (Resolve-Path $candidateEntry).Path
        break
    }
}

if (-not $entryPoint) {
    $searched = ($candidateRoots | Select-Object -Unique) -join ", "
    throw "Cutline MCP bridge not found. Set CUTLINE_REPO_ROOT to a local Cutline-Industries checkout. Searched: $searched"
}

$node = Get-Command node -ErrorAction SilentlyContinue
if (-not $node) {
    throw "Node.js is required to launch the Cutline MCP bridge. Install Node.js and try again."
}

if ([string]::IsNullOrWhiteSpace($env:CUTLINE_API_URL)) {
    $env:CUTLINE_API_URL = "http://127.0.0.1:8787"
}

if ($ValidateOnly) {
    Write-Host "Cutline repo: $resolvedRepoRoot"
    Write-Host "Cutline MCP entry: $entryPoint"
    Write-Host "Cutline API URL: $($env:CUTLINE_API_URL)"
    exit 0
}

& $node.Source $entryPoint
exit $LASTEXITCODE
