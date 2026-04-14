


SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE TYPE "public"."agendamento_status" AS ENUM (
    'pendente',
    'confirmado',
    'cancelado',
    'finalizado',
    'aguardando_cliente'
);


ALTER TYPE "public"."agendamento_status" OWNER TO "postgres";


CREATE TYPE "public"."metodo_pagamento" AS ENUM (
    'cartao_credito',
    'cartao_debito',
    'pix',
    'boleto',
    'transferencia'
);


ALTER TYPE "public"."metodo_pagamento" OWNER TO "postgres";


CREATE TYPE "public"."nivel_permissao" AS ENUM (
    'funcionario',
    'gerente',
    'dono'
);


ALTER TYPE "public"."nivel_permissao" OWNER TO "postgres";


CREATE TYPE "public"."status_assinatura" AS ENUM (
    'ativa',
    'cancelada',
    'suspensa',
    'vencida',
    'teste'
);


ALTER TYPE "public"."status_assinatura" OWNER TO "postgres";


CREATE TYPE "public"."tipo_plano" AS ENUM (
    'basico',
    'premium',
    'empresarial'
);


ALTER TYPE "public"."tipo_plano" OWNER TO "postgres";


CREATE TYPE "public"."user_role" AS ENUM (
    'cliente',
    'admin',
    'funcionario'
);


ALTER TYPE "public"."user_role" OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."accept_employee_invite"("invite_token" "text", "employee_password" "text") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
DECLARE
  invite_data RECORD;
  new_employee_id UUID;
BEGIN
  -- Validate invite token
  SELECT * INTO invite_data
  FROM funcionario_convites
  WHERE token = invite_token
    AND usado = false
    AND (expires_at IS NULL OR expires_at > NOW());

  IF NOT FOUND THEN
    RETURN json_build_object('success', false, 'error', 'Convite inválido ou expirado');
  END IF;

  -- Check if employee already exists
  IF EXISTS (
    SELECT 1 FROM funcionarios
    WHERE nome = (invite_data.funcionario_data->>'nome')::TEXT
      AND barbearia_id = invite_data.barbearia_id
  ) THEN
    RETURN json_build_object('success', false, 'error', 'Funcionário já existe nesta barbearia');
  END IF;

  -- Create employee record - AGORA COM TODOS OS CAMPOS DISPONÍVEIS
  INSERT INTO funcionarios (
    user_id,
    barbearia_id,
    nome,
    nivel,
    created_at,
    updated_at
  ) VALUES (
    NULL, -- Will be filled when auth account is created
    invite_data.barbearia_id,
    (invite_data.funcionario_data->>'nome')::TEXT,
    (invite_data.funcionario_data->>'nivel_permissao')::nivel_permissao,
    NOW(),
    NOW()
  ) RETURNING id INTO new_employee_id;

  -- ADICIONAR: Inserir dados extras se a tabela tiver mais colunas
  -- (como especialidade, foto_url, email, etc.)
  BEGIN
    -- Tentar atualizar com campos extras (se existirem na tabela)
    UPDATE funcionarios SET
      especialidade = COALESCE((invite_data.funcionario_data->>'especialidade')::TEXT, ''),
      foto_url = COALESCE((invite_data.funcionario_data->>'foto_url')::TEXT, ''),
      email = invite_data.email
    WHERE id = new_employee_id;
  EXCEPTION
    WHEN undefined_column THEN
      -- Se alguma coluna não existir, continuar sem erro
      NULL;
  END;

  -- Mark invite as used
  UPDATE funcionario_convites
  SET usado = true
  WHERE id = invite_data.id;

  RETURN json_build_object(
    'success', true,
    'employee_id', new_employee_id,
    'message', 'Funcionário registrado com sucesso',
    'nome', (invite_data.funcionario_data->>'nome')::TEXT,
    'nivel', (invite_data.funcionario_data->>'nivel_permissao')::TEXT,
    'especialidade', COALESCE((invite_data.funcionario_data->>'especialidade')::TEXT, ''),
    'email', invite_data.email
  );

EXCEPTION
  WHEN OTHERS THEN
    RETURN json_build_object('success', false, 'error', 'Erro interno: ' || SQLERRM);
END;
$$;


ALTER FUNCTION "public"."accept_employee_invite"("invite_token" "text", "employee_password" "text") OWNER TO "postgres";


COMMENT ON FUNCTION "public"."accept_employee_invite"("invite_token" "text", "employee_password" "text") IS 'Accepts employee invitation by creating employee record and marking invite as used.
Returns JSON with success status and employee_id or error message.';



CREATE OR REPLACE FUNCTION "public"."barbearia_tem_assinatura_ativa"("p_barbearia_id" "uuid") RETURNS boolean
    LANGUAGE "sql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
    SELECT EXISTS (
        SELECT 1 FROM public.assinaturas 
        WHERE barbearia_id = p_barbearia_id 
        AND status = 'ativa' 
        AND (data_fim IS NULL OR data_fim > now())
    );
$$;


ALTER FUNCTION "public"."barbearia_tem_assinatura_ativa"("p_barbearia_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."check_anonymous_appointment_limit"("telefone_cliente" "text", "user_id_param" "uuid" DEFAULT NULL::"uuid") RETURNS boolean
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
    limite_anonimo INTEGER := 3;
    agendamentos_ativos INTEGER;
BEGIN
    -- Se o usuário está logado, não aplicar limite
    IF user_id_param IS NOT NULL THEN
        RETURN TRUE;
    END IF;
    
    -- Se telefone é null ou vazio, rejeitar
    IF telefone_cliente IS NULL OR telefone_cliente = '' THEN
        RETURN FALSE;
    END IF;
    
    -- Contar agendamentos ativos para o telefone
    SELECT COUNT(*)
    INTO agendamentos_ativos
    FROM agendamentos
    WHERE cliente_telefone = telefone_cliente
    AND status IN ('pendente', 'confirmado')
    AND user_id IS NULL;
    
    RETURN agendamentos_ativos < limite_anonimo;
END;
$$;


ALTER FUNCTION "public"."check_anonymous_appointment_limit"("telefone_cliente" "text", "user_id_param" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."check_funcionario_disponibilidade"("p_funcionario_id" "uuid", "p_data_hora" timestamp with time zone) RETURNS boolean
    LANGUAGE "plpgsql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_esta_ausente BOOLEAN;
BEGIN
  -- Verifica se o funcionário está em período de ausência
  SELECT EXISTS (
    SELECT 1
    FROM public.funcionario_ausencias
    WHERE funcionario_id = p_funcionario_id
      AND p_data_hora::DATE BETWEEN data_inicio AND data_fim
  ) INTO v_esta_ausente;
  
  -- Retorna TRUE se está disponível (NOT ausente)
  RETURN NOT v_esta_ausente;
END;
$$;


ALTER FUNCTION "public"."check_funcionario_disponibilidade"("p_funcionario_id" "uuid", "p_data_hora" timestamp with time zone) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."check_if_user_exists"("p_email" "text", "p_phone" "text") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
    v_email_exists boolean := false;
    v_phone_exists boolean := false;
    v_result json;
BEGIN
    -- Verificar se email já existe
    IF p_email IS NOT NULL AND p_email != '' THEN
        SELECT EXISTS (
            SELECT 1 FROM auth.users WHERE email = p_email
        ) INTO v_email_exists;
    END IF;
    
    -- Verificar se telefone já existe (apenas se fornecido)
    IF p_phone IS NOT NULL AND p_phone != '' THEN
        SELECT EXISTS (
            SELECT 1 FROM public.profiles WHERE phone = p_phone
        ) INTO v_phone_exists;
    END IF;
    
    -- Retornar resultado em JSON
    v_result := json_build_object(
        'email_exists', v_email_exists,
        'phone_exists', v_phone_exists,
        'user_exists', (v_email_exists OR v_phone_exists)
    );
    
    RETURN v_result;
END;
$$;


ALTER FUNCTION "public"."check_if_user_exists"("p_email" "text", "p_phone" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."check_rate_limit"("operation_type" "text", "user_identifier" "text") RETURNS boolean
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  last_attempt timestamp;
  attempt_count integer;
BEGIN
  -- For demonstration - in production, implement proper rate limiting
  -- This is a placeholder for rate limiting logic
  RETURN true;
END;
$$;


ALTER FUNCTION "public"."check_rate_limit"("operation_type" "text", "user_identifier" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_feedback_on_completion"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  -- Só executa se o status mudou para 'finalizado' e tinha um status diferente antes
  IF NEW.status = 'finalizado' AND (OLD.status IS NULL OR OLD.status != 'finalizado') THEN
    -- Só cria feedback se user_id não for null
    IF NEW.user_id IS NOT NULL THEN
      -- Verifica se já não existe um feedback para este agendamento (evita duplicatas)
      IF NOT EXISTS (
        SELECT 1 FROM public.feedbacks
        WHERE agendamento_id = NEW.id
      ) THEN
        INSERT INTO public.feedbacks (
          agendamento_id,
          user_id,
          barbearia_id,
          status
        ) VALUES (
          NEW.id,
          NEW.user_id,
          NEW.barbearia_id,
          'pendente'
        );
      END IF;
    END IF;
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."create_feedback_on_completion"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."delete_user_complete"("user_email" "text") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public', 'auth'
    AS $$
DECLARE
    user_uuid uuid;
    result json;
BEGIN
    -- Buscar o user_id pelo email
    SELECT id INTO user_uuid
    FROM auth.users
    WHERE email = user_email;

    IF user_uuid IS NULL THEN
        result := json_build_object(
            'success', false,
            'message', 'Usuário não encontrado com o email fornecido'
        );
        RETURN result;
    END IF;

    -- Deletar primeiro os dados da aplicação (profiles será deletado automaticamente via cascade se configurado)
    DELETE FROM public.profiles WHERE user_id = user_uuid;

    -- Deletar o usuário da tabela auth.users
    DELETE FROM auth.users WHERE id = user_uuid;

    result := json_build_object(
        'success', true,
        'message', 'Usuário deletado com sucesso',
        'user_id', user_uuid::text
    );

    RETURN result;
EXCEPTION
    WHEN OTHERS THEN
        result := json_build_object(
            'success', false,
            'message', 'Erro ao deletar usuário: ' || SQLERRM
        );
        RETURN result;
END;
$$;


ALTER FUNCTION "public"."delete_user_complete"("user_email" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."generate_slug"("text") RETURNS "text"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $_$
BEGIN
  RETURN lower(regexp_replace($1, '[^a-zA-Z0-9]+', '-', 'g'));
END;
$_$;


ALTER FUNCTION "public"."generate_slug"("text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_anonymous_appointment_limit"() RETURNS integer
    LANGUAGE "plpgsql" STABLE
    AS $$
BEGIN
    -- Por enquanto retorna 3, mas pode ser facilmente modificado
    -- Em futuro pode consultar uma tabela de configuração
    RETURN 3;
END;
$$;


ALTER FUNCTION "public"."get_anonymous_appointment_limit"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_assinatura_ativa"("p_barbearia_id" "uuid") RETURNS json
    LANGUAGE "sql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
    SELECT row_to_json(a.*) 
    FROM public.assinaturas a
    WHERE a.barbearia_id = p_barbearia_id 
    AND a.status = 'ativa'
    AND (a.data_fim IS NULL OR a.data_fim > now())
    ORDER BY a.created_at DESC
    LIMIT 1;
$$;


ALTER FUNCTION "public"."get_assinatura_ativa"("p_barbearia_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_current_user_role"() RETURNS "public"."user_role"
    LANGUAGE "plpgsql" STABLE SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
BEGIN
  RETURN (
    SELECT p.role
    FROM public.profiles p
    WHERE p.user_id = auth.uid()
    LIMIT 1
  );
END;
$$;


ALTER FUNCTION "public"."get_current_user_role"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_default_funcionario"("barbearia_uuid" "uuid") RETURNS "uuid"
    LANGUAGE "plpgsql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
  -- Retorna o funcionário dono, ou o primeiro funcionário da barbearia
  RETURN (
    SELECT id
    FROM public.funcionarios
    WHERE barbearia_id = barbearia_uuid
    ORDER BY is_owner DESC, created_at ASC
    LIMIT 1
  );
END;
$$;


ALTER FUNCTION "public"."get_default_funcionario"("barbearia_uuid" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_funcionario_data"("user_uuid" "uuid") RETURNS TABLE("id" "uuid", "nome" "text", "nivel" "text", "barbearia_id" "uuid", "is_owner" boolean, "especialidade" "text", "email" "text")
    LANGUAGE "plpgsql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_record RECORD;
  v_role text;
BEGIN
  -- Primeiro tenta buscar na tabela funcionarios
  SELECT f.id, f.nome, f.nivel::text, f.barbearia_id, f.is_owner, f.especialidade, f.email
  INTO v_record
  FROM public.funcionarios f
  WHERE f.user_id = user_uuid
  LIMIT 1;
  -- Se encontrou, retorna
  IF FOUND THEN
    RETURN QUERY SELECT v_record.id, v_record.nome, v_record.nivel, v_record.barbearia_id, v_record.is_owner, v_record.especialidade, v_record.email;
    RETURN;
  END IF;
  -- Se não encontrou na tabela funcionarios, verifica se é admin no profile
  SELECT p.role::text, p.barbearia_id, p.name
  INTO v_role, v_record.barbearia_id, v_record.nome
  FROM public.profiles p
  WHERE p.user_id = user_uuid
  LIMIT 1;
  -- Se for admin, retorna dados do profile
  IF v_role = 'admin' AND v_record.barbearia_id IS NOT NULL THEN
    RETURN QUERY SELECT 
      user_uuid::uuid,
      v_record.nome,
      'dono'::text,
      v_record.barbearia_id,
      true,
      NULL::text,
      NULL::text;
    RETURN;
  END IF;
  -- Se não encontrou em nenhuma tabela, retorna vazio
  RETURN;
END;
$$;


ALTER FUNCTION "public"."get_funcionario_data"("user_uuid" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_public_profile_info"("profile_user_ids" "uuid"[]) RETURNS TABLE("user_id" "uuid", "name" "text", "role" "public"."user_role")
    LANGUAGE "sql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
  SELECT 
    p.user_id,
    p.name,
    p.role
  FROM public.profiles p
  WHERE p.user_id = ANY(profile_user_ids)
    AND (
      -- Só retorna dados se o usuário solicitante tem permissão
      auth.uid() = p.user_id OR  -- Próprio perfil
      (
        get_current_user_role() IN ('admin', 'funcionario') AND
        get_user_barbearia_id(auth.uid()) = p.barbearia_id
      )
    );
$$;


ALTER FUNCTION "public"."get_public_profile_info"("profile_user_ids" "uuid"[]) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_recompensas_disponiveis"("p_barbearia_id" "uuid", "p_cliente_telefone" "text") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
    v_pontos_cliente integer := 0;
    v_recompensas json;
BEGIN
    -- Buscar pontos do cliente
    SELECT pontos INTO v_pontos_cliente
    FROM public.fidelidade
    WHERE barbearia_id = p_barbearia_id AND cliente_telefone = p_cliente_telefone;
    
    -- Buscar recompensas da barbearia
    SELECT json_agg(
        json_build_object(
            'id', r.id,
            'nome', r.nome,
            'descricao', r.descricao,
            'pontos_necessarios', r.pontos_necessarios,
            'pode_resgatar', (v_pontos_cliente >= r.pontos_necessarios)
        ) ORDER BY r.pontos_necessarios
    ) INTO v_recompensas
    FROM public.recompensas r
    WHERE r.barbearia_id = p_barbearia_id AND r.ativo = true;
    
    RETURN json_build_object(
        'pontos_cliente', COALESCE(v_pontos_cliente, 0),
        'recompensas', COALESCE(v_recompensas, '[]'::json)
    );
END;
$$;


ALTER FUNCTION "public"."get_recompensas_disponiveis"("p_barbearia_id" "uuid", "p_cliente_telefone" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_user_barbearia_id"() RETURNS "uuid"
    LANGUAGE "plpgsql" STABLE SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
BEGIN
  RETURN (
    SELECT p.barbearia_id
    FROM public.profiles p
    WHERE p.user_id = auth.uid()
    LIMIT 1
  );
END;
$$;


ALTER FUNCTION "public"."get_user_barbearia_id"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_user_barbearia_id"("user_uuid" "uuid") RETURNS "uuid"
    LANGUAGE "plpgsql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_barbearia_id uuid;
  v_role text;
BEGIN
  SELECT p.role::text, p.barbearia_id INTO v_role, v_barbearia_id
  FROM public.profiles p
  WHERE p.user_id = user_uuid
  LIMIT 1;
  IF v_role = 'admin' AND v_barbearia_id IS NOT NULL THEN
    RETURN v_barbearia_id;
  END IF;
  SELECT f.barbearia_id INTO v_barbearia_id
  FROM public.funcionarios f
  WHERE f.user_id = user_uuid
  LIMIT 1;
  RETURN v_barbearia_id;
END;
$$;


ALTER FUNCTION "public"."get_user_barbearia_id"("user_uuid" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_user_profile_cached"() RETURNS TABLE("user_id" "uuid", "role" "public"."user_role", "barbearia_id" "uuid")
    LANGUAGE "sql" STABLE SECURITY DEFINER
    AS $$
  SELECT p.user_id, p.role, p.barbearia_id
  FROM public.profiles p
  WHERE p.user_id = auth.uid()
  LIMIT 1;
$$;


ALTER FUNCTION "public"."get_user_profile_cached"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_user_role"("user_uuid" "uuid") RETURNS "public"."user_role"
    LANGUAGE "sql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
  SELECT role FROM public.profiles WHERE user_id = user_uuid;
$$;


ALTER FUNCTION "public"."get_user_role"("user_uuid" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."handle_new_user"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
    new_barbearia_id uuid;
    invite_record record;
    final_slug text;
    base_slug text;
    slug_count integer;
BEGIN
    IF (NEW.raw_user_meta_data ->> 'role') = 'cliente' THEN
        INSERT INTO public.profiles (user_id, name, phone, role)
        VALUES (NEW.id, COALESCE(NEW.raw_user_meta_data ->> 'name', ''), COALESCE(NEW.raw_user_meta_data ->> 'phone', ''), 'cliente'::public.user_role);
        RETURN NEW;
    END IF;

    IF (NEW.raw_user_meta_data ->> 'role') = 'funcionario' THEN
        SELECT * INTO invite_record FROM public.funcionario_convites WHERE email = NEW.email AND usado = FALSE AND expires_at > now() LIMIT 1;
        IF FOUND THEN
            INSERT INTO public.profiles (user_id, name, phone, role, barbearia_id)
            VALUES (NEW.id, COALESCE(NEW.raw_user_meta_data ->> 'name', ''), COALESCE(NEW.raw_user_meta_data ->> 'phone', ''), 'funcionario'::public.user_role, invite_record.barbearia_id);

            INSERT INTO public.funcionarios (user_id, nome, nivel, barbearia_id, is_owner)
            VALUES (NEW.id, (invite_record.funcionario_data ->> 'nome')::text, COALESCE((invite_record.funcionario_data ->> 'nivel_permissao')::public.nivel_permissao, 'funcionario'::public.nivel_permissao), invite_record.barbearia_id, FALSE);

            UPDATE public.funcionario_convites SET usado = TRUE WHERE id = invite_record.id;
            RETURN NEW;
        END IF;
    END IF;
 
    -- Se chegou aqui, é cadastro Admin
    INSERT INTO public.profiles (user_id, name, phone, role)
    VALUES (NEW.id, COALESCE(NEW.raw_user_meta_data ->> 'name', ''), COALESCE(NEW.raw_user_meta_data ->> 'phone', ''), 'admin'::public.user_role);

    IF (NEW.raw_user_meta_data ->> 'barbershop_name') IS NOT NULL THEN
        -- Proteção contra crash de SLUG duplicado em modo desenvolvimento
        base_slug := generate_slug(NEW.raw_user_meta_data ->> 'barbershop_name');
        final_slug := base_slug;
        
        SELECT count(*) INTO slug_count FROM public.barbearias WHERE slug LIKE base_slug || '%';
        IF slug_count > 0 THEN
            final_slug := base_slug || '-' || (slug_count + 1)::text;
        END IF;

        INSERT INTO public.barbearias (nome, cidade, slug)
        VALUES (NEW.raw_user_meta_data ->> 'barbershop_name', 'Não informado', final_slug)
        RETURNING id INTO new_barbearia_id;

        UPDATE public.profiles SET barbearia_id = new_barbearia_id WHERE user_id = NEW.id;

        INSERT INTO public.funcionarios (user_id, barbearia_id, nome, nivel, is_owner, created_at, updated_at) 
        VALUES (NEW.id, new_barbearia_id, COALESCE(NEW.raw_user_meta_data ->> 'name', ''), 'dono'::public.nivel_permissao, TRUE, NOW(), NOW());

        -- CAST estrito e robusto em 'HORA'
        INSERT INTO public.horarios_funcionamento (barbearia_id, dia_semana, hora_abre, hora_fecha, fechado)
        VALUES
            (new_barbearia_id, 1, '08:00'::TIME, '18:00'::TIME, false),
            (new_barbearia_id, 2, '08:00'::TIME, '18:00'::TIME, false),
            (new_barbearia_id, 3, '08:00'::TIME, '18:00'::TIME, false),
            (new_barbearia_id, 4, '08:00'::TIME, '18:00'::TIME, false),
            (new_barbearia_id, 5, '08:00'::TIME, '18:00'::TIME, false),
            (new_barbearia_id, 6, '08:00'::TIME, '17:00'::TIME, false),
            (new_barbearia_id, 0, NULL, NULL, true);
    END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."handle_new_user"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."insert_owner_as_employee"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  owner_profile RECORD;
BEGIN
  SELECT user_id, name INTO owner_profile FROM public.profiles WHERE barbearia_id = NEW.id AND role = 'admin' LIMIT 1;

  IF FOUND THEN
    INSERT INTO public.funcionarios (user_id, barbearia_id, nome, nivel, is_owner, created_at, updated_at) 
    VALUES (owner_profile.user_id, NEW.id, owner_profile.name, 'dono'::nivel_permissao, TRUE, NOW(), NOW())
    ON CONFLICT DO NOTHING;
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."insert_owner_as_employee"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."registrar_comissao_agendamento"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_funcionario_id UUID;
  v_servico RECORD;
  v_barbearia_id UUID;
  v_comissao_percentual DECIMAL(5,2);
  v_comissao_valor DECIMAL(10,2);
BEGIN
  IF NEW.status = 'finalizado' AND OLD.status != 'finalizado' AND NEW.funcionario_id IS NOT NULL THEN
    
    v_funcionario_id := NEW.funcionario_id;
    v_barbearia_id := NEW.barbearia_id;
    
    SELECT f.comissao_percentual INTO v_comissao_percentual
    FROM public.funcionarios f
    WHERE f.id = v_funcionario_id;
    
    IF v_comissao_percentual IS NULL THEN
      v_comissao_percentual := 0;
    END IF;
    
    SELECT s.nome, s.valor INTO v_servico
    FROM public.servicos s
    WHERE s.id = NEW.servico_id;
    
    v_comissao_valor := COALESCE(v_servico.valor, 0) * (v_comissao_percentual / 100);
    
    INSERT INTO public.funcionarios_atendimentos (
      barbearia_id,
      funcionario_id,
      servico_nome,
      cliente_nome,
      cliente_telefone,
      valor,
      comissao_percentual,
      comissao_valor,
      data_atendimento,
      agendamento_id
    ) VALUES (
      v_barbearia_id,
      v_funcionario_id,
      v_servico.nome,
      NEW.cliente_nome,
      NEW.cliente_telefone,
      COALESCE(v_servico.valor, 0),
      v_comissao_percentual,
      v_comissao_valor,
      NEW.data_hora::date,
      NEW.id
    );
    
  END IF;
  
  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."registrar_comissao_agendamento"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."resgatar_recompensa"("p_recompensa_id" "uuid", "p_cliente_telefone" "text", "p_barbearia_id" "uuid") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
    v_recompensa record;
    v_pontos_cliente integer;
    v_resultado json;
BEGIN
    -- Buscar dados da recompensa
    SELECT * INTO v_recompensa
    FROM public.recompensas
    WHERE id = p_recompensa_id AND barbearia_id = p_barbearia_id AND ativo = true;
    
    IF NOT FOUND THEN
        RETURN json_build_object('success', false, 'message', 'Recompensa não encontrada ou inativa');
    END IF;
    
    -- Buscar pontos do cliente
    SELECT pontos INTO v_pontos_cliente
    FROM public.fidelidade
    WHERE barbearia_id = p_barbearia_id AND cliente_telefone = p_cliente_telefone;
    
    IF NOT FOUND OR v_pontos_cliente < v_recompensa.pontos_necessarios THEN
        RETURN json_build_object('success', false, 'message', 'Pontos insuficientes');
    END IF;
    
    -- Realizar o resgate
    BEGIN
        -- Inserir registro de resgate
        INSERT INTO public.resgates_recompensas (
            recompensa_id, cliente_telefone, barbearia_id, pontos_utilizados
        ) VALUES (
            p_recompensa_id, p_cliente_telefone, p_barbearia_id, v_recompensa.pontos_necessarios
        );
        
        -- Deduzir pontos do cliente
        UPDATE public.fidelidade
        SET pontos = pontos - v_recompensa.pontos_necessarios,
            updated_at = now()
        WHERE barbearia_id = p_barbearia_id AND cliente_telefone = p_cliente_telefone;
        
        v_resultado := json_build_object(
            'success', true, 
            'message', 'Recompensa resgatada com sucesso!',
            'recompensa', v_recompensa.nome,
            'pontos_utilizados', v_recompensa.pontos_necessarios
        );
        
        RETURN v_resultado;
        
    EXCEPTION WHEN OTHERS THEN
        RETURN json_build_object('success', false, 'message', 'Erro ao processar resgate');
    END;
END;
$$;


ALTER FUNCTION "public"."resgatar_recompensa"("p_recompensa_id" "uuid", "p_cliente_telefone" "text", "p_barbearia_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_profile_on_employee_creation"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
  UPDATE profiles
  SET
    role = CASE 
      -- Usar conversão explícita para texto (::text) para parar erros do banco
      WHEN NEW.nivel::text IN ('dono', 'gerente') THEN 'admin'::public.user_role
      ELSE 'funcionario'::public.user_role
    END,
    barbearia_id = NEW.barbearia_id,
    updated_at = NOW()
  WHERE user_id = NEW.user_id;

  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."update_profile_on_employee_creation"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_updated_at_assinaturas"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public'
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."update_updated_at_assinaturas"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_updated_at_ausencias"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public'
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."update_updated_at_ausencias"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_updated_at_fidelidade_configuracoes"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public'
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."update_updated_at_fidelidade_configuracoes"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_updated_at_recompensas"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public'
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."update_updated_at_recompensas"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."user_can_access_barbearia"("target_barbearia_id" "uuid", "required_roles" "public"."user_role"[]) RETURNS boolean
    LANGUAGE "plpgsql" STABLE SECURITY DEFINER
    AS $$
DECLARE
  user_profile RECORD;
BEGIN
  -- Validação de entrada
  IF target_barbearia_id IS NULL OR required_roles IS NULL THEN
    RETURN FALSE;
  END IF;

  -- Buscar perfil do usuário uma única vez
  SELECT role, barbearia_id INTO user_profile
  FROM public.profiles
  WHERE user_id = auth.uid()
  LIMIT 1;

  -- Verificar se encontrou o perfil e se tem permissão
  RETURN (
    user_profile.role = ANY(required_roles)
    AND user_profile.barbearia_id = target_barbearia_id
  );
END;
$$;


ALTER FUNCTION "public"."user_can_access_barbearia"("target_barbearia_id" "uuid", "required_roles" "public"."user_role"[]) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."user_is_admin_of_barbearia"("check_barbearia_id" "uuid") RETURNS boolean
    LANGUAGE "plpgsql" STABLE SECURITY DEFINER
    AS $$
BEGIN
  -- Verificar se o usuário atual é admin da barbearia especificada
  RETURN EXISTS (
    SELECT 1
    FROM public.profiles p
    WHERE p.user_id = auth.uid()
    AND p.role = 'admin'
    AND p.barbearia_id = check_barbearia_id
    AND check_barbearia_id IS NOT NULL
  );
END;
$$;


ALTER FUNCTION "public"."user_is_admin_of_barbearia"("check_barbearia_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."user_is_staff_of_barbearia"("check_barbearia_id" "uuid") RETURNS boolean
    LANGUAGE "plpgsql" STABLE SECURITY DEFINER
    AS $$
BEGIN
  -- Verificar se o usuário atual é funcionário/admin da barbearia especificada
  RETURN EXISTS (
    SELECT 1
    FROM public.profiles p
    WHERE p.user_id = auth.uid()
    AND p.role IN ('admin', 'funcionario')
    AND p.barbearia_id = check_barbearia_id
    AND check_barbearia_id IS NOT NULL
  );
END;
$$;


ALTER FUNCTION "public"."user_is_staff_of_barbearia"("check_barbearia_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."validate_and_sanitize_agendamento_data"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $_$
DECLARE
  _cleaned_phone text;
  _cleaned_email text;
BEGIN
  -- Sanitizar telefone: remover caracteres não numéricos
  IF NEW.cliente_telefone IS NOT NULL THEN
    _cleaned_phone := regexp_replace(NEW.cliente_telefone, '[^0-9]', '', 'g');
    NEW.cliente_telefone := _cleaned_phone;
  END IF;

  -- Sanitizar email: converter para minúsculas e remover espaços
  IF NEW.cliente_email IS NOT NULL THEN
    _cleaned_email := lower(trim(NEW.cliente_email));
    NEW.cliente_email := _cleaned_email;
  END IF;

  -- Sanitizar nome: remover espaços extras
  IF NEW.cliente_nome IS NOT NULL THEN
    NEW.cliente_nome := trim(regexp_replace(NEW.cliente_nome, '\s+', ' ', 'g'));
  END IF;

  -- Validar telefone: deve ter entre 10 e 11 dígitos (formato brasileiro)
  IF NEW.cliente_telefone IS NOT NULL AND NEW.cliente_telefone != '' THEN
    IF length(NEW.cliente_telefone) < 10 OR length(NEW.cliente_telefone) > 11 THEN
      RAISE EXCEPTION 'Telefone deve ter 10 ou 11 dígitos';
    END IF;
  END IF;

  -- Validar email com regex básico
  IF NEW.cliente_email IS NOT NULL AND NEW.cliente_email != '' THEN
    IF NEW.cliente_email !~ '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$' THEN
      RAISE EXCEPTION 'Email inválido';
    END IF;
  END IF;

  -- Validar nome: deve ter pelo menos 2 caracteres
  IF NEW.cliente_nome IS NOT NULL AND length(trim(NEW.cliente_nome)) < 2 THEN
    RAISE EXCEPTION 'Nome deve ter pelo menos 2 caracteres';
  END IF;

  -- Validar data/hora: não permitir agendamentos em datas passadas
  -- IMPORTANTE: Esta validação só se aplica a NOVOS agendamentos (INSERT)
  -- Para atualizações (UPDATE), só validar se a data_hora foi alterada
  IF TG_OP = 'INSERT' THEN
    -- Para novos agendamentos, não permitir datas passadas
    IF NEW.data_hora < NOW() - INTERVAL '1 hour' THEN
      RAISE EXCEPTION 'Não é possível agendar para datas passadas';
    END IF;
  ELSIF TG_OP = 'UPDATE' THEN
    -- Para atualizações, só validar data se ela foi realmente alterada
    -- Isso permite atualizar status de agendamentos passados (ex: finalizar)
    IF NEW.data_hora IS DISTINCT FROM OLD.data_hora THEN
      -- Se a data foi alterada (reagendamento), não permitir datas passadas
      IF NEW.data_hora < NOW() - INTERVAL '1 hour' THEN
        RAISE EXCEPTION 'Não é possível reagendar para datas passadas';
      END IF;
    END IF;
    -- Se apenas o status foi alterado, permitir a atualização
  END IF;

  RETURN NEW;
END;
$_$;


ALTER FUNCTION "public"."validate_and_sanitize_agendamento_data"() OWNER TO "postgres";


COMMENT ON FUNCTION "public"."validate_and_sanitize_agendamento_data"() IS 'Valida e sanitiza dados de agendamentos para proteger contra XSS, SQL injection e dados corrompidos. 
Funciona para agendamentos autenticados e anônimos.
Validações aplicadas:
- cliente_nome: remove HTML, valida tamanho (2-100 chars), permite apenas letras e acentos
- cliente_telefone: valida formato, mínimo 10 dígitos
- cliente_email: valida formato RFC 5322, normaliza lowercase
- data_hora: impede agendamentos no passado';



CREATE OR REPLACE FUNCTION "public"."validate_anonymous_appointment"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
    -- Verificar se o agendamento anônimo excede o limite
    IF NOT check_anonymous_appointment_limit(NEW.cliente_telefone, NEW.user_id) THEN
        RAISE EXCEPTION 'LIMITE_AGENDAMENTOS_ANONIMOS: Número máximo de agendamentos ativos atingido para este telefone. Finalize ou cancele agendamentos existentes antes de criar um novo.'
            USING ERRCODE = 'P0001';
    END IF;
    
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."validate_anonymous_appointment"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."validate_funcionario_availability"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
  -- Se tem funcionário específico, validar disponibilidade
  IF NEW.funcionario_id IS NOT NULL THEN
    IF NOT check_funcionario_disponibilidade(NEW.funcionario_id, NEW.data_hora) THEN
      RAISE EXCEPTION 'Funcionário não disponível nesta data (férias/recesso)';
    END IF;
  END IF;
  
  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."validate_funcionario_availability"() OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."agendamentos" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "barbearia_id" "uuid" NOT NULL,
    "servico_id" "uuid" NOT NULL,
    "funcionario_id" "uuid",
    "user_id" "uuid",
    "cliente_nome" "text" NOT NULL,
    "cliente_telefone" "text" NOT NULL,
    "cliente_email" "text",
    "data_hora" timestamp with time zone NOT NULL,
    "status" "public"."agendamento_status" DEFAULT 'pendente'::"public"."agendamento_status" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "origem" "text" GENERATED ALWAYS AS (
CASE
    WHEN ("user_id" IS NULL) THEN 'anonimo'::"text"
    ELSE 'cliente'::"text"
END) STORED,
    "avaliado" boolean DEFAULT false NOT NULL,
    CONSTRAINT "agendamentos_cliente_telefone_valid" CHECK ((("user_id" IS NOT NULL) OR (("user_id" IS NULL) AND ("cliente_telefone" IS NOT NULL) AND ("length"("regexp_replace"("cliente_telefone", '[^0-9]'::"text", ''::"text", 'g'::"text")) >= 10))))
);


ALTER TABLE "public"."agendamentos" OWNER TO "postgres";


COMMENT ON COLUMN "public"."agendamentos"."origem" IS 'Coluna gerada automaticamente que identifica se o agendamento foi criado por um cliente logado ou anônimo';



COMMENT ON COLUMN "public"."agendamentos"."avaliado" IS 'Indica se o agendamento já foi avaliado pelo cliente';



CREATE TABLE IF NOT EXISTS "public"."assinaturas" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "barbearia_id" "uuid" NOT NULL,
    "tipo_plano" "public"."tipo_plano" DEFAULT 'basico'::"public"."tipo_plano" NOT NULL,
    "status" "public"."status_assinatura" DEFAULT 'teste'::"public"."status_assinatura" NOT NULL,
    "data_inicio" timestamp with time zone DEFAULT "now"() NOT NULL,
    "data_fim" timestamp with time zone,
    "data_cancelamento" timestamp with time zone,
    "valor_mensal" numeric(10,2) DEFAULT 0.00 NOT NULL,
    "moeda" character varying(3) DEFAULT 'BRL'::character varying NOT NULL,
    "metodo_pagamento" "public"."metodo_pagamento",
    "stripe_subscription_id" "text",
    "stripe_customer_id" "text",
    "observacoes" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."assinaturas" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."audit_log" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid",
    "operation" "text" NOT NULL,
    "table_name" "text" NOT NULL,
    "record_id" "uuid",
    "old_values" "jsonb",
    "new_values" "jsonb",
    "ip_address" "inet",
    "user_agent" "text",
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."audit_log" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."barbearias" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "nome" "text" NOT NULL,
    "logo_url" "text",
    "slug" "text",
    "endereco" "text",
    "cidade" "text" NOT NULL,
    "bairro" "text",
    "cep" "text",
    "email_contato" "text",
    "telefone" "text",
    "cores_personalizadas" "jsonb" DEFAULT '{}'::"jsonb",
    "modo_tema" "text" DEFAULT 'dark'::"text",
    "gallery_urls" "text"[] DEFAULT ARRAY[]::"text"[],
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "fidelidade_ativa" boolean DEFAULT true NOT NULL,
    "descricao" "text",
    "notificacoes_ativa" boolean DEFAULT true,
    CONSTRAINT "barbearias_modo_tema_check" CHECK (("modo_tema" = ANY (ARRAY['dark'::"text", 'light'::"text"])))
);


ALTER TABLE "public"."barbearias" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."barbearias_public" WITH ("security_invoker"='on') AS
 SELECT "id",
    "nome",
    "cidade",
    "endereco",
    "telefone",
    "logo_url",
    "gallery_urls",
    "slug",
    "modo_tema",
    "cores_personalizadas"
   FROM "public"."barbearias";


ALTER VIEW "public"."barbearias_public" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."categorias_servicos" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "nome" "text" NOT NULL,
    "descricao" "text"
);


ALTER TABLE "public"."categorias_servicos" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."feedbacks" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "agendamento_id" "uuid" NOT NULL,
    "user_id" "uuid" NOT NULL,
    "barbearia_id" "uuid" NOT NULL,
    "rating" integer,
    "comment" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "response" "text",
    "response_created_at" timestamp with time zone,
    "responded_by" "uuid",
    "status" "text" DEFAULT 'pendente'::"text" NOT NULL,
    "anonimo" boolean DEFAULT false,
    CONSTRAINT "feedbacks_rating_check" CHECK ((("rating" >= 1) AND ("rating" <= 5)))
);


ALTER TABLE "public"."feedbacks" OWNER TO "postgres";


COMMENT ON COLUMN "public"."feedbacks"."rating" IS 'Rating do feedback (1-5). Pode ser NULL quando o feedback é criado automaticamente pelo sistema e ainda não foi avaliado pelo cliente.';



COMMENT ON COLUMN "public"."feedbacks"."response" IS 'Resposta do barbeiro/funcionário ao feedback do cliente';



COMMENT ON COLUMN "public"."feedbacks"."response_created_at" IS 'Data e hora quando a resposta foi criada';



COMMENT ON COLUMN "public"."feedbacks"."responded_by" IS 'ID do funcionário que respondeu ao feedback';



CREATE TABLE IF NOT EXISTS "public"."fidelidade" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "barbearia_id" "uuid" NOT NULL,
    "pontos" integer DEFAULT 0 NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "cliente_telefone" "text"
);


ALTER TABLE "public"."fidelidade" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."fidelidade_configuracoes" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "barbearia_id" "uuid" NOT NULL,
    "pontos_por_servico" integer DEFAULT 1 NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "pontos_minimos_recompensa" integer DEFAULT 100,
    "dias_expiracao" integer DEFAULT 365
);


ALTER TABLE "public"."fidelidade_configuracoes" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."funcionario_ausencias" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "funcionario_id" "uuid" NOT NULL,
    "barbearia_id" "uuid" NOT NULL,
    "tipo" "text" NOT NULL,
    "data_inicio" "date" NOT NULL,
    "data_fim" "date" NOT NULL,
    "motivo" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "ausencia_datas_validas" CHECK (("data_fim" >= "data_inicio")),
    CONSTRAINT "funcionario_ausencias_tipo_check" CHECK (("tipo" = ANY (ARRAY['ferias'::"text", 'recesso'::"text", 'outro'::"text"])))
);


ALTER TABLE "public"."funcionario_ausencias" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."funcionario_convites" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "email" "text" NOT NULL,
    "barbearia_id" "uuid" NOT NULL,
    "funcionario_data" "jsonb" NOT NULL,
    "usado" boolean DEFAULT false NOT NULL,
    "expires_at" timestamp with time zone NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "created_by" "uuid",
    "token" "text"
);


ALTER TABLE "public"."funcionario_convites" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."funcionario_pausas" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "funcionario_id" "uuid" NOT NULL,
    "barbearia_id" "uuid" NOT NULL,
    "data" "date" DEFAULT CURRENT_DATE NOT NULL,
    "hora_inicio" time without time zone NOT NULL,
    "hora_fim" time without time zone NOT NULL,
    "motivo" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "check_horario_valido" CHECK (("hora_fim" > "hora_inicio"))
);


ALTER TABLE "public"."funcionario_pausas" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."funcionarios" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid",
    "barbearia_id" "uuid" NOT NULL,
    "nome" "text" NOT NULL,
    "nivel" "public"."nivel_permissao" DEFAULT 'funcionario'::"public"."nivel_permissao" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "is_owner" boolean DEFAULT false,
    "email" "text",
    "especialidade" "text",
    "comissao_percentual" numeric(5,2) DEFAULT 0
);


ALTER TABLE "public"."funcionarios" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."funcionarios_atendimentos" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "barbearia_id" "uuid" NOT NULL,
    "funcionario_id" "uuid" NOT NULL,
    "servico_id" "uuid",
    "agendamento_id" "uuid",
    "cliente_nome" "text",
    "cliente_telefone" "text",
    "servico_nome" "text",
    "valor" numeric(10,2) NOT NULL,
    "comissao_percentual" numeric(5,2) NOT NULL,
    "comissao_valor" numeric(10,2) NOT NULL,
    "data_atendimento" "date" DEFAULT CURRENT_DATE NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "observacoes" "text"
);


ALTER TABLE "public"."funcionarios_atendimentos" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."funcionarios_public" WITH ("security_invoker"='on') AS
 SELECT "id",
    "nome",
    "barbearia_id"
   FROM "public"."funcionarios" "f";


ALTER VIEW "public"."funcionarios_public" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."horarios_funcionamento" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "barbearia_id" "uuid" NOT NULL,
    "dia_semana" integer NOT NULL,
    "hora_abre" time without time zone,
    "hora_fecha" time without time zone,
    "fechado" boolean DEFAULT false NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."horarios_funcionamento" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."profiles" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "name" "text" NOT NULL,
    "phone" "text",
    "role" "public"."user_role" DEFAULT 'cliente'::"public"."user_role" NOT NULL,
    "barbearia_id" "uuid",
    "receber_lembretes_email" boolean DEFAULT true,
    "receber_lembretes_sms" boolean DEFAULT false,
    "consentimento_marketing" boolean DEFAULT false,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."profiles" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."recompensas" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "barbearia_id" "uuid" NOT NULL,
    "nome" "text" NOT NULL,
    "descricao" "text",
    "pontos_necessarios" integer NOT NULL,
    "ativo" boolean DEFAULT true NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "recompensas_pontos_necessarios_check" CHECK (("pontos_necessarios" > 0))
);


ALTER TABLE "public"."recompensas" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."resgates_recompensas" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "recompensa_id" "uuid" NOT NULL,
    "cliente_telefone" "text" NOT NULL,
    "barbearia_id" "uuid" NOT NULL,
    "pontos_utilizados" integer NOT NULL,
    "data_resgate" timestamp with time zone DEFAULT "now"() NOT NULL,
    "status" "text" DEFAULT 'resgatado'::"text" NOT NULL,
    CONSTRAINT "resgates_recompensas_status_check" CHECK (("status" = ANY (ARRAY['resgatado'::"text", 'utilizado'::"text", 'cancelado'::"text"])))
);


ALTER TABLE "public"."resgates_recompensas" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."servicos" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "barbearia_id" "uuid" NOT NULL,
    "nome" "text" NOT NULL,
    "descricao" "text",
    "valor" numeric(10,2) NOT NULL,
    "duracao_minutos" integer NOT NULL,
    "categoria_id" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "categoria_id_2" "uuid"
);


ALTER TABLE "public"."servicos" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."servicos_public" WITH ("security_invoker"='on') AS
 SELECT "id",
    "nome",
    "descricao",
    "valor",
    "duracao_minutos",
    "barbearia_id"
   FROM "public"."servicos" "s";


ALTER VIEW "public"."servicos_public" OWNER TO "postgres";


ALTER TABLE ONLY "public"."agendamentos"
    ADD CONSTRAINT "agendamentos_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."assinaturas"
    ADD CONSTRAINT "assinaturas_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."audit_log"
    ADD CONSTRAINT "audit_log_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."barbearias"
    ADD CONSTRAINT "barbearias_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."barbearias"
    ADD CONSTRAINT "barbearias_slug_key" UNIQUE ("slug");



ALTER TABLE ONLY "public"."categorias_servicos"
    ADD CONSTRAINT "categorias_servicos_nome_key" UNIQUE ("nome");



ALTER TABLE ONLY "public"."categorias_servicos"
    ADD CONSTRAINT "categorias_servicos_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."feedbacks"
    ADD CONSTRAINT "feedbacks_agendamento_id_key" UNIQUE ("agendamento_id");



ALTER TABLE ONLY "public"."feedbacks"
    ADD CONSTRAINT "feedbacks_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."fidelidade"
    ADD CONSTRAINT "fidelidade_barbearia_telefone_unique" UNIQUE ("barbearia_id", "cliente_telefone");



ALTER TABLE ONLY "public"."fidelidade_configuracoes"
    ADD CONSTRAINT "fidelidade_configuracoes_barbearia_id_key" UNIQUE ("barbearia_id");



ALTER TABLE ONLY "public"."fidelidade_configuracoes"
    ADD CONSTRAINT "fidelidade_configuracoes_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."fidelidade"
    ADD CONSTRAINT "fidelidade_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."funcionario_ausencias"
    ADD CONSTRAINT "funcionario_ausencias_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."funcionario_convites"
    ADD CONSTRAINT "funcionario_convites_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."funcionario_pausas"
    ADD CONSTRAINT "funcionario_pausas_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."funcionarios_atendimentos"
    ADD CONSTRAINT "funcionarios_atendimentos_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."funcionarios"
    ADD CONSTRAINT "funcionarios_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."funcionarios"
    ADD CONSTRAINT "funcionarios_user_id_key" UNIQUE ("user_id");



ALTER TABLE ONLY "public"."horarios_funcionamento"
    ADD CONSTRAINT "horarios_funcionamento_barbearia_id_dia_semana_key" UNIQUE ("barbearia_id", "dia_semana");



ALTER TABLE ONLY "public"."horarios_funcionamento"
    ADD CONSTRAINT "horarios_funcionamento_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_user_id_key" UNIQUE ("user_id");



ALTER TABLE ONLY "public"."recompensas"
    ADD CONSTRAINT "recompensas_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."resgates_recompensas"
    ADD CONSTRAINT "resgates_recompensas_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."servicos"
    ADD CONSTRAINT "servicos_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."assinaturas"
    ADD CONSTRAINT "unique_barbearia_ativa" UNIQUE ("barbearia_id") DEFERRABLE INITIALLY DEFERRED;



ALTER TABLE ONLY "public"."funcionario_pausas"
    ADD CONSTRAINT "unique_pausa_funcionario" UNIQUE ("funcionario_id", "data", "hora_inicio");



CREATE INDEX "idx_agendamentos_avaliado" ON "public"."agendamentos" USING "btree" ("avaliado");



CREATE INDEX "idx_agendamentos_barbearia_datahora" ON "public"."agendamentos" USING "btree" ("barbearia_id", "data_hora");



CREATE INDEX "idx_agendamentos_origem" ON "public"."agendamentos" USING "btree" ("origem");



CREATE INDEX "idx_agendamentos_telefone" ON "public"."agendamentos" USING "btree" ("cliente_telefone");



CREATE INDEX "idx_agendamentos_user" ON "public"."agendamentos" USING "btree" ("user_id");



CREATE INDEX "idx_assinaturas_barbearia_id" ON "public"."assinaturas" USING "btree" ("barbearia_id");



CREATE INDEX "idx_assinaturas_data_fim" ON "public"."assinaturas" USING "btree" ("data_fim");



CREATE INDEX "idx_assinaturas_status" ON "public"."assinaturas" USING "btree" ("status");



CREATE INDEX "idx_assinaturas_stripe_subscription" ON "public"."assinaturas" USING "btree" ("stripe_subscription_id");



CREATE INDEX "idx_atendimentos_barbearia" ON "public"."funcionarios_atendimentos" USING "btree" ("barbearia_id");



CREATE INDEX "idx_atendimentos_data" ON "public"."funcionarios_atendimentos" USING "btree" ("data_atendimento");



CREATE INDEX "idx_atendimentos_funcionario" ON "public"."funcionarios_atendimentos" USING "btree" ("funcionario_id");



CREATE INDEX "idx_ausencias_barbearia" ON "public"."funcionario_ausencias" USING "btree" ("barbearia_id");



CREATE INDEX "idx_ausencias_funcionario_periodo" ON "public"."funcionario_ausencias" USING "btree" ("funcionario_id", "data_inicio", "data_fim");



CREATE INDEX "idx_barbearias_descricao_search" ON "public"."barbearias" USING "gin" ("to_tsvector"('"portuguese"'::"regconfig", "descricao"));



CREATE INDEX "idx_barbearias_updated_at" ON "public"."barbearias" USING "btree" ("updated_at");



CREATE INDEX "idx_feedbacks_barbearia_status" ON "public"."feedbacks" USING "btree" ("barbearia_id", "status");



CREATE INDEX "idx_feedbacks_status" ON "public"."feedbacks" USING "btree" ("status");



CREATE INDEX "idx_fidelidade_telefone" ON "public"."fidelidade" USING "btree" ("cliente_telefone");



CREATE INDEX "idx_funcionario_convites_barbearia_id" ON "public"."funcionario_convites" USING "btree" ("barbearia_id");



CREATE INDEX "idx_funcionario_convites_email" ON "public"."funcionario_convites" USING "btree" ("email");



CREATE INDEX "idx_funcionario_convites_token" ON "public"."funcionario_convites" USING "btree" ("token");



CREATE INDEX "idx_funcionario_pausas_barbearia" ON "public"."funcionario_pausas" USING "btree" ("barbearia_id");



CREATE INDEX "idx_funcionario_pausas_data" ON "public"."funcionario_pausas" USING "btree" ("data");



CREATE INDEX "idx_funcionario_pausas_funcionario" ON "public"."funcionario_pausas" USING "btree" ("funcionario_id");



CREATE INDEX "idx_horarios_funcionamento_barbearia_id" ON "public"."horarios_funcionamento" USING "btree" ("barbearia_id");



CREATE INDEX "idx_profiles_auth_lookup" ON "public"."profiles" USING "btree" ("user_id", "role", "barbearia_id") WHERE ("user_id" IS NOT NULL);



CREATE INDEX "idx_profiles_barbearia_id" ON "public"."profiles" USING "btree" ("barbearia_id") WHERE ("barbearia_id" IS NOT NULL);



CREATE INDEX "idx_profiles_barbearia_role_fast" ON "public"."profiles" USING "btree" ("barbearia_id", "role") WHERE ("barbearia_id" IS NOT NULL);



CREATE INDEX "idx_profiles_barbearia_staff" ON "public"."profiles" USING "btree" ("barbearia_id", "role", "user_id") WHERE (("barbearia_id" IS NOT NULL) AND ("role" = ANY (ARRAY['admin'::"public"."user_role", 'funcionario'::"public"."user_role"])));



CREATE INDEX "idx_profiles_role_barbearia_optimized" ON "public"."profiles" USING "btree" ("role", "barbearia_id") WHERE ("barbearia_id" IS NOT NULL);



CREATE INDEX "idx_profiles_user_id_login" ON "public"."profiles" USING "btree" ("user_id");



CREATE INDEX "idx_profiles_user_id_optimized" ON "public"."profiles" USING "btree" ("user_id");



CREATE INDEX "idx_recompensas_ativo" ON "public"."recompensas" USING "btree" ("ativo");



CREATE INDEX "idx_recompensas_barbearia_id" ON "public"."recompensas" USING "btree" ("barbearia_id");



CREATE INDEX "idx_resgates_barbearia_cliente" ON "public"."resgates_recompensas" USING "btree" ("barbearia_id", "cliente_telefone");



CREATE INDEX "idx_servicos_categoria_id" ON "public"."servicos" USING "btree" ("categoria_id") WHERE ("categoria_id" IS NOT NULL);



CREATE INDEX "idx_servicos_categoria_id_2" ON "public"."servicos" USING "btree" ("categoria_id_2") WHERE ("categoria_id_2" IS NOT NULL);



CREATE INDEX "idx_servicos_categoria_id_2_fk" ON "public"."servicos" USING "btree" ("categoria_id_2") WHERE ("categoria_id_2" IS NOT NULL);



CREATE INDEX "idx_servicos_categorias" ON "public"."servicos" USING "btree" ("categoria_id", "categoria_id_2") WHERE (("categoria_id" IS NOT NULL) OR ("categoria_id_2" IS NOT NULL));



CREATE OR REPLACE TRIGGER "trigger_create_feedback_on_completion" AFTER UPDATE ON "public"."agendamentos" FOR EACH ROW EXECUTE FUNCTION "public"."create_feedback_on_completion"();



CREATE OR REPLACE TRIGGER "trigger_insert_owner_as_employee" AFTER INSERT ON "public"."barbearias" FOR EACH ROW EXECUTE FUNCTION "public"."insert_owner_as_employee"();



CREATE OR REPLACE TRIGGER "trigger_registrar_comissao" AFTER UPDATE ON "public"."agendamentos" FOR EACH ROW EXECUTE FUNCTION "public"."registrar_comissao_agendamento"();



CREATE OR REPLACE TRIGGER "trigger_update_profile_on_employee_creation" AFTER INSERT ON "public"."funcionarios" FOR EACH ROW EXECUTE FUNCTION "public"."update_profile_on_employee_creation"();



CREATE OR REPLACE TRIGGER "trigger_update_recompensas_updated_at" BEFORE UPDATE ON "public"."recompensas" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_recompensas"();



CREATE OR REPLACE TRIGGER "trigger_validate_anonymous_appointment" BEFORE INSERT ON "public"."agendamentos" FOR EACH ROW EXECUTE FUNCTION "public"."validate_anonymous_appointment"();



CREATE OR REPLACE TRIGGER "trigger_validate_funcionario_availability" BEFORE INSERT OR UPDATE ON "public"."agendamentos" FOR EACH ROW EXECUTE FUNCTION "public"."validate_funcionario_availability"();



CREATE OR REPLACE TRIGGER "update_assinaturas_updated_at" BEFORE UPDATE ON "public"."assinaturas" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_assinaturas"();



CREATE OR REPLACE TRIGGER "update_ausencias_updated_at" BEFORE UPDATE ON "public"."funcionario_ausencias" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_ausencias"();



CREATE OR REPLACE TRIGGER "update_fidelidade_configuracoes_updated_at" BEFORE UPDATE ON "public"."fidelidade_configuracoes" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_fidelidade_configuracoes"();



CREATE OR REPLACE TRIGGER "update_funcionario_pausas_updated_at" BEFORE UPDATE ON "public"."funcionario_pausas" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_ausencias"();



CREATE OR REPLACE TRIGGER "validate_agendamento_before_insert" BEFORE INSERT OR UPDATE ON "public"."agendamentos" FOR EACH ROW EXECUTE FUNCTION "public"."validate_and_sanitize_agendamento_data"();



COMMENT ON TRIGGER "validate_agendamento_before_insert" ON "public"."agendamentos" IS 'Executa validação e sanitização automática de dados antes de INSERT/UPDATE';



ALTER TABLE ONLY "public"."agendamentos"
    ADD CONSTRAINT "agendamentos_barbearia_id_fkey" FOREIGN KEY ("barbearia_id") REFERENCES "public"."barbearias"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."agendamentos"
    ADD CONSTRAINT "agendamentos_funcionario_id_fkey" FOREIGN KEY ("funcionario_id") REFERENCES "public"."funcionarios"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."agendamentos"
    ADD CONSTRAINT "agendamentos_servico_id_fkey" FOREIGN KEY ("servico_id") REFERENCES "public"."servicos"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."agendamentos"
    ADD CONSTRAINT "agendamentos_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("user_id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."assinaturas"
    ADD CONSTRAINT "assinaturas_barbearia_id_fkey" FOREIGN KEY ("barbearia_id") REFERENCES "public"."barbearias"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."audit_log"
    ADD CONSTRAINT "audit_log_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."feedbacks"
    ADD CONSTRAINT "feedbacks_agendamento_id_fkey" FOREIGN KEY ("agendamento_id") REFERENCES "public"."agendamentos"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."feedbacks"
    ADD CONSTRAINT "feedbacks_barbearia_id_fkey" FOREIGN KEY ("barbearia_id") REFERENCES "public"."barbearias"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."feedbacks"
    ADD CONSTRAINT "feedbacks_responded_by_fkey" FOREIGN KEY ("responded_by") REFERENCES "public"."profiles"("user_id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."feedbacks"
    ADD CONSTRAINT "feedbacks_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("user_id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."fidelidade"
    ADD CONSTRAINT "fidelidade_barbearia_id_fkey" FOREIGN KEY ("barbearia_id") REFERENCES "public"."barbearias"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."fidelidade_configuracoes"
    ADD CONSTRAINT "fidelidade_configuracoes_barbearia_id_fkey" FOREIGN KEY ("barbearia_id") REFERENCES "public"."barbearias"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."fidelidade"
    ADD CONSTRAINT "fidelidade_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("user_id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."servicos"
    ADD CONSTRAINT "fk_servicos_categoria_id" FOREIGN KEY ("categoria_id") REFERENCES "public"."categorias_servicos"("id");



ALTER TABLE ONLY "public"."servicos"
    ADD CONSTRAINT "fk_servicos_categoria_id_2" FOREIGN KEY ("categoria_id_2") REFERENCES "public"."categorias_servicos"("id");



ALTER TABLE ONLY "public"."funcionario_ausencias"
    ADD CONSTRAINT "funcionario_ausencias_barbearia_id_fkey" FOREIGN KEY ("barbearia_id") REFERENCES "public"."barbearias"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."funcionario_ausencias"
    ADD CONSTRAINT "funcionario_ausencias_funcionario_id_fkey" FOREIGN KEY ("funcionario_id") REFERENCES "public"."funcionarios"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."funcionario_convites"
    ADD CONSTRAINT "funcionario_convites_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."funcionario_pausas"
    ADD CONSTRAINT "funcionario_pausas_barbearia_id_fkey" FOREIGN KEY ("barbearia_id") REFERENCES "public"."barbearias"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."funcionario_pausas"
    ADD CONSTRAINT "funcionario_pausas_funcionario_id_fkey" FOREIGN KEY ("funcionario_id") REFERENCES "public"."funcionarios"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."funcionarios_atendimentos"
    ADD CONSTRAINT "funcionarios_atendimentos_agendamento_id_fkey" FOREIGN KEY ("agendamento_id") REFERENCES "public"."agendamentos"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."funcionarios_atendimentos"
    ADD CONSTRAINT "funcionarios_atendimentos_barbearia_id_fkey" FOREIGN KEY ("barbearia_id") REFERENCES "public"."barbearias"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."funcionarios_atendimentos"
    ADD CONSTRAINT "funcionarios_atendimentos_funcionario_id_fkey" FOREIGN KEY ("funcionario_id") REFERENCES "public"."funcionarios"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."funcionarios_atendimentos"
    ADD CONSTRAINT "funcionarios_atendimentos_servico_id_fkey" FOREIGN KEY ("servico_id") REFERENCES "public"."servicos"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."funcionarios"
    ADD CONSTRAINT "funcionarios_barbearia_id_fkey" FOREIGN KEY ("barbearia_id") REFERENCES "public"."barbearias"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."funcionarios"
    ADD CONSTRAINT "funcionarios_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("user_id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."recompensas"
    ADD CONSTRAINT "recompensas_barbearia_id_fkey" FOREIGN KEY ("barbearia_id") REFERENCES "public"."barbearias"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."resgates_recompensas"
    ADD CONSTRAINT "resgates_recompensas_barbearia_id_fkey" FOREIGN KEY ("barbearia_id") REFERENCES "public"."barbearias"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."resgates_recompensas"
    ADD CONSTRAINT "resgates_recompensas_recompensa_id_fkey" FOREIGN KEY ("recompensa_id") REFERENCES "public"."recompensas"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."servicos"
    ADD CONSTRAINT "servicos_barbearia_id_fkey" FOREIGN KEY ("barbearia_id") REFERENCES "public"."barbearias"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."servicos"
    ADD CONSTRAINT "servicos_categoria_id_fkey" FOREIGN KEY ("categoria_id") REFERENCES "public"."categorias_servicos"("id") ON DELETE SET NULL;



CREATE POLICY "Admins can create ausencias" ON "public"."funcionario_ausencias" FOR INSERT TO "authenticated" WITH CHECK ((("public"."get_current_user_role"() = 'admin'::"public"."user_role") AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id")));



CREATE POLICY "Admins can create invites" ON "public"."funcionario_convites" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."profiles"
  WHERE (("profiles"."user_id" = "auth"."uid"()) AND ("profiles"."barbearia_id" = "funcionario_convites"."barbearia_id") AND ("profiles"."role" = 'admin'::"public"."user_role")))));



CREATE POLICY "Admins can delete ausencias" ON "public"."funcionario_ausencias" FOR DELETE TO "authenticated" USING ((("public"."get_current_user_role"() = 'admin'::"public"."user_role") AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id")));



CREATE POLICY "Admins can delete barbearia funcionarios" ON "public"."funcionarios" FOR DELETE TO "authenticated" USING ((("public"."get_current_user_role"() = 'admin'::"public"."user_role") AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id")));



CREATE POLICY "Admins can insert barbearia funcionarios" ON "public"."funcionarios" FOR INSERT TO "authenticated" WITH CHECK ((("public"."get_current_user_role"() = 'admin'::"public"."user_role") AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id")));



CREATE POLICY "Admins can insert barbearias" ON "public"."barbearias" FOR INSERT TO "authenticated" WITH CHECK (("public"."get_current_user_role"() = 'admin'::"public"."user_role"));



CREATE POLICY "Admins can insert own barbearia assinatura" ON "public"."assinaturas" FOR INSERT TO "authenticated" WITH CHECK ((("public"."get_current_user_role"() = 'admin'::"public"."user_role") AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id")));



CREATE POLICY "Admins can manage atendimentos" ON "public"."funcionarios_atendimentos" USING ((("public"."get_current_user_role"() = 'admin'::"public"."user_role") AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id"))) WITH CHECK ((("public"."get_current_user_role"() = 'admin'::"public"."user_role") AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id")));



CREATE POLICY "Admins can manage barbearia convites" ON "public"."funcionario_convites" USING ((("public"."get_current_user_role"() = 'admin'::"public"."user_role") AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id"))) WITH CHECK ((("public"."get_current_user_role"() = 'admin'::"public"."user_role") AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id")));



CREATE POLICY "Admins can manage barbearia horarios" ON "public"."horarios_funcionamento" USING ((("public"."get_current_user_role"() = 'admin'::"public"."user_role") AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id"))) WITH CHECK ((("public"."get_current_user_role"() = 'admin'::"public"."user_role") AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id")));



CREATE POLICY "Admins can manage barbearia recompensas" ON "public"."recompensas" TO "authenticated" USING ((("public"."get_current_user_role"() = 'admin'::"public"."user_role") AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id"))) WITH CHECK ((("public"."get_current_user_role"() = 'admin'::"public"."user_role") AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id")));



CREATE POLICY "Admins can manage barbearia servicos" ON "public"."servicos" TO "authenticated" USING ((("public"."get_current_user_role"() = 'admin'::"public"."user_role") AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id"))) WITH CHECK ((("public"."get_current_user_role"() = 'admin'::"public"."user_role") AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id")));



CREATE POLICY "Admins can manage own barbearia fidelidade config" ON "public"."fidelidade_configuracoes" USING ((("public"."get_current_user_role"() = 'admin'::"public"."user_role") AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id"))) WITH CHECK ((("public"."get_current_user_role"() = 'admin'::"public"."user_role") AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id")));



CREATE POLICY "Admins can update ausencias" ON "public"."funcionario_ausencias" FOR UPDATE TO "authenticated" USING ((("public"."get_current_user_role"() = 'admin'::"public"."user_role") AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id")));



CREATE POLICY "Admins can update barbearia funcionarios" ON "public"."funcionarios" FOR UPDATE TO "authenticated" USING ((("public"."get_current_user_role"() = 'admin'::"public"."user_role") AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id")));



CREATE POLICY "Admins can update employees" ON "public"."funcionarios" FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM "public"."profiles"
  WHERE (("profiles"."user_id" = "auth"."uid"()) AND ("profiles"."barbearia_id" = "funcionarios"."barbearia_id") AND ("profiles"."role" = 'admin'::"public"."user_role")))));



CREATE POLICY "Admins can update own barbearia" ON "public"."barbearias" FOR UPDATE TO "authenticated" USING ((("public"."get_current_user_role"() = 'admin'::"public"."user_role") AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "id")));



CREATE POLICY "Admins can update own barbearia assinatura" ON "public"."assinaturas" FOR UPDATE TO "authenticated" USING ((("public"."get_current_user_role"() = 'admin'::"public"."user_role") AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id")));



CREATE POLICY "Admins can view barbearia convites" ON "public"."funcionario_convites" FOR SELECT USING ((( SELECT "profiles"."barbearia_id"
   FROM "public"."profiles"
  WHERE (("profiles"."user_id" = "auth"."uid"()) AND ("profiles"."role" = 'admin'::"public"."user_role"))) = "barbearia_id"));



CREATE POLICY "Admins can view barbearia funcionarios" ON "public"."funcionarios" FOR SELECT TO "authenticated" USING ((("public"."get_current_user_role"() = 'admin'::"public"."user_role") AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id")));



CREATE POLICY "Admins can view own barbearia assinatura" ON "public"."assinaturas" FOR SELECT TO "authenticated" USING ((("public"."get_current_user_role"() = 'admin'::"public"."user_role") AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id")));



CREATE POLICY "Allow employee insertion during invite" ON "public"."funcionarios" FOR INSERT WITH CHECK (true);



CREATE POLICY "Allow invite updates" ON "public"."funcionario_convites" FOR UPDATE USING (true);



CREATE POLICY "Anon can create appointments" ON "public"."agendamentos" FOR INSERT TO "anon" WITH CHECK ((("cliente_nome" IS NOT NULL) AND ("cliente_telefone" IS NOT NULL) AND ("data_hora" IS NOT NULL) AND ("barbearia_id" IS NOT NULL) AND ("servico_id" IS NOT NULL) AND ("user_id" IS NULL)));



CREATE POLICY "Anon can view horarios_funcionamento" ON "public"."horarios_funcionamento" FOR SELECT TO "anon" USING (true);



CREATE POLICY "Anon can view servicos" ON "public"."servicos" FOR SELECT TO "anon" USING (true);



CREATE POLICY "Anonymous limited view of funcionarios" ON "public"."funcionarios" FOR SELECT TO "anon" USING (true);



CREATE POLICY "Anonymous users can view horarios" ON "public"."horarios_funcionamento" FOR SELECT USING (true);



CREATE POLICY "Anonymous users can view servicos" ON "public"."servicos" FOR SELECT USING (true);



CREATE POLICY "Anyone can view categorias_servicos" ON "public"."categorias_servicos" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Anyone can view horarios_funcionamento" ON "public"."horarios_funcionamento" FOR SELECT USING (true);



CREATE POLICY "Anyone can view recompensas" ON "public"."recompensas" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Anyone can view servicos" ON "public"."servicos" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Authenticated users can insert categorias_servicos" ON "public"."categorias_servicos" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "Authenticated users can update categorias_servicos" ON "public"."categorias_servicos" FOR UPDATE TO "authenticated" USING (true);



CREATE POLICY "Authenticated users can view funcionarios from same barbershop" ON "public"."funcionarios" FOR SELECT TO "authenticated" USING ((("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id") OR ("public"."get_current_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'funcionario'::"public"."user_role"]))));



CREATE POLICY "Cliente pode atualizar seus próprios feedbacks" ON "public"."feedbacks" FOR UPDATE USING ((("auth"."uid"() IS NOT NULL) AND (EXISTS ( SELECT 1
   FROM "public"."agendamentos" "a"
  WHERE (("a"."id" = "feedbacks"."agendamento_id") AND ("a"."user_id" = "auth"."uid"())))))) WITH CHECK ((("auth"."uid"() IS NOT NULL) AND (EXISTS ( SELECT 1
   FROM "public"."agendamentos" "a"
  WHERE (("a"."id" = "feedbacks"."agendamento_id") AND ("a"."user_id" = "auth"."uid"()))))));



CREATE POLICY "Cliente pode ver seus próprios feedbacks" ON "public"."feedbacks" FOR SELECT USING ((("auth"."uid"() IS NOT NULL) AND (EXISTS ( SELECT 1
   FROM "public"."agendamentos" "a"
  WHERE (("a"."id" = "feedbacks"."agendamento_id") AND ("a"."user_id" = "auth"."uid"()))))));



CREATE POLICY "Clientes podem visualizar funcionarios" ON "public"."funcionarios" FOR SELECT TO "authenticated" USING (("public"."get_current_user_role"() = 'cliente'::"public"."user_role"));



CREATE POLICY "Clients can create own appointments" ON "public"."agendamentos" FOR INSERT TO "authenticated" WITH CHECK ((("cliente_nome" IS NOT NULL) AND ("cliente_telefone" IS NOT NULL) AND ("data_hora" IS NOT NULL) AND ("barbearia_id" IS NOT NULL) AND ("servico_id" IS NOT NULL) AND ("public"."get_current_user_role"() = 'cliente'::"public"."user_role") AND ("auth"."uid"() = "user_id")));



CREATE POLICY "Clients can view own feedbacks" ON "public"."feedbacks" FOR SELECT USING ((("auth"."uid"() IS NOT NULL) AND ("auth"."uid"() = "user_id")));



CREATE POLICY "Delete invites policy" ON "public"."funcionario_convites" FOR DELETE USING ((EXISTS ( SELECT 1
   FROM "public"."profiles"
  WHERE (("profiles"."user_id" = "auth"."uid"()) AND ("profiles"."role" = 'admin'::"public"."user_role") AND ("profiles"."barbearia_id" = "funcionario_convites"."barbearia_id")))));



CREATE POLICY "Funcionarios can update appointments" ON "public"."agendamentos" FOR UPDATE TO "authenticated" USING ((("public"."get_current_user_role"() = 'funcionario'::"public"."user_role") AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id")));



CREATE POLICY "Funcionarios can view appointments" ON "public"."agendamentos" FOR SELECT TO "authenticated" USING ((("public"."get_current_user_role"() = 'funcionario'::"public"."user_role") AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id")));



CREATE POLICY "Handle new user can insert barbearia" ON "public"."barbearias" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "Handle new user can insert funcionario" ON "public"."funcionarios" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "Handle new user can insert profile" ON "public"."profiles" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "Handle new user can update profile" ON "public"."profiles" FOR UPDATE TO "authenticated" USING (("auth"."uid"() = "user_id")) WITH CHECK (("auth"."uid"() = "user_id"));



CREATE POLICY "Insert invites policy" ON "public"."funcionario_convites" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."profiles"
  WHERE (("profiles"."user_id" = "auth"."uid"()) AND ("profiles"."role" = 'admin'::"public"."user_role") AND ("profiles"."barbearia_id" = "funcionario_convites"."barbearia_id")))));



CREATE POLICY "Limited public access to barbearias" ON "public"."barbearias" FOR SELECT USING (true);



CREATE POLICY "Only admins can view audit logs" ON "public"."audit_log" FOR SELECT TO "authenticated" USING (("public"."get_current_user_role"() = 'admin'::"public"."user_role"));



CREATE POLICY "Public can view ausencias for availability" ON "public"."funcionario_ausencias" FOR SELECT TO "authenticated", "anon" USING (true);



CREATE POLICY "Public can view completed feedbacks" ON "public"."feedbacks" FOR SELECT USING (("status" = 'concluido'::"text"));



CREATE POLICY "Public can view pausas for availability" ON "public"."funcionario_pausas" FOR SELECT USING (true);



CREATE POLICY "Read specific invite by exact token match" ON "public"."funcionario_convites" FOR SELECT TO "authenticated", "anon" USING ((("usado" = false) AND ("expires_at" > "now"())));



CREATE POLICY "Select invites policy" ON "public"."funcionario_convites" FOR SELECT USING (((EXISTS ( SELECT 1
   FROM "public"."profiles"
  WHERE (("profiles"."user_id" = "auth"."uid"()) AND ("profiles"."role" = 'admin'::"public"."user_role") AND ("profiles"."barbearia_id" = "funcionario_convites"."barbearia_id")))) OR (("auth"."uid"() IS NULL) AND ("token" IS NOT NULL))));



CREATE POLICY "Sistema e clientes podem inserir feedbacks" ON "public"."feedbacks" FOR INSERT WITH CHECK (((("auth"."uid"() IS NOT NULL) AND (EXISTS ( SELECT 1
   FROM "public"."agendamentos" "a"
  WHERE (("a"."id" = "feedbacks"."agendamento_id") AND ("a"."user_id" = "auth"."uid"()) AND ("a"."status" = 'finalizado'::"public"."agendamento_status"))))) OR (EXISTS ( SELECT 1
   FROM "public"."agendamentos" "a"
  WHERE (("a"."id" = "feedbacks"."agendamento_id") AND ("a"."status" = 'finalizado'::"public"."agendamento_status") AND ("a"."user_id" = "feedbacks"."user_id") AND ("a"."barbearia_id" = "feedbacks"."barbearia_id"))))));



COMMENT ON POLICY "Sistema e clientes podem inserir feedbacks" ON "public"."feedbacks" IS 'Permite que clientes criem feedbacks para seus agendamentos finalizados E que o sistema crie feedbacks automaticamente via trigger quando um agendamento é finalizado';



CREATE POLICY "Staff can create barbearia appointments" ON "public"."agendamentos" FOR INSERT TO "authenticated" WITH CHECK ((("cliente_nome" IS NOT NULL) AND ("cliente_telefone" IS NOT NULL) AND ("data_hora" IS NOT NULL) AND ("barbearia_id" IS NOT NULL) AND ("servico_id" IS NOT NULL) AND ("public"."get_current_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'funcionario'::"public"."user_role"])) AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id")));



CREATE POLICY "Staff can create own pausas" ON "public"."funcionario_pausas" FOR INSERT WITH CHECK ((("public"."get_current_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'funcionario'::"public"."user_role"])) AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id")));



CREATE POLICY "Staff can delete own pausas" ON "public"."funcionario_pausas" FOR DELETE USING ((("public"."get_current_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'funcionario'::"public"."user_role"])) AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id")));



CREATE POLICY "Staff can insert barbearia resgates" ON "public"."resgates_recompensas" FOR INSERT TO "authenticated" WITH CHECK ((("public"."get_current_user_role"() = ANY (ARRAY['funcionario'::"public"."user_role", 'admin'::"public"."user_role"])) AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id")));



CREATE POLICY "Staff can manage barbearia fidelidade" ON "public"."fidelidade" TO "authenticated" USING ((("public"."get_current_user_role"() = ANY (ARRAY['funcionario'::"public"."user_role", 'admin'::"public"."user_role"])) AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id"))) WITH CHECK ((("public"."get_current_user_role"() = ANY (ARRAY['funcionario'::"public"."user_role", 'admin'::"public"."user_role"])) AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id")));



CREATE POLICY "Staff can update barbearia agendamentos" ON "public"."agendamentos" FOR UPDATE TO "authenticated" USING ((("public"."get_current_user_role"() = ANY (ARRAY['funcionario'::"public"."user_role", 'admin'::"public"."user_role"])) AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id")));



CREATE POLICY "Staff can update barbearia feedbacks" ON "public"."feedbacks" FOR UPDATE TO "authenticated" USING ((("public"."get_current_user_role"() = ANY (ARRAY['funcionario'::"public"."user_role", 'admin'::"public"."user_role"])) AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id")));



CREATE POLICY "Staff can update own pausas" ON "public"."funcionario_pausas" FOR UPDATE USING ((("public"."get_current_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'funcionario'::"public"."user_role"])) AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id")));



CREATE POLICY "Staff can view atendimentos" ON "public"."funcionarios_atendimentos" FOR SELECT USING ((("public"."get_current_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'funcionario'::"public"."user_role"])) AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id")));



CREATE POLICY "Staff can view barbearia agendamentos" ON "public"."agendamentos" FOR SELECT USING (
CASE
    WHEN (("public"."get_current_user_role"() = 'admin'::"public"."user_role") AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id")) THEN true
    WHEN (("public"."get_current_user_role"() = 'funcionario'::"public"."user_role") AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id")) THEN (("funcionario_id" IS NULL) OR ("funcionario_id" IN ( SELECT "funcionarios"."id"
       FROM "public"."funcionarios"
      WHERE ("funcionarios"."user_id" = "auth"."uid"()))))
    ELSE false
END);



CREATE POLICY "Staff can view barbearia ausencias" ON "public"."funcionario_ausencias" FOR SELECT TO "authenticated" USING ((("public"."get_current_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'funcionario'::"public"."user_role"])) AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id")));



CREATE POLICY "Staff can view barbearia feedbacks" ON "public"."feedbacks" FOR SELECT USING ((("public"."get_current_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'funcionario'::"public"."user_role"])) AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id")));



CREATE POLICY "Staff can view barbearia pausas" ON "public"."funcionario_pausas" FOR SELECT USING ((("public"."get_current_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'funcionario'::"public"."user_role"])) AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id")));



CREATE POLICY "Staff pode ver feedbacks da barbearia" ON "public"."feedbacks" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM "public"."profiles" "p"
  WHERE (("p"."user_id" = "auth"."uid"()) AND ("p"."barbearia_id" = "feedbacks"."barbearia_id") AND ("p"."role" = ANY (ARRAY['admin'::"public"."user_role", 'funcionario'::"public"."user_role"]))))));



CREATE POLICY "System can insert audit logs" ON "public"."audit_log" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "Todos podem ver pausas da mesma barbearia" ON "public"."funcionario_pausas" FOR SELECT USING (("barbearia_id" IN ( SELECT "profiles"."barbearia_id"
   FROM "public"."profiles"
  WHERE ("profiles"."user_id" = "auth"."uid"()))));



CREATE POLICY "Update invites policy" ON "public"."funcionario_convites" FOR UPDATE USING (((EXISTS ( SELECT 1
   FROM "public"."profiles"
  WHERE (("profiles"."user_id" = "auth"."uid"()) AND ("profiles"."role" = 'admin'::"public"."user_role") AND ("profiles"."barbearia_id" = "funcionario_convites"."barbearia_id")))) OR (("auth"."uid"() IS NULL) AND ("usado" = false)))) WITH CHECK (((EXISTS ( SELECT 1
   FROM "public"."profiles"
  WHERE (("profiles"."user_id" = "auth"."uid"()) AND ("profiles"."role" = 'admin'::"public"."user_role") AND ("profiles"."barbearia_id" = "funcionario_convites"."barbearia_id")))) OR (("auth"."uid"() IS NULL) AND ("usado" = true))));



CREATE POLICY "Users can read employees from same barbershop" ON "public"."funcionarios" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM "public"."profiles"
  WHERE (("profiles"."user_id" = "auth"."uid"()) AND ("profiles"."barbearia_id" = "funcionarios"."barbearia_id")))));



CREATE POLICY "Users can view relevant agendamentos" ON "public"."agendamentos" FOR SELECT TO "authenticated" USING (((("public"."get_current_user_role"() = 'cliente'::"public"."user_role") AND ("auth"."uid"() = "user_id")) OR (("public"."get_current_user_role"() = ANY (ARRAY['funcionario'::"public"."user_role", 'admin'::"public"."user_role"])) AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id"))));



CREATE POLICY "Users can view relevant fidelidade" ON "public"."fidelidade" FOR SELECT TO "authenticated" USING (((("public"."get_current_user_role"() = 'cliente'::"public"."user_role") AND ("auth"."uid"() = "user_id")) OR (("public"."get_current_user_role"() = ANY (ARRAY['funcionario'::"public"."user_role", 'admin'::"public"."user_role"])) AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id"))));



CREATE POLICY "Users can view relevant resgates" ON "public"."resgates_recompensas" FOR SELECT TO "authenticated" USING ((("public"."get_current_user_role"() = ANY (ARRAY['funcionario'::"public"."user_role", 'admin'::"public"."user_role"])) AND ("public"."get_user_barbearia_id"("auth"."uid"()) = "barbearia_id")));



ALTER TABLE "public"."agendamentos" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."assinaturas" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."audit_log" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."barbearias" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."categorias_servicos" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."feedbacks" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."fidelidade" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."fidelidade_configuracoes" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."funcionario_ausencias" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."funcionario_convites" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."funcionario_pausas" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."funcionarios" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."funcionarios_atendimentos" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."horarios_funcionamento" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."profiles" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "profiles_admin_edit_optimized" ON "public"."profiles" FOR UPDATE USING ((("barbearia_id" IS NOT NULL) AND "public"."user_can_access_barbearia"("barbearia_id", ARRAY['admin'::"public"."user_role"]) AND ("auth"."uid"() <> "user_id"))) WITH CHECK ((("barbearia_id" IS NOT NULL) AND "public"."user_can_access_barbearia"("barbearia_id", ARRAY['admin'::"public"."user_role"]) AND ("auth"."uid"() <> "user_id")));



CREATE POLICY "profiles_audit_log" ON "public"."profiles" USING ((("current_setting"('app.bypass_rls'::"text", true))::boolean = true));



CREATE POLICY "profiles_primary_access" ON "public"."profiles" USING ((("auth"."uid"() = "user_id") OR ("auth"."role"() = 'service_role'::"text"))) WITH CHECK ((("auth"."uid"() = "user_id") OR ("auth"."role"() = 'service_role'::"text")));



CREATE POLICY "profiles_team_read_optimized" ON "public"."profiles" FOR SELECT USING ((("barbearia_id" IS NOT NULL) AND "public"."user_can_access_barbearia"("barbearia_id", ARRAY['admin'::"public"."user_role", 'funcionario'::"public"."user_role"])));



ALTER TABLE "public"."recompensas" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."resgates_recompensas" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."servicos" ENABLE ROW LEVEL SECURITY;




ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";


GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";



GRANT ALL ON FUNCTION "public"."accept_employee_invite"("invite_token" "text", "employee_password" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."accept_employee_invite"("invite_token" "text", "employee_password" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."accept_employee_invite"("invite_token" "text", "employee_password" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."barbearia_tem_assinatura_ativa"("p_barbearia_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."barbearia_tem_assinatura_ativa"("p_barbearia_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."barbearia_tem_assinatura_ativa"("p_barbearia_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."check_anonymous_appointment_limit"("telefone_cliente" "text", "user_id_param" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."check_anonymous_appointment_limit"("telefone_cliente" "text", "user_id_param" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."check_anonymous_appointment_limit"("telefone_cliente" "text", "user_id_param" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."check_funcionario_disponibilidade"("p_funcionario_id" "uuid", "p_data_hora" timestamp with time zone) TO "anon";
GRANT ALL ON FUNCTION "public"."check_funcionario_disponibilidade"("p_funcionario_id" "uuid", "p_data_hora" timestamp with time zone) TO "authenticated";
GRANT ALL ON FUNCTION "public"."check_funcionario_disponibilidade"("p_funcionario_id" "uuid", "p_data_hora" timestamp with time zone) TO "service_role";



GRANT ALL ON FUNCTION "public"."check_if_user_exists"("p_email" "text", "p_phone" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."check_if_user_exists"("p_email" "text", "p_phone" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."check_if_user_exists"("p_email" "text", "p_phone" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."check_rate_limit"("operation_type" "text", "user_identifier" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."check_rate_limit"("operation_type" "text", "user_identifier" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."check_rate_limit"("operation_type" "text", "user_identifier" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."create_feedback_on_completion"() TO "anon";
GRANT ALL ON FUNCTION "public"."create_feedback_on_completion"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_feedback_on_completion"() TO "service_role";



GRANT ALL ON FUNCTION "public"."delete_user_complete"("user_email" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."delete_user_complete"("user_email" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."delete_user_complete"("user_email" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."generate_slug"("text") TO "anon";
GRANT ALL ON FUNCTION "public"."generate_slug"("text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."generate_slug"("text") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_anonymous_appointment_limit"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_anonymous_appointment_limit"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_anonymous_appointment_limit"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_assinatura_ativa"("p_barbearia_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_assinatura_ativa"("p_barbearia_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_assinatura_ativa"("p_barbearia_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_current_user_role"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_current_user_role"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_current_user_role"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_default_funcionario"("barbearia_uuid" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_default_funcionario"("barbearia_uuid" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_default_funcionario"("barbearia_uuid" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_funcionario_data"("user_uuid" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_funcionario_data"("user_uuid" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_funcionario_data"("user_uuid" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_public_profile_info"("profile_user_ids" "uuid"[]) TO "anon";
GRANT ALL ON FUNCTION "public"."get_public_profile_info"("profile_user_ids" "uuid"[]) TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_public_profile_info"("profile_user_ids" "uuid"[]) TO "service_role";



GRANT ALL ON FUNCTION "public"."get_recompensas_disponiveis"("p_barbearia_id" "uuid", "p_cliente_telefone" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."get_recompensas_disponiveis"("p_barbearia_id" "uuid", "p_cliente_telefone" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_recompensas_disponiveis"("p_barbearia_id" "uuid", "p_cliente_telefone" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_user_barbearia_id"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_user_barbearia_id"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_user_barbearia_id"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_user_barbearia_id"("user_uuid" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_user_barbearia_id"("user_uuid" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_user_barbearia_id"("user_uuid" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_user_profile_cached"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_user_profile_cached"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_user_profile_cached"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_user_role"("user_uuid" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_user_role"("user_uuid" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_user_role"("user_uuid" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "service_role";



GRANT ALL ON FUNCTION "public"."insert_owner_as_employee"() TO "anon";
GRANT ALL ON FUNCTION "public"."insert_owner_as_employee"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."insert_owner_as_employee"() TO "service_role";



GRANT ALL ON FUNCTION "public"."registrar_comissao_agendamento"() TO "anon";
GRANT ALL ON FUNCTION "public"."registrar_comissao_agendamento"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."registrar_comissao_agendamento"() TO "service_role";



GRANT ALL ON FUNCTION "public"."resgatar_recompensa"("p_recompensa_id" "uuid", "p_cliente_telefone" "text", "p_barbearia_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."resgatar_recompensa"("p_recompensa_id" "uuid", "p_cliente_telefone" "text", "p_barbearia_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."resgatar_recompensa"("p_recompensa_id" "uuid", "p_cliente_telefone" "text", "p_barbearia_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."update_profile_on_employee_creation"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_profile_on_employee_creation"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_profile_on_employee_creation"() TO "service_role";



GRANT ALL ON FUNCTION "public"."update_updated_at_assinaturas"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_updated_at_assinaturas"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_updated_at_assinaturas"() TO "service_role";



GRANT ALL ON FUNCTION "public"."update_updated_at_ausencias"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_updated_at_ausencias"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_updated_at_ausencias"() TO "service_role";



GRANT ALL ON FUNCTION "public"."update_updated_at_fidelidade_configuracoes"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_updated_at_fidelidade_configuracoes"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_updated_at_fidelidade_configuracoes"() TO "service_role";



GRANT ALL ON FUNCTION "public"."update_updated_at_recompensas"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_updated_at_recompensas"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_updated_at_recompensas"() TO "service_role";



GRANT ALL ON FUNCTION "public"."user_can_access_barbearia"("target_barbearia_id" "uuid", "required_roles" "public"."user_role"[]) TO "anon";
GRANT ALL ON FUNCTION "public"."user_can_access_barbearia"("target_barbearia_id" "uuid", "required_roles" "public"."user_role"[]) TO "authenticated";
GRANT ALL ON FUNCTION "public"."user_can_access_barbearia"("target_barbearia_id" "uuid", "required_roles" "public"."user_role"[]) TO "service_role";



GRANT ALL ON FUNCTION "public"."user_is_admin_of_barbearia"("check_barbearia_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."user_is_admin_of_barbearia"("check_barbearia_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."user_is_admin_of_barbearia"("check_barbearia_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."user_is_staff_of_barbearia"("check_barbearia_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."user_is_staff_of_barbearia"("check_barbearia_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."user_is_staff_of_barbearia"("check_barbearia_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."validate_and_sanitize_agendamento_data"() TO "anon";
GRANT ALL ON FUNCTION "public"."validate_and_sanitize_agendamento_data"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."validate_and_sanitize_agendamento_data"() TO "service_role";



GRANT ALL ON FUNCTION "public"."validate_anonymous_appointment"() TO "anon";
GRANT ALL ON FUNCTION "public"."validate_anonymous_appointment"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."validate_anonymous_appointment"() TO "service_role";



GRANT ALL ON FUNCTION "public"."validate_funcionario_availability"() TO "anon";
GRANT ALL ON FUNCTION "public"."validate_funcionario_availability"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."validate_funcionario_availability"() TO "service_role";


















GRANT ALL ON TABLE "public"."agendamentos" TO "anon";
GRANT ALL ON TABLE "public"."agendamentos" TO "authenticated";
GRANT ALL ON TABLE "public"."agendamentos" TO "service_role";



GRANT ALL ON TABLE "public"."assinaturas" TO "anon";
GRANT ALL ON TABLE "public"."assinaturas" TO "authenticated";
GRANT ALL ON TABLE "public"."assinaturas" TO "service_role";



GRANT ALL ON TABLE "public"."audit_log" TO "anon";
GRANT ALL ON TABLE "public"."audit_log" TO "authenticated";
GRANT ALL ON TABLE "public"."audit_log" TO "service_role";



GRANT ALL ON TABLE "public"."barbearias" TO "anon";
GRANT ALL ON TABLE "public"."barbearias" TO "authenticated";
GRANT ALL ON TABLE "public"."barbearias" TO "service_role";



GRANT ALL ON TABLE "public"."barbearias_public" TO "anon";
GRANT ALL ON TABLE "public"."barbearias_public" TO "authenticated";
GRANT ALL ON TABLE "public"."barbearias_public" TO "service_role";



GRANT ALL ON TABLE "public"."categorias_servicos" TO "anon";
GRANT ALL ON TABLE "public"."categorias_servicos" TO "authenticated";
GRANT ALL ON TABLE "public"."categorias_servicos" TO "service_role";



GRANT ALL ON TABLE "public"."feedbacks" TO "anon";
GRANT ALL ON TABLE "public"."feedbacks" TO "authenticated";
GRANT ALL ON TABLE "public"."feedbacks" TO "service_role";



GRANT ALL ON TABLE "public"."fidelidade" TO "anon";
GRANT ALL ON TABLE "public"."fidelidade" TO "authenticated";
GRANT ALL ON TABLE "public"."fidelidade" TO "service_role";



GRANT ALL ON TABLE "public"."fidelidade_configuracoes" TO "anon";
GRANT ALL ON TABLE "public"."fidelidade_configuracoes" TO "authenticated";
GRANT ALL ON TABLE "public"."fidelidade_configuracoes" TO "service_role";



GRANT ALL ON TABLE "public"."funcionario_ausencias" TO "anon";
GRANT ALL ON TABLE "public"."funcionario_ausencias" TO "authenticated";
GRANT ALL ON TABLE "public"."funcionario_ausencias" TO "service_role";



GRANT ALL ON TABLE "public"."funcionario_convites" TO "anon";
GRANT ALL ON TABLE "public"."funcionario_convites" TO "authenticated";
GRANT ALL ON TABLE "public"."funcionario_convites" TO "service_role";



GRANT ALL ON TABLE "public"."funcionario_pausas" TO "anon";
GRANT ALL ON TABLE "public"."funcionario_pausas" TO "authenticated";
GRANT ALL ON TABLE "public"."funcionario_pausas" TO "service_role";



GRANT ALL ON TABLE "public"."funcionarios" TO "anon";
GRANT ALL ON TABLE "public"."funcionarios" TO "authenticated";
GRANT ALL ON TABLE "public"."funcionarios" TO "service_role";



GRANT ALL ON TABLE "public"."funcionarios_atendimentos" TO "anon";
GRANT ALL ON TABLE "public"."funcionarios_atendimentos" TO "authenticated";
GRANT ALL ON TABLE "public"."funcionarios_atendimentos" TO "service_role";



GRANT ALL ON TABLE "public"."funcionarios_public" TO "anon";
GRANT ALL ON TABLE "public"."funcionarios_public" TO "authenticated";
GRANT ALL ON TABLE "public"."funcionarios_public" TO "service_role";



GRANT ALL ON TABLE "public"."horarios_funcionamento" TO "anon";
GRANT ALL ON TABLE "public"."horarios_funcionamento" TO "authenticated";
GRANT ALL ON TABLE "public"."horarios_funcionamento" TO "service_role";



GRANT ALL ON TABLE "public"."profiles" TO "anon";
GRANT ALL ON TABLE "public"."profiles" TO "authenticated";
GRANT ALL ON TABLE "public"."profiles" TO "service_role";



GRANT ALL ON TABLE "public"."recompensas" TO "anon";
GRANT ALL ON TABLE "public"."recompensas" TO "authenticated";
GRANT ALL ON TABLE "public"."recompensas" TO "service_role";



GRANT ALL ON TABLE "public"."resgates_recompensas" TO "anon";
GRANT ALL ON TABLE "public"."resgates_recompensas" TO "authenticated";
GRANT ALL ON TABLE "public"."resgates_recompensas" TO "service_role";



GRANT ALL ON TABLE "public"."servicos" TO "anon";
GRANT ALL ON TABLE "public"."servicos" TO "authenticated";
GRANT ALL ON TABLE "public"."servicos" TO "service_role";



GRANT ALL ON TABLE "public"."servicos_public" TO "anon";
GRANT ALL ON TABLE "public"."servicos_public" TO "authenticated";
GRANT ALL ON TABLE "public"."servicos_public" TO "service_role";









ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";
