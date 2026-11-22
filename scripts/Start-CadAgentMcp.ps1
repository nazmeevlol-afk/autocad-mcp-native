$ErrorActionPreference = 'Stop'
# Some MCP clients forward a minimal environment without Windows executable extensions.
if (-not $env:PATHEXT) { $env:PATHEXT = '.COM;.EXE;.BAT;.CMD' }
$cadRepo = Split-Path -Parent $PSScriptRoot
$cadNode = $env:CAD_AGENT_NODE
if (-not $cadNode) {
    $cadNodeCommand = Get-Command node -ErrorAction SilentlyContinue
    if ($cadNodeCommand) { $cadNode = $cadNodeCommand.Source }
}
if (-not $cadNode) {
    $cadPortableRoot = 'C:\CAD-Agent\runtime'
    $cadNode = Get-ChildItem -LiteralPath $cadPortableRoot -Directory -Filter 'node-v*-win-x64' -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending |
        ForEach-Object { Join-Path $_.FullName 'node.exe' } |
        Where-Object { Test-Path -LiteralPath $_ } |
        Select-Object -First 1
}
if (-not $cadNode -or -not (Test-Path -LiteralPath $cadNode)) {
    throw 'Install Node.js 20+ or set CAD_AGENT_NODE to the full path of node.exe.'
}
$cadNodeVersion = & $cadNode --version
$cadVersionIsValid = $cadNodeVersion -match '^v(\d+)\.'
if ($LASTEXITCODE -ne 0 -or -not $cadVersionIsValid -or [int]$Matches[1] -lt 20) {
    throw "CAD Agent requires Node.js 20+. Found '$cadNodeVersion' at '$cadNode' (exit $LASTEXITCODE)."
}
if (-not (Test-Path -LiteralPath (Join-Path $cadRepo 'node_modules\@modelcontextprotocol\sdk\package.json'))) {
    throw 'MCP dependencies are missing. Run npm ci in the source checkout, then reinstall cad-agent from its local marketplace.'
}
& $cadNode (Join-Path $cadRepo 'src\index.js')
exit $LASTEXITCODE
