$ErrorActionPreference = "Stop"

$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Resolve-Path (Join-Path $ScriptRoot "..\..")
Set-Location $ProjectRoot

$env:WGPU_BACKEND = "dx12"
$ManifestPath = ".\Bevy\Crates\Lesson_05_Basic2D\Cargo.toml"
if (-not (Test-Path $ManifestPath)) {
    throw "Lesson manifest not found: $ManifestPath"
}

cargo run --manifest-path $ManifestPath
