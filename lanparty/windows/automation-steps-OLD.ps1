#$ip = Get-NetNeighbor | Where-Object { $_.LinkLayerAddress -eq "00:d8:61:f7:41:40" } | Select-Object IPAddress
#write-host $ip.IPAddress[1]

#How to open applications in the foregroujnd?
#- create a scheduled task!

#Open each of Steam, Discord, Nvidia app, etc. and let them download any updates.

#"C:\Program Files (x86)\Steam\steam.exe"
#"C:\Program Files (x86)\Steam\steam.exe" -shutdown
#delete steam installation folder -> /config/loginusers.vdf????
#delete steam installation folder -> /userdata???

#taskkill /F /IM discord.exe /T
#RMDIR /S /Q "C:\Users\%USERNAME%\AppData\Roaming\Discord\Local Storage\leveldb"
#"C:\Users\%username%\AppData\Local\Discord\Update.exe --processStart Discord.exe"

#"C:\Program Files\NVIDIA Corporation\NVIDIA app\CEF\NVIDIA App.exe"
#Start-Process ".\[nvidia-driver-name].exe" -ArgumentList "/s"

#foreach ($Address in $AddressesForSSH) {
#  ssh $Address | UsoClient.exe StartScan
#https://www.urtech.ca/2018/11/solved-easily-script-windows-10-to-download-install-and-restart-for-windows-updates/
#}