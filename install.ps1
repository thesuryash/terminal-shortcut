$repoPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$shortcutFile = Join-Path $repoPath "shortcuts.ps1"

# Create PowerShell profile if it doesn't exist
if (!(Test-Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force | Out-Null
}

$loadCommand = ". `"$shortcutFile`""

# Read existing profile
$profileContent = ""
if (Test-Path $PROFILE) {
    $profileContent = Get-Content $PROFILE -Raw
}

# Add shortcut loader if not already present
if ($profileContent -notlike "*$shortcutFile*") {
    Add-Content $PROFILE ""
    Add-Content $PROFILE "# TerminalBrowser"
    Add-Content $PROFILE $loadCommand
}

# Load shortcuts immediately in this installer process
. $shortcutFile

Write-Host "TerminalBrowser installed."
Write-Host "Profile: $PROFILE"
Write-Host "Shortcuts: $shortcutFile"
Write-Host ""
Write-Host "Restart PowerShell or run:"
Write-Host ". `$PROFILE"
