$film = "EnterFilmName"

#get desktop path & create folder
$DesktopPath = [Environment]::GetFolderPath("Desktop")
New-Item -ItemType directory -Path $DesktopPath\$film

#init download Object
$WebClient = New-Object System.Net.WebClient

# Open file dialog to get m3u file
Add-Type -AssemblyName System.Windows.Forms

$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 

    InitialDirectory = [Environment]::GetFolderPath('Desktop')    
}
$null = $FileBrowser.ShowDialog()

$n = 1000

foreach($line in Get-Content $FileBrowser.FileName) {

    if($line -match "http"){
        Write-Host "Downloading File $n"
        $WebClient.DownloadFile("$line","$DesktopPath\$film\$n.ts")
        $n++
    }
}


# create join.bat
New-Item -Path $DesktopPath\$film\join.bat -ItemType File
Add-Content -Path $DesktopPath\$film\join.bat "copy /b $DesktopPath\$film\*.ts $DesktopPath\$film.ts"  
Start-Process $DesktopPath\$film\join.bat

Write-Host "!!! FERTIG !!!"
Write-Host "!!! FERTIG !!!"
