# BINOD SUBEDI | Windows Troubleshooting Toolkit

A growing, menu-driven collection of Windows diagnostic scripts. It is designed to help investigate common problems without memorizing commands. No toolkit can cover every Windows fault, device, driver, or vendor-specific diagnostic.

## Run it

1. Download this repository with **Code → Download ZIP**, then extract it; or clone it:
   ```bat
   git clone https://github.com/SubediBinod/Repo-shared-with-gpt.git
   ```
2. Open the extracted folder in File Explorer.
3. Double-click `toolkit.bat`.

Start in a normal terminal. Elevate to **Run as administrator** only when a particular check needs it. Some commands may return partial results without elevation.

## Available categories

- **Network:** IP configuration, ping, DNS lookup, route tracing, DNS cache, Wi-Fi profile names, and TCP connections.
- **System information:** OS, computer name, current user, and full system summary.
- **Hardware:** system/BIOS, CPU, RAM modules, battery report, device problem codes, display adapters, disk device summary.
- **Storage:** logical drive space, volume/file-system status, physical disk health where supported, online CHKDSK scan, Disk Management.
- **Performance:** top processes by CPU time and memory, memory counters, startup commands, process paths, Task Manager, Resource Monitor.
- **Windows health:** build details, SFC verification, DISM component-store check, Windows Update service state, recent system errors and unexpected shutdown events.
- **Security:** Microsoft Defender status where available, firewall profile status, local account names, current user's group memberships, pending-reboot indicators.
- **Services and processes:** stopped automatic services (filtered to reduce noise), service search/details, listening TCP ports, process/service lists.
- **Shortcuts:** Network settings, Device Manager, Event Viewer, Task Manager, and Resource Monitor.

## Structure

```text
Repo-shared-with-gpt/
├── toolkit.bat
├── README.md
├── Network/
│   └── network.bat
├── Hardware/
│   └── hardware.bat
├── Storage/
│   └── storage.bat
├── Performance/
│   └── performance.bat
├── Processes/
│   └── services.bat
├── Security/
│   └── security.bat
└── Windows/
    ├── system_info.bat
    └── windows_health.bat
```

## Add a diagnostic

1. Add a focused script in the matching folder, such as `Hardware/audio_devices.bat`.
2. Prefer read-only checks first and explain what output means.
3. Add a menu entry in `toolkit.bat` using `call "%~dp0Folder\script.bat"`.
4. Test the script on a Windows machine before relying on it.

Batch files are used for the menu and straightforward commands. PowerShell is called for structured system queries where it provides clearer output. Some checks depend on Windows version, edition, hardware, services, and permissions.

## Safety and interpretation

- These scripts primarily collect information; they are not a guarantee that a problem has been identified.
- Review output before attempting repairs. Do not run repair commands blindly.
- `sfc /verifyonly` verifies protected system files without attempting repair.
- `DISM /CheckHealth` checks whether component-store corruption has already been flagged; it is not the same as a full scan or repair.
- `chkdsk C: /scan` requests an online scan for C: and is not an offline repair.
- Battery reports and event logs may contain personal or device details. Review and redact output before sharing it.
- Wi-Fi diagnostics list saved profile names only; they do not print saved passwords.
- Avoid committing passwords, API keys, private logs, or personal data.
- Security checks are status snapshots, not a full security audit. A disabled feature may be intentional in some environments.

## Coverage boundaries

This is a practical starter collection, not literally every possible diagnostic. It does not replace OEM hardware tests, professional malware analysis, memory testing from boot media, specialist disk tools, or troubleshooting that depends on the exact symptom. Add targeted scripts as real issues arise.
