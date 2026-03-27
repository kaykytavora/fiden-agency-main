// Script para aplicar políticas RLS via API do Supabase
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = 'https://onqxspbszibcyemsuhoa.supabase.co'
const supabaseServiceKey = process.env.SUPABASE_SERVICE_KEY || 'YOUR_SERVICE_KEY_HERE'

// Nota: Você precisa do service_role key para executar SQL diretamente
const supabase = createClient(supabaseUrl, supabaseServiceKey)

const sqlCommands = [
  // Remover políticas existentes
  `DROP POLICY IF EXISTS "Allow authenticated users to read their own profile" ON public.profiles;`,
  `DROP POLICY IF EXISTS "Allow users to update their own profile" ON public.profiles;`,
  `DROP POLICY IF EXISTS "profiles_self_select" ON public.profiles;`,
  `DROP POLICY IF EXISTS "profiles_self_modify" ON public.profiles;`,
  `DROP POLICY IF EXISTS "profiles_admin_manage" ON public.profiles;`,
  
  // Criar índices
  `CREATE INDEX IF NOT EXISTS idx_profiles_user_id_login 
   ON public.profiles USING btree (user_id) 
   WHERE user_id IS NOT NULL;`,
  
  `CREATE INDEX IF NOT EXISTS idx_profiles_role_barbearia 
   ON public.profiles USING btree (role, barbearia_id) 
   WHERE role IN ('admin', 'funcionario');`,
  
  // Criar políticas
  `CREATE POLICY "login_read_own_profile"
   ON public.profiles
   FOR SELECT
   USING (auth.uid() = user_id);`,
   
  `CREATE POLICY "login_update_own_profile"
   ON public.profiles
   FOR UPDATE
   USING (auth.uid() = user_id)
   WITH CHECK (auth.uid() = user_id);`,
   
  `CREATE POLICY "login_insert_own_profile"
   ON public.profiles
   FOR INSERT
   WITH CHECK (auth.uid() = user_id);`,
   
  `CREATE POLICY "login_service_role_profiles"
   ON public.profiles
   FOR ALL
   USING (auth.role() = 'service_role')
   WITH CHECK (auth.role() = 'service_role');`
]

async function applyPolicies() {
  console.log('🔐 Aplicando Políticas RLS de Login...')
  
  for (let i = 0; i < sqlCommands.length; i++) {
    const sql = sqlCommands[i]
    console.log(`\n${i + 1}/${sqlCommands.length} Executando:`, sql.substring(0, 50) + '...')
    
    try {
      const { data, error } = await supabase.rpc('exec_sql', { sql })
      
      if (error) {
        console.log('❌ Erro:', error.message)
      } else {
        console.log('✅ Sucesso')
      }
    } catch (err) {
      console.log('❌ Erro:', err.message)
    }
  }
  
  // Verificar políticas criadas
  console.log('\n🔍 Verificando políticas criadas...')
  try {
    const { data, error } = await supabase
      .from('pg_policies')
      .select('policyname, cmd, permissive')
      .eq('tablename', 'profiles')
      .eq('schemaname', 'public')
    
    if (error) {
      console.log('❌ Erro ao verificar:', error.message)
    } else {
      console.log('✅ Políticas encontradas:', data.length)
      data.forEach(policy => {
        console.log(`  - ${policy.policyname} (${policy.cmd})`)
      })
    }
  } catch (err) {
    console.log('❌ Erro ao verificar:', err.message)
  }
}

// Executar
applyPolicies().catch(console.error)