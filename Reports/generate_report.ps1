# Windows Support Report - read-only collection
# Copyright (c) 2026 Binod Subedi. See repository LICENSE.
$ErrorActionPreference = 'Continue'
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$desktop = [Environment]::GetFolderPath('Desktop')
if ([string]::IsNullOrWhiteSpace($desktop) -or -not (Test-Path -LiteralPath $desktop)) {
    $desktop = $env:TEMP
}
$reportPath = Join-Path $desktop ("Windows-Support-Report-{0}-{1}.txt" -f $env:COMPUTERNAME, $stamp)
$script:reportLines = [System.Collections.Generic.List[string]]::new()

function Add-Section([string]$Title) {
    $script:reportLines.Add('')
    $script:reportLines.Add(('=' * 84))
    $script:reportLines.Add($Title.ToUpperInvariant())
    $script:reportLines.Add(('=' * 84))
}
function Add-Text([string]$Text) {
    $script:reportLines.Add($Text)
}
function Add-CommandOutput([string]$Title, [scriptblock]$Command) {
    Add-Section $Title
    try {
        $output = & $Command 2>&1 | Out-String -Width 240
        if ([string]::IsNullOrWhiteSpace($output)) { Add-Text '(No output returned.)' }
        else { Add-Text $output.TrimEnd() }
    } catch {
        Add-Text ("[Collection error] {0}" -f $_.Exception.Message)
    }
}

Add-Text 'BINOD SUBEDI | WINDOWS TROUBLESHOOTING TOOLKIT'
Add-Text 'WINDOWS SUPPORT REPORT'
Add-Text ("Generated: {0}" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz'))
Add-Text ("Computer: {0}" -f $env:COMPUTERNAME)
Add-Text ("Logged-in user: {0}" -f ($env:USERDOMAIN + '\' + $env:USERNAME))
Add-Text ("Report path: {0}" -f $reportPath)
Add-Text 'Purpose: read-only troubleshooting snapshot. This report may contain sensitive system, account, software, and network details.'
Add-Text 'Review and redact it before sharing. Collection does not intentionally modify system settings.'

Add-CommandOutput 'Operating system and computer summary' {
    Get-CimInstance Win32_ComputerSystem |
        Select-Object Manufacturer, Model, SystemType, Domain, Workgroup, TotalPhysicalMemory |
        Format-List
    Get-CimInstance Win32_OperatingSystem |
        Select-Object Caption, Version, BuildNumber, OSArchitecture, InstallDate, LastBootUpTime |
        Format-List
    Get-CimInstance Win32_BIOS |
        Select-Object Manufacturer, SMBIOSBIOSVersion, ReleaseDate |
        Format-List
}
Add-CommandOutput 'CPU and memory inventory' {
    Get-CimInstance Win32_Processor |
        Select-Object Name, NumberOfCores, NumberOfLogicalProcessors, MaxClockSpeed, LoadPercentage |
        Format-Table -AutoSize
    Get-CimInstance Win32_PhysicalMemory |
        Select-Object DeviceLocator, BankLabel, Capacity, Speed, Manufacturer, PartNumber |
        Format-Table -AutoSize
    Get-CimInstance Win32_OperatingSystem |
        Select-Object @{N='TotalRAM_GB';E={[math]::Round($_.TotalVisibleMemorySize/1MB,2)}},
                      @{N='FreeRAM_GB';E={[math]::Round($_.FreePhysicalMemory/1MB,2)}} |
        Format-List
}
Add-CommandOutput 'Network adapters and IP configuration' {
    Get-NetAdapter | Select-Object Name, InterfaceDescription, Status, LinkSpeed, MacAddress |
        Format-Table -AutoSize
    Get-NetIPConfiguration | Format-List
    Get-DnsClientServerAddress | Format-Table -AutoSize
}
Add-CommandOutput 'IP configuration (ipconfig /all)' { ipconfig.exe /all }
Add-CommandOutput 'Routing table' { route.exe print }
Add-CommandOutput 'Active TCP connections (first 150)' {
    Get-NetTCPConnection |
        Select-Object -First 150 State, LocalAddress, LocalPort, RemoteAddress, RemotePort, OwningProcess |
        Format-Table -AutoSize
}
Add-CommandOutput 'Storage volumes and physical disks' {
    Get-CimInstance Win32_LogicalDisk -Filter 'DriveType=3' |
        Select-Object DeviceID, VolumeName, FileSystem,
            @{N='SizeGB';E={[math]::Round($_.Size/1GB,2)}},
            @{N='FreeGB';E={[math]::Round($_.FreeSpace/1GB,2)}},
            @{N='FreePercent';E={if ($_.Size -gt 0) {[math]::Round(100*$_.FreeSpace/$_.Size,1)} else {$null}}} |
        Format-Table -AutoSize
    try {
        Get-PhysicalDisk | Select-Object FriendlyName, MediaType, BusType, HealthStatus, OperationalStatus, Size |
            Format-Table -AutoSize
    } catch { Add-Text 'Get-PhysicalDisk data unavailable on this system.' }
}
Add-CommandOutput 'Top processes by CPU time and memory' {
    Get-Process | Sort-Object CPU -Descending | Select-Object -First 20 Name, Id, CPU, WorkingSet64 |
        Format-Table -AutoSize
    Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First 20 Name, Id,
        @{N='WorkingSetMB';E={[math]::Round($_.WorkingSet64/1MB,1)}} | Format-Table -AutoSize
}
Add-CommandOutput 'Automatic services that are not running' {
    Get-CimInstance Win32_Service -Filter "StartMode='Auto' AND State<>'Running'" |
        Select-Object Name, DisplayName, State, StartMode, StartName |
        Format-Table -AutoSize
}
Add-CommandOutput 'Windows Defender status' {
    try {
        Get-MpComputerStatus |
            Select-Object AMServiceEnabled, AntivirusEnabled, AntispywareEnabled,
                RealTimeProtectionEnabled, BehaviorMonitorEnabled, AntivirusSignatureLastUpdated,
                AntivirusSignatureAge |
            Format-List
        Get-MpThreatDetection | Select-Object -First 20 InitialDetectionTime, ThreatID, ActionSuccess, Resources |
            Format-Table -Wrap
    } catch { Add-Text 'Defender status is unavailable, blocked by policy, or managed by another security product.' }
}
Add-CommandOutput 'Windows Firewall profiles' {
    Get-NetFirewallProfile | Select-Object Name, Enabled, DefaultInboundAction, DefaultOutboundAction |
        Format-Table -AutoSize
}
Add-CommandOutput 'Installed Windows updates (latest 30 hotfix entries)' {
    Get-HotFix | Sort-Object InstalledOn -Descending | Select-Object -First 30 HotFixID, Description, InstalledBy, InstalledOn |
        Format-Table -AutoSize
}
Add-CommandOutput 'Recent System critical/error events (last 7 days, up to 100)' {
    Get-WinEvent -FilterHashtable @{LogName='System'; Level=@(1,2); StartTime=(Get-Date).AddDays(-7)} -MaxEvents 100 |
        Select-Object TimeCreated, Id, LevelDisplayName, ProviderName,
            @{N='Message';E={if ($_.Message) { $m=$_.Message -replace '\s+',' '; $m.Substring(0,[Math]::Min(500,$m.Length)) } else {''}}} |
        Format-Table -Wrap
}
Add-CommandOutput 'Recent Application critical/error events (last 7 days, up to 100)' {
    Get-WinEvent -FilterHashtable @{LogName='Application'; Level=@(1,2); StartTime=(Get-Date).AddDays(-7)} -MaxEvents 100 |
        Select-Object TimeCreated, Id, LevelDisplayName, ProviderName,
            @{N='Message';E={if ($_.Message) { $m=$_.Message -replace '\s+',' '; $m.Substring(0,[Math]::Min(500,$m.Length)) } else {''}}} |
        Format-Table -Wrap
}
Add-CommandOutput 'System reliability and Windows error reporting note' {
    'Open Reliability Monitor with: perfmon.exe /rel'
    'Open Event Viewer with: eventvwr.msc'
    'This report does not dump full event logs or collect file contents.'
}
Add-Section 'Collection summary and privacy reminder'
Add-Text 'Collection finished. Some sections can be empty or show errors when cmdlets are unavailable, access is restricted, or the PC is managed.'
Add-Text 'No repair, cleanup, stress test, packet capture, malware removal, or restart was initiated by this report generator.'
Add-Text 'Sensitive content may include usernames, device names, IP/MAC addresses, domain names, running process details, installed updates, and event messages.'
Add-Text 'Inspect the report and redact sensitive fields before sending it to anyone.'
$script:reportLines | Set-Content -LiteralPath $reportPath -Encoding UTF8
Write-Host ''
Write-Host 'Windows Support Report generated.' -ForegroundColor Green
Write-Host ("Saved to: {0}" -f $reportPath) -ForegroundColor Cyan
Write-Host 'The report may contain sensitive system and network information. Review it before sharing.'
Write-Host ''
try { Start-Process notepad.exe -ArgumentList $reportPath } catch { }
Write-Host 'Press any key to return to the toolkit menu...'
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
