-- ================================================
-- VERIFICAR E CORRIGIR TRIGGER handle_new_user
-- ================================================

-- 1. Verificar se o trigger existe na tabela auth.users
SELECT 
    t.tgname as trigger_name,
    e.relname as table_name,
    t.tgenabled as enabled
FROM pg_trigger t
JOIN pg_class e ON e.oid = t.tgrelid
WHERE t.tgname = 'handle_new_user_trigger';

-- 2. Se não existir, criar o trigger
DROP TRIGGER IF EXISTS handle_new_user_trigger ON auth.users;
CREATE TRIGGER handle_new_user_trigger
AFTER INSERT ON auth.users
FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- 3. Garantir políticas RLS para o trigger funcionar
DROP POLICY IF EXISTS "Handle new user can insert profile" ON public.profiles;
CREATE POLICY "Handle new user can insert profile"
ON public.profiles
FOR INSERT
TO authenticated
WITH CHECK (true);

DROP POLICY IF EXISTS "Handle new user can insert barbearia" ON public.barbearias;
CREATE POLICY "Handle new user can insert barbearia"
ON public.barbearias
FOR INSERT
TO authenticated
WITH CHECK (true);

DROP POLICY IF EXISTS "Handle new user can insert funcionario" ON public.funcionarios;
CREATE POLICY "Handle new user can insert funcionario"
ON public.funcionarios
FOR INSERT
TO authenticated
WITH CHECK (true);

DROP POLICY IF EXISTS "Handle new user can update profile" ON public.profiles;
CREATE POLICY "Handle new user can update profile"
ON public.profiles
FOR UPDATE
TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

-- 4. Testar: ver últimos perfis criados
SELECT 
    p.user_id,
    p.name,
    p.role,
    p.barbearia_id,
    b.nome as barbearia_nome,
    p.created_at
FROM public.profiles p
LEFT JOIN public.barbearias b ON p.barbearia_id = b.id
ORDER BY p.created_at DESC
LIMIT 5;
