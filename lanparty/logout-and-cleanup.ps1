# Script: CreateLogoutAndCleanupTask.ps1
# Description: Creates a scheduled task that runs at startup to log out of Steam & Discord and clear browser history.

$taskName = "LogoutOfSteamAndDiscord"
$scriptPath = "$env:ProgramData\LogoutOfSteamAndDiscord.ps1"

$scriptContent = @'
Get-Process -Name "Steam", "Discord" -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 1
Remove-Item -Path "C:\Program Files (x86)\Steam\config\loginusers.vdf" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:appdata\discord\Local Storage\leveldb" -Recurse -Force -ErrorAction SilentlyContinue
'@

# Write cleanup script to disk
Set-Content -Path $scriptPath -Value $scriptContent -Encoding UTF8

# Ensure script execution is allowed
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine -Force

# Securely input the local users password 
$password = Read-Host "Enter the password for $env:COMPUTERNAME\$env:USERNAME" -AsSecureString
$password = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))

# Define scheduled task
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -WindowStyle Hidden -File `"$scriptPath`""
$trigger = New-ScheduledTaskTrigger -AtStartup
$settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit (New-TimeSpan -Minutes 2) -StartWhenAvailable

Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -RunLevel Highest -User "$env:COMPUTERNAME\$env:USERNAME" -Password $password -Settings $settings -Description "Logs out of Steam and Discord" -Force
