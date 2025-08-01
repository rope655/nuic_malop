# FTP connection info
$ftpBase = "ftp://ftp.ak2.ba/ak2Novo/"
$files = @("cfg.rar", "lib.rar", "rpt.rar", "dba.rar")
$destinationFolder = "C:\transfer"
$username = "gost@ak2.ba"
$password = "avz123pak456"

# Create WebClient and set credentials
$webclient = New-Object System.Net.WebClient
$webclient.Credentials = New-Object System.Net.NetworkCredential($username, $password)

# Ensure destination folder exists
if (!(Test-Path -Path $destinationFolder)) {
    New-Item -ItemType Directory -Path $destinationFolder | Out-Null
}

# Download each file
foreach ($file in $files) {
    $ftpFile = $ftpBase + $file
    $localFile = Join-Path $destinationFolder $file
    Write-Host "⬇️ Downloading $ftpFile to $localFile..."
    $webclient.DownloadFile($ftpFile, $localFile)
}

Write-Host "Sve stavke su uspjesno raspakirane"

# Extraction targets
$extractTargets = @{
    "cfg.rar" = "C:\ak2"
    "lib.rar" = "C:\ak2"
    "dba.rar" = "C:\ak2"
    "rpt.rar" = "C:\ak2\rpt"
}

# Ensure extraction folders exist
foreach ($dest in $extractTargets.Values | Select-Object -Unique) {
    if (!(Test-Path -Path $dest)) {
        New-Item -ItemType Directory -Path $dest | Out-Null
    }
}

# Determine extraction tool
$unrarPath = "C:\Program Files\WinRAR\unrar.exe"
$sevenZipPath64 = "C:\Program Files\7-Zip\7z.exe"
$sevenZipPath32 = "C:\Program Files (x86)\7-Zip\7z.exe"

$extractor = $null
$mode = ""

if (Test-Path $unrarPath) {
    $extractor = $unrarPath
    $mode = "winrar"
    Write-Host "Koristim WinRAR za raspakiravanje..."
} elseif (Test-Path $sevenZipPath64) {
    $extractor = $sevenZipPath64
    $mode = "7zip"
    Write-Host "Koristim 7zip za raspakiravanje..."
} elseif (Test-Path $sevenZipPath32) {
    $extractor = $sevenZipPath32
    $mode = "7zip"
    Write-Host "Koristim 7 zip za raspakiravanje..."
} else {
    Write-Error "Nemam ni 7Zip ni WinRAR, ne mogu raspakirati stavke."
    exit 1
}

# Extract files
foreach ($file in $files) {
    $sourceRar = Join-Path $destinationFolder $file
    if ($extractTargets.ContainsKey($file)) {
        $targetFolder = $extractTargets[$file]
        Write-Host "Extracting $file to $targetFolder..."
        
        if ($mode -eq "winrar") {
            & "$extractor" x -o+ "$sourceRar" "$targetFolder" | Out-Null
        } elseif ($mode -eq "7zip") {
            & "$extractor" x "$sourceRar" -o"$targetFolder" -y | Out-Null
        }
    }
}

Write-Host "Sve su stavke uspjesno raspakirane."
Write-Host "ZADATAK OBAVLJEN IZVRSNO!"


$chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
$imageUrl = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR1EOsN1s--tHB53Gbk5jYyJR0oADeAbceGgQ&s"

if (Test-Path $chromePath) {
    Start-Process -FilePath $chromePath -ArgumentList $imageUrl
} else {
    Write-Warning "Google Chrome nije pronađen na očekivanoj lokaciji: $chromePath"
}
