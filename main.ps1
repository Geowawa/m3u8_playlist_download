# Open file dialog to get playlist file
Add-Type -AssemblyName System.Windows.Forms

$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 

    InitialDirectory = [Environment]::GetFolderPath('Desktop')    
}
$null = $FileBrowser.ShowDialog()

$filename = $FileBrowser.SafeFileName -replace ".{4}$" -replace(' ' , '')

#get desktop path & create folder
$DesktopPath = [Environment]::GetFolderPath("Desktop")
New-Item -ItemType directory -Path $DesktopPath\$filename

#init download Object
$WebClient = New-Object System.Net.WebClient

$n = 1000

foreach($line in Get-Content $FileBrowser.FileName) {

    if($line -match "http"){
        Write-Host "Downloading File $n"
        $WebClient.DownloadFile("$line","$DesktopPath\$filename\$n.ts")
        $n++
    }
}


# create join.bat
New-Item -Path $DesktopPath\$filename\join.bat -ItemType File
Add-Content -Path $DesktopPath\$filename\join.bat "copy /b $DesktopPath\$filename\*.ts $DesktopPath\$filename.ts"  
Start-Process $DesktopPath\$filename\join.bat

Write-Host "!!! FERTIG !!!"
Write-Host "!!! FERTIG !!!"
