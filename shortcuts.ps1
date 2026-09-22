$script:TerminalBrowserRoot = $PSScriptRoot
$script:ShortcutConfig = Join-Path $PSScriptRoot "shortcuts.json"

function Import-TerminalShortcuts {

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
                    Start-Process $defaultUrl
                }
                else {
                    $queryText = [uri]::EscapeDataString(($Query -join " "))
                    $finalUrl = $searchUrl.Replace("{query}", $queryText)

                    Start-Process $finalUrl
                }
            }.GetNewClosure()

        }
        else {

            $url = $shortcut.url

            $functionBody = {
                Start-Process $url
            }.GetNewClosure()
        }

        Set-Item "Function:\global:$name" $functionBody
    }
}

function configshortcuts {

    if (Get-Command code -ErrorAction SilentlyContinue) {
        code $script:ShortcutConfig
    }
    elseif (Get-Command nano -ErrorAction SilentlyContinue) {
        nano $script:ShortcutConfig
    }
    else {
        notepad $script:ShortcutConfig
    }
}


function reloadshortcuts {
    Import-TerminalShortcuts
    Write-Host "Terminal shortcuts reloaded."
}


Import-TerminalShortcuts