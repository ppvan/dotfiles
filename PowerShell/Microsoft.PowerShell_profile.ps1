# Starship prompt (PS1)
$env:STARSHIP_CONFIG = "$HOME\Documents\dotfiles\starship\starship.toml"
Invoke-Expression (&starship init powershell)

# Eza config
$env:EZA_CONFIG_DIR = "$HOME\Documents\dotfiles\eza"

# ----- CDPATH ----------------------------------
$env:CDPATH = "${HOME}:$HOME/Documents:$HOME/Downloads:$HOME/Documents/projects:."
Import-Module CDPath
Set-Alias -Name cd           -Value Set-LocationEnhanced -Scope Global -Option AllScope -Force
Set-Alias -Name Set-Location -Value Set-LocationEnhanced -Scope Global -Option AllScope -Force
Register-CDPathCompleter
# -----------------------------------------------

# Coreutils implemented using powershell----------------
Import-Module CoreUtils
Set-Alias ls Invoke-Ls
Set-Alias grep rg
# ------------------------------------------------------
# Add Scripts to PATH
$env:PATH += ";$PSScriptRoot\Scripts"

# Remove Windows system paths from completion candidates
$env:PATH = ($env:PATH -split ';' | Where-Object {
    $_ -notmatch 'WindowsPowerShell' -and
    $_ -notmatch 'WindowsApps' -and
    $_ -notmatch '^C:\\Program Files\\Common Files' -and
    $_ -notmatch 'C:\\Program Files\\PowerShell\\7\\'
} | Select-Object -Unique) -join ';'

# PSreadline ------------------------------------------------------------------------
$PSReadLineOptions = @{
    EditMode = 'Windows'
    HistoryNoDuplicates = $true
    HistorySearchCursorMovesToEnd = $true
    Colors = @{
        Command   = '#9ccfd8'  # foam
        Parameter = '#c4a7e7'  # iris
        Operator  = '#908caa'  # subtle
        Variable  = '#f6c177'  # gold
        String    = '#f6c177'  # gold
        Number    = '#ea9a97'  # love
        Type      = '#9ccfd8'  # foam
        Comment   = '#6e6a86'  # muted
        Keyword   = '#c4a7e7'  # iris
        Error     = '#eb6f92'  # love
    }
    PredictionSource = 'History'
    PredictionViewStyle = 'ListView'
    BellStyle = 'None'
}

Set-PSReadLineOption @PSReadLineOptions

# Custom key handlers
Set-PSReadLineKeyHandler -Chord Ctrl+a -Function BeginningOfLine
Set-PSReadLineKeyHandler -Chord Ctrl+e -Function EndOfLine
Set-PSReadLineKeyHandler -Chord Ctrl+k -Function KillLine
Set-PSReadLineKeyHandler -Chord Ctrl+u -Function BackwardKillLine
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
# Custom functions for PSReadLine
Set-PSReadLineOption -AddToHistoryHandler {
    param($line)
    $sensitive = @('password', 'secret', 'token', 'apikey', 'connectionstring')
    $hasSensitive = $sensitive | Where-Object { $line -match $_ }
    return ($null -eq $hasSensitive)
}

# Strip .exe/.cmd/.ps1 extensions from command name completions
$global:__OriginalTabExpansion2 = $function:TabExpansion2

function TabExpansion2 {
    param($inputScript, $cursorColumn, $options)

    $result = & $global:__OriginalTabExpansion2 $inputScript $cursorColumn $options

    if ($result -and $result.CompletionMatches) {
        $cleaned = $result.CompletionMatches
        | Where-Object {
            $completion = $_
            $completion.ResultType -ne 'Command' -or
            $completion.CompletionText -notmatch '^(Microsoft).*'
        } | ForEach-Object {
            $completion = $_
            # Only strip for command completions (not path/file completions)
            if ($completion.ResultType -eq 'Command' -and $completion.CompletionText -match '\.(exe|cmd|ps1)$') {
                [System.Management.Automation.CompletionResult]::new(
                    ($completion.CompletionText -replace '\.(exe|cmd|ps1)$', ''),
                    ($completion.ListItemText   -replace '\.(exe|cmd|ps1)$', ''),
                    $completion.ResultType,
                    $completion.ToolTip
                )
            } else {
                $completion
            }
        }
        # CompletionMatches is ReadOnlyCollection, must replace the whole result
        $result = [System.Management.Automation.CommandCompletion]::new(
            [System.Collections.ObjectModel.Collection[System.Management.Automation.CompletionResult]]$cleaned,
            $result.CurrentMatchIndex,
            $result.ReplacementIndex,
            $result.ReplacementLength
        )
    }

    $result
}

# Custom completion for common commands
$scriptblock = {
    param($wordToComplete, $commandAst, $cursorPosition)
    $customCompletions = @{
        'git' = @('status', 'add', 'commit', 'push', 'pull', 'clone', 'checkout', 'stash')
        'yarn' = @('install', 'start', 'run', 'test', 'build')
    }

    $command = $commandAst.CommandElements[0].Value
    if ($customCompletions.ContainsKey($command)) {
        $customCompletions[$command] | Where-Object { $_ -like "$wordToComplete*" } | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
    }
}

Register-ArgumentCompleter -Native -CommandName git, npm, deno -ScriptBlock $scriptblock
#-----------------------------------------------------------------------------------------------------------

