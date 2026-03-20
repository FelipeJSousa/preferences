<#
.SYNOPSIS
    Gera scripts SQL para cada migração do Entity Framework Core individualmente.
.DESCRIPTION
    Este script lista todas as migrações disponíveis no projeto e gera um arquivo .sql para cada transição de migração, salvando-os no diretório database/scripts.
#>

$ErrorActionPreference = 'Stop'

# Configurações de Caminho
$solutionRoot = Resolve-Path "$PSScriptRoot/.."
$backendProject = Join-Path $solutionRoot "backend/src/Valid.Componentes.DigiPac.Infrastructure/Valid.Componentes.DigiPac.Infrastructure.csproj"
$startupProject = Join-Path $solutionRoot "backend/src/Valid.Componentes.DigiPac.Api/Valid.Componentes.DigiPac.Api.csproj"
$outputDir = Join-Path $solutionRoot "database/scripts"

# Garantir que o diretório de saída existe
if (!(Test-Path $outputDir)) {
    New-Item -ItemType Directory -Force -Path $outputDir | Out-Null
}

Write-Host "Obtendo lista de migrações..."
# Obtém a lista de migrações (removendo logs de build se houver)
$migrationsRaw = dotnet ef migrations list --project $backendProject --startup-project $startupProject --no-build

if ($LASTEXITCODE -ne 0) { Write-Error "Falha ao listar migrações."; exit 1 }

# Filtra apenas as linhas que parecem ser nomes de migração (ignorando 'Build started...', etc)
# Assume que nomes de migração contêm underscore (padrão timestamp_Nome)
$migrations = $migrationsRaw | Where-Object { $_ -match "^\d{14}_" }

if (!$migrations) {
    Write-Warning "Nenhuma migração encontrada."
    exit
}

$prev = "0"
$i = 1

foreach ($mig in $migrations) {
    # Remove sufixo (Pending) se existir
    $migClean = $mig -replace " \(Pending\)", ""
    
    $fileName = "{0:D2}_{1}.sql" -f $i, $migClean
    $outputPath = Join-Path $outputDir $fileName
    
    Write-Host "Gerando script para: $migClean (Base: $prev)"
    
    # Gera o script da migração anterior até a atual
    dotnet ef migrations script $prev $migClean --output $outputPath --project $backendProject --startup-project $startupProject --idempotent --no-build
    
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Erro ao gerar script para $migClean"
        exit 1
    }
    
    $prev = $migClean
    $i++
}

Write-Host "Scripts gerados com sucesso em: $outputDir"