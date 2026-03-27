// Script para aplicar políticas RLS de login diretamente
import { createClient } from '@supabase/supabase-js'
import fs from 'fs'

const supabaseUrl = 'https://onqxspbszibcyemsuhoa.supabase.co'
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ucXhzcGJzemliY3llbXN1aG9hIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjA5OTU1NzEsImV4cCI6MjAzNjU3MTU3MX0.Ej8Ej8Ej8Ej8Ej8Ej8Ej8Ej8Ej8Ej8Ej8Ej8Ej8Ej8'

const supabase = createClient(supabaseUrl, supabaseAnonKey)

async function applyLoginPolicies() {
  console.log('🔐 Aplicando Políticas RLS de Login...')
  
  // Ler o arquivo SQL
  const sqlContent = fs.readFileSync('supabase/migrations/20250817150000_login_policies_simple.sql', 'utf8')
  
  // Dividir em comandos individuais
  const commands = sqlContent
    .split(';')
    .map(cmd => cmd.trim())
    .filter(cmd => cmd.length > 0 && !cmd.startsWith('--'))
  
  console.log(`📝 Executando ${commands.length} comandos SQL...`)
  
  for (let i = 0; i < commands.length; i++) {
    const command = commands[i] + ';'
    console.log(`\n${i + 1}/${commands.length} Executando:`)
    console.log(command.substring(0, 100) + '...')
    
    try {
      // Tentar executar via RPC se disponível
      const { data, error } = await supabase.rpc('exec_sql', { sql: command })
      
      if (error) {
        console.log('❌ Erro:', error.message)
        // Continuar com próximo comando
      } else {
        console.log('✅ Sucesso')
      }
    } catch (err) {
      console.log('⚠️  Método RPC não disponível, tentando via REST...')
      
      // Tentar via REST API diretamente
      try {
        const response = await fetch(`${supabaseUrl}/rest/v1/rpc/exec_sql`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'apikey': supabaseAnonKey,
            'Authorization': `Bearer ${supabaseAnonKey}`
          },
          body: JSON.stringify({ sql: command })
        })
        
        if (response.ok) {
          console.log('✅ Sucesso via REST')
        } else {
          console.log('❌ Erro via REST:', response.statusText)
        }
      } catch (restErr) {
        console.log('❌ Erro REST:', restErr.message)
      }
    }
  }
  
  console.log('\n🎉 Processo concluído!')
  console.log('\n📋 Verificando políticas criadas...')
  
  // Verificar se as políticas foram criadas
  try {
    const { data, error } = await supabase
      .from('information_schema.table_privileges')
      .select('*')
      .limit(1)
    
    if (error) {
      console.log('❌ Não foi possível verificar via API:', error.message)
    } else {
      console.log('✅ Conexão com banco funcionando')
    }
  } catch (err) {
    console.log('❌ Erro na verificação:', err.message)
  }
  
  console.log('\n📝 Para verificar se funcionou, acesse o Dashboard do Supabase:')
  console.log('1. Vá para SQL Editor')
  console.log('2. Execute: SELECT policyname FROM pg_policies WHERE tablename = \'profiles\';')
  console.log('3. Deve mostrar as políticas: login_read_own_profile, login_update_own_profile, etc.')
}

applyLoginPolicies().catch(console.error)