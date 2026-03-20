Remove-Item "$env:APPDATA\Docker\*.tmp-settings-store*" -Force -ErrorAction SilentlyContinue
Remove-Item "$env:APPDATA\Docker\settings-store.json" -Force -ErrorAction SilentlyContinue
Remove-Item "$env:USERPROFILE\.docker\*.tmp-daemon*" -Force -ErrorAction SilentlyContinue

# 1. Corrigir pasta .docker no usuário
$dockerPath = "$env:USERPROFILE\.docker"
takeown /F $dockerPath /R /D Y
icacls $dockerPath /grant:r "$($env:USERNAME):(OI)(CI)F" /T
Remove-Item "$dockerPath\*.tmp-daemon*" -Force -ErrorAction SilentlyContinue

# 2. Corrigir pasta Docker no AppData
$appDataPath = "$env:APPDATA\Docker"
takeown /F $appDataPath /R /D Y
icacls $appDataPath /grant:r "$($env:USERNAME):(OI)(CI)F" /T
Remove-Item "$appDataPath\*.tmp-settings-store*" -Force -ErrorAction SilentlyContinue

Write-Host "Limpeza concluída. Tente abrir o Docker Desktop agora." -ForegroundColor Green