$script:TerminalBrowserRoot = $PSScriptRoot
$script:ShortcutConfig = Join-Path $PSScriptRoot "shortcuts.json"

# --------------------------------------------------
# Platform detection
# --------------------------------------------------

$script:TBIsWindows = $false
$script:TBIsMacOS   = $false
$script:TBIsLinux   = $false

if ($PSVersionTable.PSEdition -eq "Desktop") {
    # Windows PowerShell 5.1
    $script:TBIsWindows = $true
}
else {
    # PowerShell 6/7+
    $script:TBIsWindows = $IsWindows
    $script:TBIsMacOS   = $IsMacOS
    $script:TBIsLinux   = $IsLinux
}


# --------------------------------------------------
# Open URL in default browser
# --------------------------------------------------

function Open-TerminalBrowserUrl {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Url
    )

    if ($script:TBIsWindows) {
        Start-Process $Url
    }
    elseif ($script:TBIsMacOS) {
        & open $Url
    }
    elseif ($script:TBIsLinux) {
        & xdg-open $Url
    }
    else {
        Write-Error "Unsupported operating system."
    }
}


# --------------------------------------------------
# Import shortcuts.json
# --------------------------------------------------

function Import-TerminalShortcuts {

    if (!(Test-Path $script:ShortcutConfig)) {
        Write-Error "Shortcut config not found: $script:ShortcutConfig"
        return
    }

    $config = Get-Content $script:ShortcutConfig -Raw |
        ConvertFrom-Json

    foreach ($property in $config.PSObject.Properties) {

        $name = $property.Name
        $shortcut = $property.Value

        if ($shortcut.type -eq "search") {

            $searchUrl = $shortcut.url
            $defaultUrl = $shortcut.default

            $functionBody = {
                param(
                    [Parameter(ValueFromRemainingArguments = $true)]
                    [string[]]$Query
                )

                if ($Query.Count -eq 0) {
                    Open-TerminalBrowserUrl $defaultUrl
                }
                else {
                    $queryText = [uri]::EscapeDataString(($Query -join " "))
                    $finalUrl = $searchUrl.Replace("{query}", $queryText)

                    Open-TerminalBrowserUrl $finalUrl
                }
            }.GetNewClosure()

        }
        else {

            $url = $shortcut.url

            $functionBody = {
                Open-TerminalBrowserUrl $url
            }.GetNewClosure()
        }

        Set-Item "Function:\global:$name" $functionBody
    }
}


# --------------------------------------------------
# Edit shortcuts.json
# --------------------------------------------------

function configshortcuts {

    if (Get-Command code -ErrorAction SilentlyContinue) {
        & code $script:ShortcutConfig
    }
    elseif (Get-Command nano -ErrorAction SilentlyContinue) {
        & nano $script:ShortcutConfig
    }
    elseif ($script:TBIsWindows) {
        & notepad $script:ShortcutConfig
    }
    elseif ($script:TBIsMacOS) {
        & open -e $script:ShortcutConfig
    }
    elseif ($script:TBIsLinux) {
        & xdg-open $script:ShortcutConfig
    }
    else {
        Write-Error "No supported editor found."
    }
}


# --------------------------------------------------
# Reload
# --------------------------------------------------

function reloadshortcuts {
    Import-TerminalShortcuts
    Write-Host "TerminalBrowser shortcuts reloaded."
}


# Load shortcuts automatically
Import-TerminalShortcuts