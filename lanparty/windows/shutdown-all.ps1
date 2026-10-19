#shutdown-all.ps1
ssh -o "StrictHostKeyChecking no" "sleepo@192.168.1.217" -- 'shutdown /p /f'
ssh -o "StrictHostKeyChecking no" "peepo@192.168.1.216" -- 'shutdown /p /f'
Pause
## TODO set up public key openssh generation and extraction