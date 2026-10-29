$ErrorActionPreference = 'SilentlyContinue'
$script:SkipAnimation = $false

function Test-SkipKey {
    if ($script:SkipAnimation) { return $true }

    try {
        if ([Console]::KeyAvailable) {
            [void][Console]::ReadKey($true)
            $script:SkipAnimation = $true
            return $true
        }
    } catch {
        # Key polling may be unavailable if the script is launched without an interactive console.
    }

    return $false
}

function Start-IntroPause {
    param([int]$Milliseconds = 180)

    if (-not (Test-SkipKey) -and $Milliseconds -gt 0) {
        Start-Sleep -Milliseconds $Milliseconds
        [void](Test-SkipKey)
    }
}

function Write-TypeLine {
    param(
        [Parameter(Mandatory = $true)][string]$Text,
        [ConsoleColor]$ForegroundColor = [ConsoleColor]::Gray,
        [int]$Delay = 12
    )

    for ($i = 0; $i -lt $Text.Length; $i++) {
        if (Test-SkipKey) {
            Write-Host -NoNewline $Text.Substring($i) -ForegroundColor $ForegroundColor
            break
        }

        Write-Host -NoNewline $Text[$i] -ForegroundColor $ForegroundColor
        if ($Delay -gt 0) {
            Start-Sleep -Milliseconds $Delay
        }
    }

    Write-Host
    Start-IntroPause -Milliseconds 180
}

$cyan = [ConsoleColor]::Cyan
$white = [ConsoleColor]::White
$gray = [ConsoleColor]::Gray
$yellow = [ConsoleColor]::Yellow
$green = [ConsoleColor]::Green

Write-Host ('=' * 66) -ForegroundColor $cyan
Start-IntroPause -Milliseconds 250
Write-TypeLine '                   HI THERE, TROUBLESHOOTER!' $cyan 18
Write-Host ('=' * 66) -ForegroundColor $cyan
Start-IntroPause -Milliseconds 350
Write-Host
Write-Host ' Press any key to skip the animation and show the full intro.' -ForegroundColor DarkGray
Write-Host
Write-TypeLine " Welcome to the Toolkit. Something is broken, isn't it?" $white 16
Start-IntroPause -Milliseconds 250
Write-TypeLine ' Is Windows behaving perfectly today? How suspicious.' $gray 12
Write-TypeLine " If not, let's find out what is wrong before blaming the printer." $gray 12
Write-Host
Start-IntroPause -Milliseconds 250
Write-TypeLine (" PC NAME       : {0}" -f $env:COMPUTERNAME) $yellow 8
Write-TypeLine (" LOGGED-IN USER: {0}" -f $env:USERNAME) $yellow 8
Write-TypeLine (" DATE          : {0}" -f (Get-Date -Format 'ddd MM/dd/yyyy')) $yellow 8
Write-TypeLine (" TIME          : {0}" -f (Get-Date -Format 'HH:mm:ss')) $yellow 8
Write-Host
Write-Host ('-' * 66) -ForegroundColor $cyan
Start-IntroPause -Milliseconds 250
Write-TypeLine ' ABOUT THE AUTHOR' $cyan 16
Write-Host ('-' * 66) -ForegroundColor $cyan
Start-IntroPause -Milliseconds 180
Write-TypeLine " I'm Binod Subedi, an IT and Systems Engineer. I ask Windows what" $white 8
Write-TypeLine ' went wrong, interrogate the logs, and try not to take "have you' $white 8
Write-TypeLine ' tried turning it off and on again?" personally.' $white 8
Write-Host
Write-TypeLine ' GitHub   : https://github.com/SubediBinod' $green 4
Write-TypeLine ' LinkedIn : https://www.linkedin.com/in/binod-subedi-3238a7234/' $green 4
Write-TypeLine ' Portfolio: https://binodsubedi15.com.np' $green 4
Write-Host
Start-IntroPause -Milliseconds 250
Write-TypeLine ' This toolkit is a practical collection of diagnostic shortcuts' $gray 5
Write-TypeLine ' and scripts. Some checks need administrator rights or OEM tools.' $gray 5
Write-TypeLine ' Read prompts carefully; a few actions can restart the computer,' $gray 5
Write-TypeLine ' capture network traffic, or change system state.' $gray 5
Write-Host
Write-TypeLine ' Happy troubleshooting! May your logs be clear and your reboots few.' $yellow 8
Write-Host ('=' * 66) -ForegroundColor $cyan
Write-Host
