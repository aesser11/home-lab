# Script: CreateLogoutAndCleanupTask.ps1
# Description: Creates a scheduled task that runs at startup to log out of Steam & Discord and clear browser history.
# Relaunch the script with administrator privileges and bypass execution-policy if it isn't already
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File $PSCommandPath" -Verb RunAs
    exit
}

$taskName = "LogoutOfSteamAndDiscord"
$scriptPath = "$env:ProgramData\LogoutOfSteamAndDiscord.ps1"

#TODO add logout for epic launcher, battle.net, origin, gog galaxy, etc...  
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
