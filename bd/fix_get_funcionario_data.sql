-- ===================================================================
-- Função para buscar dados do funcionário/admin atual
-- ===================================================================

-- Se a função já existir, dropar antes de criar
DROP FUNCTION IF EXISTS public.get_funcionario_data(uuid);

CREATE OR REPLACE FUNCTION public.get_funcionario_data(user_uuid uuid)
RETURNS TABLE(
  id uuid,
  nome text,
  nivel text,
  barbearia_id uuid,
  is_owner boolean,
  especialidade text,
  email text
)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = 'public'
AS $$
BEGIN
  -- Primeiro tenta buscar na tabela funcionarios (funcionários e donos)
  RETURN QUERY
  SELECT 
    f.id,
    f.nome,
    f.nivel::text,
    f.barbearia_id,
    f.is_owner,
    f.especialidade,
    f.email
  FROM public.funcionarios f
  WHERE f.user_id = user_uuid
  LIMIT 1;
END;
$$;

-- ===================================================================
-- Atualizar função get_user_barbearia_id para buscar corretamente
-- ===================================================================

DROP FUNCTION IF EXISTS public.get_user_barbearia_id(uuid);

CREATE OR REPLACE FUNCTION public.get_user_barbearia_id(user_uuid uuid)
RETURNS uuid
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = 'public'
AS $$
DECLARE
  v_barbearia_id uuid;
  v_role text;
BEGIN
  -- Primeiro verificar o role do usuário na tabela profiles
  SELECT p.role::text, p.barbearia_id INTO v_role, v_barbearia_id
  FROM public.profiles p
  WHERE p.user_id = user_uuid
  LIMIT 1;

  -- Se for admin e tem barbearia_id no profile, retorna direto
  IF v_role = 'admin' AND v_barbearia_id IS NOT NULL THEN
    RETURN v_barbearia_id;
  END IF;

  -- Se não encontrou no profile ou não é admin, buscar na tabela funcionarios
  -- Isso funciona para funcionários e também para admins que estão na tabela funcionarios
  SELECT f.barbearia_id INTO v_barbearia_id
  FROM public.funcionarios f
  WHERE f.user_id = user_uuid
  LIMIT 1;

  RETURN v_barbearia_id;
END;
$$;

-- ===================================================================
-- Garantir que o admin atual esteja na tabela funcionarios (se ainda não estiver)
-- ===================================================================

-- Verificar se existem admins sem registro em funcionarios
INSERT INTO public.funcionarios (
  user_id,
  barbearia_id,
  nome,
  nivel,
  is_owner,
  created_at,
  updated_at
)
SELECT 
  p.user_id,
  p.barbearia_id,
  p.name,
  'dono'::public.nivel_permissao,
  true,
  now(),
  now()
FROM public.profiles p
WHERE p.role = 'admin'
  AND p.barbearia_id IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.funcionarios f 
    WHERE f.user_id = p.user_id
  )
ON CONFLICT DO NOTHING;

-- ===================================================================
-- Atualizar role do admin para 'dono' na tabela funcionarios (se estiver como 'admin')
-- ===================================================================

UPDATE public.funcionarios
SET nivel = 'dono'::public.nivel_permissao,
    is_owner = true,
    updated_at = now()
WHERE nivel = 'admin'::public.nivel_permissao
  AND (SELECT role FROM public.profiles WHERE user_id = funcionarios.user_id) = 'admin';

GRANT EXECUTE ON FUNCTION public.get_funcionario_data(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_funcionario_data(uuid) TO anon;
