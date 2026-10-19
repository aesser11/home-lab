# Requires Admin: Updating ProgramData and other users' shortcuts
# Run PowerShell as Administrator

# Shortcut file name
$shortcutName = "Microsoft Edge.lnk"

# Define common locations to search for Edge shortcuts
$locations = @(
    "$env:ProgramData\Microsoft\Windows\Start Menu\Programs",
    "$env:Public\Desktop"
)

# Add each user's Start Menu and Desktop
$usersFolder = "C:\Users"
Get-ChildItem -Path $usersFolder -Directory | ForEach-Object {
    $userProfile = $_.FullName
    $locations += @(
        "$userProfile\Desktop",
        "$userProfile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs"
    )
}

# Track how many were updated
$updatedCount = 0

foreach ($location in $locations) {
    $shortcutPath = Join-Path $location $shortcutName
    if (Test-Path $shortcutPath) {
        try {
            $shell = New-Object -ComObject WScript.Shell
            $shortcut = $shell.CreateShortcut($shortcutPath)

            # Only update if '--guest' isn't already there
            if ($shortcut.Arguments -notmatch "--guest") {
                $shortcut.Arguments = "--guest " + $shortcut.Arguments.Trim()
                $shortcut.Save()
                Write-Host "✅ Updated: $shortcutPath"
                $updatedCount++
            } else {
                Write-Host "ℹ️ Already set: $shortcutPath"
            }
        } catch {
            Write-Warning "⚠️ Failed to update: $shortcutPath - $_"
        }
    }
}

Write-Host "`n🎉 Done. Total shortcuts updated: $updatedCount"
