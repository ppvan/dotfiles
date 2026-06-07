# ============================================================
# CoreUtils (UnixCompat for PowerShell)
# ============================================================

Set-StrictMode -Version Latest

# ------------------------------------------------------------
# File utilities
# ------------------------------------------------------------

function touch {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [string]$Path
    )

    if (Test-Path $Path) {
        (Get-Item $Path).LastWriteTime = Get-Date
    } else {
        New-Item -Path $Path -ItemType File | Out-Null
    }
}

function head {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [string]$Path,

        [Parameter(Position=1)]
        [ValidateRange(1, 1000000)]
        [int]$Count = 10
    )

    Get-Content -Path $Path -Head $Count
}

function realpath {
    param (
        [Parameter(Mandatory, Position=0)]
        [string]$Path
    )
    
    Resolve-Path $Path
}

function basename {
    param (
        [Parameter(Mandatory, Position=0)]
        [string]$Path
    )

    Resolve-Path $Path | Get-Item  | Select-Object Directory
}

function tail {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [string]$Path,

        [Parameter(Position=1)]
        [ValidateRange(1, 1000000)]
        [int]$Count = 10,

        [switch]$Follow
    )

    Get-Content -Path $Path -Tail $Count -Wait:$Follow
}

function unzip {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [string]$Path,

        [Parameter(Position=1)]
        [string]$Destination = (Get-Location).Path
    )

    $resolved = Resolve-Path $Path -ErrorAction Stop
    Expand-Archive -Path $resolved -DestinationPath $Destination -Force
}

function trash {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$Path
    )

    process {
        $fullPath = (Resolve-Path $Path -ErrorAction Stop).Path

        if ($PSCmdlet.ShouldProcess($fullPath, "Move to Recycle Bin")) {
            $shell = New-Object -ComObject 'Shell.Application'
            $folder = Split-Path $fullPath
            $name   = Split-Path $fullPath -Leaf

            $item = $shell.NameSpace($folder).ParseName($name)
            if ($item) {
                $item.InvokeVerb("delete")
            } else {
                Write-Error "Failed to trash: $fullPath"
            }
        }
    }
}

function env { 
    param([string]$filter)
    if ($filter) { Get-ChildItem Env: | Where-Object Name -like "*$filter*" }
    else { Get-ChildItem Env: }
}

function path { 
    param([string]$filter)
    if ($filter) { $env:PATH -split ';' | Select-String $filter }
    else { $env:PATH -split ';' }
}

function pwd {
    Get-Location
}

function wc {
    param([string[]]$files)
    foreach ($file in $files) {
        Get-Content $file | Measure-Object -Word -Line -Character |
            Select-Object Lines, Words, Characters, @{Name="FileName"; Expression={$file}}
    }
}


function sed {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [string]$Path,

        [Parameter(Mandatory)]
        [string]$Find,

        [Parameter(Mandatory)]
        [string]$Replace
    )

    if ($PSCmdlet.ShouldProcess($Path, "Replace text")) {
        (Get-Content $Path) -replace $Find, $Replace | Set-Content $Path
    }
}

# ------------------------------------------------------------
# Process utilities
# ------------------------------------------------------------

function pgrep {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [string]$Name
    )

    Get-Process -Name $Name -ErrorAction SilentlyContinue
}

function pkill {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, Position=0)]
        [string]$Name
    )

    Get-Process -Name $Name -ErrorAction SilentlyContinue | ForEach-Object {
        if ($PSCmdlet.ShouldProcess($_.Name, "Stop process")) {
            Stop-Process -Id $_.Id -Force
        }
    }
}

# ------------------------------------------------------------
# Environment
# ------------------------------------------------------------

function export {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidatePattern("^[A-Za-z_][A-Za-z0-9_]*$")]
        [string]$Name,

        [Parameter(Mandatory)]
        [string]$Value
    )

    Set-Item -Path "Env:$Name" -Value $Value
}

function which {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [string]$Name
    )

    Get-Command $Name | Select-Object -ExpandProperty Source
}

# ------------------------------------------------------------
# Clipboard
# ------------------------------------------------------------

function cpy {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        [string]$InputObject
    )

    process {
        Set-Clipboard $InputObject
    }
}

function pst {
    [CmdletBinding()]
    param()

    Get-Clipboard
}

# ------------------------------------------------------------
# System
# ------------------------------------------------------------

function df {
    [CmdletBinding()]
    param()

    Get-Volume
}

function wget {
    & "wget2.exe" @args
}

function uptime {
    [CmdletBinding()]
    param()

    try {
        $boot = (Get-Uptime -Since)
        $uptime = (Get-Date) - $boot

        [PSCustomObject]@{
            BootTime = $boot
            Uptime   = $uptime
            Days     = $uptime.Days
            Hours    = $uptime.Hours
            Minutes  = $uptime.Minutes
            Seconds  = $uptime.Seconds
        }
    } catch {
        Write-Error "Failed to get uptime"
    }
}

# ------------------------------------------------------------
# Misc
# ------------------------------------------------------------

function Invoke-Ls {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Args
    )

    eza --long --icons=auto @Args
}

function admin {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Command
    )

    if ($Command) {
        $cmd = $Command -join ' '
        Start-Process wt -Verb RunAs -ArgumentList "pwsh -NoExit -Command $cmd"
    } else {
        Start-Process wt -Verb RunAs
    }
}

# ------------------------------------------------------------
# Export
# ------------------------------------------------------------

Export-ModuleMember -Function *