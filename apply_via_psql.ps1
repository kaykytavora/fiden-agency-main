# Script PowerShell para aplicar políticas RLS via psql
# Você precisará inserir a senha do banco quando solicitado

$projectRef = "onqxspbszibcyemsuhoa"
$dbUrl = "postgresql://postgres@db.$projectRef.supabase.co:5432/postgres"

Write-Host "🔐 Aplicando Políticas RLS de Login..." -ForegroundColor Green
Write-Host "Conectando ao banco: $dbUrl" -ForegroundColor Yellow
Write-Host "Você precisará inserir a senha do banco quando solicitado." -ForegroundColor Yellow
Write-Host ""

# Verificar se psql está disponível
try {
    psql --version | Out-Null
    Write-Host "✅ psql encontrado" -ForegroundColor Green
} catch {
    Write-Host "❌ psql não encontrado. Instale o PostgreSQL client primeiro." -ForegroundColor Red
    Write-Host "Download: https://www.postgresql.org/download/windows/" -ForegroundColor Yellow
    exit 1
}

# Aplicar as políticas
Write-Host "Aplicando políticas RLS..." -ForegroundColor Blue
psql $dbUrl -f temp_apply_policies.sql

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Políticas RLS aplicadas com sucesso!" -ForegroundColor Green
    
    # Verificar se as políticas foram criadas
    Write-Host "Verificando políticas criadas..." -ForegroundColor Blue
    $verifyQuery = @"
SELECT 
  policyname,
  cmd,
  permissive
FROM pg_policies 
WHERE tablename = 'profiles' 
AND schemaname = 'public'
ORDER BY policyname;
"@
    
    echo $verifyQuery | psql $dbUrl
    
} else {
    Write-Host "❌ Erro ao aplicar políticas RLS" -ForegroundColor Red
    exit 1
}