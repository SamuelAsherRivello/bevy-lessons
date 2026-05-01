$ErrorActionPreference = "Stop"

$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Resolve-Path (Join-Path $ScriptRoot "..\..")
Set-Location $ProjectRoot

function Stop-ProjectProcesses {
    $ProjectRootPattern = [regex]::Escape([string]$ProjectRoot)
    $LessonProcessPattern = "Lesson_0|lesson_0|bevy-lessons|bevy/dynamic_linking"
    $ProtectedProcessIds = [System.Collections.Generic.HashSet[int]]::new()
    $CurrentProcessId = $PID

    while ($CurrentProcessId -gt 0 -and $ProtectedProcessIds.Add($CurrentProcessId)) {
        $CurrentProcess = Get-CimInstance Win32_Process -Filter "ProcessId = $CurrentProcessId" -ErrorAction SilentlyContinue
        if ($null -eq $CurrentProcess) {
            break
        }

        $CurrentProcessId = [int]$CurrentProcess.ParentProcessId
    }

    Write-Host "Stopping stale lesson processes and build locks..."

    $Candidates = Get-CimInstance Win32_Process |
        Where-Object {
            $CommandLine = $_.CommandLine
            if ([string]::IsNullOrWhiteSpace($CommandLine)) {
                return $false
            }

            $IsRustBuildProcess = $_.Name -match "^(cargo|rustc|lesson_.*)\.exe$"
            $IsLessonScript = $_.Name -match "^(powershell|pwsh)\.exe$" -and
                ($CommandLine -match "Run_Lesson_" -or $CommandLine -match "Install_Dependencies")
            $IsThisWorkspace = $CommandLine -match $ProjectRootPattern -or $CommandLine -match $LessonProcessPattern

            ($IsRustBuildProcess -or $IsLessonScript) -and
                $IsThisWorkspace -and
                (-not $ProtectedProcessIds.Contains([int]$_.ProcessId))
        }

    foreach ($Candidate in $Candidates) {
        Write-Host "Stopping $($Candidate.Name) process $($Candidate.ProcessId)."
        Stop-Process -Id $Candidate.ProcessId -Force -ErrorAction SilentlyContinue
    }

    if ($Candidates) {
        Start-Sleep -Seconds 1
    }
    else {
        Write-Host "No stale lesson processes found."
    }
}

function Add-CargoToPathIfPresent {
    $CargoBin = Join-Path $env:USERPROFILE ".cargo\bin"
    if ((Test-Path $CargoBin) -and (-not (($env:Path -split ";") -contains $CargoBin))) {
        $env:Path = "$CargoBin;$env:Path"
    }
}

function Ensure-RustToolchain {
    Add-CargoToPathIfPresent

    if (Get-Command cargo -ErrorAction SilentlyContinue) {
        Write-Host "Rust is already installed."
        return
    }

    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        throw "Rust is not installed and winget is unavailable. Install rustup from https://rustup.rs/ and rerun this script."
    }

    Write-Host "Installing Rust via rustup..."
    winget install --id Rustlang.Rustup -e --accept-package-agreements --accept-source-agreements

    Add-CargoToPathIfPresent

    if (-not (Get-Command cargo -ErrorAction SilentlyContinue)) {
        throw "Rust installation finished, but cargo is not available in this PowerShell session yet. Open a new terminal and rerun this script."
    }
}

function Ensure-FastBevyBuildTools {
    Write-Host "Checking fast Bevy build tools..."

    $InstalledComponents = rustup component list --installed
    if ($InstalledComponents -notcontains "llvm-tools-x86_64-pc-windows-msvc") {
        Write-Host "Installing llvm-tools-preview for rust-lld..."
        rustup component add llvm-tools-preview
    }
    else {
        Write-Host "llvm-tools-preview is already installed."
    }

    if (-not (Get-Command cargo-objcopy -ErrorAction SilentlyContinue)) {
        Write-Host "Installing cargo-binutils..."
        cargo install -f cargo-binutils
    }
    else {
        Write-Host "cargo-binutils is already installed."
    }
}

function Ensure-LocalCargoConfig {
    $CargoConfigFolder = Join-Path $ProjectRoot ".cargo"
    $CargoConfigPath = Join-Path $CargoConfigFolder "config.toml"
    $CargoConfigContent = @'
[target.x86_64-pc-windows-msvc]
linker = "rust-lld.exe"
'@

    if (-not (Test-Path $CargoConfigFolder)) {
        New-Item -ItemType Directory -Path $CargoConfigFolder | Out-Null
    }

    if ((Test-Path $CargoConfigPath) -and ((Get-Content $CargoConfigPath -Raw).Trim() -eq $CargoConfigContent.Trim())) {
        Write-Host "Local Cargo config already uses rust-lld."
        return
    }

    Write-Host "Writing local Cargo config for rust-lld..."
    Set-Content -Path $CargoConfigPath -Value $CargoConfigContent
}

Ensure-RustToolchain
Ensure-FastBevyBuildTools
Ensure-LocalCargoConfig
Stop-ProjectProcesses -ProjectRoot $ProjectRoot

Write-Host ""
Write-Host "Building each lesson crate with the same dynamic-linking path used by the run scripts..."
$LessonManifests = @(
    ".\Bevy\Crates\Lesson_01_NoPlugins\Cargo.toml",
    ".\Bevy\Crates\Lesson_02_NoPluginsComponent\Cargo.toml",
    ".\Bevy\Crates\Lesson_03_SomePlugins\Cargo.toml",
    ".\Bevy\Crates\Lesson_04_DefaultPlugins\Cargo.toml",
    ".\Bevy\Crates\Lesson_05_Basic2D\Cargo.toml",
    ".\Bevy\Crates\Lesson_06_Basic3D\Cargo.toml"
)

foreach ($LessonManifest in $LessonManifests) {
    Write-Host "Building $LessonManifest..."
    cargo build --manifest-path $LessonManifest --features bevy/dynamic_linking
}

Write-Host ""
Write-Host "Dependency install complete. Lesson run scripts use prebuilt bevy/dynamic_linking targets by default for faster starts."

