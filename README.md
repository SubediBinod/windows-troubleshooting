# BINOD SUBEDI | Windows Troubleshooting Toolkit

A small, menu-driven collection of Windows diagnostic scripts. Add a script when you encounter a new problem, then link it from the main menu if it should be easy to find.

## Run it

1. Download the repository, or clone it:
   ```bat
   git clone https://github.com/SubediBinod/Repo-shared-with-gpt.git
   ```
2. Open the downloaded folder in File Explorer.
3. Double-click `toolkit.bat`.

Run from a normal Command Prompt first. Use **Run as administrator** only when a specific diagnostic or repair requires elevation.

## Current menu

- **Network diagnostics**: IP configuration, ping, DNS lookup, route tracing, DNS cache flush, Wi-Fi profile names, and active network connections.
- **System information**: computer name, Windows version, current user, and `systeminfo`.
- **Windows shortcuts**: open Network settings, Device Manager, and Event Viewer.

## Structure

```text
Repo-shared-with-gpt/
├── toolkit.bat
├── README.md
├── Network/
│   └── network.bat
└── Windows/
    └── system_info.bat
```

## Add another tool

1. Create a new `.bat` file in the relevant folder, such as `Hardware/drive_health.bat`.
2. Give it a clear title and explain what its commands do.
3. Add a numbered option to `toolkit.bat` that calls the new script.
4. Test it on a Windows machine before relying on it during troubleshooting.

Use PowerShell scripts (`.ps1`) when they make a task significantly clearer or more capable than batch. Keep repair actions separate from read-only diagnostics where possible, and explain before changing system settings.

## Safety notes

- Read diagnostic output before making changes.
- `ipconfig /flushdns` clears the local DNS cache; it does not change the configured DNS servers.
- `netstat -ano` shows network endpoints and process IDs, not a diagnosis by itself.
- The Wi-Fi option lists saved profile names only; it does not reveal passwords.
- Avoid putting passwords, tokens, private logs, or other sensitive data in this repository.
