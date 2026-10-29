# BINOD SUBEDI | Windows Troubleshooting Toolkit

A menu-driven, expandable collection of Windows diagnostic scripts. It helps investigate common faults without memorizing commands. It is broad, but no single toolkit can include literally every diagnostic for every Windows build, driver, app, hardware vendor, and enterprise configuration.

## Run it

1. Use **Code → Download ZIP** on GitHub and extract the folder, or clone:
   ```bat
   git clone https://github.com/SubediBinod/Repo-shared-with-gpt.git
   ```
2. Double-click `toolkit.bat`.
3. Start in a normal terminal. Use **Run as administrator** only when a check needs elevation.

## Diagnostic categories

- **Network:** IP configuration, ping, DNS lookup, route tracing, DNS cache, Wi-Fi profile names, active connections.
- **Advanced network:** adapters and link status, IP/gateway/DNS configuration, routing table, ARP cache, TCP port test, proxy, firewall profiles, Wi-Fi interface and network driver inventory.
- **System:** Windows version, hostname, logged-in user, full system summary.
- **Hardware:** manufacturer/model/BIOS, CPU, RAM modules, battery report, Plug and Play problem codes, display adapters and disk devices.
- **Storage:** free space, volume/file system status, physical disk health where supported, online CHKDSK scan, Disk Management.
- **Performance:** processes by CPU time and memory, memory counters, startup commands, process paths, Task Manager and Resource Monitor.
- **Windows health:** SFC verification, DISM component-store check, update service status, recent system errors, unexpected shutdown events.
- **Security:** Defender status where available, firewall profile status, local account names, current user/group information and pending reboot indicators.
- **Services and processes:** automatic services not running, service lookup/details, listening ports, process IDs and service mapping.
- **Peripherals:** printers and queues, Print Spooler, sound devices/services, Bluetooth, USB, cameras and device problem codes.
- **Applications and tasks:** installed application inventory, current-user Store packages, scheduled task results, signed drivers, startup commands, automatic services.
- **Event logs and crashes:** recent System/Application errors, app crash events, bugchecks, unexpected shutdowns, Windows Error Reporting and Reliability Monitor.
- **Power and sleep:** active plan, supported sleep states, last wake, wake-enabled devices, battery report, energy report, sleep-blocking requests.
- **Windows Update:** update services, installed hotfixes, Windows Update operational events, policy values and update settings/history.
- **Shortcuts:** Network settings, Device Manager, Event Viewer, Task Manager, Resource Monitor and Reliability Monitor.

## Repository layout

```text
Repo-shared-with-gpt/
├── toolkit.bat
├── README.md
├── Network/
│   ├── network.bat
│   └── network_deep.bat
├── Hardware/hardware.bat
├── Storage/storage.bat
├── Performance/performance.bat
├── Peripherals/peripherals.bat
├── Applications/apps_tasks.bat
├── Logs/logs.bat
├── Power/power.bat
├── Processes/services.bat
├── Security/security.bat
└── Windows/
    ├── system_info.bat
    ├── windows_health.bat
    └── update_diagnostics.bat
```

## Safety and interpretation

- These are diagnostic snapshots, not guaranteed diagnoses. Correlate output with the symptom and its time.
- The scripts primarily read information. Review commands before adding any repair or reset action.
- `sfc /verifyonly` verifies protected system files without attempting repair.
- `DISM /CheckHealth` checks whether component-store corruption has already been flagged; it is not a full scan or repair.
- `chkdsk C: /scan` requests an online scan of C: and does not request offline repair.
- Some commands and event logs need administrator rights for complete results. Unsupported cmdlets may return no data on older Windows builds.
- A service being stopped is not automatically a fault; some services are intentionally trigger-started or disabled.
- Event messages, installed software, account names, paths, network details, and driver inventories can contain private information. Redact before sharing.
- Wi-Fi profile listing does not reveal saved passwords. Never commit credentials, private logs, tokens, or personal data.

## Known limits

This is a practical general-purpose toolkit, not literally every Windows diagnostic. It does not replace OEM UEFI/hardware tests, advanced memory tests, specialist disk tools, malware forensics, packet capture, domain/Group Policy diagnostics, or troubleshooting tied to a particular application. Some hardware tests require rebooting into a diagnostic environment; some vendor tools must be downloaded separately. Add targeted scripts when real cases reveal gaps.

## Adding a tool

1. Create a focused script under the appropriate folder.
2. Prefer read-only checks and explain their purpose.
3. Add a numbered entry in `toolkit.bat`.
4. Test on a Windows machine before relying on it.
