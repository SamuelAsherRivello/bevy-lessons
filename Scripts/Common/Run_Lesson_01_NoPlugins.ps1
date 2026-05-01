$ErrorActionPreference = "Stop"

$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Resolve-Path (Join-Path $ScriptRoot "..\..")
Set-Location $ProjectRoot

$ManifestPath = ".\Bevy\Crates\Lesson_01_NoPlugins\Cargo.toml"
if (-not (Test-Path $ManifestPath)) {
    throw "Lesson manifest not found: $ManifestPath"
}

cargo run --manifest-path $ManifestPath
