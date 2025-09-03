# Script: CreateLogoutAndCleanupTask.ps1
# Description: Creates a scheduled task that runs at startup to log out of Steam & Discord and clear browser history.

$taskName = "LogoutAndClearHistoryAtStartup"
$scriptPath = "$env:ProgramData\LogoutAndCleanupScript.ps1"

$scriptContent = @'
# Kill Steam and Discord processes
Get-Process -Name "Steam", "Discord" -ErrorAction SilentlyContinue | Stop-Process -Force

Start-Sleep -Seconds 2  # Wait for processes to terminate cleanly

# ----- Steam Logout -----
Remove-Item -Path "C:\Program Files (x86)\Steam\config\loginusers.vdf" -Force -ErrorAction SilentlyContinue
Write-Output "Deleted Steam login session."

# ----- Discord Logout -----
Remove-Item -Path "C:\Users\%USERNAME%\AppData\Roaming\Discord\Local Storage\leveldb\" -Recurse -Force -ErrorAction SilentlyContinue
Write-Output "Cleared Discord local storage (forced logout)."

# ----- Clear Edge Browsing History -----
Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\History*" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue
Write-Output "Cleared Edge Browsing History"

# ----- Clear Chrome Browsing History -----
Remove-Item -Path "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\History*" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue
Write-Output "Cleared Chrome Browsing History"

# ----- Log the execution -----
Add-Content -Path "$env:ProgramData\LogoutAndCleanup.log" -Value "Task ran at $(Get-Date)"

'@

# Write cleanup script to disk
Set-Content -Path $scriptPath -Value $scriptContent -Encoding UTF8

# Ensure script execution is allowed
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine -Force

# Define scheduled task
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -WindowStyle Hidden -File `"$scriptPath`""
$trigger = New-ScheduledTaskTrigger -AtStartup
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit (New-TimeSpan -Minutes 15) -StartWhenAvailable

Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Description "Logs out of Steam/Discord and clears browser history at startup." -Force

Write-Host "Scheduled Task '$taskName' created successfully to run at system startup."
