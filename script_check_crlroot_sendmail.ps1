#===============================================================================
# Script Name   : script_check_crlroot_sendmail.ps1
# Author        : GUERRY Cynthia (Eracy37)
# Version       : 1.0.0
# Last Modifed  : 16/04/2025
# Description   : Script to restart a service if a web page is not responding
#===============================================================================

$CRLPath = "D:\XXXX\XXXX.crl"
$emailTo = "XXXX@local.com"
$smtpServer = "smtp_XXXX.local"
$emailFrom = "crl-root-ca@XXX.local"
$logFile = "D:\XXXX\CRL_Email_log.txt"
$alertDays = 5
$checkDays = 15

if (Test-Path $logFile) {
    $logContent = Get-Content $logFile -First 1 -ErrorAction SilentlyContinue
    if ($logContent -match '^(\d{2}/\d{2}/\d{4} \d{2}:\d{2})$') {
        try {
            $lastAlert = [DateTime]::ParseExact($matches[1], 'dd/MM/yyyy HH:mm', $null)
            if ((Get-Date) -lt $lastAlert.AddDays($alertDays)) { exit }
        } catch {}
    }
}

$CRLInfo = certutil -v $CRLPath | out-string
$nextUpdateLine** = ($CRLInfo -split "`n" | Where-Object { $_ -match "NextUpdate:" } | Select-Object -Last 1)

if ($nextUpdateLine) {
    $nextUpdate = ($nextUpdateLine -split "NextUpdate:")[-1].Trim()
    $expireDate = [DateTime]::ParseExact($nextUpdate, "dd/MM/yyyy HH:mm", $null)
    $daysLeft = ($expireDate - (Get-Date)).Days

if ($daysLeft -lt $checkDays -and $daysLeft -ge 0) {
    $body = "CRL: $(Split-Path $CRLPath -Leaf)`nExpiration date: $($expireDate.ToString('yyyy-MM-dd'))`nDays remaining: $daysLeft"
    Send-MailMessage -From $emailFrom -To $emailTo -Subject "CRL Root CA Alert" -Body $body -SmtpServer $smtpServer
    Get-Date -Format "dd/MM/yyyy HH:mm" | Out-File $logFile -Force
}
