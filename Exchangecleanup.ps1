write-host "Starting Exchange cleanup script. Written by Remco Daemen for NTS Solutions."

# Add this script to windows task scheduler with the following settings:
# Program:      C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
# Arguments:    -ExecutionPolicy Bypass -command "C:\Scripts\ClearGFILogs.ps1"
#
# Enable options to run wether user is logged in or not, with highest priviliges, every sunday at midnight.



$Path ="$env:SystemDrive\Program Files (x86)\GFI\MailEssentials\EmailSecurity\DebugLogs\*", "$env:SystemDrive\Program Files (x86)\GFI\MailEssentials\AntiSpam\DebugLogs\*", "$env:SystemDrive\inetpub\logs\*", "$env:windir\System32\LogFiles\*"

# How long do you want to keep files by default?
$Daysback = "3"

# How long do you want to keep .log files? (Recommended 30 days at least)
$DaysbackLog = "30"


$DatetoDelete = (Get-Date).AddDays(-$Daysback)
$DatetoDeleteLog = (Get-Date).AddDays(-$DaysbackLog)

Get-ChildItem $Path -recurse -filter *.log -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -lt $DatetoDeleteLog } | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue 
Get-ChildItem $Path -recurse -include *.tmp, *.xml, *.tmp -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -lt $DatetoDeleteLog } | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue 


# The following lines clears temp folder and empty folders in the temp folder.

Get-ChildItem "$env:windir\Temp", "$env:TEMP" -recurse -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue 
Get-ChildItem "$env:windir\Temp", "$env:TEMP" -recurse -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Where {$_.PSIsContainer -and @(Get-ChildItem -LiteralPath:$_.fullname).Count -eq 0} | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue 
