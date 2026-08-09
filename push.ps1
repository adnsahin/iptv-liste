# iptv-liste deposundaki degisiklikleri GitHub'a gonderir (push).
# KULLANIM: Once bu klasordeki panel.m3u / liste.m3u / turk.m3u dosyasini elle degistirip KAYDEDIN,
#           sonra push.bat'a cift tiklayin.

$ErrorActionPreference = 'Stop'
$env:Path = "$env:LOCALAPPDATA\PortableGit\cmd;$env:Path"

$repo = "C:\Users\MONSTER\Desktop\openai-test\TelegramArama\iptv-liste"

# turk.m3u 100MB'dan buyuk oldugu icin GitHub'a sığmaz.
# turk.m3u degistiyse once bol_turk.py ile 4 esit parcaya bolunur
# (turk1.m3u ... turk4.m3u) ve o parcalar push edilir.
$turkRaw = Join-Path $repo "turk.m3u"
if (Test-Path $turkRaw) {
    Write-Host "turk.m3u 4 parcaya bolunuyor..." -ForegroundColor Cyan
    Push-Location $repo
    python bol_turk.py
    Pop-Location
    Write-Host "tamam -> turk1.m3u ... turk4.m3u" -ForegroundColor Green
}

# Degisiklik var mi?
$status = git -C $repo status --porcelain
if (-not $status) {
    Write-Host "Degisiklik yok - push edilecek bir sey yok." -ForegroundColor Yellow
    exit 0
}

Write-Host "Degisen dosyalar:" -ForegroundColor Cyan
git -C $repo status --short
Write-Host ""

git -C $repo add -A
$tarih = Get-Date -Format "yyyy-MM-dd HH:mm"
git -C $repo commit -m "Elle guncelleme - $tarih" | Out-Null
Write-Host "GitHub'a push ediliyor..." -ForegroundColor Cyan
git -C $repo push

Write-Host ""
Write-Host "TAMAM! Adresler (degismedi):" -ForegroundColor Green
Write-Host "  https://raw.githubusercontent.com/adnsahin/iptv-liste/main/panel.m3u"
Write-Host "  https://raw.githubusercontent.com/adnsahin/iptv-liste/main/liste.m3u"
Write-Host "  https://raw.githubusercontent.com/adnsahin/iptv-liste/main/turk1.m3u"
Write-Host "  https://raw.githubusercontent.com/adnsahin/iptv-liste/main/turk2.m3u"
Write-Host "  https://raw.githubusercontent.com/adnsahin/iptv-liste/main/turk3.m3u"
Write-Host "  https://raw.githubusercontent.com/adnsahin/iptv-liste/main/turk4.m3u"
Write-Host "(4 listeyi de player'a ayri ayri ekleyin.)"
Write-Host "(Degisiklik player'a ~5 dakika icinde yansir.)"
