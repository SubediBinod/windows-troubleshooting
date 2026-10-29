# BINOD SUBEDI | Windows Troubleshooting Toolkit

A menu-driven, expandable collection of Windows diagnostic scripts. It covers common Windows, hardware, network, security and enterprise checks. It is not literally every diagnostic for every device: some tests need bootable media, OEM utilities, specialized tools, elevated access or physical inspection.

## Run it

1. Use **Code → Download ZIP** on GitHub and extract the folder, or clone:
   ```bat
   git clone https://github.com/SubediBinod/windows-troubleshooting.git
   ```
2. Double-click `toolkit.bat`.
3. Choose **Q — Quick Health Check** for a fast, read-only triage sweep and a timestamped report saved to the Desktop.
4. Start in a normal terminal; elevate only when a particular check needs it.

## Coverage

- **Quick Health Check:** quick gateway/internet/DNS checks, CPU and RAM pressure, system-drive free space, available physical-disk health indicators, essential service states, Defender/firewall visibility, recent critical System events and unexpected-shutdown indicators. Saves a timestamped report to the Desktop. Read-only; no repair or reboot.
- **Network:** IP configuration, ping, DNS, route tracing, DNS cache, Wi-Fi profile names, active connections, adapters, gateways, ARP, proxy, firewall and TCP tests.
- **Packet capture:** built-in Windows `pktmon` start/stop, ETL capture and PCAPNG conversion where supported. Wireshark is needed for detailed protocol inspection.
- **System:** Windows version/build, host/user and system summary.
- **Hardware:** board and BIOS identification, CPU model/cores/logical processors, firmware-reported RAM slots and module details, Windows Memory Diagnostic results/launch, storage reliability counters where supported, SMART failure-prediction status where exposed, WHEA hardware error events and storage-related events.
- **CMOS / RTC:** symptom checklist for clock resets and firmware settings loss. Windows generally cannot directly measure coin-cell voltage; physical inspection and the motherboard manual may be needed.
- **OEM diagnostics:** identify manufacturer/model, open firmware settings, optional driver settings, Device Manager, Reliability Monitor and System Information, with official support portals listed in the script.
- **Storage:** free space, volumes/file systems, disk status, online CHKDSK scan and Disk Management.
- **Performance:** process CPU time/memory, memory counters, startup commands, process paths, Task Manager and Resource Monitor.
- **Windows health and updates:** SFC verification, DISM component-store check, update services/hotfixes/events, system errors and unexpected shutdowns.
- **Security:** Defender and firewall status, accounts, group membership, pending-reboot indicators, Defender detections/exclusions, connections, processes, drivers, scheduled tasks, common Run keys and Defender event logs. Defender Offline scan is an explicitly confirmed reboot action.
- **Services, applications and tasks:** stopped automatic services, service lookup, listening ports, installed apps, Store packages, scheduled tasks, signed driver inventory and startup commands.
- **Peripherals:** printers/queues, audio, Bluetooth, USB, cameras and device problem codes.
- **Logs/crashes:** System/Application errors, app crashes, bugchecks, unexpected shutdowns, Windows Error Reporting and Reliability Monitor.
- **Power/sleep:** power plan, sleep states, wake source, wake-enabled devices, battery/energy reports and sleep-blocking requests.
- **Enterprise:** domain/workgroup, Group Policy reports, Entra ID/device registration status, domain-controller discovery, secure-channel test, user token/groups, SMB connections, firewall and policy-related event logs.
- **Shortcuts:** Device Manager, Event Viewer, Task Manager, Resource Monitor, Reliability Monitor and System Information.

## Repository layout

```text
Repo-shared-with-gpt/
├── toolkit.bat
├── README.md
├── Network/
│   ├── network.bat
│   ├── network_deep.bat
│   └── packet_capture.bat
├── Hardware/
│   ├── hardware.bat
│   ├── deep_hardware.bat
│   └── oem_tools.bat
├── Storage/storage.bat
├── Performance/performance.bat
├── Peripherals/peripherals.bat
├── Applications/apps_tasks.bat
├── Logs/logs.bat
├── Power/power.bat
├── Processes/services.bat
├── Security/
│   ├── security.bat
│   └── forensics.bat
├── Enterprise/enterprise.bat
└── Windows/
    ├── quick_health.bat
    ├── quick_health.ps1
    ├── system_info.bat
    ├── windows_health.bat
    └── update_diagnostics.bat
```

## Important hardware limitations

- **Motherboard failure:** Windows cannot conclusively prove a motherboard is faulty. Correlate WHEA events, crashes, power behavior, POST/UEFI diagnostics and component substitution; also consider PSU, cooling, RAM, CPU and firmware.
- **CPU threads:** the script reports firmware/OS-visible cores and logical processors. It does not prove every core/thread is stable. A repeatable CPU stress test and temperature/power monitoring are separate tests; use reputable tools and watch temperatures.
- **RAM slots:** SMBIOS/WMI data can be inaccurate or omit empty slots. To isolate a bad DIMM versus a bad slot, power down, follow the board manual, test one known-good module in recommended slots, and consider a bootable memory tester.
- **RAM health:** `mdsched.exe` restarts the PC and is a useful first check, not a guarantee. A bootable memory test such as MemTest86 can provide longer testing. A clean test does not exclude intermittent faults or memory-controller/board issues.
- **Disk health:** Windows health counters and SMART may not be exposed by every controller or USB enclosure. A blank result is not proof of health. Back up important data before intensive testing; consult the drive vendor's official diagnostics and logs.
- **CMOS/RTC:** a clock reset after power is removed or BIOS settings being lost can suggest an RTC battery, but time synchronization, firmware or board issues can cause similar symptoms. Use the exact board/laptop manual for replacement.
- **OEM tests:** use official utilities for the exact model, for example Dell SupportAssist/ePSA, HP PC Hardware Diagnostics, Lenovo diagnostics, ASUS diagnostics or the manufacturer's own UEFI tests. Availability varies by model.
- **Packet capture:** only capture traffic you are authorized to inspect. Capture files can expose internal IP addresses, DNS requests and sensitive metadata.
- **Malware triage:** inventory findings are leads, not proof. For a serious incident, preserve logs/evidence, avoid cleanup that destroys evidence, and involve the organization's security team. Defender Offline initiates a restart after explicit confirmation.
- **Enterprise:** domain commands require a suitable joined device, connectivity, permissions and organizational configuration. Do not change policy or repair domain trust automatically from a diagnostic script.

## Safety

- Prefer observation before repair. These scripts are diagnostic snapshots, not guaranteed diagnoses.
- Quick Health Check results are indicators, not a definitive diagnosis. ICMP/TCP/DNS checks may be blocked by VPNs, firewalls or company policy; disk health may be unavailable through some controllers; a clean snapshot does not rule out intermittent faults.
- `sfc /verifyonly` verifies protected system files without repairing them.
- `DISM /CheckHealth` checks whether component-store corruption has already been flagged; it is not a full scan or repair.
- `chkdsk C: /scan` requests an online scan, not offline repair.
- Review and redact event logs, Group Policy reports, process command lines, account names, paths, and network data before sharing.
- Do not commit credentials, private logs, tokens, or personal information.
- Do not flash BIOS/UEFI without a specific reason, correct model firmware, stable power and a recovery plan.

## External tools and official references

- Microsoft Windows Memory Diagnostic: run `mdsched.exe`; see [Microsoft's memory diagnostic guidance](https://support.microsoft.com/en-us/windows/experience/performance-optimization/how-to-fix-error-0xa-irql-not-less-or-equal).
- Microsoft Defender Offline: [official instructions](https://learn.microsoft.com/en-us/defender-endpoint/microsoft-defender-offline).
- Microsoft Sysinternals Sysmon for ongoing defensive telemetry: [official documentation](https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon). Sysmon logs activity; it does not independently decide whether activity is malicious.
- Packet analysis: [Wireshark](https://www.wireshark.org/) can inspect PCAP/PCAPNG captures; use an official download.
- Memory testing: [MemTest86](https://www.memtest86.com/) provides bootable memory testing; follow its official media instructions carefully.
- Drive tests: use the storage manufacturer's official diagnostic utility for the exact drive model.

## Add a diagnostic

1. Create a focused script in the appropriate folder.
2. Prefer read-only checks; label any reboot, elevated, capture, scan or repair action clearly.
3. Add a numbered entry in `toolkit.bat`.
4. Test each menu path on a real Windows machine before relying on it.
