-- ====================================================================
-- POLÍTICAS RLS PARA CRIAÇÃO DE BARBEARIA E FUNCIONÁRIO NO CADASTRO
-- ====================================================================

-- 1. Permitir usuários autenticados criarem barbearias
DROP POLICY IF EXISTS "Authenticated users can insert barbearias" ON public.barbearias;
CREATE POLICY "Authenticated users can insert barbearias"
ON public.barbearias
FOR INSERT
TO authenticated
WITH CHECK (true);

-- 2. Permitir usuários autenticados criarem funcionários (para vínculo do dono)
DROP POLICY IF EXISTS "Authenticated users can insert funcionarios" ON public.funcionarios;
CREATE POLICY "Authenticated users can insert funcionarios"
ON public.funcionarios
FOR INSERT
TO authenticated
WITH CHECK (true);

-- 3. Permitir usuários autenticados verem funcionários da própria barbearia
DROP POLICY IF EXISTS "Authenticated users can view own barbearia funcionarios" ON public.funcionarios;
CREATE POLICY "Authenticated users can view own barbearia funcionarios"
ON public.funcionarios
FOR SELECT
TO authenticated
USING (
  get_user_barbearia_id(auth.uid()) = barbearia_id OR
  auth.uid() = user_id
);

-- 4. Permitir usuários autenticados atualizarem próprio perfil
DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;
CREATE POLICY "Users can update own profile"
ON public.profiles
FOR UPDATE
TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);
