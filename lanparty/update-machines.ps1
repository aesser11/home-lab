#update-machines.ps1
#https://powershell.one/code/11.html

#Get input prompt for which machines to turn on
#TODO create a MAP of HOSTS sleepo
$MacAddresses = @(
  "00:d8:61:f7:41:40", #sleepo@192.168.1.217
  "e8:9c:25:78:f6:9b"  #peepo@192.168.1.216 
)

$AddressesForSSH = @(
  "sleepo@192.168.1.217",
  "peepo@192.168.1.216" 
)

function Invoke-WakeOnLan
{
  param
  (
    # one or more MACAddresses
    [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
    # mac address must be a following this regex pattern:
    [ValidatePattern('^([0-9A-F]{2}[:-]){5}([0-9A-F]{2})$')]
    [string[]]
    $MacAddress 
  )
 
  begin
  {
    # instantiate a UDP client:
    $UDPclient = [System.Net.Sockets.UdpClient]::new()
  }
  process
  {
    foreach($_ in $MacAddress)
    {
      try {
        $currentMacAddress = $_
        
        # get byte array from mac address:
        $mac = $currentMacAddress -split '[:-]' |
          # convert the hex number into byte:
          ForEach-Object {
            [System.Convert]::ToByte($_, 16)
          }
 
        #region compose the "magic packet"
        
        # create a byte array with 102 bytes initialized to 255 each:
        $packet = [byte[]](,0xFF * 102)
        
        # leave the first 6 bytes untouched, and
        # repeat the target mac address bytes in bytes 7 through 102:
        6..101 | Foreach-Object { 
          # $_ is indexing in the byte array,
          # $_ % 6 produces repeating indices between 0 and 5
          # (modulo operator)
          $packet[$_] = $mac[($_ % 6)]
        }
        
        #endregion
        
        # connect to port 400 on broadcast address:
        $UDPclient.Connect(([System.Net.IPAddress]::Broadcast),4000)
        
        # send the magic packet to the broadcast address:
        $null = $UDPclient.Send($packet, $packet.Length)
        Write-Verbose "sent magic packet to $currentMacAddress..."
      }
      catch 
      {
        Write-Warning "Unable to send ${mac}: $_"
      }
    }
  }
  end
  {
    # release the UDF client and free its memory:
    $UDPclient.Close()
    $UDPclient.Dispose()
  }
}

foreach ($macAddress in $macAddresses) {
  Invoke-WakeOnLan -MacAddress $macAddress
}

Pause

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