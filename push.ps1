# iptv-liste deposundaki degisiklikleri GitHub'a gonderir (push).
# KULLANIM: Once bu klasordeki panel.m3u / liste.m3u / turk.m3u dosyasini elle degistirip KAYDEDIN,
#           sonra push.bat'a cift tiklayin.

$ErrorActionPreference = 'Stop'
$env:Path = "$env:LOCALAPPDATA\PortableGit\cmd;$env:Path"

$repo = "C:\Users\MONSTER\Desktop\openai-test\TelegramArama\iptv-liste"

# turk.m3u 100MB'dan buyuk oldugu icin GitHub'a sığmaz.
# turk.m3u degistiyse once gzip ile turk.m3u.gz uretilir ve o push edilir.
$turkRaw = Join-Path $repo "turk.m3u"
$turkGz  = Join-Path $repo "turk.m3u.gz"
if (Test-Path $turkRaw) {
    Write-Host "turk.m3u gzip sikistiriliyor..." -ForegroundColor Cyan
    $inStream  = [System.IO.File]::OpenRead($turkRaw)
    $outStream = [System.IO.File]::Create($turkGz)
    $gzip = New-Object System.IO.Compression.GZipStream($outStream, [System.IO.Compression.CompressionLevel]::Optimal)
    $inStream.CopyTo($gzip)
    $gzip.Dispose()
    $outStream.Dispose()
    $inStream.Dispose()
    Write-Host "tamam -> turk.m3u.gz" -ForegroundColor Green
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
Write-Host "  https://raw.githubusercontent.com/adnsahin/iptv-liste/main/turk.m3u.gz  (gzip - player otomatik acar)"
Write-Host "(Degisiklik player'a ~5 dakika icinde yansir.)"
