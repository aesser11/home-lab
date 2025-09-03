# Script: CreateLogoutAndCleanupTask.ps1
# Description: Creates a scheduled task that runs at startup to log out of Steam & Discord and clear browser history.

$taskName = "LogoutAndClearHistoryAtStartup"
$scriptPath = "$env:ProgramData\LogoutAndCleanupScript.ps1"

$scriptContent = @'
# Kill Steam and Discord processes
Get-Process -Name "Steam", "Discord" -ErrorAction SilentlyContinue | Stop-Process -Force

Start-Sleep -Seconds 2  # Wait for processes to terminate cleanly

# ----- Steam Logout -----
$steamConfig = "$env:APPDATA\Steam\config\loginusers.vdf"
if (Test-Path $steamConfig) {
    Remove-Item $steamConfig -Force -ErrorAction SilentlyContinue
    Write-Output "Deleted Steam login session."
}
# Optional: Remove Steam Guard "remember me" files
$steamSSFN = Get-ChildItem "$env:PROGRAMFILES(x86)\Steam\" -Filter "ssfn*" -ErrorAction SilentlyContinue
foreach ($file in $steamSSFN) {
    Remove-Item $file.FullName -Force -ErrorAction SilentlyContinue
}

# ----- Discord Logout -----
$discordStorage = "$env:APPDATA\discord\Local Storage\leveldb"
if (Test-Path $discordStorage) {
    Remove-Item "$discordStorage\*" -Force -ErrorAction SilentlyContinue
    Write-Output "Cleared Discord local storage (forced logout)."
}
# Optional: Remove cookies and preferences
$discordCookies = "$env:APPDATA\discord\Cookies"
$discordPrefs = "$env:APPDATA\discord\Preferences"
Remove-Item $discordCookies, $discordPrefs -Force -ErrorAction SilentlyContinue

# ----- Clear Edge Browsing History -----
Remove-Item "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\History*" -Force -ErrorAction SilentlyContinue
Remove-Item "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue

# ----- Clear Chrome Browsing History -----
Remove-Item "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\History*" -Force -ErrorAction SilentlyContinue
Remove-Item "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue

# ----- Clear Firefox Browsing History -----
$firefoxProfiles = Get-ChildItem "$env:APPDATA\Mozilla\Firefox\Profiles\" -Directory -ErrorAction SilentlyContinue
foreach ($profile in $firefoxProfiles) {
    Remove-Item "$($profile.FullName)\places.sqlite" -Force -ErrorAction SilentlyContinue
    Remove-Item "$($profile.FullName)\cache2\*" -Recurse -Force -ErrorAction SilentlyContinue
}

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
$settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -ExecutionTimeLimit (New-TimeSpan -Minutes 15) `
    -StartWhenAvailable `
    -RunOnlyIfLoggedOn:$false `
    -WakeToRun:$false `
    -RunOnlyIfNetworkAvailable:$false `
    -RunOnlyIfIdle:$false

Register-ScheduledTask -TaskName $taskName `
    -Action $action `
    -Trigger $trigger `
    -Principal $principal `
    -Settings $settings `
    -Description "Logs out of Steam/Discord and clears browser history at startup." `
    -Force

Write-Host "Scheduled Task '$taskName' created successfully to run at system startup."
