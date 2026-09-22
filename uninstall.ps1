@'
$repoPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$shortcutFile = Join-Path $repoPath "shortcuts.ps1"
$loadCommand = ". `"$shortcutFile`""

if (Test-Path $PROFILE) {
    $content = Get-Content $PROFILE

    $content = $content | Where-Object {
        $_ -ne $loadCommand -and $_ -ne "# Terminal Shortcuts"
    }

    $content | Set-Content $PROFILE
}

Write-Host "Terminal shortcuts removed from PowerShell profile."
'@ | Set-Content uninstall.ps1