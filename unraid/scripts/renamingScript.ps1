Get-ChildItem *.mkv -R | Rename-Item -NewName { $_.Name -replace "\d\d\d","S01E01" }

Get-ChildItem *.avi -R | Rename-Item -NewName { $_.Name -replace " - 7"," - S07E" }

Get-ChildItem *.mkv -R | Rename-Item -NewName { "The Three Stooges - " + $_.Name }

(Get-ChildItem *.mkv -R) | Rename-Item -NewName {$_.Name -replace "^","The Three Stooges - "}

Get-ChildItem *.mkv -R | Rename-Item -NewName { $_.Name -replace "S01E","1934x" }
