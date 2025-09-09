# Script: CreateLogoutAndCleanupTask.ps1
# Description: Creates a scheduled task that runs at startup to log out of Steam & Discord and clear browser history.

$taskName = "LogoutAndClearHistoryAtStartup"
$scriptPath = "$env:ProgramData\LogoutAndCleanupScript.ps1"

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

# Define scheduled task
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -WindowStyle Hidden -File `"$scriptPath`""
$trigger = New-ScheduledTaskTrigger -AtStartup
$principal = New-ScheduledTaskPrincipal -UserId "$env:USERNAME" -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit (New-TimeSpan -Minutes 15) -StartWhenAvailable

Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Description "Logs out of Steam/Discord and clears browser history at startup." -Force

Write-Host "Scheduled Task '$taskName' created successfully to run at system startup."
