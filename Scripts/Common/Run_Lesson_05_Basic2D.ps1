param(
    [switch]$StaticLinking
)

$ErrorActionPreference = "Stop"
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Resolve-Path (Join-Path $ScriptRoot "..\..")

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

function Assert-CachedLesson {
    param(
        [string]$ManifestPath,
        [string]$TargetExe
    )

    if (-not (Test-Path $ManifestPath)) {
        throw "Lesson manifest not found: $ManifestPath"
    }

    if (-not (Test-Path $TargetExe)) {
        throw "Cached lesson executable not found: $TargetExe. Run Install_Dependencies.ps1 first."
    }

    $ManifestFolder = Split-Path -Parent (Resolve-Path $ManifestPath)
    $NewestInput = Get-ChildItem -Path $ManifestFolder -Recurse -File |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1

    foreach ($RootInputPath in @((Join-Path $ProjectRoot "Cargo.toml"), (Join-Path $ProjectRoot "Cargo.lock"))) {
        if (Test-Path $RootInputPath) {
            $RootInput = Get-Item $RootInputPath
            if (($null -eq $NewestInput) -or ($RootInput.LastWriteTime -gt $NewestInput.LastWriteTime)) {
                $NewestInput = $RootInput
            }
        }
    }

    if (($null -ne $NewestInput) -and ((Get-Item $TargetExe).LastWriteTime -lt $NewestInput.LastWriteTime)) {
        throw "Cached lesson executable is older than source files. Run Install_Dependencies.ps1 first."
    }
}

Stop-ProjectProcesses
Set-Location $ProjectRoot
$env:PATH = "$(Join-Path $ProjectRoot 'target\debug');$(Join-Path $ProjectRoot 'target\debug\deps');$env:PATH"
$env:WGPU_BACKEND = "dx12"

$ManifestPath = ".\Bevy\Crates\Lesson_05_Basic2D\Cargo.toml"
$TargetExe = Join-Path $ProjectRoot "target\debug\lesson_05_basic_2d.exe"

if ($StaticLinking) {
    cargo run --manifest-path $ManifestPath
    exit $LASTEXITCODE
}

Assert-CachedLesson -ManifestPath $ManifestPath -TargetExe $TargetExe
Write-Host "Running cached lesson through Cargo: $ManifestPath"
cargo run --manifest-path $ManifestPath --features bevy/dynamic_linking
exit $LASTEXITCODE
