## script_check_crlroot_sendmail
Checks Root CRL expiration and sends email alerts when threshold is reached

### Use 
Modifiy param :
```bash
$CRLPath = "D:\XXXX\XXXX.crl"
$emailTo = "XXXX@local.com"
$smtpServer = "smtp_XXXX.local"
$emailFrom = "crl-root-ca@XXX.local"
$logFile = "D:\XXXX\CRL_Email_log.txt"
$alertDays = 5
$checkDays = 15
```
