# Relaunch the script with administrator privileges and bypass execution-policy if it isn't already
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File $PSCommandPath" -Verb RunAs
    exit
}


#################
# Reimage Steps #
#################
$firstRunFunctions1 = @(
    # user input required
    "renameComputer",#change-prompt-logic
    
    # tailored to my desired settings
    "downloadSoftware"
)

$finalFirstRunFunctions3 = @(
    # automated and universal
    "removeWin10Apps",

    "remainingStepsToText"
)

$everyRunFunctions2 = @(
    # universal functions
    "disableTelemetry",
    "setTimeZone",
    "disableStickyKeys",
    "soundCommsAttenuation",
    "disableMouseAcceleration",

    # tailored to my desired settings
    "modifyWindowsFeatures",
    "setPowerProfile",

    # functions exclusively for myself
    "enableGuestSMBShares",
    "uninstallOneDrive",
    "disableLocalIntranetFileWarnings",
    "advancedExplorerSettings"
)

$finalEveryRunFunctions4 = @(
    "promptForRestart"
)