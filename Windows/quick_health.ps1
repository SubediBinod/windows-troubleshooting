# Quick Health Check - read-only Windows triage
# Copyright (c) 2026 Binod Subedi. See repository LICENSE.
$ErrorActionPreference = 'SilentlyContinue'
$lines = [System.Collections.Generic.List[string]]::new()
$counts = @{ PASS = 0; WARN = 0; FAIL = 0; INFO = 0 }

function Add-Line([string]$Text) {
    $script:lines.Add($Text)
}
function Add-Result([string]$Status, [string]$Name, [string]$Detail) {
    if (-not $script:counts.ContainsKey($Status)) { $Status = 'INFO' }
    $script:counts[$Status]++
    Add-Line(('[{0}] {1}: {2}' -f $Status, $Name, $Detail))
}

$stamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
$report = Join-Path ([Environment]::GetFolderPath('Desktop')) ("Quick-Health-{0}-{1}.txt" -f $env:COMPUTERNAME, (Get-Date -Format 'yyyyMMdd-HHmmss'))
Add-Line('BINOD SUBEDI | WINDOWS TROUBLESHOOTING TOOLKIT')
Add-Line('QUICK HEALTH CHECK')
Add-Line(('Computer: {0} | User: {1} | Date: {2}' -f $env:COMPUTERNAME, $env:USERNAME, $stamp))
Add-Line(('OS: {0}' -f (Get-CimInstance Win32_OperatingSystem).Caption))
Add-Line(('Report: {0}' -f $report))
Add-Line(('=' * 76))

# Reachability, DNS and default gateway
try {
    $adapters = @(Get-NetAdapter -Physical | Where-Object Status -eq 'Up')
    if ($adapters.Count -gt 0) { Add-Result PASS 'Network adapter' ("{0} physical adapter(s) up: {1}" -f $adapters.Count, (($adapters | Select-Object -ExpandProperty Name) -join ', ')) }
    else { Add-Result WARN 'Network adapter' 'No physical network adapter is reported as Up; this may be normal for Wi-Fi/virtual-only systems.' }
} catch { Add-Result WARN 'Network adapter' 'Could not query physical adapters on this Windows build.' }

$gateways = @(Get-NetRoute -DestinationPrefix '0.0.0.0/0' | Where-Object State -eq 'Alive' | Select-Object -ExpandProperty NextHop -Unique)
if ($gateways.Count -gt 0) {
    Add-Result PASS 'Default gateway' ($gateways -join ', ')
    $gwOk = $false
    foreach ($gw in $gateways) { if (Test-Connection -ComputerName $gw -Count 1 -Quiet -ErrorAction SilentlyContinue) { $gwOk = $true; break } }
    if ($gwOk) { Add-Result PASS 'Gateway ping' 'At least one default gateway replied.' }
    else { Add-Result WARN 'Gateway ping' 'No gateway replied to ICMP. Firewalls may block ping; this alone does not prove failure.' }
} else { Add-Result WARN 'Default gateway' 'No IPv4 default route found.' }

$internet = Test-NetConnection -ComputerName '1.1.1.1' -Port 443 -InformationLevel Quiet -WarningAction SilentlyContinue
if ($internet) { Add-Result PASS 'Internet TCP reachability' 'TCP port 443 to 1.1.1.1 succeeded.' }
else { Add-Result WARN 'Internet TCP reachability' 'TCP port 443 to 1.1.1.1 failed; network policy, proxy, VPN or outage may explain this.' }
try {
    Resolve-DnsName 'www.microsoft.com' -Type A -ErrorAction Stop | Out-Null
    Add-Result PASS 'DNS resolution' 'www.microsoft.com resolved successfully.'
} catch { Add-Result WARN 'DNS resolution' 'Could not resolve www.microsoft.com; check DNS, VPN or network policy.' }

# CPU and memory snapshot
$cpu = Get-CimInstance Win32_Processor | Measure-Object -Property LoadPercentage -Average
if ($null -ne $cpu.Average) {
    $cpuLoad = [math]::Round($cpu.Average, 0)
    if ($cpuLoad -ge 90) { Add-Result WARN 'CPU load' ("Current average load is {0}%." -f $cpuLoad) }
    else { Add-Result PASS 'CPU load' ("Current average load is {0}%." -f $cpuLoad) }
} else { Add-Result INFO 'CPU load' 'Load percentage was not exposed by WMI.' }

$os = Get-CimInstance Win32_OperatingSystem
if ($os.TotalVisibleMemorySize -gt 0) {
    $totalGB = [math]::Round($os.TotalVisibleMemorySize / 1MB, 1)
    $freeGB = [math]::Round($os.FreePhysicalMemory / 1MB, 1)
    $usedPct = [math]::Round((1 - ($os.FreePhysicalMemory / $os.TotalVisibleMemorySize)) * 100, 0)
    if ($usedPct -ge 92) { Add-Result WARN 'Memory pressure' ("{0}% RAM in use; {1} GB free of {2} GB." -f $usedPct, $freeGB, $totalGB) }
    else { Add-Result PASS 'Memory pressure' ("{0}% RAM in use; {1} GB free of {2} GB." -f $usedPct, $freeGB, $totalGB) }
} else { Add-Result INFO 'Memory pressure' 'RAM usage could not be read.' }

# System drive free space
$systemDrive = $env:SystemDrive
$drive = Get-CimInstance Win32_LogicalDisk -Filter ("DeviceID='{0}'" -f $systemDrive)
if ($drive -and $drive.Size -gt 0) {
    $freePct = [math]::Round(($drive.FreeSpace / $drive.Size) * 100, 0)
    $freeGB = [math]::Round($drive.FreeSpace / 1GB, 1)
    if ($freePct -lt 10 -or $freeGB -lt 5) { Add-Result WARN 'System drive space' ("{0}: has {1}% free ({2} GB)." -f $systemDrive, $freePct, $freeGB) }
    else { Add-Result PASS 'System drive space' ("{0}: has {1}% free ({2} GB)." -f $systemDrive, $freePct, $freeGB) }
} else { Add-Result INFO 'System drive space' 'Could not read system drive capacity.' }

# Basic disk reliability indicators, when exposed
try {
    $disks = @(Get-PhysicalDisk)
    if ($disks.Count -gt 0) {
        foreach ($disk in $disks) {
            $health = [string]$disk.HealthStatus
            if ($health -and $health -notin @('Healthy','Unknown')) { Add-Result WARN 'Physical disk health' ("{0}: HealthStatus={1}, OperationalStatus={2}" -f $disk.FriendlyName, $health, ($disk.OperationalStatus -join ',')) }
            elseif ($health -eq 'Healthy') { Add-Result PASS 'Physical disk health' ("{0}: reports Healthy (not a guarantee against failure)." -f $disk.FriendlyName) }
            else { Add-Result INFO 'Physical disk health' ("{0}: health status is unavailable/unknown." -f $disk.FriendlyName) }
        }
    } else { Add-Result INFO 'Physical disk health' 'No physical disk data exposed by this storage provider.' }
} catch { Add-Result INFO 'Physical disk health' 'Storage health cmdlets are unavailable or blocked.' }

# Essential service states
foreach ($serviceName in @('EventLog','Winmgmt','Dhcp','Dnscache','MpsSvc')) {
    $svc = Get-Service -Name $serviceName
    if (-not $svc) { Add-Result INFO "Service $serviceName" 'Not found or not queryable.' }
    elseif ($svc.Status -eq 'Running') { Add-Result PASS "Service $serviceName" 'Running.' }
    elseif ($serviceName -in @('Dhcp','Dnscache','MpsSvc','EventLog','Winmgmt')) { Add-Result WARN "Service $serviceName" ("Status is {0}." -f $svc.Status) }
}

# Defender and firewall visibility
try {
    $mp = Get-MpComputerStatus
    if ($mp) {
        if ($mp.RealTimeProtectionEnabled) { Add-Result PASS 'Defender real-time protection' 'Enabled.' }
        else { Add-Result WARN 'Defender real-time protection' 'Not enabled; another managed antivirus may be intentional. Verify security status.' }
        $sigAge = $mp.AntivirusSignatureAge
        if ($null -ne $sigAge -and $sigAge -gt 7) { Add-Result WARN 'Defender signatures' ("Signature age is {0} day(s)." -f $sigAge) }
        elseif ($null -ne $sigAge) { Add-Result PASS 'Defender signatures' ("Signature age is {0} day(s)." -f $sigAge) }
    } else { Add-Result INFO 'Defender status' 'Status unavailable; another antivirus or policy may apply.' }
} catch { Add-Result INFO 'Defender status' 'Defender cmdlets unavailable or restricted by policy.' }
try {
    $fw = @(Get-NetFirewallProfile)
    $off = @($fw | Where-Object Enabled -eq $false)
    if ($fw.Count -gt 0 -and $off.Count -eq 0) { Add-Result PASS 'Windows Firewall' 'All reported profiles enabled.' }
    elseif ($off.Count -gt 0) { Add-Result WARN 'Windows Firewall' ("Disabled profile(s): {0}. Confirm this is intentional and policy-compliant." -f (($off | Select-Object -ExpandProperty Name) -join ', ')) }
    else { Add-Result INFO 'Windows Firewall' 'Could not read firewall profile state.' }
} catch { Add-Result INFO 'Windows Firewall' 'Firewall state unavailable.' }

# Recent critical/error events, limited to last 24 hours
$since = (Get-Date).AddHours(-24)
try {
    $critical = @(Get-WinEvent -FilterHashtable @{ LogName='System'; Level=1; StartTime=$since } -MaxEvents 20)
    if ($critical.Count -gt 0) { Add-Result WARN 'Recent critical System events' ("Found {0} critical event(s) in the last 24 hours. Inspect Event Viewer; this is not automatically a hardware diagnosis." -f $critical.Count) }
    else { Add-Result PASS 'Recent critical System events' 'No critical System events found in the last 24 hours.' }
} catch { Add-Result INFO 'Recent critical System events' 'Log unavailable or no matching events returned.' }
try {
    $unexpected = @(Get-WinEvent -FilterHashtable @{ LogName='System'; ProviderName='Microsoft-Windows-Kernel-Power'; Id=41; StartTime=$since } -MaxEvents 10)
    if ($unexpected.Count -gt 0) { Add-Result WARN 'Unexpected shutdown indicators' ("Found {0} Kernel-Power event 41 record(s) in the last 24 hours." -f $unexpected.Count) }
    else { Add-Result PASS 'Unexpected shutdown indicators' 'No Kernel-Power event 41 found in the last 24 hours.' }
} catch { Add-Result INFO 'Unexpected shutdown indicators' 'Event query unavailable.' }

# Uptime
try {
    $boot = $os.LastBootUpTime
    if ($boot) { Add-Result INFO 'System uptime' ("Last boot: {0}; uptime: {1} day(s)." -f $boot, [math]::Round(((Get-Date)-$boot).TotalDays,1)) }
} catch { }

Add-Line(('=' * 76))
Add-Line(('SUMMARY: PASS={0} WARN={1} FAIL={2} INFO={3}' -f $counts.PASS, $counts.WARN, $counts.FAIL, $counts.INFO))
Add-Line('Interpretation: this is a quick triage snapshot, not a definitive hardware or malware diagnosis.')
Add-Line('Network ping/port checks can be blocked by policy; SMART/health data may be unavailable.')
Add-Line('No repair, cleanup, stress test, packet capture, or restart was initiated by this script.')
$lines | Set-Content -LiteralPath $report -Encoding UTF8
foreach ($line in $lines) {
    if ($line -match '^\[PASS\]') { Write-Host $line -ForegroundColor Green }
    elseif ($line -match '^\[WARN\]') { Write-Host $line -ForegroundColor Yellow }
    elseif ($line -match '^\[FAIL\]') { Write-Host $line -ForegroundColor Red }
    else { Write-Host $line }
}
Write-Host ''
Write-Host ("Report saved to: {0}" -f $report) -ForegroundColor Cyan
Write-Host 'Press any key to return to the toolkit menu...'
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
