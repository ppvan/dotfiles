
# ============================================================
# CDPath Module
# ============================================================

if (-not $env:CDPATH) {
    $env:CDPATH = "${HOME}:$HOME/Documents:$HOME/Downloads:$HOME/Documents/code"
}

function Get-CDPATHDirs {
    $env:CDPATH -split ':' | Where-Object { Test-Path $_ -PathType Container }
}

function Resolve-CDTarget ([string]$target) {
    if (Test-Path $target) {
        return (Resolve-Path $target).Path
    }

    foreach ($base in Get-CDPATHDirs) {
        $candidate = Join-Path $base $target
        if (Test-Path $candidate -PathType Container) {
            return $candidate
        }
    }
    return $null
}

function Set-LocationEnhanced {
    param(
        [Parameter(Position=0)]
        [string]$Path = $HOME,

        [switch]$PassThru
    )

    if ($Path -eq '-') {
        if ($global:__CDPrev) {
            $resolved = $global:__CDPrev
        } else {
            Write-Error "No previous directory"
            return
        }
    } else {
        $resolved = Resolve-CDTarget $Path
        if (-not $resolved) {
            Write-Error "cd: no such directory: $Path"
            return
        }
    }

    $global:__CDPrev = $PWD.Path
    Microsoft.PowerShell.Management\Set-Location $resolved

    if ($PassThru) { Get-Location }
}

function Register-CDPathCompleter {
    Register-ArgumentCompleter -CommandName 'Set-LocationEnhanced','cd' -ParameterName 'Path' -ScriptBlock {
        param($cmd, $param, $wordToComplete, $ast, $fakeBound)
        $results = [System.Collections.Generic.List[object]]::new()
        $seen    = [System.Collections.Generic.HashSet[string]]::new(
                       [System.StringComparer]::OrdinalIgnoreCase)

        # --- 1. CDPATH matches first (short-name, preferred) ---
        foreach ($base in Get-CDPATHDirs) {
            Get-ChildItem -Path $base -Directory -ErrorAction SilentlyContinue |
                Where-Object { $_.Name -like "$wordToComplete*" } |
                ForEach-Object {
                    if ($seen.Add($_.FullName)) {
                        $results.Add([System.Management.Automation.CompletionResult]::new(
                            $_.Name,
                            "$($_.Name)  [$base]",
                            'ProviderItem',
                            $_.FullName))
                    }
                }
        }

        # --- 2. CWD fallback (only dirs not already covered by CDPATH) ---
        Get-ChildItem -Path "$wordToComplete*" -Directory -ErrorAction SilentlyContinue |
            ForEach-Object {
                if ($seen.Add($_.FullName)) {
                    $results.Add([System.Management.Automation.CompletionResult]::new(
                        $_.FullName, $_.Name, 'ProviderItem', $_.FullName))
                }
            }

        $results
    }
}

# Export functions
Export-ModuleMember -Function Set-LocationEnhanced, Register-CDPathCompleter