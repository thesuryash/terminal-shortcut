# TerminalBrowser

TerminalBrowser is a lightweight PowerShell shortcut launcher that lets you open websites and perform searches directly from the terminal using simple commands.

Instead of manually typing URLs, you can define shortcuts in a JSON file and use commands such as:

```powershell
linkedin
github
gmail
chatgpt
google quantum computing
```

The project automatically loads these shortcuts into PowerShell whenever your profile starts.

## Project Structure

```text
TerminalBrowser/
├── shortcuts.json
├── shortcuts.ps1
├── install.ps1
├── uninstall.ps1
└── README.md
```

## How It Works

Shortcut definitions are stored in:

```text
shortcuts.json
```

PowerShell reads this file and dynamically creates terminal commands from each entry.

Example:

```json
{
  "linkedin": {
    "url": "https://www.linkedin.com/"
  },

  "github": {
    "url": "https://github.com/"
  },

  "gmail": {
    "url": "https://mail.google.com/"
  },

  "chatgpt": {
    "url": "https://chatgpt.com/"
  },

  "google": {
    "type": "search",
    "url": "https://www.google.com/search?q={query}",
    "default": "https://www.google.com/"
  }
}
```

This creates commands such as:

```powershell
linkedin
github
gmail
chatgpt
```

Search shortcuts can accept arguments:

```powershell
google quantum computing
```

which opens a Google search for:

```text
quantum computing
```

## Installation

Clone the repository:

```powershell
git clone https://github.com/YOURUSERNAME/TerminalBrowser.git
```

Enter the directory:

```powershell
cd TerminalBrowser
```

Run the installer:

```powershell
.\install.ps1
```

Reload your PowerShell profile:

```powershell
. $PROFILE
```

You can also simply close and reopen PowerShell.

## Editing Shortcuts

Run:

```powershell
configshortcuts
```

This opens:

```text
shortcuts.json
```

in the first available editor:

1. VS Code
2. Nano
3. Notepad

Add or modify shortcuts in the JSON file.

Example:

```json
"cornell": {
  "url": "https://www.cornell.edu/"
}
```

Then reload the shortcuts:

```powershell
reloadshortcuts
```

You can now run:

```powershell
cornell
```

## Adding a Basic Shortcut

Add an entry to `shortcuts.json`:

```json
"example": {
  "url": "https://example.com/"
}
```

Reload:

```powershell
reloadshortcuts
```

Then run:

```powershell
example
```

## Adding a Search Shortcut

A search shortcut uses `{query}` as a placeholder:

```json
"google": {
  "type": "search",
  "url": "https://www.google.com/search?q={query}",
  "default": "https://www.google.com/"
}
```

Running:

```powershell
google
```

opens Google normally.

Running:

```powershell
google powerShell scripting
```

opens a Google search for that query.

## Reloading Shortcuts

After editing `shortcuts.json`, run:

```powershell
reloadshortcuts
```

There is no need to restart PowerShell.

## PowerShell Compatibility

TerminalBrowser supports Windows PowerShell 5.1 and newer versions of PowerShell.

You can check your version with:

```powershell
$PSVersionTable.PSVersion
```

The shortcut loader avoids newer-only features such as:

```powershell
ConvertFrom-Json -AsHashtable
```

so it remains compatible with Windows PowerShell 5.1.

## PowerShell Profile

During installation, TerminalBrowser adds a loader entry to your PowerShell profile.

It will look similar to:

```powershell
. "C:\path\to\TerminalBrowser\shortcuts.ps1"
```

The installer determines the location of the repository automatically, so the project does not depend on a hard-coded installation path.

This means the repository can be cloned anywhere, such as:

```text
C:\Tools\TerminalBrowser
D:\Programming\TerminalBrowser
S:\Programming\TerminalBrowser
```

## Uninstall

Run:

```powershell
.\uninstall.ps1
```

Then restart PowerShell.

## Example Workflow

Edit your shortcuts:

```powershell
configshortcuts
```

Add:

```json
"jobs": {
  "url": "https://www.linkedin.com/jobs/"
}
```

Save the file.

Reload:

```powershell
reloadshortcuts
```

Then use:

```powershell
jobs
```

## Goals

TerminalBrowser is designed to be:

- Simple
- Portable
- Git-friendly
- Easy to configure
- Independent of installation location
- Compatible with Windows PowerShell 5.1+
- Easy to expand with additional shortcut types