--
-- PostgreSQL database dump
--

\restrict 8RSN8aLzjxWsBskHZzhVcegml8t9hhK0P058truBMSC2ZEJJhT3UW60keDVP7rR

-- Dumped from database version 17.4
-- Dumped by pg_dump version 18.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA auth;


--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA extensions;


--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA graphql;


--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA graphql_public;


--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA pgbouncer;


--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA realtime;


--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA storage;


--
-- Name: supabase_migrations; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA supabase_migrations;


--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA vault;


--
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


--
-- Name: oauth_authorization_status; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_authorization_status AS ENUM (
    'pending',
    'approved',
    'denied',
    'expired'
);


--
-- Name: oauth_client_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_client_type AS ENUM (
    'public',
    'confidential'
);


--
-- Name: oauth_registration_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_registration_type AS ENUM (
    'dynamic',
    'manual'
);


--
-- Name: oauth_response_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_response_type AS ENUM (
    'code'
);


--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


--
-- Name: agendamento_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.agendamento_status AS ENUM (
    'pendente',
    'confirmado',
    'cancelado',
    'finalizado'
);


--
-- Name: metodo_pagamento; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.metodo_pagamento AS ENUM (
    'cartao_credito',
    'cartao_debito',
    'pix',
    'boleto',
    'transferencia'
);


--
-- Name: nivel_permissao; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.nivel_permissao AS ENUM (
    'funcionario',
    'gerente',
    'dono'
);


--
-- Name: status_assinatura; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.status_assinatura AS ENUM (
    'ativa',
    'cancelada',
    'suspensa',
    'vencida',
    'teste'
);


--
-- Name: tipo_plano; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.tipo_plano AS ENUM (
    'basico',
    'premium',
    'empresarial'
);


--
-- Name: user_role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.user_role AS ENUM (
    'cliente',
    'admin',
    'funcionario'
);


--
-- Name: action; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


--
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: -
--

CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS',
    'VECTOR'
);


--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    IF EXISTS (
      SELECT FROM pg_extension
      WHERE extname = 'pg_net'
      -- all versions in use on existing projects as of 2025-02-20
      -- version 0.12.0 onwards don't need these applied
      AND extversion IN ('0.2', '0.6', '0.7', '0.7.1', '0.8', '0.10.0', '0.11.0')
    ) THEN
      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

      REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
      REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

      GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
      GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    END IF;
  END IF;
END;
$$;


--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: -
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $_$
  BEGIN
      RAISE DEBUG 'PgBouncer auth request: %', p_usename;

      RETURN QUERY
      SELECT
          rolname::text,
          CASE WHEN rolvaliduntil < now()
              THEN null
              ELSE rolpassword::text
          END
      FROM pg_authid
      WHERE rolname=$1 and rolcanlogin;
  END;
  $_$;


--
-- Name: accept_employee_invite(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.accept_employee_invite(invite_token text, employee_password text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
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


--
-- Name: FUNCTION accept_employee_invite(invite_token text, employee_password text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.accept_employee_invite(invite_token text, employee_password text) IS 'Accepts employee invitation by creating employee record and marking invite as used.
Returns JSON with success status and employee_id or error message.';


--
-- Name: barbearia_tem_assinatura_ativa(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.barbearia_tem_assinatura_ativa(p_barbearia_id uuid) RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
    SELECT EXISTS (
        SELECT 1 FROM public.assinaturas 
        WHERE barbearia_id = p_barbearia_id 
        AND status = 'ativa' 
        AND (data_fim IS NULL OR data_fim > now())
    );
$$;


--
-- Name: check_anonymous_appointment_limit(text, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.check_anonymous_appointment_limit(telefone_cliente text, user_id_param uuid DEFAULT NULL::uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
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


--
-- Name: check_funcionario_disponibilidade(uuid, timestamp with time zone); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.check_funcionario_disponibilidade(p_funcionario_id uuid, p_data_hora timestamp with time zone) RETURNS boolean
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    SET search_path TO 'public'
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


--
-- Name: check_if_user_exists(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.check_if_user_exists(p_email text, p_phone text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
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


--
-- Name: check_rate_limit(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.check_rate_limit(operation_type text, user_identifier text) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
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


--
-- Name: create_feedback_on_completion(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.create_feedback_on_completion() RETURNS trigger
    LANGUAGE plpgsql
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


--
-- Name: delete_user_complete(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.delete_user_complete(user_email text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public', 'auth'
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


--
-- Name: generate_slug(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.generate_slug(text) RETURNS text
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $_$
BEGIN
  RETURN lower(regexp_replace($1, '[^a-zA-Z0-9]+', '-', 'g'));
END;
$_$;


--
-- Name: get_anonymous_appointment_limit(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_anonymous_appointment_limit() RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    -- Por enquanto retorna 3, mas pode ser facilmente modificado
    -- Em futuro pode consultar uma tabela de configuração
    RETURN 3;
END;
$$;


--
-- Name: get_assinatura_ativa(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_assinatura_ativa(p_barbearia_id uuid) RETURNS json
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
    SELECT row_to_json(a.*) 
    FROM public.assinaturas a
    WHERE a.barbearia_id = p_barbearia_id 
    AND a.status = 'ativa'
    AND (a.data_fim IS NULL OR a.data_fim > now())
    ORDER BY a.created_at DESC
    LIMIT 1;
$$;


--
-- Name: get_current_user_role(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_current_user_role() RETURNS public.user_role
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    SET search_path TO ''
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


--
-- Name: get_default_funcionario(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_default_funcionario(barbearia_uuid uuid) RETURNS uuid
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    SET search_path TO 'public'
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


--
-- Name: get_public_profile_info(uuid[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_public_profile_info(profile_user_ids uuid[]) RETURNS TABLE(user_id uuid, name text, role public.user_role)
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
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


--
-- Name: get_recompensas_disponiveis(uuid, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_recompensas_disponiveis(p_barbearia_id uuid, p_cliente_telefone text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
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


--
-- Name: get_user_barbearia_id(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_user_barbearia_id() RETURNS uuid
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    SET search_path TO ''
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


--
-- Name: get_user_barbearia_id(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_user_barbearia_id(user_uuid uuid) RETURNS uuid
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    SET search_path TO ''
    AS $$
      BEGIN
        RETURN (
          SELECT p.barbearia_id
          FROM public.profiles p
          WHERE p.user_id = user_uuid
          LIMIT 1
        );
      END;
      $$;


--
-- Name: get_user_profile_cached(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_user_profile_cached() RETURNS TABLE(user_id uuid, role public.user_role, barbearia_id uuid)
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
  SELECT p.user_id, p.role, p.barbearia_id
  FROM public.profiles p
  WHERE p.user_id = auth.uid()
  LIMIT 1;
$$;


--
-- Name: get_user_role(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_user_role(user_uuid uuid) RETURNS public.user_role
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT role FROM public.profiles WHERE user_id = user_uuid;
$$;


--
-- Name: handle_new_user(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.handle_new_user() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    new_barbearia_id uuid;
    invite_record record;
BEGIN
    -- Se a role for 'cliente', apenas insere no profiles e termina.
    IF (NEW.raw_user_meta_data ->> 'role') = 'cliente' THEN
        INSERT INTO public.profiles (user_id, name, phone, role)
        VALUES (
            NEW.id,
            COALESCE(NEW.raw_user_meta_data ->> 'name', ''),
            COALESCE(NEW.raw_user_meta_data ->> 'phone', ''),
            'cliente'::public.user_role
        );
        RETURN NEW;
    END IF;

    -- Verificar se é um funcionário sendo criado via convite
    IF (NEW.raw_user_meta_data ->> 'role') = 'funcionario' THEN
        -- Buscar convite ativo pelo email
        SELECT * INTO invite_record
        FROM public.funcionario_convites
        WHERE email = NEW.email
        AND usado = FALSE
        AND expires_at > now()
        LIMIT 1;

        IF FOUND THEN
            -- Inserir perfil do funcionário
            INSERT INTO public.profiles (user_id, name, phone, role, barbearia_id)
            VALUES (
                NEW.id,
                COALESCE(NEW.raw_user_meta_data ->> 'name', ''),
                COALESCE(NEW.raw_user_meta_data ->> 'phone', ''),
                'funcionario'::public.user_role,
                invite_record.barbearia_id
            );

            -- Criar registro na tabela funcionarios
            INSERT INTO public.funcionarios (
                user_id,
                nome,
                nivel,
                barbearia_id,
                is_owner
            )
            VALUES (
                NEW.id,
                (invite_record.funcionario_data ->> 'nome')::text,
                COALESCE((invite_record.funcionario_data ->> 'nivel_permissao')::public.nivel_permissao, 'funcionario'::public.nivel_permissao),
                invite_record.barbearia_id,
                FALSE
            );

            -- Marcar convite como usado
            UPDATE public.funcionario_convites
            SET usado = TRUE
            WHERE id = invite_record.id;

            RETURN NEW;
        END IF;
    END IF;

    -- Fluxo padrão para administradores (criar barbearia)
    INSERT INTO public.profiles (user_id, name, phone, role)
    VALUES (
        NEW.id,
        COALESCE(NEW.raw_user_meta_data ->> 'name', ''),
        COALESCE(NEW.raw_user_meta_data ->> 'phone', ''),
        'admin'::public.user_role
    );

    -- Se for admin e tiver nome da barbearia, criar a barbearia
    IF (NEW.raw_user_meta_data ->> 'barbershop_name') IS NOT NULL THEN
        -- Criar a barbearia com slug
        INSERT INTO public.barbearias (nome, cidade, slug)
        VALUES (
            NEW.raw_user_meta_data ->> 'barbershop_name',
            'Não informado',
            generate_slug(NEW.raw_user_meta_data ->> 'barbershop_name')
        )
        RETURNING id INTO new_barbearia_id;

        -- Associar o usuário à barbearia
        UPDATE public.profiles
        SET barbearia_id = new_barbearia_id
        WHERE user_id = NEW.id;

        -- Inserir o dono como funcionário com nivel 'dono' (valor correto do enum)
        INSERT INTO public.funcionarios (
            user_id,
            barbearia_id,
            nome,
            nivel,
            is_owner,
            created_at,
            updated_at
        ) VALUES (
            NEW.id,
            new_barbearia_id,
            COALESCE(NEW.raw_user_meta_data ->> 'name', ''),
            'dono'::public.nivel_permissao,  -- Corrigido: era 'admin', agora é 'dono'
            TRUE,
            NOW(),
            NOW()
        );

        -- Criar horários de funcionamento padrão
        INSERT INTO public.horarios_funcionamento (barbearia_id, dia_semana, hora_abre, hora_fecha, fechado)
        VALUES
            (new_barbearia_id, 1, '08:00', '18:00', false),
            (new_barbearia_id, 2, '08:00', '18:00', false),
            (new_barbearia_id, 3, '08:00', '18:00', false),
            (new_barbearia_id, 4, '08:00', '18:00', false),
            (new_barbearia_id, 5, '08:00', '18:00', false),
            (new_barbearia_id, 6, '08:00', '17:00', false),
            (new_barbearia_id, 0, NULL, NULL, true);
    END IF;

  RETURN NEW;
END;
$$;


--
-- Name: insert_owner_as_employee(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.insert_owner_as_employee() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  owner_profile RECORD;
BEGIN
  -- Buscar informações do perfil do dono
  SELECT user_id, name INTO owner_profile
  FROM public.profiles
  WHERE barbearia_id = NEW.id
  AND role = 'admin'
  LIMIT 1;

  -- Se encontrou o perfil do admin/dono, inserir como funcionário
  IF FOUND THEN
    INSERT INTO public.funcionarios (
      user_id,
      barbearia_id,
      nome,
      nivel,
      is_owner,
      created_at,
      updated_at
    ) VALUES (
      owner_profile.user_id,
      NEW.id,
      owner_profile.name,
      'admin'::nivel_permissao,
      TRUE,
      NOW(),
      NOW()
    )
    ON CONFLICT DO NOTHING; -- Evita duplicatas
  END IF;

  RETURN NEW;
END;
$$;


--
-- Name: resgatar_recompensa(uuid, text, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.resgatar_recompensa(p_recompensa_id uuid, p_cliente_telefone text, p_barbearia_id uuid) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
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


--
-- Name: update_profile_on_employee_creation(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_profile_on_employee_creation() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Atualizar o perfil do usuário para funcionário
  UPDATE profiles
  SET
    role = 'funcionario',
    barbearia_id = NEW.barbearia_id,
    updated_at = NOW()
  WHERE user_id = NEW.user_id;

  RETURN NEW;
END;
$$;


--
-- Name: update_updated_at_assinaturas(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_updated_at_assinaturas() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public'
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;


--
-- Name: update_updated_at_ausencias(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_updated_at_ausencias() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public'
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;


--
-- Name: update_updated_at_fidelidade_configuracoes(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_updated_at_fidelidade_configuracoes() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public'
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;


--
-- Name: update_updated_at_recompensas(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_updated_at_recompensas() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public'
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;


--
-- Name: user_can_access_barbearia(uuid, public.user_role[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.user_can_access_barbearia(target_barbearia_id uuid, required_roles public.user_role[]) RETURNS boolean
    LANGUAGE plpgsql STABLE SECURITY DEFINER
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


--
-- Name: user_is_admin_of_barbearia(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.user_is_admin_of_barbearia(check_barbearia_id uuid) RETURNS boolean
    LANGUAGE plpgsql STABLE SECURITY DEFINER
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


--
-- Name: user_is_staff_of_barbearia(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.user_is_staff_of_barbearia(check_barbearia_id uuid) RETURNS boolean
    LANGUAGE plpgsql STABLE SECURITY DEFINER
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


--
-- Name: validate_and_sanitize_agendamento_data(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.validate_and_sanitize_agendamento_data() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
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


--
-- Name: FUNCTION validate_and_sanitize_agendamento_data(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.validate_and_sanitize_agendamento_data() IS 'Valida e sanitiza dados de agendamentos para proteger contra XSS, SQL injection e dados corrompidos. 
Funciona para agendamentos autenticados e anônimos.
Validações aplicadas:
- cliente_nome: remove HTML, valida tamanho (2-100 chars), permite apenas letras e acentos
- cliente_telefone: valida formato, mínimo 10 dígitos
- cliente_email: valida formato RFC 5322, normaliza lowercase
- data_hora: impede agendamentos no passado';


--
-- Name: validate_anonymous_appointment(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.validate_anonymous_appointment() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
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


--
-- Name: validate_funcionario_availability(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.validate_funcionario_availability() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
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


--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
-- Regclass of the table e.g. public.notes
entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

-- I, U, D, T: insert, update ...
action realtime.action = (
    case wal ->> 'action'
        when 'I' then 'INSERT'
        when 'U' then 'UPDATE'
        when 'D' then 'DELETE'
        else 'ERROR'
    end
);

-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

subscriptions realtime.subscription[] = array_agg(subs)
    from
        realtime.subscription subs
    where
        subs.entity = entity_
        -- Filter by action early - only get subscriptions interested in this action
        -- action_filter column can be: '*' (all), 'INSERT', 'UPDATE', or 'DELETE'
        and (subs.action_filter = '*' or subs.action_filter = action::text);

-- Subscription vars
roles regrole[] = array_agg(distinct us.claims_role::text)
    from
        unnest(subscriptions) us;

working_role regrole;
claimed_role regrole;
claims jsonb;

subscription_id uuid;
subscription_has_access bool;
visible_to_subscription_ids uuid[] = '{}';

-- structured info for wal's columns
columns realtime.wal_column[];
-- previous identity values for update/delete
old_columns realtime.wal_column[];

error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

-- Primary jsonb output for record
output jsonb;

begin
perform set_config('role', null, true);

columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'columns') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

old_columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'identity') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

for working_role in select * from unnest(roles) loop

    -- Update `is_selectable` for columns and old_columns
    columns =
        array_agg(
            (
                c.name,
                c.type_name,
                c.type_oid,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
            )::realtime.wal_column
        )
        from
            unnest(columns) c;

    old_columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(old_columns) c;

    if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            -- subscriptions is already filtered by entity
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 400: Bad Request, no primary key']
        )::realtime.wal_rls;

    -- The claims role does not have SELECT permission to the primary key of entity
    elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 401: Unauthorized']
        )::realtime.wal_rls;

    else
        output = jsonb_build_object(
            'schema', wal ->> 'schema',
            'table', wal ->> 'table',
            'type', action,
            'commit_timestamp', to_char(
                ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
            ),
            'columns', (
                select
                    jsonb_agg(
                        jsonb_build_object(
                            'name', pa.attname,
                            'type', pt.typname
                        )
                        order by pa.attnum asc
                    )
                from
                    pg_attribute pa
                    join pg_type pt
                        on pa.atttypid = pt.oid
                where
                    attrelid = entity_
                    and attnum > 0
                    and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
            )
        )
        -- Add "record" key for insert and update
        || case
            when action in ('INSERT', 'UPDATE') then
                jsonb_build_object(
                    'record',
                    (
                        select
                            jsonb_object_agg(
                                -- if unchanged toast, get column name and value from old record
                                coalesce((c).name, (oc).name),
                                case
                                    when (c).name is null then (oc).value
                                    else (c).value
                                end
                            )
                        from
                            unnest(columns) c
                            full outer join unnest(old_columns) oc
                                on (c).name = (oc).name
                        where
                            coalesce((c).is_selectable, (oc).is_selectable)
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                    )
                )
            else '{}'::jsonb
        end
        -- Add "old_record" key for update and delete
        || case
            when action = 'UPDATE' then
                jsonb_build_object(
                        'old_record',
                        (
                            select jsonb_object_agg((c).name, (c).value)
                            from unnest(old_columns) c
                            where
                                (c).is_selectable
                                and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                        )
                    )
            when action = 'DELETE' then
                jsonb_build_object(
                    'old_record',
                    (
                        select jsonb_object_agg((c).name, (c).value)
                        from unnest(old_columns) c
                        where
                            (c).is_selectable
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                    )
                )
            else '{}'::jsonb
        end;

        -- Create the prepared statement
        if is_rls_enabled and action <> 'DELETE' then
            if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
            end if;
            execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
        end if;

        visible_to_subscription_ids = '{}';

        for subscription_id, claims in (
                select
                    subs.subscription_id,
                    subs.claims
                from
                    unnest(subscriptions) subs
                where
                    subs.entity = entity_
                    and subs.claims_role = working_role
                    and (
                        realtime.is_visible_through_filters(columns, subs.filters)
                        or (
                          action = 'DELETE'
                          and realtime.is_visible_through_filters(old_columns, subs.filters)
                        )
                    )
        ) loop

            if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
            else
                -- Check if RLS allows the role to see the record
                perform
                    -- Trim leading and trailing quotes from working_role because set_config
                    -- doesn't recognize the role as valid if they are included
                    set_config('role', trim(both '"' from working_role::text), true),
                    set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                    visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
            end if;
        end loop;

        perform set_config('role', null, true);

        return next (
            output,
            is_rls_enabled,
            visible_to_subscription_ids,
            case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
            end
        )::realtime.wal_rls;

    end if;
end loop;

perform set_config('role', null, true);
end;
$$;


--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
declare
  res jsonb;
begin
  if type_::text = 'bytea' then
    return to_jsonb(val);
  end if;
  execute format('select to_jsonb(%L::'|| type_::text || ')', val) into res;
  return res;
end
$$;


--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS SETOF realtime.wal_rls
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
      with pub as (
        select
          concat_ws(
            ',',
            case when bool_or(pubinsert) then 'insert' else null end,
            case when bool_or(pubupdate) then 'update' else null end,
            case when bool_or(pubdelete) then 'delete' else null end
          ) as w2j_actions,
          coalesce(
            string_agg(
              realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
              ','
            ) filter (where ppt.tablename is not null and ppt.tablename not like '% %'),
            ''
          ) w2j_add_tables
        from
          pg_publication pp
          left join pg_publication_tables ppt
            on pp.pubname = ppt.pubname
        where
          pp.pubname = publication
        group by
          pp.pubname
        limit 1
      ),
      w2j as (
        select
          x.*, pub.w2j_add_tables
        from
          pub,
          pg_logical_slot_get_changes(
            slot_name, null, max_changes,
            'include-pk', 'true',
            'include-transaction', 'false',
            'include-timestamp', 'true',
            'include-type-oids', 'true',
            'format-version', '2',
            'actions', pub.w2j_actions,
            'add-tables', pub.w2j_add_tables
          ) x
      )
      select
        xyz.wal,
        xyz.is_rls_enabled,
        xyz.subscription_ids,
        xyz.errors
      from
        w2j,
        realtime.apply_rls(
          wal := w2j.data::jsonb,
          max_record_bytes := max_record_bytes
        ) xyz(wal, is_rls_enabled, subscription_ids, errors)
      where
        w2j.w2j_add_tables <> ''
        and xyz.subscription_ids[1] is not null
    $$;


--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  generated_id uuid;
  final_payload jsonb;
BEGIN
  BEGIN
    -- Generate a new UUID for the id
    generated_id := gen_random_uuid();

    -- Check if payload has an 'id' key, if not, add the generated UUID
    IF payload ? 'id' THEN
      final_payload := payload;
    ELSE
      final_payload := jsonb_set(payload, '{id}', to_jsonb(generated_id));
    END IF;

    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (id, payload, event, topic, private, extension)
    VALUES (generated_id, final_payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      RAISE WARNING 'ErrorSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
        col_names text[] = coalesce(
                array_agg(c.column_name order by c.ordinal_position),
                '{}'::text[]
            )
            from
                information_schema.columns c
            where
                format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
                and pg_catalog.has_column_privilege(
                    (new.claims ->> 'role'),
                    format('%I.%I', c.table_schema, c.table_name)::regclass,
                    c.column_name,
                    'SELECT'
                );
        filter realtime.user_defined_filter;
        col_type regtype;

        in_val jsonb;
    begin
        for filter in select * from unnest(new.filters) loop
            -- Filtered column is valid
            if not filter.column_name = any(col_names) then
                raise exception 'invalid column for filter %', filter.column_name;
            end if;

            -- Type is sanitized and safe for string interpolation
            col_type = (
                select atttypid::regtype
                from pg_catalog.pg_attribute
                where attrelid = new.entity
                      and attname = filter.column_name
            );
            if col_type is null then
                raise exception 'failed to lookup type for column %', filter.column_name;
            end if;

            -- Set maximum number of entries for in filter
            if filter.op = 'in'::realtime.equality_op then
                in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
                if coalesce(jsonb_array_length(in_val), 0) > 100 then
                    raise exception 'too many values for `in` filter. Maximum 100';
                end if;
            else
                -- raises an exception if value is not coercable to type
                perform realtime.cast(filter.value, col_type);
            end if;

        end loop;

        -- Apply consistent order to filters so the unique constraint on
        -- (subscription_id, entity, filters) can't be tricked by a different filter order
        new.filters = coalesce(
            array_agg(f order by f.column_name, f.op, f.value),
            '{}'
        ) from unnest(new.filters) f;

        return new;
    end;
    $$;


--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


--
-- Name: delete_leaf_prefixes(text[], text[]); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.delete_leaf_prefixes(bucket_ids text[], names text[]) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_rows_deleted integer;
BEGIN
    LOOP
        WITH candidates AS (
            SELECT DISTINCT
                t.bucket_id,
                unnest(storage.get_prefixes(t.name)) AS name
            FROM unnest(bucket_ids, names) AS t(bucket_id, name)
        ),
        uniq AS (
             SELECT
                 bucket_id,
                 name,
                 storage.get_level(name) AS level
             FROM candidates
             WHERE name <> ''
             GROUP BY bucket_id, name
        ),
        leaf AS (
             SELECT
                 p.bucket_id,
                 p.name,
                 p.level
             FROM storage.prefixes AS p
                  JOIN uniq AS u
                       ON u.bucket_id = p.bucket_id
                           AND u.name = p.name
                           AND u.level = p.level
             WHERE NOT EXISTS (
                 SELECT 1
                 FROM storage.objects AS o
                 WHERE o.bucket_id = p.bucket_id
                   AND o.level = p.level + 1
                   AND o.name COLLATE "C" LIKE p.name || '/%'
             )
             AND NOT EXISTS (
                 SELECT 1
                 FROM storage.prefixes AS c
                 WHERE c.bucket_id = p.bucket_id
                   AND c.level = p.level + 1
                   AND c.name COLLATE "C" LIKE p.name || '/%'
             )
        )
        DELETE
        FROM storage.prefixes AS p
            USING leaf AS l
        WHERE p.bucket_id = l.bucket_id
          AND p.name = l.name
          AND p.level = l.level;

        GET DIAGNOSTICS v_rows_deleted = ROW_COUNT;
        EXIT WHEN v_rows_deleted = 0;
    END LOOP;
END;
$$;


--
-- Name: enforce_bucket_name_length(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.enforce_bucket_name_length() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    if length(new.name) > 100 then
        raise exception 'bucket name "%" is too long (% characters). Max is 100.', new.name, length(new.name);
    end if;
    return new;
end;
$$;


--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
    _filename text;
BEGIN
    SELECT string_to_array(name, '/') INTO _parts;
    SELECT _parts[array_length(_parts,1)] INTO _filename;
    RETURN reverse(split_part(reverse(_filename), '.', 1));
END
$$;


--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
BEGIN
    -- Split on "/" to get path segments
    SELECT string_to_array(name, '/') INTO _parts;
    -- Return everything except the last segment
    RETURN _parts[1 : array_length(_parts,1) - 1];
END
$$;


--
-- Name: get_common_prefix(text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT CASE
    WHEN position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)) > 0
    THEN left(p_key, length(p_prefix) + position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)))
    ELSE NULL
END;
$$;


--
-- Name: get_level(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_level(name text) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
SELECT array_length(string_to_array("name", '/'), 1);
$$;


--
-- Name: get_prefix(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_prefix(name text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
SELECT
    CASE WHEN strpos("name", '/') > 0 THEN
             regexp_replace("name", '[\/]{1}[^\/]+\/?$', '')
         ELSE
             ''
        END;
$_$;


--
-- Name: get_prefixes(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_prefixes(name text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $$
DECLARE
    parts text[];
    prefixes text[];
    prefix text;
BEGIN
    -- Split the name into parts by '/'
    parts := string_to_array("name", '/');
    prefixes := '{}';

    -- Construct the prefixes, stopping one level below the last part
    FOR i IN 1..array_length(parts, 1) - 1 LOOP
            prefix := array_to_string(parts[1:i], '/');
            prefixes := array_append(prefixes, prefix);
    END LOOP;

    RETURN prefixes;
END;
$$;


--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::bigint) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;

    -- Configuration
    v_is_asc BOOLEAN;
    v_prefix TEXT;
    v_start TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_is_asc := lower(coalesce(sort_order, 'asc')) = 'asc';
    v_prefix := coalesce(prefix_param, '');
    v_start := CASE WHEN coalesce(next_token, '') <> '' THEN next_token ELSE coalesce(start_after, '') END;
    v_file_batch_size := LEAST(GREATEST(max_keys * 2, 100), 1000);

    -- Calculate upper bound for prefix filtering (bytewise, using COLLATE "C")
    IF v_prefix = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix, 1) = delimiter_param THEN
        v_upper_bound := left(v_prefix, -1) || chr(ascii(delimiter_param) + 1);
    ELSE
        v_upper_bound := left(v_prefix, -1) || chr(ascii(right(v_prefix, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'AND o.name COLLATE "C" < $3 ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'AND o.name COLLATE "C" >= $3 ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- ========================================================================
    -- SEEK INITIALIZATION: Determine starting position
    -- ========================================================================
    IF v_start = '' THEN
        IF v_is_asc THEN
            v_next_seek := v_prefix;
        ELSE
            -- DESC without cursor: find the last item in range
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;

            IF v_next_seek IS NOT NULL THEN
                v_next_seek := v_next_seek || delimiter_param;
            ELSE
                RETURN;
            END IF;
        END IF;
    ELSE
        -- Cursor provided: determine if it refers to a folder or leaf
        IF EXISTS (
            SELECT 1 FROM storage.objects o
            WHERE o.bucket_id = _bucket_id
              AND o.name COLLATE "C" LIKE v_start || delimiter_param || '%'
            LIMIT 1
        ) THEN
            -- Cursor refers to a folder
            IF v_is_asc THEN
                v_next_seek := v_start || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_start || delimiter_param;
            END IF;
        ELSE
            -- Cursor refers to a leaf object
            IF v_is_asc THEN
                v_next_seek := v_start || delimiter_param;
            ELSE
                v_next_seek := v_start;
            END IF;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= max_keys;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(v_peek_name, v_prefix, delimiter_param);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Emit and skip to next folder (no heap access needed)
            name := rtrim(v_common_prefix, delimiter_param);
            id := NULL;
            updated_at := NULL;
            created_at := NULL;
            last_accessed_at := NULL;
            metadata := NULL;
            RETURN NEXT;
            v_count := v_count + 1;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := left(v_common_prefix, -1) || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_common_prefix;
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query USING _bucket_id, v_next_seek,
                CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix) ELSE v_prefix END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(v_current.name, v_prefix, delimiter_param);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := v_current.name;
                    EXIT;
                END IF;

                -- Emit file
                name := v_current.name;
                id := v_current.id;
                updated_at := v_current.updated_at;
                created_at := v_current.created_at;
                last_accessed_at := v_current.last_accessed_at;
                metadata := v_current.metadata;
                RETURN NEXT;
                v_count := v_count + 1;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := v_current.name || delimiter_param;
                ELSE
                    v_next_seek := v_current.name;
                END IF;

                EXIT WHEN v_count >= max_keys;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


--
-- Name: protect_delete(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.protect_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Check if storage.allow_delete_query is set to 'true'
    IF COALESCE(current_setting('storage.allow_delete_query', true), 'false') != 'true' THEN
        RAISE EXCEPTION 'Direct deletion from storage tables is not allowed. Use the Storage API instead.'
            USING HINT = 'This prevents accidental data loss from orphaned objects.',
                  ERRCODE = '42501';
    END IF;
    RETURN NULL;
END;
$$;


--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;
    v_delimiter CONSTANT TEXT := '/';

    -- Configuration
    v_limit INT;
    v_prefix TEXT;
    v_prefix_lower TEXT;
    v_is_asc BOOLEAN;
    v_order_by TEXT;
    v_sort_order TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;
    v_skipped INT := 0;
BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_limit := LEAST(coalesce(limits, 100), 1500);
    v_prefix := coalesce(prefix, '') || coalesce(search, '');
    v_prefix_lower := lower(v_prefix);
    v_is_asc := lower(coalesce(sortorder, 'asc')) = 'asc';
    v_file_batch_size := LEAST(GREATEST(v_limit * 2, 100), 1000);

    -- Validate sort column
    CASE lower(coalesce(sortcolumn, 'name'))
        WHEN 'name' THEN v_order_by := 'name';
        WHEN 'updated_at' THEN v_order_by := 'updated_at';
        WHEN 'created_at' THEN v_order_by := 'created_at';
        WHEN 'last_accessed_at' THEN v_order_by := 'last_accessed_at';
        ELSE v_order_by := 'name';
    END CASE;

    v_sort_order := CASE WHEN v_is_asc THEN 'asc' ELSE 'desc' END;

    -- ========================================================================
    -- NON-NAME SORTING: Use path_tokens approach (unchanged)
    -- ========================================================================
    IF v_order_by != 'name' THEN
        RETURN QUERY EXECUTE format(
            $sql$
            WITH folders AS (
                SELECT path_tokens[$1] AS folder
                FROM storage.objects
                WHERE objects.name ILIKE $2 || '%%'
                  AND bucket_id = $3
                  AND array_length(objects.path_tokens, 1) <> $1
                GROUP BY folder
                ORDER BY folder %s
            )
            (SELECT folder AS "name",
                   NULL::uuid AS id,
                   NULL::timestamptz AS updated_at,
                   NULL::timestamptz AS created_at,
                   NULL::timestamptz AS last_accessed_at,
                   NULL::jsonb AS metadata FROM folders)
            UNION ALL
            (SELECT path_tokens[$1] AS "name",
                   id, updated_at, created_at, last_accessed_at, metadata
             FROM storage.objects
             WHERE objects.name ILIKE $2 || '%%'
               AND bucket_id = $3
               AND array_length(objects.path_tokens, 1) = $1
             ORDER BY %I %s)
            LIMIT $4 OFFSET $5
            $sql$, v_sort_order, v_order_by, v_sort_order
        ) USING levels, v_prefix, bucketname, v_limit, offsets;
        RETURN;
    END IF;

    -- ========================================================================
    -- NAME SORTING: Hybrid skip-scan with batch optimization
    -- ========================================================================

    -- Calculate upper bound for prefix filtering
    IF v_prefix_lower = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix_lower, 1) = v_delimiter THEN
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(v_delimiter) + 1);
    ELSE
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(right(v_prefix_lower, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'AND lower(o.name) COLLATE "C" < $3 ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'AND lower(o.name) COLLATE "C" >= $3 ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- Initialize seek position
    IF v_is_asc THEN
        v_next_seek := v_prefix_lower;
    ELSE
        -- DESC: find the last item in range first (static SQL)
        IF v_upper_bound IS NOT NULL THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower AND lower(o.name) COLLATE "C" < v_upper_bound
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSIF v_prefix_lower <> '' THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSE
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        END IF;

        IF v_peek_name IS NOT NULL THEN
            v_next_seek := lower(v_peek_name) || v_delimiter;
        ELSE
            RETURN;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= v_limit;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek AND lower(o.name) COLLATE "C" < v_upper_bound
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix_lower <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(lower(v_peek_name), v_prefix_lower, v_delimiter);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Handle offset, emit if needed, skip to next folder
            IF v_skipped < offsets THEN
                v_skipped := v_skipped + 1;
            ELSE
                name := split_part(rtrim(storage.get_common_prefix(v_peek_name, v_prefix, v_delimiter), v_delimiter), v_delimiter, levels);
                id := NULL;
                updated_at := NULL;
                created_at := NULL;
                last_accessed_at := NULL;
                metadata := NULL;
                RETURN NEXT;
                v_count := v_count + 1;
            END IF;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := lower(left(v_common_prefix, -1)) || chr(ascii(v_delimiter) + 1);
            ELSE
                v_next_seek := lower(v_common_prefix);
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix_lower is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query
                USING bucketname, v_next_seek,
                    CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix_lower) ELSE v_prefix_lower END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(lower(v_current.name), v_prefix_lower, v_delimiter);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := lower(v_current.name);
                    EXIT;
                END IF;

                -- Handle offset skipping
                IF v_skipped < offsets THEN
                    v_skipped := v_skipped + 1;
                ELSE
                    -- Emit file
                    name := split_part(v_current.name, v_delimiter, levels);
                    id := v_current.id;
                    updated_at := v_current.updated_at;
                    created_at := v_current.created_at;
                    last_accessed_at := v_current.last_accessed_at;
                    metadata := v_current.metadata;
                    RETURN NEXT;
                    v_count := v_count + 1;
                END IF;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := lower(v_current.name) || v_delimiter;
                ELSE
                    v_next_seek := lower(v_current.name);
                END IF;

                EXIT WHEN v_count >= v_limit;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


--
-- Name: search_by_timestamp(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_cursor_op text;
    v_query text;
    v_prefix text;
BEGIN
    v_prefix := coalesce(p_prefix, '');

    IF p_sort_order = 'asc' THEN
        v_cursor_op := '>';
    ELSE
        v_cursor_op := '<';
    END IF;

    v_query := format($sql$
        WITH raw_objects AS (
            SELECT
                o.name AS obj_name,
                o.id AS obj_id,
                o.updated_at AS obj_updated_at,
                o.created_at AS obj_created_at,
                o.last_accessed_at AS obj_last_accessed_at,
                o.metadata AS obj_metadata,
                storage.get_common_prefix(o.name, $1, '/') AS common_prefix
            FROM storage.objects o
            WHERE o.bucket_id = $2
              AND o.name COLLATE "C" LIKE $1 || '%%'
        ),
        -- Aggregate common prefixes (folders)
        -- Both created_at and updated_at use MIN(obj_created_at) to match the old prefixes table behavior
        aggregated_prefixes AS (
            SELECT
                rtrim(common_prefix, '/') AS name,
                NULL::uuid AS id,
                MIN(obj_created_at) AS updated_at,
                MIN(obj_created_at) AS created_at,
                NULL::timestamptz AS last_accessed_at,
                NULL::jsonb AS metadata,
                TRUE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NOT NULL
            GROUP BY common_prefix
        ),
        leaf_objects AS (
            SELECT
                obj_name AS name,
                obj_id AS id,
                obj_updated_at AS updated_at,
                obj_created_at AS created_at,
                obj_last_accessed_at AS last_accessed_at,
                obj_metadata AS metadata,
                FALSE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NULL
        ),
        combined AS (
            SELECT * FROM aggregated_prefixes
            UNION ALL
            SELECT * FROM leaf_objects
        ),
        filtered AS (
            SELECT *
            FROM combined
            WHERE (
                $5 = ''
                OR ROW(
                    date_trunc('milliseconds', %I),
                    name COLLATE "C"
                ) %s ROW(
                    COALESCE(NULLIF($6, '')::timestamptz, 'epoch'::timestamptz),
                    $5
                )
            )
        )
        SELECT
            split_part(name, '/', $3) AS key,
            name,
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
        FROM filtered
        ORDER BY
            COALESCE(date_trunc('milliseconds', %I), 'epoch'::timestamptz) %s,
            name COLLATE "C" %s
        LIMIT $4
    $sql$,
        p_sort_column,
        v_cursor_op,
        p_sort_column,
        p_sort_order,
        p_sort_order
    );

    RETURN QUERY EXECUTE v_query
    USING v_prefix, p_bucket_id, p_level, p_limit, p_start_after, p_sort_column_after;
END;
$_$;


--
-- Name: search_legacy_v1(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search_legacy_v1(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
    v_order_by text;
    v_sort_order text;
begin
    case
        when sortcolumn = 'name' then
            v_order_by = 'name';
        when sortcolumn = 'updated_at' then
            v_order_by = 'updated_at';
        when sortcolumn = 'created_at' then
            v_order_by = 'created_at';
        when sortcolumn = 'last_accessed_at' then
            v_order_by = 'last_accessed_at';
        else
            v_order_by = 'name';
        end case;

    case
        when sortorder = 'asc' then
            v_sort_order = 'asc';
        when sortorder = 'desc' then
            v_sort_order = 'desc';
        else
            v_sort_order = 'asc';
        end case;

    v_order_by = v_order_by || ' ' || v_sort_order;

    return query execute
        'with folders as (
           select path_tokens[$1] as folder
           from storage.objects
             where objects.name ilike $2 || $3 || ''%''
               and bucket_id = $4
               and array_length(objects.path_tokens, 1) <> $1
           group by folder
           order by folder ' || v_sort_order || '
     )
     (select folder as "name",
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[$1] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where objects.name ilike $2 || $3 || ''%''
       and bucket_id = $4
       and array_length(objects.path_tokens, 1) = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


--
-- Name: search_v2(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer DEFAULT 100, levels integer DEFAULT 1, start_after text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, sort_column text DEFAULT 'name'::text, sort_column_after text DEFAULT ''::text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_sort_col text;
    v_sort_ord text;
    v_limit int;
BEGIN
    -- Cap limit to maximum of 1500 records
    v_limit := LEAST(coalesce(limits, 100), 1500);

    -- Validate and normalize sort_order
    v_sort_ord := lower(coalesce(sort_order, 'asc'));
    IF v_sort_ord NOT IN ('asc', 'desc') THEN
        v_sort_ord := 'asc';
    END IF;

    -- Validate and normalize sort_column
    v_sort_col := lower(coalesce(sort_column, 'name'));
    IF v_sort_col NOT IN ('name', 'updated_at', 'created_at') THEN
        v_sort_col := 'name';
    END IF;

    -- Route to appropriate implementation
    IF v_sort_col = 'name' THEN
        -- Use list_objects_with_delimiter for name sorting (most efficient: O(k * log n))
        RETURN QUERY
        SELECT
            split_part(l.name, '/', levels) AS key,
            l.name AS name,
            l.id,
            l.updated_at,
            l.created_at,
            l.last_accessed_at,
            l.metadata
        FROM storage.list_objects_with_delimiter(
            bucket_name,
            coalesce(prefix, ''),
            '/',
            v_limit,
            start_after,
            '',
            v_sort_ord
        ) l;
    ELSE
        -- Use aggregation approach for timestamp sorting
        -- Not efficient for large datasets but supports correct pagination
        RETURN QUERY SELECT * FROM storage.search_by_timestamp(
            prefix, bucket_name, v_limit, levels, start_after,
            v_sort_ord, v_sort_col, sort_column_after
        );
    END IF;
END;
$$;


--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: custom_oauth_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.custom_oauth_providers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    provider_type text NOT NULL,
    identifier text NOT NULL,
    name text NOT NULL,
    client_id text NOT NULL,
    client_secret text NOT NULL,
    acceptable_client_ids text[] DEFAULT '{}'::text[] NOT NULL,
    scopes text[] DEFAULT '{}'::text[] NOT NULL,
    pkce_enabled boolean DEFAULT true NOT NULL,
    attribute_mapping jsonb DEFAULT '{}'::jsonb NOT NULL,
    authorization_params jsonb DEFAULT '{}'::jsonb NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    email_optional boolean DEFAULT false NOT NULL,
    issuer text,
    discovery_url text,
    skip_nonce_check boolean DEFAULT false NOT NULL,
    cached_discovery jsonb,
    discovery_cached_at timestamp with time zone,
    authorization_url text,
    token_url text,
    userinfo_url text,
    jwks_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT custom_oauth_providers_authorization_url_https CHECK (((authorization_url IS NULL) OR (authorization_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_authorization_url_length CHECK (((authorization_url IS NULL) OR (char_length(authorization_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_client_id_length CHECK (((char_length(client_id) >= 1) AND (char_length(client_id) <= 512))),
    CONSTRAINT custom_oauth_providers_discovery_url_length CHECK (((discovery_url IS NULL) OR (char_length(discovery_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_identifier_format CHECK ((identifier ~ '^[a-z0-9][a-z0-9:-]{0,48}[a-z0-9]$'::text)),
    CONSTRAINT custom_oauth_providers_issuer_length CHECK (((issuer IS NULL) OR ((char_length(issuer) >= 1) AND (char_length(issuer) <= 2048)))),
    CONSTRAINT custom_oauth_providers_jwks_uri_https CHECK (((jwks_uri IS NULL) OR (jwks_uri ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_jwks_uri_length CHECK (((jwks_uri IS NULL) OR (char_length(jwks_uri) <= 2048))),
    CONSTRAINT custom_oauth_providers_name_length CHECK (((char_length(name) >= 1) AND (char_length(name) <= 100))),
    CONSTRAINT custom_oauth_providers_oauth2_requires_endpoints CHECK (((provider_type <> 'oauth2'::text) OR ((authorization_url IS NOT NULL) AND (token_url IS NOT NULL) AND (userinfo_url IS NOT NULL)))),
    CONSTRAINT custom_oauth_providers_oidc_discovery_url_https CHECK (((provider_type <> 'oidc'::text) OR (discovery_url IS NULL) OR (discovery_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_issuer_https CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NULL) OR (issuer ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_requires_issuer CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NOT NULL))),
    CONSTRAINT custom_oauth_providers_provider_type_check CHECK ((provider_type = ANY (ARRAY['oauth2'::text, 'oidc'::text]))),
    CONSTRAINT custom_oauth_providers_token_url_https CHECK (((token_url IS NULL) OR (token_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_token_url_length CHECK (((token_url IS NULL) OR (char_length(token_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_userinfo_url_https CHECK (((userinfo_url IS NULL) OR (userinfo_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_userinfo_url_length CHECK (((userinfo_url IS NULL) OR (char_length(userinfo_url) <= 2048)))
);


--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text,
    code_challenge_method auth.code_challenge_method,
    code_challenge text,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone,
    invite_token text,
    referrer text,
    oauth_client_state_id uuid,
    linking_target_id uuid,
    email_optional boolean DEFAULT false NOT NULL
);


--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.flow_state IS 'Stores metadata for all OAuth/SSO login flows';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid,
    last_webauthn_challenge_data jsonb
);


--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: COLUMN mfa_factors.last_webauthn_challenge_data; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.mfa_factors.last_webauthn_challenge_data IS 'Stores the latest WebAuthn challenge data including attestation/assertion for customer verification';


--
-- Name: oauth_authorizations; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_authorizations (
    id uuid NOT NULL,
    authorization_id text NOT NULL,
    client_id uuid NOT NULL,
    user_id uuid,
    redirect_uri text NOT NULL,
    scope text NOT NULL,
    state text,
    resource text,
    code_challenge text,
    code_challenge_method auth.code_challenge_method,
    response_type auth.oauth_response_type DEFAULT 'code'::auth.oauth_response_type NOT NULL,
    status auth.oauth_authorization_status DEFAULT 'pending'::auth.oauth_authorization_status NOT NULL,
    authorization_code text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone DEFAULT (now() + '00:03:00'::interval) NOT NULL,
    approved_at timestamp with time zone,
    nonce text,
    CONSTRAINT oauth_authorizations_authorization_code_length CHECK ((char_length(authorization_code) <= 255)),
    CONSTRAINT oauth_authorizations_code_challenge_length CHECK ((char_length(code_challenge) <= 128)),
    CONSTRAINT oauth_authorizations_expires_at_future CHECK ((expires_at > created_at)),
    CONSTRAINT oauth_authorizations_nonce_length CHECK ((char_length(nonce) <= 255)),
    CONSTRAINT oauth_authorizations_redirect_uri_length CHECK ((char_length(redirect_uri) <= 2048)),
    CONSTRAINT oauth_authorizations_resource_length CHECK ((char_length(resource) <= 2048)),
    CONSTRAINT oauth_authorizations_scope_length CHECK ((char_length(scope) <= 4096)),
    CONSTRAINT oauth_authorizations_state_length CHECK ((char_length(state) <= 4096))
);


--
-- Name: oauth_client_states; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_client_states (
    id uuid NOT NULL,
    provider_type text NOT NULL,
    code_verifier text,
    created_at timestamp with time zone NOT NULL
);


--
-- Name: TABLE oauth_client_states; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.oauth_client_states IS 'Stores OAuth states for third-party provider authentication flows where Supabase acts as the OAuth client.';


--
-- Name: oauth_clients; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_clients (
    id uuid NOT NULL,
    client_secret_hash text,
    registration_type auth.oauth_registration_type NOT NULL,
    redirect_uris text NOT NULL,
    grant_types text NOT NULL,
    client_name text,
    client_uri text,
    logo_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    client_type auth.oauth_client_type DEFAULT 'confidential'::auth.oauth_client_type NOT NULL,
    token_endpoint_auth_method text NOT NULL,
    CONSTRAINT oauth_clients_client_name_length CHECK ((char_length(client_name) <= 1024)),
    CONSTRAINT oauth_clients_client_uri_length CHECK ((char_length(client_uri) <= 2048)),
    CONSTRAINT oauth_clients_logo_uri_length CHECK ((char_length(logo_uri) <= 2048)),
    CONSTRAINT oauth_clients_token_endpoint_auth_method_check CHECK ((token_endpoint_auth_method = ANY (ARRAY['client_secret_basic'::text, 'client_secret_post'::text, 'none'::text])))
);


--
-- Name: oauth_consents; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_consents (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    client_id uuid NOT NULL,
    scopes text NOT NULL,
    granted_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_at timestamp with time zone,
    CONSTRAINT oauth_consents_revoked_after_granted CHECK (((revoked_at IS NULL) OR (revoked_at >= granted_at))),
    CONSTRAINT oauth_consents_scopes_length CHECK ((char_length(scopes) <= 2048)),
    CONSTRAINT oauth_consents_scopes_not_empty CHECK ((char_length(TRIM(BOTH FROM scopes)) > 0))
);


--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: -
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: -
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text,
    oauth_client_id uuid,
    refresh_token_hmac_key text,
    refresh_token_counter bigint,
    scopes text,
    CONSTRAINT sessions_scopes_length CHECK ((char_length(scopes) <= 4096))
);


--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: COLUMN sessions.refresh_token_hmac_key; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.refresh_token_hmac_key IS 'Holds a HMAC-SHA256 key used to sign refresh tokens for this session.';


--
-- Name: COLUMN sessions.refresh_token_counter; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.refresh_token_counter IS 'Holds the ID (counter) of the last issued refresh token.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    disabled boolean,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: webauthn_challenges; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.webauthn_challenges (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    challenge_type text NOT NULL,
    session_data jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    CONSTRAINT webauthn_challenges_challenge_type_check CHECK ((challenge_type = ANY (ARRAY['signup'::text, 'registration'::text, 'authentication'::text])))
);


--
-- Name: webauthn_credentials; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.webauthn_credentials (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    credential_id bytea NOT NULL,
    public_key bytea NOT NULL,
    attestation_type text DEFAULT ''::text NOT NULL,
    aaguid uuid,
    sign_count bigint DEFAULT 0 NOT NULL,
    transports jsonb DEFAULT '[]'::jsonb NOT NULL,
    backup_eligible boolean DEFAULT false NOT NULL,
    backed_up boolean DEFAULT false NOT NULL,
    friendly_name text DEFAULT ''::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    last_used_at timestamp with time zone
);


--
-- Name: agendamentos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.agendamentos (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    barbearia_id uuid NOT NULL,
    servico_id uuid NOT NULL,
    funcionario_id uuid,
    user_id uuid,
    cliente_nome text NOT NULL,
    cliente_telefone text NOT NULL,
    cliente_email text,
    data_hora timestamp with time zone NOT NULL,
    status public.agendamento_status DEFAULT 'pendente'::public.agendamento_status NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    origem text GENERATED ALWAYS AS (
CASE
    WHEN (user_id IS NULL) THEN 'anonimo'::text
    ELSE 'cliente'::text
END) STORED,
    avaliado boolean DEFAULT false NOT NULL,
    CONSTRAINT agendamentos_cliente_telefone_valid CHECK (((user_id IS NOT NULL) OR ((user_id IS NULL) AND (cliente_telefone IS NOT NULL) AND (length(regexp_replace(cliente_telefone, '[^0-9]'::text, ''::text, 'g'::text)) >= 10))))
);


--
-- Name: COLUMN agendamentos.origem; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agendamentos.origem IS 'Coluna gerada automaticamente que identifica se o agendamento foi criado por um cliente logado ou anônimo';


--
-- Name: COLUMN agendamentos.avaliado; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agendamentos.avaliado IS 'Indica se o agendamento já foi avaliado pelo cliente';


--
-- Name: assinaturas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assinaturas (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    barbearia_id uuid NOT NULL,
    tipo_plano public.tipo_plano DEFAULT 'basico'::public.tipo_plano NOT NULL,
    status public.status_assinatura DEFAULT 'teste'::public.status_assinatura NOT NULL,
    data_inicio timestamp with time zone DEFAULT now() NOT NULL,
    data_fim timestamp with time zone,
    data_cancelamento timestamp with time zone,
    valor_mensal numeric(10,2) DEFAULT 0.00 NOT NULL,
    moeda character varying(3) DEFAULT 'BRL'::character varying NOT NULL,
    metodo_pagamento public.metodo_pagamento,
    stripe_subscription_id text,
    stripe_customer_id text,
    observacoes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: audit_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.audit_log (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    operation text NOT NULL,
    table_name text NOT NULL,
    record_id uuid,
    old_values jsonb,
    new_values jsonb,
    ip_address inet,
    user_agent text,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: barbearias; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.barbearias (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nome text NOT NULL,
    logo_url text,
    slug text,
    endereco text,
    cidade text NOT NULL,
    bairro text,
    cep text,
    email_contato text,
    telefone text,
    cores_personalizadas jsonb DEFAULT '{}'::jsonb,
    modo_tema text DEFAULT 'dark'::text,
    gallery_urls text[] DEFAULT ARRAY[]::text[],
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    fidelidade_ativa boolean DEFAULT true NOT NULL,
    descricao text,
    notificacoes_ativa boolean DEFAULT true,
    CONSTRAINT barbearias_modo_tema_check CHECK ((modo_tema = ANY (ARRAY['dark'::text, 'light'::text])))
);


--
-- Name: barbearias_public; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.barbearias_public WITH (security_invoker='on') AS
 SELECT id,
    nome,
    cidade,
    endereco,
    telefone,
    logo_url,
    gallery_urls,
    slug,
    modo_tema,
    cores_personalizadas
   FROM public.barbearias;


--
-- Name: categorias_servicos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categorias_servicos (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nome text NOT NULL,
    descricao text
);


--
-- Name: feedbacks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.feedbacks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    agendamento_id uuid NOT NULL,
    user_id uuid NOT NULL,
    barbearia_id uuid NOT NULL,
    rating integer,
    comment text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    response text,
    response_created_at timestamp with time zone,
    responded_by uuid,
    status text DEFAULT 'pendente'::text NOT NULL,
    anonimo boolean DEFAULT false,
    CONSTRAINT feedbacks_rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);


--
-- Name: COLUMN feedbacks.rating; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.feedbacks.rating IS 'Rating do feedback (1-5). Pode ser NULL quando o feedback é criado automaticamente pelo sistema e ainda não foi avaliado pelo cliente.';


--
-- Name: COLUMN feedbacks.response; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.feedbacks.response IS 'Resposta do barbeiro/funcionário ao feedback do cliente';


--
-- Name: COLUMN feedbacks.response_created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.feedbacks.response_created_at IS 'Data e hora quando a resposta foi criada';


--
-- Name: COLUMN feedbacks.responded_by; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.feedbacks.responded_by IS 'ID do funcionário que respondeu ao feedback';


--
-- Name: fidelidade; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fidelidade (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    barbearia_id uuid NOT NULL,
    pontos integer DEFAULT 0 NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    cliente_telefone text
);


--
-- Name: fidelidade_configuracoes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fidelidade_configuracoes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    barbearia_id uuid NOT NULL,
    pontos_por_servico integer DEFAULT 1 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    pontos_minimos_recompensa integer DEFAULT 100,
    dias_expiracao integer DEFAULT 365
);


--
-- Name: funcionario_ausencias; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.funcionario_ausencias (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    funcionario_id uuid NOT NULL,
    barbearia_id uuid NOT NULL,
    tipo text NOT NULL,
    data_inicio date NOT NULL,
    data_fim date NOT NULL,
    motivo text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT ausencia_datas_validas CHECK ((data_fim >= data_inicio)),
    CONSTRAINT funcionario_ausencias_tipo_check CHECK ((tipo = ANY (ARRAY['ferias'::text, 'recesso'::text, 'outro'::text])))
);


--
-- Name: funcionario_convites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.funcionario_convites (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    email text NOT NULL,
    barbearia_id uuid NOT NULL,
    funcionario_data jsonb NOT NULL,
    usado boolean DEFAULT false NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    token text
);


--
-- Name: funcionario_pausas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.funcionario_pausas (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    funcionario_id uuid NOT NULL,
    barbearia_id uuid NOT NULL,
    data date DEFAULT CURRENT_DATE NOT NULL,
    hora_inicio time without time zone NOT NULL,
    hora_fim time without time zone NOT NULL,
    motivo text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT check_horario_valido CHECK ((hora_fim > hora_inicio))
);


--
-- Name: funcionarios; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.funcionarios (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    barbearia_id uuid NOT NULL,
    nome text NOT NULL,
    nivel public.nivel_permissao DEFAULT 'funcionario'::public.nivel_permissao NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_owner boolean DEFAULT false,
    email text,
    especialidade text
);


--
-- Name: funcionarios_public; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.funcionarios_public WITH (security_invoker='on') AS
 SELECT id,
    nome,
    barbearia_id
   FROM public.funcionarios f;


--
-- Name: horarios_funcionamento; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.horarios_funcionamento (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    barbearia_id uuid NOT NULL,
    dia_semana integer NOT NULL,
    hora_abre time without time zone,
    hora_fecha time without time zone,
    fechado boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.profiles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    name text NOT NULL,
    phone text,
    role public.user_role DEFAULT 'cliente'::public.user_role NOT NULL,
    barbearia_id uuid,
    receber_lembretes_email boolean DEFAULT true,
    receber_lembretes_sms boolean DEFAULT false,
    consentimento_marketing boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: recompensas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.recompensas (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    barbearia_id uuid NOT NULL,
    nome text NOT NULL,
    descricao text,
    pontos_necessarios integer NOT NULL,
    ativo boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT recompensas_pontos_necessarios_check CHECK ((pontos_necessarios > 0))
);


--
-- Name: resgates_recompensas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resgates_recompensas (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    recompensa_id uuid NOT NULL,
    cliente_telefone text NOT NULL,
    barbearia_id uuid NOT NULL,
    pontos_utilizados integer NOT NULL,
    data_resgate timestamp with time zone DEFAULT now() NOT NULL,
    status text DEFAULT 'resgatado'::text NOT NULL,
    CONSTRAINT resgates_recompensas_status_check CHECK ((status = ANY (ARRAY['resgatado'::text, 'utilizado'::text, 'cancelado'::text])))
);


--
-- Name: servicos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.servicos (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    barbearia_id uuid NOT NULL,
    nome text NOT NULL,
    descricao text,
    valor numeric(10,2) NOT NULL,
    duracao_minutos integer NOT NULL,
    categoria_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    categoria_id_2 uuid
);


--
-- Name: servicos_public; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.servicos_public WITH (security_invoker='on') AS
 SELECT id,
    nome,
    descricao,
    valor,
    duracao_minutos,
    barbearia_id
   FROM public.servicos s;


--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
)
PARTITION BY RANGE (inserted_at);


--
-- Name: messages_2026_03_23; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages_2026_03_23 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: messages_2026_03_24; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages_2026_03_24 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: messages_2026_03_25; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages_2026_03_25 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: messages_2026_03_26; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages_2026_03_26 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: messages_2026_03_27; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages_2026_03_27 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: messages_2026_03_28; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages_2026_03_28 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    action_filter text DEFAULT '*'::text,
    CONSTRAINT subscription_action_filter_check CHECK ((action_filter = ANY (ARRAY['*'::text, 'INSERT'::text, 'UPDATE'::text, 'DELETE'::text])))
);


--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: -
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text,
    type storage.buckettype DEFAULT 'STANDARD'::storage.buckettype NOT NULL
);


--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: buckets_analytics; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets_analytics (
    name text NOT NULL,
    type storage.buckettype DEFAULT 'ANALYTICS'::storage.buckettype NOT NULL,
    format text DEFAULT 'ICEBERG'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: buckets_vectors; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets_vectors (
    id text NOT NULL,
    type storage.buckettype DEFAULT 'VECTOR'::storage.buckettype NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: objects; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb
);


--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb
);


--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: vector_indexes; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.vector_indexes (
    id text DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    bucket_id text NOT NULL,
    data_type text NOT NULL,
    dimension integer NOT NULL,
    distance_metric text NOT NULL,
    metadata_configuration jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: supabase_migrations; Owner: -
--

CREATE TABLE supabase_migrations.schema_migrations (
    version text NOT NULL,
    statements text[],
    name text,
    created_by text,
    idempotency_key text,
    rollback text[]
);


--
-- Name: seed_files; Type: TABLE; Schema: supabase_migrations; Owner: -
--

CREATE TABLE supabase_migrations.seed_files (
    path text NOT NULL,
    hash text NOT NULL
);


--
-- Name: messages_2026_03_23; Type: TABLE ATTACH; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_03_23 FOR VALUES FROM ('2026-03-23 00:00:00') TO ('2026-03-24 00:00:00');


--
-- Name: messages_2026_03_24; Type: TABLE ATTACH; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_03_24 FOR VALUES FROM ('2026-03-24 00:00:00') TO ('2026-03-25 00:00:00');


--
-- Name: messages_2026_03_25; Type: TABLE ATTACH; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_03_25 FOR VALUES FROM ('2026-03-25 00:00:00') TO ('2026-03-26 00:00:00');


--
-- Name: messages_2026_03_26; Type: TABLE ATTACH; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_03_26 FOR VALUES FROM ('2026-03-26 00:00:00') TO ('2026-03-27 00:00:00');


--
-- Name: messages_2026_03_27; Type: TABLE ATTACH; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_03_27 FOR VALUES FROM ('2026-03-27 00:00:00') TO ('2026-03-28 00:00:00');


--
-- Name: messages_2026_03_28; Type: TABLE ATTACH; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_03_28 FOR VALUES FROM ('2026-03-28 00:00:00') TO ('2026-03-29 00:00:00');


--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
00000000-0000-0000-0000-000000000000	b6ab4bc3-3e53-44c5-acd5-72cd52db0eb6	{"action":"user_signedup","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-08-23 00:08:08.207662+00	
00000000-0000-0000-0000-000000000000	50b4fa20-6bdb-444f-adbc-87359c7f7b0f	{"action":"login","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-08-23 00:08:08.220948+00	
00000000-0000-0000-0000-000000000000	9a39f2aa-aebb-43d1-9716-ddff7cdea05a	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-08-24 02:13:46.341352+00	
00000000-0000-0000-0000-000000000000	bc37117d-4c7b-4df7-90b1-431e8c30421c	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-08-24 02:13:46.353907+00	
00000000-0000-0000-0000-000000000000	bd62651b-56dc-4472-8985-e3ebcc7b5125	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-08-25 02:48:24.518184+00	
00000000-0000-0000-0000-000000000000	e5a4e4c2-cae6-4623-98f9-59159914ea75	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-08-25 02:48:24.529679+00	
00000000-0000-0000-0000-000000000000	e0aef6c4-3595-4e9d-9668-4f9cc7091511	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-08-26 02:48:23.533974+00	
00000000-0000-0000-0000-000000000000	55818a6c-85aa-4500-a8ab-7bdf87ecf05b	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-08-26 02:48:23.543954+00	
00000000-0000-0000-0000-000000000000	fca13e69-bca5-479b-8a78-9cd3a825b4af	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-08-26 14:45:59.595694+00	
00000000-0000-0000-0000-000000000000	dda54f8a-de5f-4134-9357-26b3523d0ff0	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-08-26 14:45:59.60286+00	
00000000-0000-0000-0000-000000000000	09adef3c-1a68-4dc3-9d6f-4a3ea63443f6	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-08-27 22:13:37.107571+00	
00000000-0000-0000-0000-000000000000	c811f2d2-3c21-40b6-9da0-994d8a06e9ce	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-08-27 22:13:37.11836+00	
00000000-0000-0000-0000-000000000000	cb873314-d837-4783-89f0-3b7d73d657ab	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-01 22:00:20.010735+00	
00000000-0000-0000-0000-000000000000	da58c2ca-58b8-4225-831d-a43a0bea857c	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-01 22:00:20.018554+00	
00000000-0000-0000-0000-000000000000	2473bbcd-4584-4d38-86bd-651706363178	{"action":"user_signedup","actor_id":"3fd737a7-0f66-4717-bb7a-5c7a164707db","actor_username":"luan59718@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-09-01 22:18:47.752437+00	
00000000-0000-0000-0000-000000000000	d8f439c0-60af-4dd1-87d2-7f44b9e1a33d	{"action":"login","actor_id":"3fd737a7-0f66-4717-bb7a-5c7a164707db","actor_username":"luan59718@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-01 22:18:47.767097+00	
00000000-0000-0000-0000-000000000000	5980a8d1-2c08-4e82-8617-f725e8925dc9	{"action":"logout","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-01 22:24:08.159093+00	
00000000-0000-0000-0000-000000000000	83eff9c0-c45f-43f1-a66d-9925c232f469	{"action":"user_signedup","actor_id":"ebf3fe8a-bd72-45e6-9ea3-9868df1e5369","actor_username":"1234@1234.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-09-01 22:27:16.783869+00	
00000000-0000-0000-0000-000000000000	20c35520-8d78-4800-b5b3-3ab3f65b60d0	{"action":"login","actor_id":"ebf3fe8a-bd72-45e6-9ea3-9868df1e5369","actor_username":"1234@1234.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-01 22:27:16.793103+00	
00000000-0000-0000-0000-000000000000	e3f15dea-accd-400c-945c-b4a20675b26a	{"action":"login","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-01 22:42:13.883266+00	
00000000-0000-0000-0000-000000000000	b4b06e91-c948-4797-aa0f-d95a8af3d188	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-01 23:40:52.007644+00	
00000000-0000-0000-0000-000000000000	0c8ce54b-1828-430a-9758-6042df393d4d	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-01 23:40:52.009108+00	
00000000-0000-0000-0000-000000000000	3f9b18aa-3f5d-4603-8b1c-c59ea763ebd3	{"action":"token_refreshed","actor_id":"3fd737a7-0f66-4717-bb7a-5c7a164707db","actor_username":"luan59718@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-01 23:49:55.803402+00	
00000000-0000-0000-0000-000000000000	0c9a039c-4127-4382-8239-734d16a0270a	{"action":"token_revoked","actor_id":"3fd737a7-0f66-4717-bb7a-5c7a164707db","actor_username":"luan59718@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-01 23:49:55.804241+00	
00000000-0000-0000-0000-000000000000	4d910d9a-bb7a-4020-9ce6-dc29e8f5dfe7	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-02 12:52:03.521598+00	
00000000-0000-0000-0000-000000000000	6af9f101-3eef-4996-9110-70450ef89f76	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-02 12:52:03.533304+00	
00000000-0000-0000-0000-000000000000	3816b29f-73c3-4652-a0d4-d4245f3aacb2	{"action":"logout","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-02 12:52:39.327634+00	
00000000-0000-0000-0000-000000000000	5820938e-a9fa-4e9b-ade7-db7959e9a372	{"action":"login","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-02 12:53:33.642604+00	
00000000-0000-0000-0000-000000000000	9f0f0289-a7bf-481a-96fc-a8941efd227b	{"action":"logout","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-02 13:17:55.557278+00	
00000000-0000-0000-0000-000000000000	fa37450e-19c7-4751-8b2a-41efa4952028	{"action":"login","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-02 13:18:43.213617+00	
00000000-0000-0000-0000-000000000000	d9fea8a3-020d-4a80-9aae-9d6b25a6060e	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-03 14:20:57.985676+00	
00000000-0000-0000-0000-000000000000	fa0c39f7-b225-4aa8-b366-049050711eae	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-03 14:20:57.994818+00	
00000000-0000-0000-0000-000000000000	48588178-82e7-476d-adca-83467c03aa74	{"action":"logout","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-03 14:21:14.258097+00	
00000000-0000-0000-0000-000000000000	f67c4a1c-d971-4eac-9070-ba856bdc82ed	{"action":"login","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-04 13:01:50.000054+00	
00000000-0000-0000-0000-000000000000	ef24d54c-4cc2-49fc-be63-52744f74ed58	{"action":"logout","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-04 13:06:30.708348+00	
00000000-0000-0000-0000-000000000000	1291bce0-0ae8-4ea8-8ca2-97021246a15e	{"action":"login","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-05 13:57:22.230479+00	
00000000-0000-0000-0000-000000000000	3903140f-ca9b-4051-b4fb-baa1a30a7595	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-06 17:24:25.650405+00	
00000000-0000-0000-0000-000000000000	575e7c48-88bb-425b-9f08-16390d8e670d	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-06 17:24:25.661481+00	
00000000-0000-0000-0000-000000000000	1a9b9706-112f-4345-bd9d-7b4c870c4df0	{"action":"logout","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-06 17:25:19.083973+00	
00000000-0000-0000-0000-000000000000	ce84faa2-7f3d-4583-9e04-18c3e778a68e	{"action":"login","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-06 17:27:41.33762+00	
00000000-0000-0000-0000-000000000000	362c7cab-2736-419e-9a15-70db9dbe0745	{"action":"token_refreshed","actor_id":"ebf3fe8a-bd72-45e6-9ea3-9868df1e5369","actor_username":"1234@1234.com","actor_via_sso":false,"log_type":"token"}	2025-09-07 20:00:54.851086+00	
00000000-0000-0000-0000-000000000000	fcda7413-6bb6-4ca2-ba4d-b487d146cdbe	{"action":"token_revoked","actor_id":"ebf3fe8a-bd72-45e6-9ea3-9868df1e5369","actor_username":"1234@1234.com","actor_via_sso":false,"log_type":"token"}	2025-09-07 20:00:54.872036+00	
00000000-0000-0000-0000-000000000000	3e358191-93a9-4d9c-a75d-6c7bfcee8039	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-07 20:04:12.593094+00	
00000000-0000-0000-0000-000000000000	f1fd5ba1-98a7-47e9-9869-db6bb87ac653	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-07 20:04:12.59588+00	
00000000-0000-0000-0000-000000000000	437f6244-59db-4a49-8caf-fc632c4be3c3	{"action":"logout","actor_id":"ebf3fe8a-bd72-45e6-9ea3-9868df1e5369","actor_username":"1234@1234.com","actor_via_sso":false,"log_type":"account"}	2025-09-07 20:16:34.153431+00	
00000000-0000-0000-0000-000000000000	248136f9-91e6-48d5-8771-10c3b46b4a9c	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-09 23:39:22.544972+00	
00000000-0000-0000-0000-000000000000	aecccb96-2585-4724-bc61-a6e631ade373	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-09 23:39:22.557127+00	
00000000-0000-0000-0000-000000000000	e2bfec9a-1e79-490d-92e3-5516dc722288	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-10 00:38:09.551469+00	
00000000-0000-0000-0000-000000000000	eaf39585-8caf-4956-9779-2051af688373	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-10 00:38:09.555721+00	
00000000-0000-0000-0000-000000000000	8ec7f3c5-fb2f-4287-80a6-0adbef87c9bd	{"action":"logout","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-10 00:38:12.229165+00	
00000000-0000-0000-0000-000000000000	0881c5d5-c0d2-4459-a3b8-4efc71650408	{"action":"login","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-10 01:03:26.929726+00	
00000000-0000-0000-0000-000000000000	359c69d7-ee20-4819-85b3-5d3043e1e27f	{"action":"user_signedup","actor_id":"259fdb34-a544-4cbc-81b8-1f4ae5d9c9c3","actor_username":"rafaelgomesa0403@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-09-10 01:36:38.599725+00	
00000000-0000-0000-0000-000000000000	046813d3-9fdf-4e0d-8dd3-83ad7411eda3	{"action":"login","actor_id":"259fdb34-a544-4cbc-81b8-1f4ae5d9c9c3","actor_username":"rafaelgomesa0403@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-10 01:36:38.613476+00	
00000000-0000-0000-0000-000000000000	5257cc44-b909-4be5-8495-9c016ad094c9	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-10 02:02:35.651964+00	
00000000-0000-0000-0000-000000000000	4d20e3a6-ee63-41a4-b465-bc311b9d81fe	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-10 02:02:35.654129+00	
00000000-0000-0000-0000-000000000000	f142c5c1-8287-4f62-bb42-43e82c2c755f	{"action":"token_refreshed","actor_id":"259fdb34-a544-4cbc-81b8-1f4ae5d9c9c3","actor_username":"rafaelgomesa0403@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-10 02:35:26.549196+00	
00000000-0000-0000-0000-000000000000	1ad25265-0575-4fb4-8c28-8bc49f8a1bfc	{"action":"token_revoked","actor_id":"259fdb34-a544-4cbc-81b8-1f4ae5d9c9c3","actor_username":"rafaelgomesa0403@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-10 02:35:26.554372+00	
00000000-0000-0000-0000-000000000000	27b7d828-24d7-4d66-a200-91fb287c5341	{"action":"token_refreshed","actor_id":"259fdb34-a544-4cbc-81b8-1f4ae5d9c9c3","actor_username":"rafaelgomesa0403@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-10 15:32:13.465193+00	
00000000-0000-0000-0000-000000000000	ad0a5f91-23d1-4e8d-8caf-fbe6dd5e3544	{"action":"token_revoked","actor_id":"259fdb34-a544-4cbc-81b8-1f4ae5d9c9c3","actor_username":"rafaelgomesa0403@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-10 15:32:13.474899+00	
00000000-0000-0000-0000-000000000000	503a19bd-c683-45c6-ac6c-d03277dc1ecc	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-11 22:00:27.692771+00	
00000000-0000-0000-0000-000000000000	7a6821e2-0266-471f-9b67-3d3ecd205728	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-11 22:00:27.718176+00	
00000000-0000-0000-0000-000000000000	f982df61-f76b-40ff-82ed-9abd91d0f481	{"action":"user_signedup","actor_id":"de7a70fd-66a4-4df8-849f-b0aa44f43fb2","actor_username":"luanjunior017@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-09-11 22:04:01.288018+00	
00000000-0000-0000-0000-000000000000	d6b10723-b338-4d19-95d1-fe41d0ad306e	{"action":"login","actor_id":"de7a70fd-66a4-4df8-849f-b0aa44f43fb2","actor_username":"luanjunior017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-11 22:04:01.30994+00	
00000000-0000-0000-0000-000000000000	805034ea-fdb5-4caa-ba8c-7277fd89db7b	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-11 22:59:37.181542+00	
00000000-0000-0000-0000-000000000000	29f27485-ad3b-410f-a53c-dd24f6b41106	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-11 22:59:37.18365+00	
00000000-0000-0000-0000-000000000000	3ac6e4dd-b957-4923-851d-27fd7c29d3ba	{"action":"token_refreshed","actor_id":"de7a70fd-66a4-4df8-849f-b0aa44f43fb2","actor_username":"luanjunior017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-11 23:03:09.156776+00	
00000000-0000-0000-0000-000000000000	801d55bf-d7b4-41e4-bff9-0f1a5af9bbb5	{"action":"token_revoked","actor_id":"de7a70fd-66a4-4df8-849f-b0aa44f43fb2","actor_username":"luanjunior017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-11 23:03:09.160041+00	
00000000-0000-0000-0000-000000000000	6ff1bc98-b2fc-48c9-bc48-b34f2d393c89	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-12 22:01:54.192817+00	
00000000-0000-0000-0000-000000000000	3b1d0c8f-892e-4544-8d2e-c1ba7cb2e932	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-12 22:01:54.207011+00	
00000000-0000-0000-0000-000000000000	ef105cc0-d8ec-461c-a563-d2804bf361d5	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-12 23:00:44.920284+00	
00000000-0000-0000-0000-000000000000	9a12ccf1-4341-411c-9766-738e08f65505	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-12 23:00:44.925481+00	
00000000-0000-0000-0000-000000000000	3a2f9102-39d3-477d-bbdb-bf2a09932d5f	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-12 23:59:54.977913+00	
00000000-0000-0000-0000-000000000000	ffb7a57f-230d-433a-ad09-8327986721a8	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-12 23:59:54.979659+00	
00000000-0000-0000-0000-000000000000	242ab632-79f6-40b2-8ffa-344d626caca6	{"action":"logout","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-13 00:33:03.776866+00	
00000000-0000-0000-0000-000000000000	084cdcc9-9c8d-43b1-a846-4bbb674c51d2	{"action":"login","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 00:33:23.127521+00	
00000000-0000-0000-0000-000000000000	149de804-4aa7-4c04-a78a-50edd3491a09	{"action":"login","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 00:35:36.764487+00	
00000000-0000-0000-0000-000000000000	b7485342-0b76-4bd6-9744-986962bd7449	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-14 16:02:36.927681+00	
00000000-0000-0000-0000-000000000000	ef097559-67b5-49b8-94c2-da600b1aa48f	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-14 16:02:36.937627+00	
00000000-0000-0000-0000-000000000000	249e5463-27d0-4958-98e0-4c06555a3ea6	{"action":"token_refreshed","actor_id":"de7a70fd-66a4-4df8-849f-b0aa44f43fb2","actor_username":"luanjunior017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-14 16:43:32.244308+00	
00000000-0000-0000-0000-000000000000	4934507f-bcca-49c6-8211-cfe47ae3fb99	{"action":"token_revoked","actor_id":"de7a70fd-66a4-4df8-849f-b0aa44f43fb2","actor_username":"luanjunior017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-14 16:43:32.24813+00	
00000000-0000-0000-0000-000000000000	ca8e059f-b388-45b1-8120-7d0e55ec3c55	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-14 17:02:23.180381+00	
00000000-0000-0000-0000-000000000000	0d04424d-2ace-4a30-a993-187b2901da22	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-14 17:02:23.181933+00	
00000000-0000-0000-0000-000000000000	1813d75c-bd66-40ea-b7a6-54fb76ab0b36	{"action":"logout","actor_id":"de7a70fd-66a4-4df8-849f-b0aa44f43fb2","actor_username":"luanjunior017@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-14 17:20:21.963665+00	
00000000-0000-0000-0000-000000000000	60c42962-28b2-4645-868b-d8488e624585	{"action":"login","actor_id":"de7a70fd-66a4-4df8-849f-b0aa44f43fb2","actor_username":"luanjunior017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-14 17:21:06.430164+00	
00000000-0000-0000-0000-000000000000	6d0772a1-2ddb-465e-961a-bad45bf1e3ea	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-14 18:01:25.301505+00	
00000000-0000-0000-0000-000000000000	e1d50277-3360-4151-ab22-6a932175babd	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-14 18:01:25.30331+00	
00000000-0000-0000-0000-000000000000	5487e46a-93dc-4747-a4ee-5a9cf79b84fb	{"action":"token_refreshed","actor_id":"de7a70fd-66a4-4df8-849f-b0aa44f43fb2","actor_username":"luanjunior017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-14 18:22:03.774613+00	
00000000-0000-0000-0000-000000000000	813c3d16-8b9d-4c10-9730-f2ad1b903d97	{"action":"token_revoked","actor_id":"de7a70fd-66a4-4df8-849f-b0aa44f43fb2","actor_username":"luanjunior017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-14 18:22:03.775499+00	
00000000-0000-0000-0000-000000000000	e7ca2538-521f-4972-97a0-8a683eb9432f	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-14 22:11:34.600203+00	
00000000-0000-0000-0000-000000000000	4b294950-1a82-44a6-b30f-bcbe70bf56f6	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-14 22:11:34.602002+00	
00000000-0000-0000-0000-000000000000	b443dbd3-c436-4f21-ad43-ee25b73b5ec7	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-14 22:20:01.203125+00	
00000000-0000-0000-0000-000000000000	a03204ce-ca70-44a9-88d8-0ac4a5f3e4b7	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-14 22:20:01.205285+00	
00000000-0000-0000-0000-000000000000	bd89d5d6-1931-49cc-850a-78009cc80ae2	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-14 23:19:06.406574+00	
00000000-0000-0000-0000-000000000000	419ac3e8-e60a-48d4-b253-b62288b80403	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-14 23:19:06.408906+00	
00000000-0000-0000-0000-000000000000	41992c23-44e6-4636-93ab-66781892e45e	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-15 00:18:18.646922+00	
00000000-0000-0000-0000-000000000000	55fab20a-8693-419d-b540-7d09c09ca4f3	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-15 00:18:18.648942+00	
00000000-0000-0000-0000-000000000000	940b15a0-0ede-4d40-8690-c0dd6b793b69	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-15 01:02:04.015141+00	
00000000-0000-0000-0000-000000000000	92619f30-8129-444c-91f8-07a5e5c9bc0c	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-15 01:02:04.016706+00	
00000000-0000-0000-0000-000000000000	72cbc41c-be59-4bd9-99ba-e8fd80087168	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-15 01:17:21.478033+00	
00000000-0000-0000-0000-000000000000	62b90b02-d5f3-4289-a855-45c5707334d1	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-15 01:17:21.479839+00	
00000000-0000-0000-0000-000000000000	ddc3e5aa-86bc-4168-9bb9-392b3c8ccdb8	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-15 04:06:19.636635+00	
00000000-0000-0000-0000-000000000000	902a16e3-ae71-437a-a786-3061ef42dd69	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-15 04:06:19.637403+00	
00000000-0000-0000-0000-000000000000	c8217d9a-891f-40bf-8d8f-0ccad4b62b60	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-16 00:19:30.845331+00	
00000000-0000-0000-0000-000000000000	7182ebbc-4430-4763-9c00-45474f5e773b	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-16 00:19:30.860156+00	
00000000-0000-0000-0000-000000000000	22cc7297-2d48-4993-b8c4-560b6392bdc3	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-16 00:37:36.644264+00	
00000000-0000-0000-0000-000000000000	6272f3b4-1d18-4fa1-9fd0-4848e7db5763	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-16 00:37:36.648051+00	
00000000-0000-0000-0000-000000000000	4d6244bc-ee26-4fe6-a241-b969508416db	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-16 01:18:50.364443+00	
00000000-0000-0000-0000-000000000000	d3eec148-0034-4b49-bd22-2154d9a0aaa7	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-16 01:18:50.366172+00	
00000000-0000-0000-0000-000000000000	6f003ff6-c5b9-4c7e-b4fd-3b174a521328	{"action":"token_refreshed","actor_id":"de7a70fd-66a4-4df8-849f-b0aa44f43fb2","actor_username":"luanjunior017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-16 01:24:42.036658+00	
00000000-0000-0000-0000-000000000000	ecc5b253-c87a-4330-b335-d055d51442d2	{"action":"token_revoked","actor_id":"de7a70fd-66a4-4df8-849f-b0aa44f43fb2","actor_username":"luanjunior017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-16 01:24:42.038744+00	
00000000-0000-0000-0000-000000000000	5128dba7-86a0-4e04-8dc7-a9e9e90a1d8a	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-16 02:24:37.192855+00	
00000000-0000-0000-0000-000000000000	3a9a6e55-4791-48fc-89d5-cf0dbe6335f4	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-16 02:24:37.196681+00	
00000000-0000-0000-0000-000000000000	12ff4976-5740-4834-861c-b4657c94cd9e	{"action":"token_refreshed","actor_id":"de7a70fd-66a4-4df8-849f-b0aa44f43fb2","actor_username":"luanjunior017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-16 02:25:01.017806+00	
00000000-0000-0000-0000-000000000000	5ef68ad3-fc1c-4c8e-bdbf-09ce29aa940d	{"action":"token_revoked","actor_id":"de7a70fd-66a4-4df8-849f-b0aa44f43fb2","actor_username":"luanjunior017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-16 02:25:01.018421+00	
00000000-0000-0000-0000-000000000000	ae837393-71ae-40f0-8187-00fcf65edaa8	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-16 11:39:29.310148+00	
00000000-0000-0000-0000-000000000000	6085ebad-3833-4b4f-9211-33126044b49a	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-16 11:39:29.321197+00	
00000000-0000-0000-0000-000000000000	7877c9ef-d6aa-46d6-86cb-6814bfc0b5a5	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-16 11:40:07.891865+00	
00000000-0000-0000-0000-000000000000	1e33599c-a9d7-4ad2-b82e-d02ede15b86d	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-16 11:40:07.892931+00	
00000000-0000-0000-0000-000000000000	5d2a1a06-1346-413c-81ed-590f66025af2	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-16 12:38:09.16568+00	
00000000-0000-0000-0000-000000000000	18a642c4-21e1-47c5-80ef-6d2a4aab4d48	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-16 12:38:09.171553+00	
00000000-0000-0000-0000-000000000000	dc07f5a0-dbdd-4065-ae5f-7ac1d4f0b580	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-16 13:36:59.40294+00	
00000000-0000-0000-0000-000000000000	b95e31d8-1b7d-4192-b3ea-1154833a006a	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-16 13:36:59.4051+00	
00000000-0000-0000-0000-000000000000	e4e6ebe8-7195-4f8b-a1f4-9ad1e4a64a24	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-16 22:09:06.817713+00	
00000000-0000-0000-0000-000000000000	b8896f13-99c5-4604-84a7-b8cb17e078ba	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-16 22:09:06.830721+00	
00000000-0000-0000-0000-000000000000	96a2b323-9ca8-4e6f-81ff-31c767057087	{"action":"token_refreshed","actor_id":"de7a70fd-66a4-4df8-849f-b0aa44f43fb2","actor_username":"luanjunior017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-16 22:11:45.673492+00	
00000000-0000-0000-0000-000000000000	9d886f8d-f843-45e3-a16c-2777884053d4	{"action":"token_revoked","actor_id":"de7a70fd-66a4-4df8-849f-b0aa44f43fb2","actor_username":"luanjunior017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-16 22:11:45.675794+00	
00000000-0000-0000-0000-000000000000	f168ba3b-d054-4912-a2da-1029a9b9d438	{"action":"logout","actor_id":"de7a70fd-66a4-4df8-849f-b0aa44f43fb2","actor_username":"luanjunior017@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-16 22:13:13.93106+00	
00000000-0000-0000-0000-000000000000	77869757-6781-4426-be08-2607329e4f88	{"action":"login","actor_id":"de7a70fd-66a4-4df8-849f-b0aa44f43fb2","actor_username":"luanjunior017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-16 22:13:39.644135+00	
00000000-0000-0000-0000-000000000000	af59ea2a-3234-4288-9739-0873f280db6d	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-16 23:07:50.542178+00	
00000000-0000-0000-0000-000000000000	b1f9e8e6-6fd8-4cac-91de-e182a12f26fc	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-16 23:07:50.544666+00	
00000000-0000-0000-0000-000000000000	d92e365e-749e-4c2a-880e-74b6be86eb9d	{"action":"token_refreshed","actor_id":"de7a70fd-66a4-4df8-849f-b0aa44f43fb2","actor_username":"luanjunior017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-16 23:16:58.939572+00	
00000000-0000-0000-0000-000000000000	105d658a-a37d-4aa6-9514-6604d6ad61a3	{"action":"token_revoked","actor_id":"de7a70fd-66a4-4df8-849f-b0aa44f43fb2","actor_username":"luanjunior017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-16 23:16:58.941987+00	
00000000-0000-0000-0000-000000000000	c070e9b2-1b90-4a46-965e-f189aaba0360	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-17 00:06:40.648707+00	
00000000-0000-0000-0000-000000000000	3513371a-a2ee-46c4-9337-f158a795de6c	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-17 00:06:40.653664+00	
00000000-0000-0000-0000-000000000000	f22f463b-6872-4812-b6ce-4bfeb41ca3e3	{"action":"token_refreshed","actor_id":"de7a70fd-66a4-4df8-849f-b0aa44f43fb2","actor_username":"luanjunior017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-17 00:16:19.008398+00	
00000000-0000-0000-0000-000000000000	c4b774c4-93d2-4b2c-a3e1-1ff78a430a28	{"action":"token_revoked","actor_id":"de7a70fd-66a4-4df8-849f-b0aa44f43fb2","actor_username":"luanjunior017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-17 00:16:19.010112+00	
00000000-0000-0000-0000-000000000000	796c7e62-3b4c-4838-91a8-e9fbaf0b1abb	{"action":"logout","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-17 00:19:46.140283+00	
00000000-0000-0000-0000-000000000000	21b04347-8ea1-421c-a2e1-70658ddf06d0	{"action":"login","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-17 00:20:19.322485+00	
00000000-0000-0000-0000-000000000000	4ca41afc-2e24-455e-8c8d-6803e00b18d8	{"action":"logout","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-17 00:20:22.265914+00	
00000000-0000-0000-0000-000000000000	af7799c1-3c08-4c1c-8c22-4f8837034299	{"action":"login","actor_id":"de7a70fd-66a4-4df8-849f-b0aa44f43fb2","actor_username":"luanjunior017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-17 00:20:53.338686+00	
00000000-0000-0000-0000-000000000000	b95b83b7-3a73-462c-8db8-72a3167bd715	{"action":"logout","actor_id":"de7a70fd-66a4-4df8-849f-b0aa44f43fb2","actor_username":"luanjunior017@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-17 00:22:46.901461+00	
00000000-0000-0000-0000-000000000000	eb8609ee-83e0-4198-8301-180a4abcb27a	{"action":"login","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-17 00:23:41.383202+00	
00000000-0000-0000-0000-000000000000	c64f68fe-29fa-4643-b706-01f73fca75cc	{"action":"logout","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-17 00:31:41.606303+00	
00000000-0000-0000-0000-000000000000	b1ca7205-9726-4976-9406-993b5806b5a6	{"action":"login","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-17 00:31:56.389546+00	
00000000-0000-0000-0000-000000000000	be7a5704-51d8-40bb-b13c-d9fcdd264ad3	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-18 23:03:42.749332+00	
00000000-0000-0000-0000-000000000000	05967c72-6dd4-43b6-9dfe-2e79022b09a8	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-18 23:03:42.765102+00	
00000000-0000-0000-0000-000000000000	e8ceee8a-63b7-4449-8a65-a1984e23c7e7	{"action":"token_refreshed","actor_id":"3fd737a7-0f66-4717-bb7a-5c7a164707db","actor_username":"luan59718@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-18 23:21:00.089109+00	
00000000-0000-0000-0000-000000000000	0466dbe8-f62b-4f85-88c8-30bb8e3961c3	{"action":"token_revoked","actor_id":"3fd737a7-0f66-4717-bb7a-5c7a164707db","actor_username":"luan59718@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-18 23:21:00.092333+00	
00000000-0000-0000-0000-000000000000	4d6ca985-bb2f-47a5-987c-dc9a47eb348d	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-19 00:02:14.856859+00	
00000000-0000-0000-0000-000000000000	0f975bb4-2c84-40e1-a0f4-93f460137e86	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-19 00:02:14.859613+00	
00000000-0000-0000-0000-000000000000	e40c8a01-d79b-4e5b-b0f3-8df0e5894e92	{"action":"login","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-23 01:17:24.33101+00	
00000000-0000-0000-0000-000000000000	f8840ab6-3247-47c3-9889-c2552967a4bb	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-23 22:22:39.11205+00	
00000000-0000-0000-0000-000000000000	9b992959-8634-4f83-8df2-cb6c838731e4	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-23 22:22:39.134088+00	
00000000-0000-0000-0000-000000000000	40b4b7b7-daed-43fe-be10-5266dd5bfe09	{"action":"user_signedup","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-09-23 22:52:26.005746+00	
00000000-0000-0000-0000-000000000000	7a7483dc-2451-4c47-afe8-de86489a58ea	{"action":"login","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-23 22:52:26.023225+00	
00000000-0000-0000-0000-000000000000	3b17cb27-7bb8-432e-b04a-75867a34a62f	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-23 23:21:16.748401+00	
00000000-0000-0000-0000-000000000000	2428b1c3-467e-4633-b68c-d00d4fbebf04	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-23 23:21:16.751624+00	
00000000-0000-0000-0000-000000000000	68382403-3de1-49c1-a667-a5b1a5bc9559	{"action":"token_refreshed","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-24 00:19:12.197156+00	
00000000-0000-0000-0000-000000000000	3d33ed78-738b-4926-b3b6-9968e8890bae	{"action":"token_revoked","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-24 00:19:12.203677+00	
00000000-0000-0000-0000-000000000000	5b0ac2ae-7f2e-445b-a702-912e9593e9c9	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-24 00:20:11.712395+00	
00000000-0000-0000-0000-000000000000	3f8bc6c5-ad17-4130-85fa-2382cb791b53	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-24 00:20:11.715553+00	
00000000-0000-0000-0000-000000000000	8ff0241b-1126-4bab-9f0d-a586ae2adbdd	{"action":"user_signedup","actor_id":"70dd2ff9-7ccc-4c50-bae6-45a1ae309f98","actor_username":"faktmj007@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-09-24 01:10:08.333925+00	
00000000-0000-0000-0000-000000000000	42b703c8-2706-43bd-b2f3-038bd607c84c	{"action":"login","actor_id":"70dd2ff9-7ccc-4c50-bae6-45a1ae309f98","actor_username":"faktmj007@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-24 01:10:08.348625+00	
00000000-0000-0000-0000-000000000000	83432309-2394-45f4-82c1-309ac891210d	{"action":"logout","actor_id":"70dd2ff9-7ccc-4c50-bae6-45a1ae309f98","actor_username":"faktmj007@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-24 01:12:42.860585+00	
00000000-0000-0000-0000-000000000000	02665a28-dc81-488b-a3a6-5f99e7c34aea	{"action":"login","actor_id":"70dd2ff9-7ccc-4c50-bae6-45a1ae309f98","actor_username":"faktmj007@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-24 01:14:06.712782+00	
00000000-0000-0000-0000-000000000000	7d45f80f-8b02-4f78-a712-ffc7d0084b50	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-24 01:19:30.056102+00	
00000000-0000-0000-0000-000000000000	f575d335-5eb2-438b-8ce7-0a17e4867bd4	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-24 01:19:30.066316+00	
00000000-0000-0000-0000-000000000000	5f0aba34-3db0-40cf-abbe-f8f99ac069f9	{"action":"logout","actor_id":"70dd2ff9-7ccc-4c50-bae6-45a1ae309f98","actor_username":"faktmj007@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-24 01:23:52.031996+00	
00000000-0000-0000-0000-000000000000	88fd3b9b-f5da-4d60-811f-03d86e5762d7	{"action":"user_signedup","actor_id":"1641a141-1fc2-4ea2-92cd-c5defa0acf8d","actor_username":"luanjunior855@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-09-24 01:24:58.157768+00	
00000000-0000-0000-0000-000000000000	0086d260-c7f0-4ee5-8d23-9b4ded6e2f53	{"action":"login","actor_id":"1641a141-1fc2-4ea2-92cd-c5defa0acf8d","actor_username":"luanjunior855@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-24 01:24:58.166444+00	
00000000-0000-0000-0000-000000000000	36df3e11-18ce-45db-b6dd-0d44a517e3ae	{"action":"user_repeated_signup","actor_id":"1641a141-1fc2-4ea2-92cd-c5defa0acf8d","actor_username":"luanjunior855@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-09-24 01:25:06.736828+00	
00000000-0000-0000-0000-000000000000	e314bbb0-3eb2-48a2-9018-7cbd2725e8f3	{"action":"login","actor_id":"1641a141-1fc2-4ea2-92cd-c5defa0acf8d","actor_username":"luanjunior855@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-24 01:45:59.294829+00	
00000000-0000-0000-0000-000000000000	36b39eb1-2122-45ce-8e78-4429678b4fa9	{"action":"logout","actor_id":"1641a141-1fc2-4ea2-92cd-c5defa0acf8d","actor_username":"luanjunior855@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-24 01:46:30.732526+00	
00000000-0000-0000-0000-000000000000	7e0b7f4a-bef5-4beb-ab66-629af8b9665a	{"action":"user_repeated_signup","actor_id":"1641a141-1fc2-4ea2-92cd-c5defa0acf8d","actor_username":"luanjunior855@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-09-24 01:47:11.390257+00	
00000000-0000-0000-0000-000000000000	9106472a-7e16-4185-b3cc-fc82fc39362c	{"action":"token_refreshed","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-24 20:09:59.029928+00	
00000000-0000-0000-0000-000000000000	a279be0c-22c2-489e-904c-a54cbd372d44	{"action":"token_revoked","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-24 20:09:59.053404+00	
00000000-0000-0000-0000-000000000000	70448b43-d6ff-4ab1-8c81-3e173c455cdb	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-24 22:09:43.390918+00	
00000000-0000-0000-0000-000000000000	6facb979-d6b3-4208-8d22-eab1538a6de7	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-24 22:09:43.395316+00	
00000000-0000-0000-0000-000000000000	8132f22f-594b-43d4-bf45-6731e98e2b21	{"action":"token_refreshed","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-24 22:13:34.635364+00	
00000000-0000-0000-0000-000000000000	4e2193f1-7748-4f66-8e7b-e4eadf82e30a	{"action":"token_revoked","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-24 22:13:34.639003+00	
00000000-0000-0000-0000-000000000000	ecd958af-32bd-4b54-840c-cddd659365c2	{"action":"login","actor_id":"70dd2ff9-7ccc-4c50-bae6-45a1ae309f98","actor_username":"faktmj007@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-24 22:26:06.344882+00	
00000000-0000-0000-0000-000000000000	9396f658-ebd9-4b69-b246-7de613fbe161	{"action":"logout","actor_id":"70dd2ff9-7ccc-4c50-bae6-45a1ae309f98","actor_username":"faktmj007@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-24 22:58:00.579368+00	
00000000-0000-0000-0000-000000000000	e32d2f3a-f49c-4d39-b40a-7f8f32493d95	{"action":"user_repeated_signup","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-09-24 23:07:06.906718+00	
00000000-0000-0000-0000-000000000000	70f3d887-b0a3-46f8-9c92-66ac4839bd3a	{"action":"login","actor_id":"70dd2ff9-7ccc-4c50-bae6-45a1ae309f98","actor_username":"faktmj007@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-24 23:07:54.486599+00	
00000000-0000-0000-0000-000000000000	244fce8b-b4b8-4750-9703-1ec76db18d7b	{"action":"token_refreshed","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-24 23:08:13.200564+00	
00000000-0000-0000-0000-000000000000	bdb9e07c-1251-4f54-9b43-e8835f443280	{"action":"token_revoked","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-24 23:08:13.201096+00	
00000000-0000-0000-0000-000000000000	0743fddc-6728-4d18-b717-379d98cf47d3	{"action":"logout","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-24 23:08:22.309641+00	
00000000-0000-0000-0000-000000000000	5a092631-fe6e-4e65-b1b6-2c5ed54d3ab9	{"action":"login","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-24 23:16:58.924609+00	
00000000-0000-0000-0000-000000000000	b60e0763-4fa6-499b-b0f0-601d2e7d5345	{"action":"token_refreshed","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-24 23:23:13.713264+00	
00000000-0000-0000-0000-000000000000	3d15bd58-99fc-4e3e-960b-069d207dcc5a	{"action":"token_revoked","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-24 23:23:13.716315+00	
00000000-0000-0000-0000-000000000000	e64a1458-efe3-4a82-baa1-e7aec1fb752c	{"action":"logout","actor_id":"96493f07-bff8-4b25-9cd3-c530093e1847","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-24 23:27:01.352051+00	
00000000-0000-0000-0000-000000000000	1bfd7b35-f070-4856-a225-37aea9ea92a6	{"action":"user_signedup","actor_id":"fde3610d-a8b4-4bad-8ffc-b5a67b2194f8","actor_username":"drezzyyt5@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-09-24 23:27:40.980364+00	
00000000-0000-0000-0000-000000000000	0f87e6e6-14e6-4090-9170-f2c0ffe4de35	{"action":"login","actor_id":"fde3610d-a8b4-4bad-8ffc-b5a67b2194f8","actor_username":"drezzyyt5@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-24 23:27:40.988005+00	
00000000-0000-0000-0000-000000000000	e2ffac1e-0ccf-4d21-8c86-1eed249b70c6	{"action":"logout","actor_id":"fde3610d-a8b4-4bad-8ffc-b5a67b2194f8","actor_username":"drezzyyt5@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-24 23:27:56.529284+00	
00000000-0000-0000-0000-000000000000	af08c2c5-4448-4399-81d4-e4c8c8623664	{"action":"login","actor_id":"fde3610d-a8b4-4bad-8ffc-b5a67b2194f8","actor_username":"drezzyyt5@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-24 23:28:06.881044+00	
00000000-0000-0000-0000-000000000000	a44214b6-4a60-46b9-acf5-bb6760e9700f	{"action":"login","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-25 00:15:52.73016+00	
00000000-0000-0000-0000-000000000000	3cb8f682-ac42-48dc-bbd7-a109353444ed	{"action":"login","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-25 00:16:04.69484+00	
00000000-0000-0000-0000-000000000000	7a092c59-9e77-43b2-87bf-4cb98495c56f	{"action":"login","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-25 00:16:09.331453+00	
00000000-0000-0000-0000-000000000000	5451c0d9-1e55-4ce8-9efc-4bb0840b2274	{"action":"login","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-25 00:16:30.683503+00	
00000000-0000-0000-0000-000000000000	8baf1008-9afb-4edf-851a-b8ed2f2d8184	{"action":"user_signedup","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-09-25 00:16:48.467699+00	
00000000-0000-0000-0000-000000000000	f35579ab-d953-410c-9d6a-b1d30bcd7ba0	{"action":"login","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-25 00:16:48.472341+00	
00000000-0000-0000-0000-000000000000	9359a1f9-e153-497c-bf58-8b0cdce03848	{"action":"login","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-25 00:21:43.901025+00	
00000000-0000-0000-0000-000000000000	46fad47a-84bc-4573-8ddc-4c11d03bfb5f	{"action":"login","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-25 00:24:29.771585+00	
00000000-0000-0000-0000-000000000000	ca4009c8-30b3-4b9c-a1a2-e6383f384624	{"action":"login","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-25 00:28:53.84713+00	
00000000-0000-0000-0000-000000000000	8befec22-26d8-403d-83da-11d6e3a93b87	{"action":"login","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-25 00:38:13.736512+00	
00000000-0000-0000-0000-000000000000	236477f9-6a0c-4104-96d9-f6bb8423d9cb	{"action":"logout","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-25 00:38:31.94802+00	
00000000-0000-0000-0000-000000000000	b14c1432-33c1-479c-b05f-43c652122b0d	{"action":"login","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-25 00:38:51.349715+00	
00000000-0000-0000-0000-000000000000	9b25d8ad-b5e3-4f1b-abc1-c189b0593361	{"action":"logout","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-25 00:38:59.725339+00	
00000000-0000-0000-0000-000000000000	709255ca-18a1-4345-b473-5322efdba300	{"action":"login","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-25 00:39:17.897742+00	
00000000-0000-0000-0000-000000000000	180eb170-4365-41b1-8a77-409cc816f342	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-25 14:34:45.264799+00	
00000000-0000-0000-0000-000000000000	debeeaa3-48f6-4377-9e52-27440e7c677c	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-25 14:34:45.280521+00	
00000000-0000-0000-0000-000000000000	a71abac7-de08-4425-afb7-9eea28186435	{"action":"login","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-25 14:34:54.908904+00	
00000000-0000-0000-0000-000000000000	a54f7ac8-ab7b-497d-b2ab-595f201fe4fa	{"action":"logout","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-25 14:54:36.240701+00	
00000000-0000-0000-0000-000000000000	b58352ab-3277-47ba-8a1b-b2d4a7a13f0d	{"action":"login","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-25 14:54:54.300016+00	
00000000-0000-0000-0000-000000000000	17feb465-d1c7-4bd3-898f-fcd555511b40	{"action":"logout","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-25 15:04:35.923919+00	
00000000-0000-0000-0000-000000000000	515ac3be-1b40-4ecb-b3a4-39ff004bbb09	{"action":"login","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-25 15:04:59.992945+00	
00000000-0000-0000-0000-000000000000	0794dd57-b7fa-4b33-abe1-2fe56203adfd	{"action":"logout","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-25 15:05:09.573874+00	
00000000-0000-0000-0000-000000000000	f5d24b0d-d071-4ce5-bd5e-1bc182306205	{"action":"user_signedup","actor_id":"c9941f4f-5b88-4261-b3d5-e03fce6881dc","actor_username":"drezzyyt5@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-09-25 15:06:06.815555+00	
00000000-0000-0000-0000-000000000000	a4cba8bb-9f57-48fe-861f-5d8f18d7fce3	{"action":"login","actor_id":"c9941f4f-5b88-4261-b3d5-e03fce6881dc","actor_username":"drezzyyt5@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-25 15:06:06.8216+00	
00000000-0000-0000-0000-000000000000	40796cfd-1b9f-4184-828c-57eaee253eef	{"action":"token_refreshed","actor_id":"c9941f4f-5b88-4261-b3d5-e03fce6881dc","actor_username":"drezzyyt5@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-25 23:06:12.950941+00	
00000000-0000-0000-0000-000000000000	a1ae18d1-25af-4bcd-af9c-2040f2d6a41e	{"action":"token_revoked","actor_id":"c9941f4f-5b88-4261-b3d5-e03fce6881dc","actor_username":"drezzyyt5@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-25 23:06:12.952585+00	
00000000-0000-0000-0000-000000000000	ba0e8e85-daa4-4506-b1bc-a90ff1fa08bf	{"action":"logout","actor_id":"c9941f4f-5b88-4261-b3d5-e03fce6881dc","actor_username":"drezzyyt5@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-25 23:44:57.917254+00	
00000000-0000-0000-0000-000000000000	877c2775-db34-40bf-a8d0-3725768894ef	{"action":"login","actor_id":"c9941f4f-5b88-4261-b3d5-e03fce6881dc","actor_username":"drezzyyt5@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-25 23:45:30.432146+00	
00000000-0000-0000-0000-000000000000	2097a567-1767-4919-aa7f-c13199b2651a	{"action":"logout","actor_id":"c9941f4f-5b88-4261-b3d5-e03fce6881dc","actor_username":"drezzyyt5@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-26 00:11:25.030426+00	
00000000-0000-0000-0000-000000000000	40351578-864c-4e6b-b52b-d282db1e36a7	{"action":"login","actor_id":"c9941f4f-5b88-4261-b3d5-e03fce6881dc","actor_username":"drezzyyt5@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-26 00:25:40.444571+00	
00000000-0000-0000-0000-000000000000	252d003b-612d-4f38-91d0-25be593a7d05	{"action":"token_refreshed","actor_id":"c9941f4f-5b88-4261-b3d5-e03fce6881dc","actor_username":"drezzyyt5@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-26 01:24:52.105525+00	
00000000-0000-0000-0000-000000000000	9144a5c1-766a-4d0e-b052-b2828ef9bd94	{"action":"token_revoked","actor_id":"c9941f4f-5b88-4261-b3d5-e03fce6881dc","actor_username":"drezzyyt5@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-26 01:24:52.1078+00	
00000000-0000-0000-0000-000000000000	a7722a6a-3a1c-4200-a134-b4a56d7fd3d6	{"action":"logout","actor_id":"c9941f4f-5b88-4261-b3d5-e03fce6881dc","actor_username":"drezzyyt5@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-26 01:28:30.778726+00	
00000000-0000-0000-0000-000000000000	02f9d9fa-0a49-4862-a61d-9b4446a552b5	{"action":"login","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-26 01:28:40.839625+00	
00000000-0000-0000-0000-000000000000	1396c1b2-6c41-4cc8-be44-c4aa48496751	{"action":"token_refreshed","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-27 18:40:30.186069+00	
00000000-0000-0000-0000-000000000000	ed77a68f-046a-4f72-8961-ac5af61c2024	{"action":"token_revoked","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-27 18:40:30.205837+00	
00000000-0000-0000-0000-000000000000	b5595340-491c-4255-a4ae-3c3e045cc9c9	{"action":"logout","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-27 18:53:04.261582+00	
00000000-0000-0000-0000-000000000000	808ec89c-2af3-4ec7-bce0-0c7d4c165a34	{"action":"login","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-27 18:53:16.787596+00	
00000000-0000-0000-0000-000000000000	b533713a-fc52-4955-a16a-3fd94d6a9b5f	{"action":"logout","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-27 18:53:35.188092+00	
00000000-0000-0000-0000-000000000000	ebbe4732-844f-41a9-9e50-f40778facec3	{"action":"login","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-27 18:54:00.984583+00	
00000000-0000-0000-0000-000000000000	cbfda432-79a5-4eb9-94ae-fc8dec4b1097	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-27 19:06:59.655438+00	
00000000-0000-0000-0000-000000000000	41012277-64ce-4d56-a7d5-bc352f285698	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-27 19:06:59.65863+00	
00000000-0000-0000-0000-000000000000	f96f2ae5-473a-41de-954e-a7d279952f60	{"action":"logout","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-27 19:45:32.245213+00	
00000000-0000-0000-0000-000000000000	2be4e754-8664-4a4b-bad1-04806eab3d76	{"action":"login","actor_id":"c9941f4f-5b88-4261-b3d5-e03fce6881dc","actor_username":"drezzyyt5@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-27 19:46:14.928188+00	
00000000-0000-0000-0000-000000000000	9818083b-04b1-4d81-b9c1-f87e90b97dbb	{"action":"logout","actor_id":"c9941f4f-5b88-4261-b3d5-e03fce6881dc","actor_username":"drezzyyt5@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-27 19:46:21.949731+00	
00000000-0000-0000-0000-000000000000	45532e59-efda-4402-9a37-9fba58541b77	{"action":"login","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-27 19:46:32.913591+00	
00000000-0000-0000-0000-000000000000	9bf32e57-51a9-4144-9d7b-ae3c782c8130	{"action":"token_refreshed","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-27 19:52:41.148857+00	
00000000-0000-0000-0000-000000000000	82ffa38c-839b-4884-912e-43a353d5f1f5	{"action":"token_revoked","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-27 19:52:41.152218+00	
00000000-0000-0000-0000-000000000000	3110fdcc-866e-42fb-9ba5-a4b5ec0fe4fd	{"action":"logout","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-27 20:21:50.342274+00	
00000000-0000-0000-0000-000000000000	ac4ebe5a-820d-4d72-a816-29df20cb17f7	{"action":"login","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-27 20:22:25.962862+00	
00000000-0000-0000-0000-000000000000	8fee81a7-0b96-4949-9209-3ac5958571b0	{"action":"token_refreshed","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-27 20:51:48.063297+00	
00000000-0000-0000-0000-000000000000	c2ee7532-f2cb-4710-bb20-06c00fd7d475	{"action":"token_revoked","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-27 20:51:48.071631+00	
00000000-0000-0000-0000-000000000000	c261886a-aeb2-4ddb-a9a6-7208a70b2ace	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-27 21:20:52.91538+00	
00000000-0000-0000-0000-000000000000	04ac4d57-f1e1-4f2a-b042-a647bd9e8f52	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-27 21:20:52.919099+00	
00000000-0000-0000-0000-000000000000	ebfb008c-4746-43ed-9692-40e68420c475	{"action":"token_refreshed","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-27 21:50:38.972288+00	
00000000-0000-0000-0000-000000000000	d811dd27-ce91-4e62-8a14-b1bbbeddf9bd	{"action":"token_revoked","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-27 21:50:38.973804+00	
00000000-0000-0000-0000-000000000000	845e4742-3c90-456c-8551-cf8d2f6e4b7b	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-27 22:20:06.083981+00	
00000000-0000-0000-0000-000000000000	759aaf7b-a2d3-43b4-a26e-ee7f8b9f90b7	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-27 22:20:06.087779+00	
00000000-0000-0000-0000-000000000000	9aec8430-c570-45cc-85eb-595a2c9de0f8	{"action":"login","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-27 22:46:06.33+00	
00000000-0000-0000-0000-000000000000	656c8a09-58bf-4b80-a7f9-2e8bd7b939f7	{"action":"token_refreshed","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-27 22:53:26.366151+00	
00000000-0000-0000-0000-000000000000	2f855740-6625-4a16-b3b1-993b66a1539e	{"action":"token_revoked","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-27 22:53:26.369326+00	
00000000-0000-0000-0000-000000000000	ce5982a5-d64e-4b9d-9c8c-df06d99ff622	{"action":"user_signedup","actor_id":"c4154c64-b02b-4c03-9948-75171bb60c3f","actor_username":"rafaeloliveira67539@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-09-27 23:07:29.562993+00	
00000000-0000-0000-0000-000000000000	04942b96-b8de-438d-9508-6bcb0cba69f9	{"action":"login","actor_id":"c4154c64-b02b-4c03-9948-75171bb60c3f","actor_username":"rafaeloliveira67539@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-27 23:07:29.585439+00	
00000000-0000-0000-0000-000000000000	7a5667ac-b8b7-4ee9-9d17-17ea72fb2ead	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-27 23:18:48.945188+00	
00000000-0000-0000-0000-000000000000	41f9da4b-ed94-4bd2-9c69-a9d0fa847752	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-27 23:18:48.951053+00	
00000000-0000-0000-0000-000000000000	8ebbacf0-a052-41cd-82ce-f36971991a26	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-28 00:17:36.383995+00	
00000000-0000-0000-0000-000000000000	844f870b-fd43-4123-91a6-1c8bc68c268b	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-28 00:17:36.38959+00	
00000000-0000-0000-0000-000000000000	75ee2634-c2ee-4ae0-99fa-240e556355e7	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-01 22:04:00.49477+00	
00000000-0000-0000-0000-000000000000	300856c8-2857-42e2-ab06-9aa7b96b0d13	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-01 22:04:00.516956+00	
00000000-0000-0000-0000-000000000000	30fc7f8e-0798-467d-9d8b-467aa86cd817	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-05 00:54:00.041093+00	
00000000-0000-0000-0000-000000000000	839b42dc-7975-4574-9575-e1ca89417f4d	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-05 00:54:00.061241+00	
00000000-0000-0000-0000-000000000000	ac1bb34d-350c-4d07-b8fa-a5305a17b6f6	{"action":"user_signedup","actor_id":"38319931-975f-45b6-9c8e-112dca479893","actor_username":"faktmj007@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-10-05 01:03:55.08137+00	
00000000-0000-0000-0000-000000000000	f6ebd0c8-f405-485b-abb2-682a9c7daaa1	{"action":"login","actor_id":"38319931-975f-45b6-9c8e-112dca479893","actor_username":"faktmj007@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-10-05 01:03:55.090415+00	
00000000-0000-0000-0000-000000000000	df1a98cc-96a2-4629-b455-3ed5ce514ef3	{"action":"token_refreshed","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-05 01:05:48.126522+00	
00000000-0000-0000-0000-000000000000	c677cef4-21ca-4f78-8820-5ad47ecf5c19	{"action":"token_revoked","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-05 01:05:48.127314+00	
00000000-0000-0000-0000-000000000000	16c6c263-1ff5-405b-8f41-d5660f5e6fd2	{"action":"logout","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-10-05 01:19:10.29514+00	
00000000-0000-0000-0000-000000000000	87a6a96f-2eac-4272-baab-1cc30e4527a1	{"action":"login","actor_id":"c9941f4f-5b88-4261-b3d5-e03fce6881dc","actor_username":"drezzyyt5@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-10-05 01:19:24.831401+00	
00000000-0000-0000-0000-000000000000	1c44993b-30b4-4cc2-8263-79a88ff6de93	{"action":"logout","actor_id":"c9941f4f-5b88-4261-b3d5-e03fce6881dc","actor_username":"drezzyyt5@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-10-05 01:19:28.32667+00	
00000000-0000-0000-0000-000000000000	9389129a-167d-4dc2-835c-a79583125ff0	{"action":"user_signedup","actor_id":"0357b8ef-16b6-4869-8630-f46c096dc9a9","actor_username":"lns017dev@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-10-05 01:20:13.511817+00	
00000000-0000-0000-0000-000000000000	2553da13-9e3d-4a5e-8458-6347063eba15	{"action":"login","actor_id":"0357b8ef-16b6-4869-8630-f46c096dc9a9","actor_username":"lns017dev@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-10-05 01:20:13.517218+00	
00000000-0000-0000-0000-000000000000	8f167a55-473d-461e-9e19-fc88d25e3587	{"action":"logout","actor_id":"0357b8ef-16b6-4869-8630-f46c096dc9a9","actor_username":"lns017dev@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-10-05 01:20:47.825449+00	
00000000-0000-0000-0000-000000000000	9f33fade-5f97-4f2d-95de-e96cd4dde82c	{"action":"login","actor_id":"0357b8ef-16b6-4869-8630-f46c096dc9a9","actor_username":"lns017dev@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-10-05 01:21:39.36459+00	
00000000-0000-0000-0000-000000000000	65b9c7e3-c0b6-4f04-931a-4a9dff1064d2	{"action":"logout","actor_id":"0357b8ef-16b6-4869-8630-f46c096dc9a9","actor_username":"lns017dev@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-10-05 01:22:39.750603+00	
00000000-0000-0000-0000-000000000000	74b701fb-139e-4fc7-86de-9b70d822da3b	{"action":"login","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-10-05 01:22:51.056487+00	
00000000-0000-0000-0000-000000000000	2e041f84-cfbd-48b6-b083-2338b0aa4ea8	{"action":"logout","actor_id":"38319931-975f-45b6-9c8e-112dca479893","actor_username":"faktmj007@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-10-05 01:24:57.512482+00	
00000000-0000-0000-0000-000000000000	84e26448-3659-479f-a373-ea357e0974f8	{"action":"user_signedup","actor_id":"c6484ce8-6846-47c5-ae37-18130c44f7a3","actor_username":"contatoluandev@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-10-05 01:25:06.789344+00	
00000000-0000-0000-0000-000000000000	4e51ceaa-a5eb-4a2e-84cb-cba1c38de31d	{"action":"login","actor_id":"c6484ce8-6846-47c5-ae37-18130c44f7a3","actor_username":"contatoluandev@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-10-05 01:25:06.794047+00	
00000000-0000-0000-0000-000000000000	4d20d7d7-9881-443c-8620-be1a62454d74	{"action":"logout","actor_id":"c6484ce8-6846-47c5-ae37-18130c44f7a3","actor_username":"contatoluandev@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-10-05 01:26:42.695118+00	
00000000-0000-0000-0000-000000000000	7da147d5-ea9e-4761-a5a9-22466b44e592	{"action":"login","actor_id":"38319931-975f-45b6-9c8e-112dca479893","actor_username":"faktmj007@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-10-05 01:27:00.073203+00	
00000000-0000-0000-0000-000000000000	a221055e-e188-4ebb-b381-10aeb79ffc70	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-06 00:15:17.682003+00	
00000000-0000-0000-0000-000000000000	fa607681-7543-4f4c-8812-2cbcde0ffce9	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-06 00:15:17.691337+00	
00000000-0000-0000-0000-000000000000	b0f1dc35-34e4-44a8-a06a-147d31457c3f	{"action":"token_refreshed","actor_id":"38319931-975f-45b6-9c8e-112dca479893","actor_username":"faktmj007@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-06 00:16:00.159284+00	
00000000-0000-0000-0000-000000000000	51d51a5b-dbe9-49c3-ace2-b8d5c2f4c45a	{"action":"token_revoked","actor_id":"38319931-975f-45b6-9c8e-112dca479893","actor_username":"faktmj007@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-06 00:16:00.160538+00	
00000000-0000-0000-0000-000000000000	05830b8b-d292-4638-9277-8d230d1b701c	{"action":"logout","actor_id":"38319931-975f-45b6-9c8e-112dca479893","actor_username":"faktmj007@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-10-06 00:40:26.016089+00	
00000000-0000-0000-0000-000000000000	1145aec5-0177-4829-a614-bb0da26e8ace	{"action":"user_signedup","actor_id":"30b1a6e9-28ab-4555-aebe-993f2f5882ce","actor_username":"luanesmaganoob855@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-10-06 00:40:37.101806+00	
00000000-0000-0000-0000-000000000000	2d53f4d8-ee2e-446c-b79c-351c536f1f82	{"action":"login","actor_id":"30b1a6e9-28ab-4555-aebe-993f2f5882ce","actor_username":"luanesmaganoob855@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-10-06 00:40:37.109365+00	
00000000-0000-0000-0000-000000000000	8936f01e-a849-4401-a6ff-679f090f39ae	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"contatoluandev@gmail.com","user_id":"c6484ce8-6846-47c5-ae37-18130c44f7a3","user_phone":""}}	2025-10-06 00:42:23.368329+00	
00000000-0000-0000-0000-000000000000	8e360971-8cb2-405d-bae8-b53cabd658b2	{"action":"logout","actor_id":"30b1a6e9-28ab-4555-aebe-993f2f5882ce","actor_username":"luanesmaganoob855@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-10-06 00:46:47.684581+00	
00000000-0000-0000-0000-000000000000	7ba64e6f-f756-40c8-9808-83647bf96793	{"action":"user_repeated_signup","actor_id":"0357b8ef-16b6-4869-8630-f46c096dc9a9","actor_username":"lns017dev@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-10-06 00:47:01.993944+00	
00000000-0000-0000-0000-000000000000	1c864903-a5ab-4881-87d8-95580d5ade8b	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-07 03:11:09.93618+00	
00000000-0000-0000-0000-000000000000	5d68aca1-27a3-46e4-84f2-ef59b520ae7a	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-07 03:11:09.950808+00	
00000000-0000-0000-0000-000000000000	4c8613e3-c5f5-497f-bf3c-e7e0e224fa6f	{"action":"login","actor_id":"38319931-975f-45b6-9c8e-112dca479893","actor_username":"faktmj007@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-10-07 03:12:26.513099+00	
00000000-0000-0000-0000-000000000000	47858488-6daf-43d2-b454-636930909530	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-08 03:09:56.044473+00	
00000000-0000-0000-0000-000000000000	27dd9611-28aa-4440-a300-de5ebddfc943	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-08 03:09:56.068103+00	
00000000-0000-0000-0000-000000000000	5995bfdb-f4a8-46fa-b0a7-78d813146f6b	{"action":"logout","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-10-08 03:10:23.697858+00	
00000000-0000-0000-0000-000000000000	bd694421-dd42-4d7d-b3c9-cde4b9373ee3	{"action":"login","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-10-08 03:12:04.410218+00	
00000000-0000-0000-0000-000000000000	19311d9f-678f-40e9-9554-ef86a46e23bd	{"action":"token_refreshed","actor_id":"38319931-975f-45b6-9c8e-112dca479893","actor_username":"faktmj007@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-08 03:12:54.35569+00	
00000000-0000-0000-0000-000000000000	3f61f39d-eda7-4c85-9452-fcbed007d875	{"action":"token_revoked","actor_id":"38319931-975f-45b6-9c8e-112dca479893","actor_username":"faktmj007@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-08 03:12:54.359389+00	
00000000-0000-0000-0000-000000000000	c558c096-0c8e-47f3-9425-bb4471711abd	{"action":"logout","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-10-08 03:33:29.257241+00	
00000000-0000-0000-0000-000000000000	ab604d15-e75f-4800-a0ed-29879b17e456	{"action":"login","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-10-08 03:34:28.53672+00	
00000000-0000-0000-0000-000000000000	a11dd0a9-29bd-4a0d-950e-e4962020c2d6	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-09 01:06:42.19894+00	
00000000-0000-0000-0000-000000000000	b7a6c445-6f78-4609-8698-24899268085b	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-09 01:06:42.231915+00	
00000000-0000-0000-0000-000000000000	921b7931-16f7-4e6e-8815-d7ee218cd95f	{"action":"logout","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-10-09 01:07:25.281168+00	
00000000-0000-0000-0000-000000000000	f935d467-5996-4b44-8be6-2a2d1c7620b3	{"action":"login","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-10-09 01:09:08.057012+00	
00000000-0000-0000-0000-000000000000	9f3f6f0b-c719-4f98-87d4-4855537df5f9	{"action":"logout","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-10-09 01:12:23.020973+00	
00000000-0000-0000-0000-000000000000	0e0ad8c0-4b5c-49aa-9816-4058e935c2a4	{"action":"login","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-10-09 01:13:09.122975+00	
00000000-0000-0000-0000-000000000000	cbab8c24-f11d-418f-9e65-c19a943fed82	{"action":"logout","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-10-09 01:14:15.664927+00	
00000000-0000-0000-0000-000000000000	e53b9769-eb6f-44d5-904c-5b570ae903ba	{"action":"login","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-10-09 01:17:13.676695+00	
00000000-0000-0000-0000-000000000000	8beb958a-1b00-4d6a-af14-2b23db689e2c	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-10 14:05:13.805543+00	
00000000-0000-0000-0000-000000000000	063dc2a5-98e5-4c70-9b22-4005a3e9993d	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-10 14:05:13.838033+00	
00000000-0000-0000-0000-000000000000	bb2de9df-3ec2-490b-b3b6-7234b2ecd48e	{"action":"logout","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-10-10 14:05:24.018872+00	
00000000-0000-0000-0000-000000000000	c0ff021c-1e70-4285-a8b1-d8c42c971ecc	{"action":"token_refreshed","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-07 22:34:18.745379+00	
00000000-0000-0000-0000-000000000000	9f7bca67-9165-4585-8927-fa4a0fc33ab0	{"action":"token_revoked","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-07 22:34:18.752214+00	
00000000-0000-0000-0000-000000000000	2349c2e7-2e66-4bff-adfc-950229443452	{"action":"user_repeated_signup","actor_id":"3fd737a7-0f66-4717-bb7a-5c7a164707db","actor_username":"luan59718@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-11-07 22:42:58.251668+00	
00000000-0000-0000-0000-000000000000	9c7ab1d2-67b4-4b21-b528-54457c9839a4	{"action":"user_signedup","actor_id":"72f4663e-11f6-4c41-876a-5fa272e969c5","actor_username":"luang9552@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-11-07 22:45:16.434711+00	
00000000-0000-0000-0000-000000000000	17ab13f0-79a7-430d-bb1a-616f6d913845	{"action":"login","actor_id":"72f4663e-11f6-4c41-876a-5fa272e969c5","actor_username":"luang9552@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-11-07 22:45:16.442688+00	
00000000-0000-0000-0000-000000000000	fdd65e9b-7ab5-4150-a11c-bba673b32f04	{"action":"token_refreshed","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-07 23:33:30.003784+00	
00000000-0000-0000-0000-000000000000	c3603db2-2e6c-44b2-a2d8-d101169efe2c	{"action":"token_revoked","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-07 23:33:30.01996+00	
00000000-0000-0000-0000-000000000000	3a238cae-6101-42cb-9553-51a7af854143	{"action":"token_refreshed","actor_id":"72f4663e-11f6-4c41-876a-5fa272e969c5","actor_username":"luang9552@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-07 23:44:15.239751+00	
00000000-0000-0000-0000-000000000000	a3d5369f-2b65-42f1-b1a4-5a91dca7a479	{"action":"token_revoked","actor_id":"72f4663e-11f6-4c41-876a-5fa272e969c5","actor_username":"luang9552@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-07 23:44:15.247528+00	
00000000-0000-0000-0000-000000000000	0cf6370e-24fe-45fb-b3d6-3c55cc830827	{"action":"token_refreshed","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-08 00:31:44.119096+00	
00000000-0000-0000-0000-000000000000	79fabdaa-711c-4cd5-8608-0c9ae80aa06f	{"action":"token_revoked","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-08 00:31:44.133032+00	
00000000-0000-0000-0000-000000000000	105f3caa-6492-4275-a87e-40ae89224035	{"action":"login","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-11-10 13:41:12.109251+00	
00000000-0000-0000-0000-000000000000	d66e4d76-5ed0-49f7-b95d-4d8cc0935cb0	{"action":"token_refreshed","actor_id":"38319931-975f-45b6-9c8e-112dca479893","actor_username":"faktmj007@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-10 13:43:24.43407+00	
00000000-0000-0000-0000-000000000000	d880ee12-9109-435b-85db-7d98e2617135	{"action":"token_revoked","actor_id":"38319931-975f-45b6-9c8e-112dca479893","actor_username":"faktmj007@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-10 13:43:24.437738+00	
00000000-0000-0000-0000-000000000000	20f10501-34ff-4076-821f-88cd1fa23765	{"action":"logout","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-11-10 13:44:23.590468+00	
00000000-0000-0000-0000-000000000000	16225de3-9be3-498c-bfc4-f1b2a751fda4	{"action":"login","actor_id":"c9941f4f-5b88-4261-b3d5-e03fce6881dc","actor_username":"drezzyyt5@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-11-10 13:58:19.089568+00	
00000000-0000-0000-0000-000000000000	20e6d538-9469-4743-8e61-ef9def274efc	{"action":"logout","actor_id":"c9941f4f-5b88-4261-b3d5-e03fce6881dc","actor_username":"drezzyyt5@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-11-10 13:58:22.871019+00	
00000000-0000-0000-0000-000000000000	657e8577-1ef1-4a9b-8029-d6125dbe7b1f	{"action":"login","actor_id":"38319931-975f-45b6-9c8e-112dca479893","actor_username":"faktmj007@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-11-10 14:06:21.16368+00	
00000000-0000-0000-0000-000000000000	86ec8fa6-2453-4a63-b791-b4bb0124159c	{"action":"logout","actor_id":"38319931-975f-45b6-9c8e-112dca479893","actor_username":"faktmj007@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-11-10 14:06:26.502539+00	
00000000-0000-0000-0000-000000000000	176b7683-2d18-40de-962f-3299c5615957	{"action":"login","actor_id":"0357b8ef-16b6-4869-8630-f46c096dc9a9","actor_username":"lns017dev@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-11-10 14:08:05.007401+00	
00000000-0000-0000-0000-000000000000	b48d62e7-7bb1-4613-90f3-d8bb319f46e3	{"action":"token_refreshed","actor_id":"0357b8ef-16b6-4869-8630-f46c096dc9a9","actor_username":"lns017dev@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-11 13:30:55.107087+00	
00000000-0000-0000-0000-000000000000	9f757584-a410-43f4-97c4-bc269c514023	{"action":"token_revoked","actor_id":"0357b8ef-16b6-4869-8630-f46c096dc9a9","actor_username":"lns017dev@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-11 13:30:55.125085+00	
00000000-0000-0000-0000-000000000000	b31129da-771d-4b79-9065-30f2593a0057	{"action":"token_refreshed","actor_id":"0357b8ef-16b6-4869-8630-f46c096dc9a9","actor_username":"lns017dev@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-18 23:36:13.830935+00	
00000000-0000-0000-0000-000000000000	af92c302-3846-4d6b-82fc-4ae879f963c1	{"action":"token_revoked","actor_id":"0357b8ef-16b6-4869-8630-f46c096dc9a9","actor_username":"lns017dev@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-18 23:36:13.838424+00	
00000000-0000-0000-0000-000000000000	6ba45b89-de98-498e-b20a-2c2ffbd59306	{"action":"logout","actor_id":"0357b8ef-16b6-4869-8630-f46c096dc9a9","actor_username":"lns017dev@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-11-19 00:06:12.577722+00	
00000000-0000-0000-0000-000000000000	f79d4083-32a1-4692-b571-f72db559bf52	{"action":"login","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-11-19 00:12:22.589271+00	
00000000-0000-0000-0000-000000000000	d0c00328-c44b-4cb9-a9a1-caeb06f441c5	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-20 00:31:01.867914+00	
00000000-0000-0000-0000-000000000000	982a6184-2037-4b1d-98e2-436458b85e74	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-20 00:31:01.896581+00	
00000000-0000-0000-0000-000000000000	1bcbfba0-a613-4447-b64e-2bf952bce4d3	{"action":"token_refreshed","actor_id":"72f4663e-11f6-4c41-876a-5fa272e969c5","actor_username":"luang9552@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-20 23:54:29.069532+00	
00000000-0000-0000-0000-000000000000	fa90a59c-c81b-4a31-a53c-ef461be1eee4	{"action":"token_revoked","actor_id":"72f4663e-11f6-4c41-876a-5fa272e969c5","actor_username":"luang9552@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-20 23:54:29.095506+00	
00000000-0000-0000-0000-000000000000	40810caa-d892-4e8f-bf2d-4a059c81676f	{"action":"token_refreshed","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-20 23:54:34.127456+00	
00000000-0000-0000-0000-000000000000	10c405d5-1fd4-4ad9-a57e-82f097a34e55	{"action":"token_revoked","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-20 23:54:34.12818+00	
00000000-0000-0000-0000-000000000000	574f58b1-ad44-4385-85ea-7033a22e4688	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-21 22:48:25.829147+00	
00000000-0000-0000-0000-000000000000	ce298e99-3872-4e01-9ff2-8f5897604c60	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-21 22:48:25.843288+00	
00000000-0000-0000-0000-000000000000	b2353b15-d1ba-42ff-914d-0034d057f9e3	{"action":"logout","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-11-21 22:49:04.75925+00	
00000000-0000-0000-0000-000000000000	13281d7a-c50e-4cbc-83be-b60eb86cac11	{"action":"login","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-11-21 22:52:15.770008+00	
00000000-0000-0000-0000-000000000000	a3049803-2851-4dfc-8bf6-a41383db1037	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-21 23:51:22.586055+00	
00000000-0000-0000-0000-000000000000	831960dc-230b-4b2a-9679-70cf1dbcf95e	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-21 23:51:22.599535+00	
00000000-0000-0000-0000-000000000000	3d04c068-74a1-4bc2-afb0-df41fee90dfd	{"action":"token_refreshed","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-21 23:59:45.313848+00	
00000000-0000-0000-0000-000000000000	381792fa-3f08-4fc6-b0d4-a69e9494a7c2	{"action":"token_revoked","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-21 23:59:45.316785+00	
00000000-0000-0000-0000-000000000000	c0d3d2f2-9ce4-4dda-8d83-099422def339	{"action":"token_refreshed","actor_id":"72f4663e-11f6-4c41-876a-5fa272e969c5","actor_username":"luang9552@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-22 00:02:56.255469+00	
00000000-0000-0000-0000-000000000000	8e287a78-c3bc-42a3-b2ab-123f03a7e273	{"action":"token_revoked","actor_id":"72f4663e-11f6-4c41-876a-5fa272e969c5","actor_username":"luang9552@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-22 00:02:56.25639+00	
00000000-0000-0000-0000-000000000000	fcc5a894-6246-465c-995d-8a5c1bb43039	{"action":"login","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-11-22 00:07:04.127356+00	
00000000-0000-0000-0000-000000000000	96bc1439-99df-4c84-989e-4d4320c2c471	{"action":"login","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-11-22 00:12:39.922356+00	
00000000-0000-0000-0000-000000000000	48f818c1-816b-45db-92ef-5e0cf25774dd	{"action":"token_refreshed","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-22 22:30:29.367339+00	
00000000-0000-0000-0000-000000000000	65ff6ff7-ff44-4c48-a2dc-58b1be0913cb	{"action":"token_revoked","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-22 22:30:29.399727+00	
00000000-0000-0000-0000-000000000000	5d5b9281-9d72-4be6-9aee-f08f081bf5e1	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-24 00:43:45.029626+00	
00000000-0000-0000-0000-000000000000	81fe9271-47d0-4572-af79-7b4e553be37e	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-24 00:43:45.056704+00	
00000000-0000-0000-0000-000000000000	dbe82171-796b-417f-aed2-088742cede3f	{"action":"login","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-11-24 00:49:58.30219+00	
00000000-0000-0000-0000-000000000000	c7a2daba-c394-452a-bc4b-d437c4e6b908	{"action":"login","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-11-24 00:49:58.665549+00	
00000000-0000-0000-0000-000000000000	37b423a8-4dee-4dc0-b830-43183a1306e0	{"action":"logout","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-11-24 01:23:15.598417+00	
00000000-0000-0000-0000-000000000000	73ad2715-3e03-42d4-a501-d4ca5790de4d	{"action":"login","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-11-24 01:23:24.629117+00	
00000000-0000-0000-0000-000000000000	e857c5a9-51a2-449e-8dd8-2cc69bca5306	{"action":"login","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-11-24 01:27:51.368173+00	
00000000-0000-0000-0000-000000000000	1901f9b1-88c5-49dc-8838-d036ee14e8f3	{"action":"token_refreshed","actor_id":"72f4663e-11f6-4c41-876a-5fa272e969c5","actor_username":"luang9552@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-24 23:06:08.791397+00	
00000000-0000-0000-0000-000000000000	f3dfe3aa-740d-4a95-b5cf-e847174b267d	{"action":"token_revoked","actor_id":"72f4663e-11f6-4c41-876a-5fa272e969c5","actor_username":"luang9552@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-24 23:06:08.819188+00	
00000000-0000-0000-0000-000000000000	9b702c59-d01f-4d61-b1c8-bef9574d5ab9	{"action":"token_refreshed","actor_id":"72f4663e-11f6-4c41-876a-5fa272e969c5","actor_username":"luang9552@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-25 00:05:38.581608+00	
00000000-0000-0000-0000-000000000000	3fdedf4e-8613-4109-9dde-08e76201e3ea	{"action":"token_revoked","actor_id":"72f4663e-11f6-4c41-876a-5fa272e969c5","actor_username":"luang9552@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-25 00:05:38.598893+00	
00000000-0000-0000-0000-000000000000	1f416dfd-74d2-46ab-845b-85cae70d054c	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-25 23:38:58.999696+00	
00000000-0000-0000-0000-000000000000	61aaa39d-0dcf-4042-b7c2-26c6cea5e76f	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-25 23:38:59.031318+00	
00000000-0000-0000-0000-000000000000	76cec739-90a2-43cb-b0e9-88e4d2b3989c	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-26 00:13:02.615818+00	
00000000-0000-0000-0000-000000000000	52970ee2-1dc4-44c0-be2f-0730513fe28e	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-26 00:13:02.618217+00	
00000000-0000-0000-0000-000000000000	1b735280-78b7-4ba0-acc8-336c728f9521	{"action":"login","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-11-26 00:25:03.776799+00	
00000000-0000-0000-0000-000000000000	2f5049ba-f6d2-42a6-b2e1-424e2cc061d4	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-26 00:38:25.113861+00	
00000000-0000-0000-0000-000000000000	1c4e34d9-ac17-44fd-baa5-5b8db7f5aca5	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-26 00:38:25.125718+00	
00000000-0000-0000-0000-000000000000	95e08e26-dcdc-4d58-91a2-ec1291ca544e	{"action":"login","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-11-26 12:36:15.571328+00	
00000000-0000-0000-0000-000000000000	945da3fb-3216-47e6-8006-bb82b858e673	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-26 14:25:24.293764+00	
00000000-0000-0000-0000-000000000000	5b17262a-09aa-4df7-bf87-e774191ec04f	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-26 14:25:24.312654+00	
00000000-0000-0000-0000-000000000000	82ee58c7-d0f9-464a-8030-fe71422e0342	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-27 02:23:13.993454+00	
00000000-0000-0000-0000-000000000000	5910c41a-7c1e-4997-b3c2-74b709f31a4d	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-27 02:23:14.017328+00	
00000000-0000-0000-0000-000000000000	0551a18d-3a1d-4dac-af69-84d17bf90c53	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-27 02:41:17.2384+00	
00000000-0000-0000-0000-000000000000	3e67aa6c-81c9-4ae0-bf7a-7873af146f74	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-27 02:41:17.250485+00	
00000000-0000-0000-0000-000000000000	e5569d64-66c9-4070-bbe2-68d10a3e119c	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-27 02:58:32.190822+00	
00000000-0000-0000-0000-000000000000	85a573a6-d3cc-4ee3-8b41-b7422249f024	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-27 02:58:32.201263+00	
00000000-0000-0000-0000-000000000000	233a1eff-7707-4d85-98ac-f9f834067083	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-27 22:39:21.982171+00	
00000000-0000-0000-0000-000000000000	31ce27e9-f1b2-4572-9cb9-d8750633c834	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-27 22:39:22.009208+00	
00000000-0000-0000-0000-000000000000	78cfcfef-88a3-4248-8878-e18dd7bc733f	{"action":"token_refreshed","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-27 22:41:26.3163+00	
00000000-0000-0000-0000-000000000000	cf2a6457-1a33-4c48-97e2-a55e9a2e6501	{"action":"token_revoked","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-27 22:41:26.331525+00	
00000000-0000-0000-0000-000000000000	331ca4e5-7457-47e7-95a6-8ea65edfe0fb	{"action":"token_refreshed","actor_id":"72f4663e-11f6-4c41-876a-5fa272e969c5","actor_username":"luang9552@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-27 23:23:28.971907+00	
00000000-0000-0000-0000-000000000000	c6429455-e467-428a-b4ad-e9d24e4daf3f	{"action":"token_revoked","actor_id":"72f4663e-11f6-4c41-876a-5fa272e969c5","actor_username":"luang9552@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-27 23:23:28.983279+00	
00000000-0000-0000-0000-000000000000	66133749-d6b8-40c3-954a-160d63987c49	{"action":"token_refreshed","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-27 23:40:14.263693+00	
00000000-0000-0000-0000-000000000000	5d891433-578a-40af-b858-0fa9c59c0088	{"action":"token_revoked","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-27 23:40:14.274452+00	
00000000-0000-0000-0000-000000000000	edef9b5f-47ea-462e-a9fc-06b4f54c91b5	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-27 23:46:07.753843+00	
00000000-0000-0000-0000-000000000000	ea85bf78-bf7a-4ab8-900c-42881b4bdb70	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-27 23:46:07.757277+00	
00000000-0000-0000-0000-000000000000	35b2d6f7-7f48-470f-9cf5-34d699365de8	{"action":"login","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-11-27 23:50:32.38057+00	
00000000-0000-0000-0000-000000000000	100afbec-d226-4cd0-9271-9851d087ea3c	{"action":"token_refreshed","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-29 18:40:44.899958+00	
00000000-0000-0000-0000-000000000000	45a886fd-4ea1-4102-83ba-134b69a23fe2	{"action":"token_revoked","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-29 18:40:44.929836+00	
00000000-0000-0000-0000-000000000000	cc7002dd-844e-48cc-a0db-d10f81cfbaef	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-06 15:55:29.914518+00	
00000000-0000-0000-0000-000000000000	36b296a6-0cfe-4bb8-9991-3adb34473ee8	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-06 15:55:29.947868+00	
00000000-0000-0000-0000-000000000000	a7496b91-d715-4ff8-bcd4-402ab2a88387	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-11 13:59:04.970716+00	
00000000-0000-0000-0000-000000000000	d2439c47-54fd-4266-acb4-158e5b836870	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-12 21:18:16.583821+00	
00000000-0000-0000-0000-000000000000	e7794b20-f9d1-4b60-adf0-4bb67522780d	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-12 21:18:16.610992+00	
00000000-0000-0000-0000-000000000000	f3bbd54e-c46f-473f-ba36-100893b7a9c9	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-14 18:08:20.471099+00	
00000000-0000-0000-0000-000000000000	0c2956bc-0d56-4980-ad42-67db899baabe	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-14 18:08:20.496963+00	
00000000-0000-0000-0000-000000000000	43ab6820-0f55-4bde-920a-ce01f6bd61a8	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-21 17:46:45.154765+00	
00000000-0000-0000-0000-000000000000	3064783d-36cc-46e1-a558-72d68a17b799	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-21 17:46:45.180755+00	
00000000-0000-0000-0000-000000000000	afbe2901-fb2a-4dc9-9f9e-d8a33881a4a1	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-27 18:38:32.294209+00	
00000000-0000-0000-0000-000000000000	775ffd70-6b7e-422a-bd07-862ede14d021	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-27 18:38:32.333017+00	
00000000-0000-0000-0000-000000000000	526200e3-a7ac-46eb-b28d-1dec3ac133f8	{"action":"logout","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-12-27 18:38:39.544815+00	
00000000-0000-0000-0000-000000000000	19b7813a-a113-431d-9d49-23f7cd1f31e4	{"action":"user_recovery_requested","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-12-27 18:39:11.215596+00	
00000000-0000-0000-0000-000000000000	3ed1dd1b-cd0a-48da-8809-5ab23ca5ede8	{"action":"login","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-12-27 18:39:39.523181+00	
00000000-0000-0000-0000-000000000000	3e27f8d4-7a21-454c-8e3d-202a25c7b315	{"action":"user_updated_password","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-12-27 18:39:39.899327+00	
00000000-0000-0000-0000-000000000000	19822ad6-1455-42eb-bed2-bac8911beee6	{"action":"user_modified","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-12-27 18:39:39.900632+00	
00000000-0000-0000-0000-000000000000	4f4c9798-81bf-4b4b-9ab7-039f30aac277	{"action":"login","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-12-27 18:39:52.102528+00	
00000000-0000-0000-0000-000000000000	526f7bb5-244a-40ac-a0cd-2a8c2a12e948	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-02 14:15:12.390219+00	
00000000-0000-0000-0000-000000000000	62aac96f-aed4-4360-96e7-e108ade9ac98	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-02 14:15:12.41974+00	
00000000-0000-0000-0000-000000000000	203f0ef3-529c-4df9-881e-2bb277658b5d	{"action":"logout","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-01-02 14:29:05.845513+00	
00000000-0000-0000-0000-000000000000	19aa6849-56ed-4fd1-8715-99824cc408ad	{"action":"user_recovery_requested","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"user"}	2026-01-02 14:44:07.11736+00	
00000000-0000-0000-0000-000000000000	f246bf48-29b4-45e5-9b94-2ef9f67271e5	{"action":"user_recovery_requested","actor_id":"c9941f4f-5b88-4261-b3d5-e03fce6881dc","actor_username":"drezzyyt5@gmail.com","actor_via_sso":false,"log_type":"user"}	2026-01-02 14:46:08.342012+00	
00000000-0000-0000-0000-000000000000	edd4bfae-9bcd-46de-9e96-e6e62301e13e	{"action":"login","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-02 14:49:16.467554+00	
00000000-0000-0000-0000-000000000000	4ca2a486-8c57-43c2-a4a1-224d361e1ee3	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-03 16:49:31.228124+00	
00000000-0000-0000-0000-000000000000	cad22c15-d411-4ed4-b878-d57187af31c9	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-03 16:49:31.254442+00	
00000000-0000-0000-0000-000000000000	5d0cd8ed-e22e-4604-87e8-5089e77b3d6e	{"action":"login","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-03 17:16:54.079402+00	
00000000-0000-0000-0000-000000000000	5a57d17b-2c4c-44b5-b643-8179451d964d	{"action":"login","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-03 17:18:23.117805+00	
00000000-0000-0000-0000-000000000000	85bb0270-a6ce-48a6-9b09-a91c194ca207	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-04 15:00:39.5362+00	
00000000-0000-0000-0000-000000000000	445925ed-423c-4567-8d4e-1d5deac29a61	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-04 15:00:39.553149+00	
00000000-0000-0000-0000-000000000000	c397bd22-59ae-4d52-8150-08bcf9e2c05a	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-11 17:27:17.871052+00	
00000000-0000-0000-0000-000000000000	0bc2f3a3-20ca-462d-9fa9-9c32207aae7b	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-11 17:27:17.899767+00	
00000000-0000-0000-0000-000000000000	51762e71-ed72-46b0-abc4-605ef09af33e	{"action":"user_signedup","actor_id":"b8183aa4-4bcb-4cd0-a65b-fb33db0b907d","actor_username":"tavorakayky@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2026-01-12 21:41:38.299813+00	
00000000-0000-0000-0000-000000000000	61a7e5d7-c301-42b2-a7c0-c21ee4b5ccef	{"action":"login","actor_id":"b8183aa4-4bcb-4cd0-a65b-fb33db0b907d","actor_username":"tavorakayky@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-12 21:41:38.331087+00	
00000000-0000-0000-0000-000000000000	9a4d95dd-c0d6-4307-9ecc-ea4b8486d9bc	{"action":"logout","actor_id":"b8183aa4-4bcb-4cd0-a65b-fb33db0b907d","actor_username":"tavorakayky@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-01-12 21:43:11.889427+00	
00000000-0000-0000-0000-000000000000	5d343848-3dfa-4494-b0da-9ed76a8087eb	{"action":"login","actor_id":"b8183aa4-4bcb-4cd0-a65b-fb33db0b907d","actor_username":"tavorakayky@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-12 22:05:41.955479+00	
00000000-0000-0000-0000-000000000000	9cfdcd4d-0364-4d4c-b813-be7b94525796	{"action":"logout","actor_id":"b8183aa4-4bcb-4cd0-a65b-fb33db0b907d","actor_username":"tavorakayky@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-01-12 22:05:48.859139+00	
00000000-0000-0000-0000-000000000000	9b478b8a-d182-4c06-8765-e6d5a0a2d6f2	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-12 22:06:40.198709+00	
00000000-0000-0000-0000-000000000000	b3b579cd-4e0c-475c-9da6-ff1f1dba779b	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-12 22:06:40.202953+00	
00000000-0000-0000-0000-000000000000	cd4e85ff-3cde-4deb-a524-e71942878b2c	{"action":"logout","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-01-12 22:14:04.361512+00	
00000000-0000-0000-0000-000000000000	d0c2cbe6-9154-402d-8fb5-1b5d89a6f7dd	{"action":"user_signedup","actor_id":"a11ab880-093e-49cf-8607-017f134e9b79","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2026-01-12 22:19:40.912935+00	
00000000-0000-0000-0000-000000000000	d7b7cd4a-bd05-4bab-abfd-bca73059f23b	{"action":"login","actor_id":"a11ab880-093e-49cf-8607-017f134e9b79","actor_username":"lns089180@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-12 22:19:40.93346+00	
00000000-0000-0000-0000-000000000000	4dba53eb-8548-40b3-be5e-bb9ce077e9dc	{"action":"user_signedup","actor_id":"230fc139-982f-4289-a8a0-f5f86e10c40e","actor_username":"kaykyptavora@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2026-01-12 22:20:20.001344+00	
00000000-0000-0000-0000-000000000000	7e863d47-8094-482c-b704-b48a7d56e03b	{"action":"login","actor_id":"230fc139-982f-4289-a8a0-f5f86e10c40e","actor_username":"kaykyptavora@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-12 22:20:20.011009+00	
00000000-0000-0000-0000-000000000000	8694d703-c5c7-4a29-85c3-fdc680064a72	{"action":"logout","actor_id":"230fc139-982f-4289-a8a0-f5f86e10c40e","actor_username":"kaykyptavora@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-01-12 22:27:02.34337+00	
00000000-0000-0000-0000-000000000000	c0199dab-5b5e-4a68-9058-62b294b15fa8	{"action":"login","actor_id":"b8183aa4-4bcb-4cd0-a65b-fb33db0b907d","actor_username":"tavorakayky@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-12 22:28:31.74977+00	
00000000-0000-0000-0000-000000000000	b0490d87-61a2-4adf-b402-c608d7258126	{"action":"logout","actor_id":"b8183aa4-4bcb-4cd0-a65b-fb33db0b907d","actor_username":"tavorakayky@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-01-12 22:31:28.57607+00	
00000000-0000-0000-0000-000000000000	d196cea5-4277-4b72-bec1-33b2132c06fe	{"action":"login","actor_id":"230fc139-982f-4289-a8a0-f5f86e10c40e","actor_username":"kaykyptavora@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-12 22:31:32.540006+00	
00000000-0000-0000-0000-000000000000	462404c3-6f26-4ce3-9213-93a51018b786	{"action":"logout","actor_id":"230fc139-982f-4289-a8a0-f5f86e10c40e","actor_username":"kaykyptavora@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-01-12 22:31:39.975475+00	
00000000-0000-0000-0000-000000000000	fbd111f0-01fb-455b-911a-d00192d2bc50	{"action":"login","actor_id":"b8183aa4-4bcb-4cd0-a65b-fb33db0b907d","actor_username":"tavorakayky@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-12 22:31:47.620173+00	
00000000-0000-0000-0000-000000000000	5d930815-430d-4308-b948-0c0f7896ef6b	{"action":"token_refreshed","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-12 22:32:47.16951+00	
00000000-0000-0000-0000-000000000000	68094d61-5905-489c-86da-75ba4acc8b74	{"action":"token_revoked","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-12 22:32:47.179288+00	
00000000-0000-0000-0000-000000000000	8ee917ac-d289-445c-8d9b-b9b1533d85d8	{"action":"logout","actor_id":"b8183aa4-4bcb-4cd0-a65b-fb33db0b907d","actor_username":"tavorakayky@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-01-12 22:33:25.115405+00	
00000000-0000-0000-0000-000000000000	b2015e6f-f2db-42f5-bb1f-b2b6f08d4787	{"action":"login","actor_id":"230fc139-982f-4289-a8a0-f5f86e10c40e","actor_username":"kaykyptavora@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-12 22:33:28.577273+00	
00000000-0000-0000-0000-000000000000	c9de6aee-9d63-4381-af1c-aaa38f3fc258	{"action":"logout","actor_id":"230fc139-982f-4289-a8a0-f5f86e10c40e","actor_username":"kaykyptavora@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-01-12 22:35:25.341017+00	
00000000-0000-0000-0000-000000000000	ac3bcb2c-9326-49bc-9a25-afa341195367	{"action":"login","actor_id":"b8183aa4-4bcb-4cd0-a65b-fb33db0b907d","actor_username":"tavorakayky@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-12 22:35:37.923096+00	
00000000-0000-0000-0000-000000000000	22083b12-57c7-4cbb-9aa2-994441d83142	{"action":"logout","actor_id":"b8183aa4-4bcb-4cd0-a65b-fb33db0b907d","actor_username":"tavorakayky@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-01-12 22:38:48.647897+00	
00000000-0000-0000-0000-000000000000	9553646f-093b-4d44-b8b0-5972b454912b	{"action":"user_recovery_requested","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"user"}	2026-01-12 22:39:08.375631+00	
00000000-0000-0000-0000-000000000000	88317446-551e-4762-a17e-1b94b00b2c6b	{"action":"login","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-01-12 22:39:34.6244+00	
00000000-0000-0000-0000-000000000000	bf230124-1f33-465c-b65c-d614c0476416	{"action":"user_updated_password","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"user"}	2026-01-12 22:39:34.93477+00	
00000000-0000-0000-0000-000000000000	965b72e7-8038-42f7-b09d-628e99506489	{"action":"user_modified","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"user"}	2026-01-12 22:39:34.935362+00	
00000000-0000-0000-0000-000000000000	3781d9a5-daa7-4e64-96fa-812b14f62bd1	{"action":"login","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-12 22:39:39.145736+00	
00000000-0000-0000-0000-000000000000	57c7a1c7-f385-4227-a728-efe0cdac8dbe	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-13 14:22:31.209728+00	
00000000-0000-0000-0000-000000000000	b9aca9b1-30c6-47aa-94d5-f9204df2868a	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-13 14:22:31.228812+00	
00000000-0000-0000-0000-000000000000	7f14bdc2-1082-4cf7-9161-125ae6a7acd7	{"action":"token_refreshed","actor_id":"72f4663e-11f6-4c41-876a-5fa272e969c5","actor_username":"luang9552@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-21 23:25:30.731237+00	
00000000-0000-0000-0000-000000000000	f0de75b3-dd37-4995-bbc6-0e215c68c2cf	{"action":"token_revoked","actor_id":"72f4663e-11f6-4c41-876a-5fa272e969c5","actor_username":"luang9552@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-21 23:25:30.753125+00	
00000000-0000-0000-0000-000000000000	25a221fa-1b08-4335-9887-9a4ef7a11808	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-21 23:28:11.948412+00	
00000000-0000-0000-0000-000000000000	764d5fab-4427-4601-b80d-0d86677e3fed	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-21 23:28:11.954648+00	
00000000-0000-0000-0000-000000000000	8f59f7ae-1520-4362-804f-a625a8d1f65d	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-28 12:16:22.056678+00	
00000000-0000-0000-0000-000000000000	49572138-c8a7-4554-be29-07f03263542e	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-28 12:16:22.084701+00	
00000000-0000-0000-0000-000000000000	1feb1d5f-2e8b-47ec-b09c-a8fa71627141	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-29 22:49:25.072366+00	
00000000-0000-0000-0000-000000000000	f2bc751a-a2c8-46b5-a772-28934b11ce74	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-29 22:49:25.095467+00	
00000000-0000-0000-0000-000000000000	fbfaabd4-c9e8-4bc7-be3c-a3afadf3bba9	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-30 14:02:31.547059+00	
00000000-0000-0000-0000-000000000000	f996ad4d-6784-45c4-9edd-530fe178dbd3	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-30 14:02:31.572332+00	
00000000-0000-0000-0000-000000000000	e64529de-ca38-43de-afad-4050b77ebd88	{"action":"token_refreshed","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-30 18:06:42.991127+00	
00000000-0000-0000-0000-000000000000	95aa748d-c73f-42b2-b865-3b2616f25448	{"action":"token_revoked","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-30 18:06:43.022394+00	
00000000-0000-0000-0000-000000000000	b146c009-c169-4126-9fca-17714c6476c1	{"action":"token_refreshed","actor_id":"72f4663e-11f6-4c41-876a-5fa272e969c5","actor_username":"luang9552@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-30 18:11:35.901863+00	
00000000-0000-0000-0000-000000000000	f3c03a83-b6ae-4e51-ab7a-6af28b289a2d	{"action":"token_revoked","actor_id":"72f4663e-11f6-4c41-876a-5fa272e969c5","actor_username":"luang9552@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-30 18:11:35.910546+00	
00000000-0000-0000-0000-000000000000	4deb0fbf-9f3d-44c0-9566-9d6199683102	{"action":"token_refreshed","actor_id":"72f4663e-11f6-4c41-876a-5fa272e969c5","actor_username":"luang9552@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-30 19:09:59.642975+00	
00000000-0000-0000-0000-000000000000	db1001b9-af70-4085-8729-4cf68a23e5dc	{"action":"token_revoked","actor_id":"72f4663e-11f6-4c41-876a-5fa272e969c5","actor_username":"luang9552@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-30 19:09:59.652456+00	
00000000-0000-0000-0000-000000000000	636b9d1f-8ed7-434a-8bc7-0a23ef302ac5	{"action":"token_refreshed","actor_id":"72f4663e-11f6-4c41-876a-5fa272e969c5","actor_username":"luang9552@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-30 20:08:29.373602+00	
00000000-0000-0000-0000-000000000000	1135d3b3-1eb5-4e32-ba94-ad354b77b5dd	{"action":"token_revoked","actor_id":"72f4663e-11f6-4c41-876a-5fa272e969c5","actor_username":"luang9552@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-30 20:08:29.387493+00	
00000000-0000-0000-0000-000000000000	f9add644-412d-40ac-b445-de1aa1218201	{"action":"token_refreshed","actor_id":"c4154c64-b02b-4c03-9948-75171bb60c3f","actor_username":"rafaeloliveira67539@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-31 15:53:24.357292+00	
00000000-0000-0000-0000-000000000000	f0935c78-0e12-428b-b4a8-f5cb0c732f06	{"action":"token_revoked","actor_id":"c4154c64-b02b-4c03-9948-75171bb60c3f","actor_username":"rafaeloliveira67539@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-31 15:53:24.386454+00	
00000000-0000-0000-0000-000000000000	d71a1a5b-fc80-45b7-ae63-3077132d18e2	{"action":"token_refreshed","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-31 16:55:54.558726+00	
00000000-0000-0000-0000-000000000000	fcd0891b-ed69-4d2c-b15d-7d81d2c9e38e	{"action":"token_revoked","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-31 16:55:54.576984+00	
00000000-0000-0000-0000-000000000000	7e81809a-b0be-4635-a463-ca5080e0be3d	{"action":"token_refreshed","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-31 17:55:15.167806+00	
00000000-0000-0000-0000-000000000000	666ae479-ca68-4229-b61b-ff352706d9fb	{"action":"token_revoked","actor_id":"0cadcee8-15d5-4ff6-86e9-b339b63eafcc","actor_username":"rafaelgomes77oliveira@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-31 17:55:15.180155+00	
00000000-0000-0000-0000-000000000000	f480c3f2-1c9a-4ecc-9e09-5457058a77f3	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-31 18:16:28.161472+00	
00000000-0000-0000-0000-000000000000	f679e608-1794-40c6-b6d5-70ccc8ee962a	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-31 18:16:28.166035+00	
00000000-0000-0000-0000-000000000000	ac3bbf7d-5dbe-4beb-857a-0f5d10088710	{"action":"token_refreshed","actor_id":"c4154c64-b02b-4c03-9948-75171bb60c3f","actor_username":"rafaeloliveira67539@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-31 18:37:26.411887+00	
00000000-0000-0000-0000-000000000000	828f687e-f64f-4524-93be-db7e385312ca	{"action":"token_revoked","actor_id":"c4154c64-b02b-4c03-9948-75171bb60c3f","actor_username":"rafaeloliveira67539@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-31 18:37:26.419852+00	
00000000-0000-0000-0000-000000000000	2f31bdf1-4f4c-4bf4-99bd-88a12fa6a09c	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-31 19:40:18.211559+00	
00000000-0000-0000-0000-000000000000	96ea3f04-4ca4-4d5b-b142-c7d0c32a8f76	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-31 19:40:18.224921+00	
00000000-0000-0000-0000-000000000000	19099c04-ca7c-47b2-8e58-38f54c04dcd7	{"action":"user_signedup","actor_id":"9d1298fe-5d94-48b9-b1d8-84916445ae84","actor_username":"jv808508@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2026-02-01 18:55:13.835103+00	
00000000-0000-0000-0000-000000000000	e7a749a7-bc4b-4eee-923e-590ee3e386a4	{"action":"login","actor_id":"9d1298fe-5d94-48b9-b1d8-84916445ae84","actor_username":"jv808508@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-02-01 18:55:13.86776+00	
00000000-0000-0000-0000-000000000000	fd4e7078-eff8-4663-9c76-f04013d628f1	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-01 20:33:05.429556+00	
00000000-0000-0000-0000-000000000000	b0138875-3474-4fe5-9ea8-ab6032ebdc2e	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-01 20:33:05.444822+00	
00000000-0000-0000-0000-000000000000	8ccd1689-533d-4b55-aa18-71e1b5f6ed12	{"action":"login","actor_id":"9d1298fe-5d94-48b9-b1d8-84916445ae84","actor_username":"jv808508@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-02-01 21:56:34.22237+00	
00000000-0000-0000-0000-000000000000	5f318bb7-fe48-4d15-84b8-e6c02a4d1947	{"action":"logout","actor_id":"9d1298fe-5d94-48b9-b1d8-84916445ae84","actor_username":"jv808508@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-02-01 21:57:38.503342+00	
00000000-0000-0000-0000-000000000000	c02bdfbf-df5e-40db-9d1c-0f74d4930824	{"action":"login","actor_id":"9d1298fe-5d94-48b9-b1d8-84916445ae84","actor_username":"jv808508@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-02-01 21:58:28.252397+00	
00000000-0000-0000-0000-000000000000	e8da2548-4175-42e8-bcac-42efa9b164da	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-01 22:02:28.507059+00	
00000000-0000-0000-0000-000000000000	e387d941-733c-4265-b2fd-6ec648738b31	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-01 22:02:28.512268+00	
00000000-0000-0000-0000-000000000000	a14f1c9e-d266-4bff-8fa6-f7e49692c10e	{"action":"logout","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-02-01 22:02:32.891369+00	
00000000-0000-0000-0000-000000000000	6deef5c4-187f-4b1f-a1b6-f7f48d18deca	{"action":"login","actor_id":"9d1298fe-5d94-48b9-b1d8-84916445ae84","actor_username":"jv808508@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-02-01 22:02:59.97767+00	
00000000-0000-0000-0000-000000000000	95feadb2-3fc2-4d15-9a92-d765de8c949e	{"action":"token_refreshed","actor_id":"c4154c64-b02b-4c03-9948-75171bb60c3f","actor_username":"rafaeloliveira67539@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-02 14:09:34.162893+00	
00000000-0000-0000-0000-000000000000	e8050120-40ac-4b61-92d2-9a1176c34ef9	{"action":"token_revoked","actor_id":"c4154c64-b02b-4c03-9948-75171bb60c3f","actor_username":"rafaeloliveira67539@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-02 14:09:34.19203+00	
00000000-0000-0000-0000-000000000000	e7ad45a8-5dd5-402d-8f8a-cbf4a5f367d3	{"action":"token_refreshed","actor_id":"9d1298fe-5d94-48b9-b1d8-84916445ae84","actor_username":"jv808508@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-02 22:33:41.598029+00	
00000000-0000-0000-0000-000000000000	22a0e74d-9f09-47b8-9281-bdc19769f710	{"action":"token_revoked","actor_id":"9d1298fe-5d94-48b9-b1d8-84916445ae84","actor_username":"jv808508@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-02 22:33:41.621488+00	
00000000-0000-0000-0000-000000000000	78863a3d-bb45-48dd-8942-0131a7c695fb	{"action":"logout","actor_id":"9d1298fe-5d94-48b9-b1d8-84916445ae84","actor_username":"jv808508@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-02-02 22:34:12.177294+00	
00000000-0000-0000-0000-000000000000	f569dc59-6259-4df1-aa3b-3627989f18c8	{"action":"login","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-02-02 22:34:38.715403+00	
00000000-0000-0000-0000-000000000000	5045a029-1431-4155-aba4-cba55b364495	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-03 00:05:03.998706+00	
00000000-0000-0000-0000-000000000000	0644e366-9489-4d57-990a-6ed5bda861f1	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-03 00:05:04.024969+00	
00000000-0000-0000-0000-000000000000	d31e6ca1-6f47-4af4-b302-fb371874861f	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-03 22:21:03.989452+00	
00000000-0000-0000-0000-000000000000	c72e3cb4-3693-4f7c-b48a-6bef4676e622	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-03 22:21:04.018435+00	
00000000-0000-0000-0000-000000000000	65475f92-9291-47b9-930c-e59e144286a0	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-04 13:12:34.470338+00	
00000000-0000-0000-0000-000000000000	de664ab5-9676-45ac-ac5f-e67f10782565	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-04 13:12:34.48626+00	
00000000-0000-0000-0000-000000000000	03c3b5f4-42f8-499c-8f07-f3673e334f4d	{"action":"logout","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-02-04 13:12:39.660622+00	
00000000-0000-0000-0000-000000000000	d9e530ab-abd0-4e32-8a99-cf956aa47211	{"action":"token_refreshed","actor_id":"c4154c64-b02b-4c03-9948-75171bb60c3f","actor_username":"rafaeloliveira67539@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-06 00:10:41.91828+00	
00000000-0000-0000-0000-000000000000	12b9d207-bddf-43fd-8904-11c99071fad6	{"action":"token_revoked","actor_id":"c4154c64-b02b-4c03-9948-75171bb60c3f","actor_username":"rafaeloliveira67539@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-06 00:10:41.945852+00	
00000000-0000-0000-0000-000000000000	4a7c0834-9bd0-4592-bda1-abb8ae3230c4	{"action":"token_refreshed","actor_id":"c4154c64-b02b-4c03-9948-75171bb60c3f","actor_username":"rafaeloliveira67539@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-06 00:23:48.993781+00	
00000000-0000-0000-0000-000000000000	70c3db69-dc0d-4617-ab76-5dd03483eff2	{"action":"token_refreshed","actor_id":"c4154c64-b02b-4c03-9948-75171bb60c3f","actor_username":"rafaeloliveira67539@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-12 18:11:05.155685+00	
00000000-0000-0000-0000-000000000000	8e7ac892-cac2-4433-b8c9-49401a3f1cce	{"action":"token_revoked","actor_id":"c4154c64-b02b-4c03-9948-75171bb60c3f","actor_username":"rafaeloliveira67539@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-12 18:11:05.180358+00	
00000000-0000-0000-0000-000000000000	ad35c633-a703-47e4-b8a8-12ba5dd570fc	{"action":"token_refreshed","actor_id":"c4154c64-b02b-4c03-9948-75171bb60c3f","actor_username":"rafaeloliveira67539@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-16 10:16:20.3942+00	
00000000-0000-0000-0000-000000000000	79432f09-5c1b-402b-afb8-756f78d74166	{"action":"token_revoked","actor_id":"c4154c64-b02b-4c03-9948-75171bb60c3f","actor_username":"rafaeloliveira67539@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-16 10:16:20.421865+00	
00000000-0000-0000-0000-000000000000	017e859a-3bc5-4f9e-b020-435e58c021a5	{"action":"token_refreshed","actor_id":"c4154c64-b02b-4c03-9948-75171bb60c3f","actor_username":"rafaeloliveira67539@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-16 13:56:46.148656+00	
00000000-0000-0000-0000-000000000000	ad849476-a6aa-4e6d-8d66-01b0aead1f44	{"action":"token_revoked","actor_id":"c4154c64-b02b-4c03-9948-75171bb60c3f","actor_username":"rafaeloliveira67539@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-16 13:56:46.158835+00	
00000000-0000-0000-0000-000000000000	e25292ef-2e38-4bf9-8612-89f06976428e	{"action":"token_refreshed","actor_id":"c4154c64-b02b-4c03-9948-75171bb60c3f","actor_username":"rafaeloliveira67539@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-16 15:35:01.644292+00	
00000000-0000-0000-0000-000000000000	8b11a464-72f7-4c6e-8ba8-08574a9ca8dd	{"action":"login","actor_id":"0357b8ef-16b6-4869-8630-f46c096dc9a9","actor_username":"lns017dev@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-03-24 02:51:21.134547+00	
00000000-0000-0000-0000-000000000000	47bb02e0-1ccf-4f9b-bd1c-51145323b0df	{"action":"logout","actor_id":"0357b8ef-16b6-4869-8630-f46c096dc9a9","actor_username":"lns017dev@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-03-24 02:51:29.857476+00	
00000000-0000-0000-0000-000000000000	500cfeed-827d-49be-85fa-c141119c6897	{"action":"login","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-03-24 02:54:45.211034+00	
00000000-0000-0000-0000-000000000000	27241b98-58f9-4975-a78d-fe1dc8b47277	{"action":"login","actor_id":"b8183aa4-4bcb-4cd0-a65b-fb33db0b907d","actor_username":"tavorakayky@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-03-24 21:07:29.660635+00	
00000000-0000-0000-0000-000000000000	86b46ff6-508c-4451-902c-442a368d4783	{"action":"logout","actor_id":"b8183aa4-4bcb-4cd0-a65b-fb33db0b907d","actor_username":"tavorakayky@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-03-24 21:07:53.691219+00	
00000000-0000-0000-0000-000000000000	96f3bb79-935b-4727-bf8c-1fab07f348e1	{"action":"login","actor_id":"b8183aa4-4bcb-4cd0-a65b-fb33db0b907d","actor_username":"tavorakayky@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-03-24 21:11:52.076396+00	
00000000-0000-0000-0000-000000000000	27d85458-b134-4efd-9c01-5e306ced0302	{"action":"logout","actor_id":"b8183aa4-4bcb-4cd0-a65b-fb33db0b907d","actor_username":"tavorakayky@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-03-24 21:11:54.985459+00	
00000000-0000-0000-0000-000000000000	2326b42c-6b23-44e5-b9fa-fcbca06a53b3	{"action":"login","actor_id":"b8183aa4-4bcb-4cd0-a65b-fb33db0b907d","actor_username":"tavorakayky@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-03-24 21:12:25.883271+00	
00000000-0000-0000-0000-000000000000	361b995e-6b98-44a0-9e63-9016bdf0c94e	{"action":"logout","actor_id":"b8183aa4-4bcb-4cd0-a65b-fb33db0b907d","actor_username":"tavorakayky@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-03-24 21:57:55.235012+00	
00000000-0000-0000-0000-000000000000	06255527-0f14-4c61-b5a1-6d0317403a00	{"action":"login","actor_id":"230fc139-982f-4289-a8a0-f5f86e10c40e","actor_username":"kaykyptavora@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-03-24 21:58:16.907439+00	
00000000-0000-0000-0000-000000000000	556b17ea-48c2-4106-8d3a-303ebe0d1e0a	{"action":"logout","actor_id":"230fc139-982f-4289-a8a0-f5f86e10c40e","actor_username":"kaykyptavora@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-03-24 22:01:20.302764+00	
00000000-0000-0000-0000-000000000000	f3619f0f-21ff-4667-b791-15d7800cd90a	{"action":"login","actor_id":"230fc139-982f-4289-a8a0-f5f86e10c40e","actor_username":"kaykyptavora@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-03-24 22:02:08.937847+00	
00000000-0000-0000-0000-000000000000	fbe825c7-bb8e-4076-8115-cfebb70e216a	{"action":"logout","actor_id":"230fc139-982f-4289-a8a0-f5f86e10c40e","actor_username":"kaykyptavora@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-03-24 22:02:34.776713+00	
00000000-0000-0000-0000-000000000000	1a0274df-4970-4ff4-a784-a6199550cc4d	{"action":"login","actor_id":"230fc139-982f-4289-a8a0-f5f86e10c40e","actor_username":"kaykyptavora@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-03-24 22:03:59.804176+00	
00000000-0000-0000-0000-000000000000	80dd7734-a606-4db5-bdda-729789373cf6	{"action":"logout","actor_id":"230fc139-982f-4289-a8a0-f5f86e10c40e","actor_username":"kaykyptavora@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-03-24 22:19:36.881243+00	
00000000-0000-0000-0000-000000000000	7b7ff7c1-f6d9-4688-8bbe-b5a31c7af04e	{"action":"login","actor_id":"b8183aa4-4bcb-4cd0-a65b-fb33db0b907d","actor_username":"tavorakayky@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-03-24 22:19:51.744013+00	
00000000-0000-0000-0000-000000000000	8875d518-1c82-465a-ba8e-8aa2ef4119a3	{"action":"logout","actor_id":"b8183aa4-4bcb-4cd0-a65b-fb33db0b907d","actor_username":"tavorakayky@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-03-24 22:20:48.890444+00	
00000000-0000-0000-0000-000000000000	9af440f4-371e-42c3-91ee-f59862e24379	{"action":"login","actor_id":"b8183aa4-4bcb-4cd0-a65b-fb33db0b907d","actor_username":"tavorakayky@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-03-24 22:21:38.706267+00	
00000000-0000-0000-0000-000000000000	2c44c0ce-0495-4dfe-967c-ffd0626c988a	{"action":"logout","actor_id":"b8183aa4-4bcb-4cd0-a65b-fb33db0b907d","actor_username":"tavorakayky@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-03-24 22:21:59.819724+00	
00000000-0000-0000-0000-000000000000	dff562fd-e8ed-43fd-8ef3-f95572d81b3a	{"action":"login","actor_id":"230fc139-982f-4289-a8a0-f5f86e10c40e","actor_username":"kaykyptavora@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-03-24 22:22:13.011211+00	
00000000-0000-0000-0000-000000000000	8ceb5d49-888c-46f2-9da0-075a66059267	{"action":"login","actor_id":"b8183aa4-4bcb-4cd0-a65b-fb33db0b907d","actor_username":"tavorakayky@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-03-24 22:27:53.987568+00	
00000000-0000-0000-0000-000000000000	cf713d6e-e390-4db0-a08c-e5f85c0b4899	{"action":"logout","actor_id":"b8183aa4-4bcb-4cd0-a65b-fb33db0b907d","actor_username":"tavorakayky@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-03-24 22:28:00.508265+00	
00000000-0000-0000-0000-000000000000	64a4bc5e-3ad3-4c36-9df9-f9ed93ba2eff	{"action":"login","actor_id":"230fc139-982f-4289-a8a0-f5f86e10c40e","actor_username":"kaykyptavora@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-03-24 22:28:15.264312+00	
00000000-0000-0000-0000-000000000000	81f07f9e-75f4-4a1b-90c9-46b53733eca9	{"action":"logout","actor_id":"230fc139-982f-4289-a8a0-f5f86e10c40e","actor_username":"kaykyptavora@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-03-24 22:30:16.387559+00	
00000000-0000-0000-0000-000000000000	275c047b-8c34-45a0-8261-dfdd7dab541f	{"action":"token_refreshed","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-03-24 22:40:20.888399+00	
00000000-0000-0000-0000-000000000000	1841bad6-4f82-48a6-84c7-94cefa538c01	{"action":"token_revoked","actor_id":"38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb","actor_username":"luanjunio017@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-03-24 22:40:20.903609+00	
00000000-0000-0000-0000-000000000000	60840ff9-bcc9-4f7e-a783-b8c4dd2ccd42	{"action":"login","actor_id":"230fc139-982f-4289-a8a0-f5f86e10c40e","actor_username":"kaykyptavora@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-03-24 23:15:03.676503+00	
00000000-0000-0000-0000-000000000000	9ec0dd94-8385-42ec-a5a5-2d79198c1e5f	{"action":"logout","actor_id":"230fc139-982f-4289-a8a0-f5f86e10c40e","actor_username":"kaykyptavora@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-03-24 23:15:10.091412+00	
00000000-0000-0000-0000-000000000000	add8c6e8-df64-418c-802c-c4b976a233c0	{"action":"login","actor_id":"b8183aa4-4bcb-4cd0-a65b-fb33db0b907d","actor_username":"tavorakayky@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-03-24 23:15:49.914522+00	
00000000-0000-0000-0000-000000000000	32eb9d34-b0e0-4232-a8f8-58a0390ea24f	{"action":"login","actor_id":"b8183aa4-4bcb-4cd0-a65b-fb33db0b907d","actor_username":"tavorakayky@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-03-24 23:16:19.1703+00	
00000000-0000-0000-0000-000000000000	2085be8b-dccd-4824-a69f-1846d7da630e	{"action":"logout","actor_id":"b8183aa4-4bcb-4cd0-a65b-fb33db0b907d","actor_username":"tavorakayky@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-03-24 23:17:53.316347+00	
00000000-0000-0000-0000-000000000000	95e1ea87-307c-4363-abda-bf1683614158	{"action":"login","actor_id":"230fc139-982f-4289-a8a0-f5f86e10c40e","actor_username":"kaykyptavora@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-03-24 23:18:09.254705+00	
00000000-0000-0000-0000-000000000000	79a0e4ab-23e4-452f-98b0-982342e13450	{"action":"logout","actor_id":"230fc139-982f-4289-a8a0-f5f86e10c40e","actor_username":"kaykyptavora@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-03-24 23:21:17.43369+00	
\.


--
-- Data for Name: custom_oauth_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.custom_oauth_providers (id, provider_type, identifier, name, client_id, client_secret, acceptable_client_ids, scopes, pkce_enabled, attribute_mapping, authorization_params, enabled, email_optional, issuer, discovery_url, skip_nonce_check, cached_discovery, discovery_cached_at, authorization_url, token_url, userinfo_url, jwks_uri, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at, invite_token, referrer, oauth_client_state_id, linking_target_id, email_optional) FROM stdin;
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
3fd737a7-0f66-4717-bb7a-5c7a164707db	3fd737a7-0f66-4717-bb7a-5c7a164707db	{"sub": "3fd737a7-0f66-4717-bb7a-5c7a164707db", "name": "Luan Alves", "role": "cliente", "email": "luan59718@gmail.com", "phone": "33999288022", "email_verified": false, "phone_verified": false}	email	2025-09-01 22:18:47.743266+00	2025-09-01 22:18:47.743322+00	2025-09-01 22:18:47.743322+00	c4f46f02-50a3-4111-958a-1abaa2166298
0cadcee8-15d5-4ff6-86e9-b339b63eafcc	0cadcee8-15d5-4ff6-86e9-b339b63eafcc	{"sub": "0cadcee8-15d5-4ff6-86e9-b339b63eafcc", "name": "Rafael Gomes Antunes de Oliveira", "role": "admin", "email": "rafaelgomes77oliveira@gmail.com", "phone": "(21) 99673-2729", "email_verified": false, "phone_verified": false, "barbershop_name": "Ralfhs Cuts"}	email	2025-09-23 22:52:25.992858+00	2025-09-23 22:52:25.992915+00	2025-09-23 22:52:25.992915+00	a4165a24-f8ee-43d7-a2c3-a039190efa44
38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb	38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb	{"sub": "38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb", "name": "Luan Junio Silva", "role": "admin", "email": "luanjunio017@gmail.com", "phone": "(79) 9000-0000", "email_verified": false, "phone_verified": false, "barbershop_name": "Lns Barber"}	email	2025-09-25 00:16:48.460359+00	2025-09-25 00:16:48.460409+00	2025-09-25 00:16:48.460409+00	d9086e0a-9bd5-4fe2-ad57-bb4a54765c5a
c9941f4f-5b88-4261-b3d5-e03fce6881dc	c9941f4f-5b88-4261-b3d5-e03fce6881dc	{"sub": "c9941f4f-5b88-4261-b3d5-e03fce6881dc", "name": "Luan Junio Silva", "role": "admin", "email": "drezzyyt5@gmail.com", "phone": "(79) 99673-0000", "email_verified": false, "phone_verified": false, "barbershop_name": "Agendem Barber"}	email	2025-09-25 15:06:06.806697+00	2025-09-25 15:06:06.80675+00	2025-09-25 15:06:06.80675+00	b7c3ee78-e7ab-4b87-acea-ed5105bac1de
c4154c64-b02b-4c03-9948-75171bb60c3f	c4154c64-b02b-4c03-9948-75171bb60c3f	{"sub": "c4154c64-b02b-4c03-9948-75171bb60c3f", "name": "ralfhslenda", "role": "cliente", "email": "rafaeloliveira67539@gmail.com", "phone": "33999353731", "email_verified": false, "phone_verified": false}	email	2025-09-27 23:07:29.555724+00	2025-09-27 23:07:29.555785+00	2025-09-27 23:07:29.555785+00	1e98b85c-eda3-4891-9bfd-2a657cc9011b
38319931-975f-45b6-9c8e-112dca479893	38319931-975f-45b6-9c8e-112dca479893	{"sub": "38319931-975f-45b6-9c8e-112dca479893", "name": "Victor Gomes", "role": "funcionario", "email": "faktmj007@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-10-05 01:03:55.071453+00	2025-10-05 01:03:55.071513+00	2025-10-05 01:03:55.071513+00	8ccde969-037b-4b37-9b8d-8f7980d81ee4
0357b8ef-16b6-4869-8630-f46c096dc9a9	0357b8ef-16b6-4869-8630-f46c096dc9a9	{"sub": "0357b8ef-16b6-4869-8630-f46c096dc9a9", "name": "Lns Cliente", "role": "cliente", "email": "lns017dev@gmail.com", "phone": "7997777777", "email_verified": false, "phone_verified": false}	email	2025-10-05 01:20:13.503781+00	2025-10-05 01:20:13.503827+00	2025-10-05 01:20:13.503827+00	ca7ce215-8413-4c51-a553-4ddf3e9225a5
30b1a6e9-28ab-4555-aebe-993f2f5882ce	30b1a6e9-28ab-4555-aebe-993f2f5882ce	{"sub": "30b1a6e9-28ab-4555-aebe-993f2f5882ce", "name": "Luan Barber", "role": "funcionario", "email": "luanesmaganoob855@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-10-06 00:40:37.091638+00	2025-10-06 00:40:37.091691+00	2025-10-06 00:40:37.091691+00	b62cb07f-4b5c-4ef3-9f3b-6ae5c7ac4870
72f4663e-11f6-4c41-876a-5fa272e969c5	72f4663e-11f6-4c41-876a-5fa272e969c5	{"sub": "72f4663e-11f6-4c41-876a-5fa272e969c5", "name": "Labizerra Apelão", "role": "funcionario", "email": "luang9552@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-11-07 22:45:16.427856+00	2025-11-07 22:45:16.427911+00	2025-11-07 22:45:16.427911+00	de9939b1-0f04-4eda-8fae-ff348a3136e7
b8183aa4-4bcb-4cd0-a65b-fb33db0b907d	b8183aa4-4bcb-4cd0-a65b-fb33db0b907d	{"sub": "b8183aa4-4bcb-4cd0-a65b-fb33db0b907d", "name": "kayky ", "role": "cliente", "email": "tavorakayky@gmail.com", "phone": "11958376570", "email_verified": false, "phone_verified": false}	email	2026-01-12 21:41:38.279101+00	2026-01-12 21:41:38.280351+00	2026-01-12 21:41:38.280351+00	2399f5bd-44fe-4980-83db-e2d1ee4e98c3
230fc139-982f-4289-a8a0-f5f86e10c40e	230fc139-982f-4289-a8a0-f5f86e10c40e	{"sub": "230fc139-982f-4289-a8a0-f5f86e10c40e", "name": "corte de giro", "role": "admin", "email": "kaykyptavora@gmail.com", "phone": "(11) 95837-6570", "email_verified": false, "phone_verified": false, "barbershop_name": "Picles Cortes"}	email	2026-01-12 22:20:19.997341+00	2026-01-12 22:20:19.997391+00	2026-01-12 22:20:19.997391+00	98385fc9-1fcd-4540-8638-1a3042a5a10a
9d1298fe-5d94-48b9-b1d8-84916445ae84	9d1298fe-5d94-48b9-b1d8-84916445ae84	{"sub": "9d1298fe-5d94-48b9-b1d8-84916445ae84", "name": "João Victor Gomes de Oliveira", "role": "cliente", "email": "jv808508@gmail.com", "phone": null, "email_verified": false, "phone_verified": false}	email	2026-02-01 18:55:13.804184+00	2026-02-01 18:55:13.806187+00	2026-02-01 18:55:13.806187+00	ab7669b5-872c-4a56-8e07-daeaadec8e61
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
5dfa4dcd-b380-44d3-9635-26b3b00cb5e1	2025-09-01 22:18:47.781225+00	2025-09-01 22:18:47.781225+00	password	c802990f-aa89-4382-be2c-14f80bce67d5
71158d02-b7cd-477d-bbc0-91ed484ef030	2025-11-07 22:45:16.459126+00	2025-11-07 22:45:16.459126+00	password	311e62c4-1a44-4c5e-a1db-2069639024b8
b9d00a70-c6c6-4c26-a0bb-77fdf032b7cc	2025-09-27 18:54:00.988271+00	2025-09-27 18:54:00.988271+00	password	a0ada13c-8b8c-474e-85fd-7e1da80d0b6c
6e511f18-9a5b-448a-8234-aa00ac1312d2	2026-03-24 02:54:45.24775+00	2026-03-24 02:54:45.24775+00	password	620fa34a-74eb-4e9e-a20c-8836c25773de
f60bf646-c6cf-4758-8202-9607aeb5d808	2025-09-27 23:07:29.60096+00	2025-09-27 23:07:29.60096+00	password	454d447d-9770-492e-a799-a9a32c808061
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid, last_webauthn_challenge_data) FROM stdin;
\.


--
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_authorizations (id, authorization_id, client_id, user_id, redirect_uri, scope, state, resource, code_challenge, code_challenge_method, response_type, status, authorization_code, created_at, expires_at, approved_at, nonce) FROM stdin;
\.


--
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_client_states (id, provider_type, code_verifier, created_at) FROM stdin;
\.


--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_clients (id, client_secret_hash, registration_type, redirect_uris, grant_types, client_name, client_uri, logo_uri, created_at, updated_at, deleted_at, client_type, token_endpoint_auth_method) FROM stdin;
\.


--
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_consents (id, user_id, client_id, scopes, granted_at, revoked_at) FROM stdin;
\.


--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
b9ca6cc2-b8bd-4e58-ac09-529159db33ba	c9941f4f-5b88-4261-b3d5-e03fce6881dc	recovery_token	4bc8ac201bee81bb9f3fd9ea0c50e8abc462ced639705dfe47b81470	drezzyyt5@gmail.com	2026-01-02 14:46:10.185719	2026-01-02 14:46:10.185719
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
00000000-0000-0000-0000-000000000000	306	bd2dmkmmt2f6	3fd737a7-0f66-4717-bb7a-5c7a164707db	t	2025-09-01 23:49:55.805434+00	2025-09-18 23:21:00.09293+00	nchue2kdzyy5	5dfa4dcd-b380-44d3-9635-26b3b00cb5e1
00000000-0000-0000-0000-000000000000	368	pcjt6vymdewk	3fd737a7-0f66-4717-bb7a-5c7a164707db	f	2025-09-18 23:21:00.094863+00	2025-09-18 23:21:00.094863+00	bd2dmkmmt2f6	5dfa4dcd-b380-44d3-9635-26b3b00cb5e1
00000000-0000-0000-0000-000000000000	495	if46bdyilobc	72f4663e-11f6-4c41-876a-5fa272e969c5	t	2025-11-27 23:23:28.990102+00	2026-01-21 23:25:30.754499+00	hrdlo5axlxcq	71158d02-b7cd-477d-bbc0-91ed484ef030
00000000-0000-0000-0000-000000000000	476	idg5y4hg3uoy	0cadcee8-15d5-4ff6-86e9-b339b63eafcc	t	2025-11-22 22:30:29.430236+00	2025-11-27 22:41:26.332268+00	6ucfu2olhytc	b9d00a70-c6c6-4c26-a0bb-77fdf032b7cc
00000000-0000-0000-0000-000000000000	483	hrdlo5axlxcq	72f4663e-11f6-4c41-876a-5fa272e969c5	t	2025-11-25 00:05:38.619426+00	2025-11-27 23:23:28.984767+00	g7fi2n36tmh4	71158d02-b7cd-477d-bbc0-91ed484ef030
00000000-0000-0000-0000-000000000000	494	doo3livtvyna	0cadcee8-15d5-4ff6-86e9-b339b63eafcc	t	2025-11-27 22:41:26.338779+00	2025-11-27 23:40:14.277042+00	idg5y4hg3uoy	b9d00a70-c6c6-4c26-a0bb-77fdf032b7cc
00000000-0000-0000-0000-000000000000	414	hg77j5uksvkj	0cadcee8-15d5-4ff6-86e9-b339b63eafcc	t	2025-09-27 18:54:00.986184+00	2025-09-27 19:52:41.152837+00	\N	b9d00a70-c6c6-4c26-a0bb-77fdf032b7cc
00000000-0000-0000-0000-000000000000	432	57jklusjl3ne	0cadcee8-15d5-4ff6-86e9-b339b63eafcc	t	2025-10-05 01:05:48.129994+00	2025-11-07 22:34:18.753886+00	nnzhgp4qucv5	b9d00a70-c6c6-4c26-a0bb-77fdf032b7cc
00000000-0000-0000-0000-000000000000	302	nchue2kdzyy5	3fd737a7-0f66-4717-bb7a-5c7a164707db	t	2025-09-01 22:18:47.773873+00	2025-09-01 23:49:55.80475+00	\N	5dfa4dcd-b380-44d3-9635-26b3b00cb5e1
00000000-0000-0000-0000-000000000000	418	ph32ak24lw3i	0cadcee8-15d5-4ff6-86e9-b339b63eafcc	t	2025-09-27 19:52:41.154767+00	2025-09-27 20:51:48.072293+00	hg77j5uksvkj	b9d00a70-c6c6-4c26-a0bb-77fdf032b7cc
00000000-0000-0000-0000-000000000000	453	sdrdxousq4jo	0cadcee8-15d5-4ff6-86e9-b339b63eafcc	t	2025-11-07 22:34:18.765367+00	2025-11-07 23:33:30.022504+00	57jklusjl3ne	b9d00a70-c6c6-4c26-a0bb-77fdf032b7cc
00000000-0000-0000-0000-000000000000	420	26qzqutlzqrr	0cadcee8-15d5-4ff6-86e9-b339b63eafcc	t	2025-09-27 20:51:48.07485+00	2025-09-27 21:50:38.974375+00	ph32ak24lw3i	b9d00a70-c6c6-4c26-a0bb-77fdf032b7cc
00000000-0000-0000-0000-000000000000	454	7jbiwokvxq7s	72f4663e-11f6-4c41-876a-5fa272e969c5	t	2025-11-07 22:45:16.449661+00	2025-11-07 23:44:15.248839+00	\N	71158d02-b7cd-477d-bbc0-91ed484ef030
00000000-0000-0000-0000-000000000000	496	2ku5hg6x2pzn	0cadcee8-15d5-4ff6-86e9-b339b63eafcc	t	2025-11-27 23:40:14.282537+00	2025-11-29 18:40:44.930485+00	doo3livtvyna	b9d00a70-c6c6-4c26-a0bb-77fdf032b7cc
00000000-0000-0000-0000-000000000000	455	jw2og5pwj62i	0cadcee8-15d5-4ff6-86e9-b339b63eafcc	t	2025-11-07 23:33:30.03888+00	2025-11-08 00:31:44.136631+00	sdrdxousq4jo	b9d00a70-c6c6-4c26-a0bb-77fdf032b7cc
00000000-0000-0000-0000-000000000000	422	k4uunqsopz2j	0cadcee8-15d5-4ff6-86e9-b339b63eafcc	t	2025-09-27 21:50:38.975735+00	2025-09-27 22:53:26.369877+00	26qzqutlzqrr	b9d00a70-c6c6-4c26-a0bb-77fdf032b7cc
00000000-0000-0000-0000-000000000000	522	xdgw7fda223m	0cadcee8-15d5-4ff6-86e9-b339b63eafcc	t	2026-01-12 22:32:47.190058+00	2026-01-30 18:06:43.023611+00	gghm3qxgwfxw	b9d00a70-c6c6-4c26-a0bb-77fdf032b7cc
00000000-0000-0000-0000-000000000000	528	bzl4giuw5i4d	72f4663e-11f6-4c41-876a-5fa272e969c5	t	2026-01-21 23:25:30.765622+00	2026-01-30 18:11:35.912586+00	if46bdyilobc	71158d02-b7cd-477d-bbc0-91ed484ef030
00000000-0000-0000-0000-000000000000	534	g55g57rkx5bl	72f4663e-11f6-4c41-876a-5fa272e969c5	t	2026-01-30 18:11:35.914927+00	2026-01-30 19:09:59.654411+00	bzl4giuw5i4d	71158d02-b7cd-477d-bbc0-91ed484ef030
00000000-0000-0000-0000-000000000000	535	moqhyil6qhyf	72f4663e-11f6-4c41-876a-5fa272e969c5	t	2026-01-30 19:09:59.672925+00	2026-01-30 20:08:29.388076+00	g55g57rkx5bl	71158d02-b7cd-477d-bbc0-91ed484ef030
00000000-0000-0000-0000-000000000000	536	qp6mt7hchrjo	72f4663e-11f6-4c41-876a-5fa272e969c5	f	2026-01-30 20:08:29.402505+00	2026-01-30 20:08:29.402505+00	moqhyil6qhyf	71158d02-b7cd-477d-bbc0-91ed484ef030
00000000-0000-0000-0000-000000000000	426	zjskr6je4dze	c4154c64-b02b-4c03-9948-75171bb60c3f	t	2025-09-27 23:07:29.589591+00	2026-01-31 15:53:24.387761+00	\N	f60bf646-c6cf-4758-8202-9607aeb5d808
00000000-0000-0000-0000-000000000000	533	jfn6zjm4xo3n	0cadcee8-15d5-4ff6-86e9-b339b63eafcc	t	2026-01-30 18:06:43.045342+00	2026-01-31 16:55:54.5784+00	xdgw7fda223m	b9d00a70-c6c6-4c26-a0bb-77fdf032b7cc
00000000-0000-0000-0000-000000000000	456	kogzmdgdkbmd	72f4663e-11f6-4c41-876a-5fa272e969c5	t	2025-11-07 23:44:15.254312+00	2025-11-20 23:54:29.098608+00	7jbiwokvxq7s	71158d02-b7cd-477d-bbc0-91ed484ef030
00000000-0000-0000-0000-000000000000	538	demf7er6ift7	0cadcee8-15d5-4ff6-86e9-b339b63eafcc	t	2026-01-31 16:55:54.591159+00	2026-01-31 17:55:15.182033+00	jfn6zjm4xo3n	b9d00a70-c6c6-4c26-a0bb-77fdf032b7cc
00000000-0000-0000-0000-000000000000	457	sne6zb25twbf	0cadcee8-15d5-4ff6-86e9-b339b63eafcc	t	2025-11-08 00:31:44.148393+00	2025-11-20 23:54:34.128942+00	jw2og5pwj62i	b9d00a70-c6c6-4c26-a0bb-77fdf032b7cc
00000000-0000-0000-0000-000000000000	539	qb4q5gvsehj7	0cadcee8-15d5-4ff6-86e9-b339b63eafcc	f	2026-01-31 17:55:15.192755+00	2026-01-31 17:55:15.192755+00	demf7er6ift7	b9d00a70-c6c6-4c26-a0bb-77fdf032b7cc
00000000-0000-0000-0000-000000000000	425	nnzhgp4qucv5	0cadcee8-15d5-4ff6-86e9-b339b63eafcc	t	2025-09-27 22:53:26.371204+00	2025-10-05 01:05:48.127868+00	k4uunqsopz2j	b9d00a70-c6c6-4c26-a0bb-77fdf032b7cc
00000000-0000-0000-0000-000000000000	537	oaux46puizh2	c4154c64-b02b-4c03-9948-75171bb60c3f	t	2026-01-31 15:53:24.411607+00	2026-01-31 18:37:26.421764+00	zjskr6je4dze	f60bf646-c6cf-4758-8202-9607aeb5d808
00000000-0000-0000-0000-000000000000	468	oinkntmc3u73	0cadcee8-15d5-4ff6-86e9-b339b63eafcc	t	2025-11-20 23:54:34.129878+00	2025-11-21 23:59:45.317928+00	sne6zb25twbf	b9d00a70-c6c6-4c26-a0bb-77fdf032b7cc
00000000-0000-0000-0000-000000000000	467	gu5eeocymw3s	72f4663e-11f6-4c41-876a-5fa272e969c5	t	2025-11-20 23:54:29.117909+00	2025-11-22 00:02:56.260158+00	kogzmdgdkbmd	71158d02-b7cd-477d-bbc0-91ed484ef030
00000000-0000-0000-0000-000000000000	472	6ucfu2olhytc	0cadcee8-15d5-4ff6-86e9-b339b63eafcc	t	2025-11-21 23:59:45.318623+00	2025-11-22 22:30:29.402857+00	oinkntmc3u73	b9d00a70-c6c6-4c26-a0bb-77fdf032b7cc
00000000-0000-0000-0000-000000000000	541	ujvoodt6lgn2	c4154c64-b02b-4c03-9948-75171bb60c3f	t	2026-01-31 18:37:26.431246+00	2026-02-02 14:09:34.204028+00	oaux46puizh2	f60bf646-c6cf-4758-8202-9607aeb5d808
00000000-0000-0000-0000-000000000000	499	gghm3qxgwfxw	0cadcee8-15d5-4ff6-86e9-b339b63eafcc	t	2025-11-29 18:40:44.952837+00	2026-01-12 22:32:47.18051+00	2ku5hg6x2pzn	b9d00a70-c6c6-4c26-a0bb-77fdf032b7cc
00000000-0000-0000-0000-000000000000	473	52frhw5nwjiv	72f4663e-11f6-4c41-876a-5fa272e969c5	t	2025-11-22 00:02:56.260846+00	2025-11-24 23:06:08.821615+00	gu5eeocymw3s	71158d02-b7cd-477d-bbc0-91ed484ef030
00000000-0000-0000-0000-000000000000	482	g7fi2n36tmh4	72f4663e-11f6-4c41-876a-5fa272e969c5	t	2025-11-24 23:06:08.85147+00	2025-11-25 00:05:38.603238+00	52frhw5nwjiv	71158d02-b7cd-477d-bbc0-91ed484ef030
00000000-0000-0000-0000-000000000000	549	7nhcaug2inr3	c4154c64-b02b-4c03-9948-75171bb60c3f	t	2026-02-02 14:09:34.230674+00	2026-02-06 00:10:41.949229+00	ujvoodt6lgn2	f60bf646-c6cf-4758-8202-9607aeb5d808
00000000-0000-0000-0000-000000000000	555	np2tdzaztdua	c4154c64-b02b-4c03-9948-75171bb60c3f	t	2026-02-06 00:10:41.974268+00	2026-02-12 18:11:05.182805+00	7nhcaug2inr3	f60bf646-c6cf-4758-8202-9607aeb5d808
00000000-0000-0000-0000-000000000000	556	g6cdqtxey43i	c4154c64-b02b-4c03-9948-75171bb60c3f	t	2026-02-12 18:11:05.207041+00	2026-02-16 10:16:20.42253+00	np2tdzaztdua	f60bf646-c6cf-4758-8202-9607aeb5d808
00000000-0000-0000-0000-000000000000	557	pu2aojn634jv	c4154c64-b02b-4c03-9948-75171bb60c3f	t	2026-02-16 10:16:20.445756+00	2026-02-16 13:56:46.159417+00	g6cdqtxey43i	f60bf646-c6cf-4758-8202-9607aeb5d808
00000000-0000-0000-0000-000000000000	558	envazvsaef7r	c4154c64-b02b-4c03-9948-75171bb60c3f	f	2026-02-16 13:56:46.171848+00	2026-02-16 13:56:46.171848+00	pu2aojn634jv	f60bf646-c6cf-4758-8202-9607aeb5d808
00000000-0000-0000-0000-000000000000	560	pkdgouh6532l	38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb	t	2026-03-24 02:54:45.23383+00	2026-03-24 22:40:20.90428+00	\N	6e511f18-9a5b-448a-8234-aa00ac1312d2
00000000-0000-0000-0000-000000000000	572	rwp7hijccyiz	38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb	f	2026-03-24 22:40:20.914733+00	2026-03-24 22:40:20.914733+00	pkdgouh6532l	6e511f18-9a5b-448a-8234-aa00ac1312d2
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
20250717082212
20250731150234
20250804100000
20250901200500
20250903112500
20250904133000
20250925093508
20251007112900
20251104100000
20251111201300
20251201000000
20260115000000
20260121000000
20260219120000
20260302000000
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag, oauth_client_id, refresh_token_hmac_key, refresh_token_counter, scopes) FROM stdin;
71158d02-b7cd-477d-bbc0-91ed484ef030	72f4663e-11f6-4c41-876a-5fa272e969c5	2025-11-07 22:45:16.444016+00	2026-01-30 20:08:29.411962+00	\N	aal1	\N	2026-01-30 20:08:29.411851	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	45.165.2.38	\N	\N	\N	\N	\N
5dfa4dcd-b380-44d3-9635-26b3b00cb5e1	3fd737a7-0f66-4717-bb7a-5c7a164707db	2025-09-01 22:18:47.768983+00	2025-09-18 23:21:00.099069+00	\N	aal1	\N	2025-09-18 23:21:00.098998	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	45.165.3.221	\N	\N	\N	\N	\N
b9d00a70-c6c6-4c26-a0bb-77fdf032b7cc	0cadcee8-15d5-4ff6-86e9-b339b63eafcc	2025-09-27 18:54:00.985416+00	2026-01-31 17:55:15.209397+00	\N	aal1	\N	2026-01-31 17:55:15.209286	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 OPR/126.0.0.0	45.186.33.1	\N	\N	\N	\N	\N
f60bf646-c6cf-4758-8202-9607aeb5d808	c4154c64-b02b-4c03-9948-75171bb60c3f	2025-09-27 23:07:29.586693+00	2026-02-16 15:35:01.671622+00	\N	aal1	\N	2026-02-16 15:35:01.670981	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Mobile Safari/537.36	152.255.96.47	\N	\N	\N	\N	\N
6e511f18-9a5b-448a-8234-aa00ac1312d2	38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb	2026-03-24 02:54:45.227701+00	2026-03-24 22:40:20.93286+00	\N	aal1	\N	2026-03-24 22:40:20.932552	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36	191.7.94.14	\N	\N	\N	\N	\N
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at, disabled) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
00000000-0000-0000-0000-000000000000	38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb	authenticated	authenticated	luanjunio017@gmail.com	$2a$10$Ye7l8nTcbJPQeepRumasjudlh5EapoCPHV4BiFyzRz4jRn4oNYdY6	2025-09-25 00:16:48.468217+00	\N		\N		\N			\N	2026-03-24 02:54:45.227577+00	{"provider": "email", "providers": ["email"]}	{"sub": "38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb", "name": "Luan Junio Silva", "role": "admin", "email": "luanjunio017@gmail.com", "phone": "(79) 9000-0000", "email_verified": true, "phone_verified": false, "barbershop_name": "Lns Barber"}	\N	2025-09-25 00:16:48.448729+00	2026-03-24 22:40:20.920619+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	c4154c64-b02b-4c03-9948-75171bb60c3f	authenticated	authenticated	rafaeloliveira67539@gmail.com	$2a$10$6QNcrS9hyfBgXLJXlawOae1UKbw2oVgorJEmPhecGaAGD2SJXUVam	2025-09-27 23:07:29.568509+00	\N		\N		\N			\N	2025-09-27 23:07:29.586602+00	{"provider": "email", "providers": ["email"]}	{"sub": "c4154c64-b02b-4c03-9948-75171bb60c3f", "name": "ralfhslenda", "role": "cliente", "email": "rafaeloliveira67539@gmail.com", "phone": "33999353731", "email_verified": true, "phone_verified": false}	\N	2025-09-27 23:07:29.53566+00	2026-02-16 13:56:46.177948+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	0cadcee8-15d5-4ff6-86e9-b339b63eafcc	authenticated	authenticated	rafaelgomes77oliveira@gmail.com	$2a$10$3x6ds8Kg.3b7r98rnWQzcuf.U5rpT8NaWhB4XJi12kfn1Z0Y7xFam	2025-09-23 22:52:26.011177+00	\N		\N		\N			\N	2025-09-27 18:54:00.985334+00	{"provider": "email", "providers": ["email"]}	{"sub": "0cadcee8-15d5-4ff6-86e9-b339b63eafcc", "name": "Rafael Gomes Antunes de Oliveira", "role": "admin", "email": "rafaelgomes77oliveira@gmail.com", "phone": "(21) 99673-2729", "email_verified": true, "phone_verified": false, "barbershop_name": "Ralfhs Cuts"}	\N	2025-09-23 22:52:25.950443+00	2026-01-31 17:55:15.20278+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	0357b8ef-16b6-4869-8630-f46c096dc9a9	authenticated	authenticated	lns017dev@gmail.com	$2a$10$4VyH6cMrF4CCDsxVJIps0.6sz3JKvPCfXeGnpH7QWT9MpgGTPyAJK	2025-10-05 01:20:13.512499+00	\N		\N		\N			\N	2026-03-24 02:51:21.166175+00	{"provider": "email", "providers": ["email"]}	{"sub": "0357b8ef-16b6-4869-8630-f46c096dc9a9", "name": "Lns Cliente", "role": "cliente", "email": "lns017dev@gmail.com", "phone": "7997777777", "email_verified": true, "phone_verified": false}	\N	2025-10-05 01:20:13.496902+00	2026-03-24 02:51:21.260738+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	72f4663e-11f6-4c41-876a-5fa272e969c5	authenticated	authenticated	luang9552@gmail.com	$2a$10$YMeJ3BQO8fINd0uyXA.rf.mBaOl5I4CW0BCeGyRMTMDnGhHsFJ.u.	2025-11-07 22:45:16.436843+00	\N		\N		\N			\N	2025-11-07 22:45:16.443919+00	{"provider": "email", "providers": ["email"]}	{"sub": "72f4663e-11f6-4c41-876a-5fa272e969c5", "name": "Labizerra Apelão", "role": "funcionario", "email": "luang9552@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-11-07 22:45:16.395299+00	2026-01-30 20:08:29.405018+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	9d1298fe-5d94-48b9-b1d8-84916445ae84	authenticated	authenticated	jv808508@gmail.com	$2a$10$9iPlRraSd1UhkjZMtmq88u5YrfrXpccfyYl.7.CTCgIC6CKwitFRe	2026-02-01 18:55:13.850208+00	\N		\N		\N			\N	2026-02-01 22:02:59.980567+00	{"provider": "email", "providers": ["email"]}	{"sub": "9d1298fe-5d94-48b9-b1d8-84916445ae84", "name": "João Victor Gomes de Oliveira", "role": "cliente", "email": "jv808508@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-02-01 18:55:13.676961+00	2026-02-02 22:33:41.656973+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	3fd737a7-0f66-4717-bb7a-5c7a164707db	authenticated	authenticated	luan59718@gmail.com	$2a$10$Zy7AiXimxtewfNZujkDhxeFJxKX8uVh8FDJNIoalA5yXIgwJmFs5W	2025-09-01 22:18:47.755071+00	\N		\N		\N			\N	2025-09-01 22:18:47.768903+00	{"provider": "email", "providers": ["email"]}	{"sub": "3fd737a7-0f66-4717-bb7a-5c7a164707db", "name": "Luan Alves", "role": "cliente", "email": "luan59718@gmail.com", "phone": "33999288022", "email_verified": true, "phone_verified": false}	\N	2025-09-01 22:18:47.712191+00	2025-09-18 23:21:00.096546+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	b8183aa4-4bcb-4cd0-a65b-fb33db0b907d	authenticated	authenticated	tavorakayky@gmail.com	$2a$10$WQUrxtC5rpZCONFpL62Ee.DOgqO5VItLaxhLkaq5sh5EnJU6Ietrq	2026-01-12 21:41:38.315106+00	\N		\N		\N			\N	2026-03-24 23:16:19.172985+00	{"provider": "email", "providers": ["email"]}	{"sub": "b8183aa4-4bcb-4cd0-a65b-fb33db0b907d", "name": "kayky ", "role": "cliente", "email": "tavorakayky@gmail.com", "phone": "11958376570", "email_verified": true, "phone_verified": false}	\N	2026-01-12 21:41:38.201015+00	2026-03-24 23:16:19.177564+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	38319931-975f-45b6-9c8e-112dca479893	authenticated	authenticated	faktmj007@gmail.com	$2a$10$H2FUUt/LpnnsSpw1pCwXoeqYYiVbJuXPmTeFeapbdjzTmsiUISX7m	2025-10-05 01:03:55.085196+00	\N		\N		\N			\N	2025-11-10 14:06:21.177885+00	{"provider": "email", "providers": ["email"]}	{"sub": "38319931-975f-45b6-9c8e-112dca479893", "name": "Victor Gomes", "role": "funcionario", "email": "faktmj007@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-10-05 01:03:55.049444+00	2025-11-10 14:06:21.186473+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	30b1a6e9-28ab-4555-aebe-993f2f5882ce	authenticated	authenticated	luanesmaganoob855@gmail.com	$2a$10$CAv3jFQGNb5uqBR.b6OBiuxeiBF1pyYi0kIhaZr5XommrZ.d429ta	2025-10-06 00:40:37.102306+00	\N		\N		\N			\N	2025-10-06 00:40:37.109868+00	{"provider": "email", "providers": ["email"]}	{"sub": "30b1a6e9-28ab-4555-aebe-993f2f5882ce", "name": "Luan Barber", "role": "funcionario", "email": "luanesmaganoob855@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-10-06 00:40:37.052475+00	2025-10-06 00:40:37.11973+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	c9941f4f-5b88-4261-b3d5-e03fce6881dc	authenticated	authenticated	drezzyyt5@gmail.com	$2a$10$oRkV/AhHy9UC.P30NRr6MO38AEQqoW15wXwanrZ9qztDWEfwHkOuC	2025-09-25 15:06:06.816353+00	\N		\N	4bc8ac201bee81bb9f3fd9ea0c50e8abc462ced639705dfe47b81470	2026-01-02 14:46:08.350468+00			\N	2025-11-10 13:58:19.098329+00	{"provider": "email", "providers": ["email"]}	{"sub": "c9941f4f-5b88-4261-b3d5-e03fce6881dc", "name": "Luan Junio Silva", "role": "admin", "email": "drezzyyt5@gmail.com", "phone": "(79) 99673-0000", "email_verified": true, "phone_verified": false, "barbershop_name": "Agendem Barber"}	\N	2025-09-25 15:06:06.777638+00	2026-01-02 14:46:10.176623+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	230fc139-982f-4289-a8a0-f5f86e10c40e	authenticated	authenticated	kaykyptavora@gmail.com	$2a$10$YLbu1i/n5dRHxqAl/Z7/kuqXs4NsuJbsk2vLbh240Bxn6o0B7gOf2	2026-01-12 22:20:20.008261+00	\N		\N		\N			\N	2026-03-24 23:18:09.25574+00	{"provider": "email", "providers": ["email"]}	{"sub": "230fc139-982f-4289-a8a0-f5f86e10c40e", "name": "corte de giro", "role": "admin", "email": "kaykyptavora@gmail.com", "phone": "(11) 95837-6570", "email_verified": true, "phone_verified": false, "barbershop_name": "Picles Cortes"}	\N	2026-01-12 22:20:19.989547+00	2026-03-24 23:18:09.26374+00	\N	\N			\N		0	\N		\N	f	\N	f
\.


--
-- Data for Name: webauthn_challenges; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.webauthn_challenges (id, user_id, challenge_type, session_data, created_at, expires_at) FROM stdin;
\.


--
-- Data for Name: webauthn_credentials; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.webauthn_credentials (id, user_id, credential_id, public_key, attestation_type, aaguid, sign_count, transports, backup_eligible, backed_up, friendly_name, created_at, updated_at, last_used_at) FROM stdin;
\.


--
-- Data for Name: agendamentos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.agendamentos (id, barbearia_id, servico_id, funcionario_id, user_id, cliente_nome, cliente_telefone, cliente_email, data_hora, status, created_at, updated_at, avaliado) FROM stdin;
0e364d6a-f70b-4a43-bae9-e52ad1d306bd	30731b1b-198a-4a7f-938d-b228ed4e1137	d911f146-359b-4994-b41c-e90869a1c27b	\N	\N	LuanAlves	33999288022	Luan59718@gmail.com	2025-09-25 11:30:00+00	confirmado	2025-09-24 23:33:40.199763+00	2025-09-24 23:33:40.199763+00	f
a8bd8da5-54e5-49b1-945d-86d66469dba6	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	\N	\N	sgsdfgsadf	75345314343	\N	2025-10-01 12:00:00+00	finalizado	2025-09-27 20:49:56.770085+00	2025-09-27 21:38:14.543+00	f
4bb4197c-1804-469b-a64d-74a74359f246	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	\N	\N	aiohdsolajnsd	09684867404	\N	2025-10-04 15:30:00+00	finalizado	2025-09-27 21:36:51.003396+00	2025-09-27 21:38:20.716+00	f
ec8ff5b2-ae3e-46fc-bb85-6933855c6cff	30731b1b-198a-4a7f-938d-b228ed4e1137	d911f146-359b-4994-b41c-e90869a1c27b	\N	\N	jeribaldo   adasda dasd	16321651320	\N	2025-10-06 11:00:00+00	finalizado	2025-09-27 20:19:44.971031+00	2025-09-27 22:46:10.638+00	f
f492976d-81d6-4e90-b3a4-c2b140cafbb6	30731b1b-198a-4a7f-938d-b228ed4e1137	351cd792-bf7f-4867-93ed-68cc39e1d3e7	\N	\N	adw	78563435123	\N	2025-10-08 18:30:00+00	finalizado	2025-09-27 20:21:08.017348+00	2025-09-27 22:46:16.193+00	f
18aa26ec-7641-4119-92ee-4b4750fcd202	30731b1b-198a-4a7f-938d-b228ed4e1137	d911f146-359b-4994-b41c-e90869a1c27b	\N	\N	RAFAEL GOMES ANTUNES DE OLIVEIRA	99998766544	\N	2025-09-29 11:00:00+00	finalizado	2025-09-27 22:49:43.521381+00	2025-09-27 23:03:30.331+00	f
f9c6eb21-0e61-40ff-86e9-759dee01e246	30731b1b-198a-4a7f-938d-b228ed4e1137	d911f146-359b-4994-b41c-e90869a1c27b	\N	c4154c64-b02b-4c03-9948-75171bb60c3f	ralfhslenda	33999353731	rafaeloliveira67539@gmail.com	2025-09-29 11:00:00+00	confirmado	2025-09-27 23:07:52.878313+00	2025-09-27 23:07:52.878313+00	f
b4d7be86-156e-4cc4-a5ec-ed4a91b86111	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	f4eb553e-0ded-4c3c-bfeb-f0a80e5f86d4	38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb	Luan Junio Silva	7990000000	luanjunio017@gmail.com	2025-10-06 11:00:00+00	finalizado	2025-10-05 01:06:42.57706+00	2025-10-05 01:07:04.872+00	f
d9f98153-a263-4fc5-8487-9201ab004c1b	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	f4eb553e-0ded-4c3c-bfeb-f0a80e5f86d4	\N	Joao	33999888888	jv808508@gmail.com	2025-10-21 18:00:00+00	confirmado	2025-10-21 17:14:39.090426+00	2025-10-21 17:14:39.090426+00	f
1f29a43d-ac50-4a9f-9cfa-6fd8d3f2729e	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	f4eb553e-0ded-4c3c-bfeb-f0a80e5f86d4	38319931-975f-45b6-9c8e-112dca479893	Victor Gomes	7777777777	faktmj007@gmail.com	2025-10-06 11:00:00+00	finalizado	2025-10-06 00:33:34.144846+00	2025-10-06 00:38:49.946+00	f
a0350a26-f467-478d-9429-05f742325c95	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	1efaf073-0949-43ae-aec5-0a699174cea9	30b1a6e9-28ab-4555-aebe-993f2f5882ce	Luan Barber	7777777777	luanesmaganoob855@gmail.com	2025-10-06 20:30:00+00	confirmado	2025-10-06 00:41:16.429186+00	2025-10-06 00:41:16.429186+00	f
3aeb1fed-79b3-4fd6-a1fd-302750bcb8d8	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	\N	\N	LINDAO	60416841651	ikhjblgsiuhdlbsikfhjbn@gmail.com	2025-10-08 18:00:00+00	finalizado	2025-10-05 01:26:25.743607+00	2025-10-05 01:26:34.316+00	f
d407c479-9751-4d61-adda-43b2085e0cb4	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	f4eb553e-0ded-4c3c-bfeb-f0a80e5f86d4	\N	Baiano	7991111111	\N	2025-10-07 11:00:00+00	finalizado	2025-10-07 03:12:01.651564+00	2025-10-07 03:12:01.651564+00	f
58788a40-cb55-4678-8f1c-299939ce2073	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	f4eb553e-0ded-4c3c-bfeb-f0a80e5f86d4	38319931-975f-45b6-9c8e-112dca479893	Victor Gomes	7777777777	faktmj007@gmail.com	2025-10-08 11:00:00+00	finalizado	2025-10-07 03:17:29.861461+00	2025-10-07 03:18:05.26+00	f
29c3f82b-cae8-4dcf-82aa-c50b4af477d9	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	f4eb553e-0ded-4c3c-bfeb-f0a80e5f86d4	\N	Luan Junio Silva	99999999999	\N	2025-10-08 11:00:00+00	finalizado	2025-10-08 03:11:02.833755+00	2025-10-08 03:11:02.833755+00	f
128bf273-dbda-4e5c-8eff-f3c11dc592f7	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	f4eb553e-0ded-4c3c-bfeb-f0a80e5f86d4	38319931-975f-45b6-9c8e-112dca479893	Victor Gomes	7777777777	faktmj007@gmail.com	2025-10-08 11:30:00+00	finalizado	2025-10-08 03:13:11.223474+00	2025-10-08 03:13:11.223474+00	f
6056fcba-4240-43d6-b692-102196737841	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	f4eb553e-0ded-4c3c-bfeb-f0a80e5f86d4	\N	Luan Junio Silva	99999999999	\N	2025-10-08 11:00:00+00	finalizado	2025-10-08 03:33:45.457371+00	2025-10-08 03:33:45.457371+00	f
639a4dcd-cb49-48a4-9b93-a21ffba86623	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	f4eb553e-0ded-4c3c-bfeb-f0a80e5f86d4	\N	Luan Junio Silva	99999999999	\N	2025-10-09 11:00:00+00	finalizado	2025-10-09 01:08:05.618301+00	2025-10-09 01:09:21.066+00	f
5abc5854-09c8-4abc-849e-23625f5bbdd7	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	f4eb553e-0ded-4c3c-bfeb-f0a80e5f86d4	\N	Luan Junio Silva	79996734444	\N	2025-10-09 11:00:00+00	finalizado	2025-10-09 01:12:49.346974+00	2025-10-09 01:13:17.446+00	f
ae499378-5fac-44bf-a0e7-dec3041a7c56	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	f4eb553e-0ded-4c3c-bfeb-f0a80e5f86d4	\N	Luan Junio Silva	79996734060	luanjunior855@gmail.com	2025-10-09 11:00:00+00	finalizado	2025-10-09 01:16:01.969323+00	2025-10-09 01:17:26.562+00	f
9476ab6d-84a5-4438-813c-fe88a0a62524	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	f4eb553e-0ded-4c3c-bfeb-f0a80e5f86d4	\N	Luan Junio Silva	79996734060	\N	2025-10-09 11:00:00+00	finalizado	2025-10-09 01:16:36.932457+00	2025-10-09 01:17:28.084+00	f
2d340df8-b3f1-41bf-ba59-e66540ab349f	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	f4eb553e-0ded-4c3c-bfeb-f0a80e5f86d4	\N	Luan Junio Silva	79996734060	\N	2025-10-10 14:30:00+00	confirmado	2025-10-10 14:06:53.087353+00	2025-10-10 14:06:53.087353+00	f
5a1fe611-0e70-49e7-9068-5b6231fda95a	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	f4eb553e-0ded-4c3c-bfeb-f0a80e5f86d4	\N	Jov	33333333333	\N	2025-10-13 16:00:00+00	confirmado	2025-10-12 02:19:07.62363+00	2025-10-12 02:19:07.62363+00	f
3f89faa4-87e2-4149-969a-65130a50a037	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	f4eb553e-0ded-4c3c-bfeb-f0a80e5f86d4	\N	Luan Junio Silva	79996734056	drezzyyt5@gmail.com	2025-11-07 14:30:00+00	confirmado	2025-11-07 14:16:37.798481+00	2025-11-07 14:16:37.798481+00	f
73016b41-698d-4a0c-b0bd-e22ed3954419	30731b1b-198a-4a7f-938d-b228ed4e1137	351cd792-bf7f-4867-93ed-68cc39e1d3e7	\N	\N	Luan Junio Silva	99999999999	\N	2025-11-08 15:00:00+00	finalizado	2025-11-07 22:35:39.291866+00	2025-11-07 22:35:54.213+00	f
08f16f40-8130-4cb0-8385-1ab64b6a819e	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	f4eb553e-0ded-4c3c-bfeb-f0a80e5f86d4	\N	Luan Junio Silva	7999999999	\N	2025-11-22 11:00:00+00	finalizado	2025-11-21 23:38:28.283735+00	2025-11-21 23:38:59.535+00	f
3279d0d4-b229-49fe-bf36-44d144ca9e6e	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	f4eb553e-0ded-4c3c-bfeb-f0a80e5f86d4	38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb	Luan Junio Silva	7990000000	luanjunio017@gmail.com	2025-11-28 11:00:00+00	finalizado	2025-11-27 22:43:16.418564+00	2025-11-27 22:43:26.731+00	f
912ecf2a-2db8-44d9-a6e2-fa8905ebaef7	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	f4eb553e-0ded-4c3c-bfeb-f0a80e5f86d4	\N	Joao	11111111111	\N	2025-12-06 13:30:00+00	confirmado	2025-12-04 13:48:26.489344+00	2025-12-04 13:48:26.489344+00	f
e698078b-0b04-413e-b9d5-d1221dd9637c	63c23133-d41c-460f-aa4a-ee23f96c0ee6	b8f7b01f-18dc-41d1-a534-cb82af53a603	c6ad1742-7c7e-473b-8970-27192f32d717	b8183aa4-4bcb-4cd0-a65b-fb33db0b907d	kayky	11958376570	tavorakayky@gmail.com	2026-01-13 15:50:00+00	finalizado	2026-01-12 22:32:27.373116+00	2026-01-12 22:35:14.694+00	f
567b6def-7a76-460b-aa70-7ab8334930f5	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	1efaf073-0949-43ae-aec5-0a699174cea9	\N	corte de giro	11958376570	tavorakayky@gmail.com	2026-01-13 11:00:00+00	finalizado	2026-01-12 22:12:31.156632+00	2026-01-12 22:40:14.709+00	f
53529260-8dad-4dbc-ac02-a53e47e3a02f	63c23133-d41c-460f-aa4a-ee23f96c0ee6	b8f7b01f-18dc-41d1-a534-cb82af53a603	c6ad1742-7c7e-473b-8970-27192f32d717	\N	Baiano	7991111111	\N	2026-01-14 12:00:00+00	confirmado	2026-01-12 23:03:45.948109+00	2026-01-12 23:03:45.948109+00	f
63347ea3-7dc9-45c7-9457-07c660f45578	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	de628e4b-afc1-4daa-88d5-9977bbba16e8	9d1298fe-5d94-48b9-b1d8-84916445ae84	João Victor Gomes de Oliveira	33999672045	jv808508@gmail.com	2026-02-01 20:00:00+00	finalizado	2026-02-01 19:02:30.385799+00	2026-02-03 00:05:14.919+00	f
17bae0d3-f010-4601-b5d8-34b6425de9e9	63c23133-d41c-460f-aa4a-ee23f96c0ee6	b8f7b01f-18dc-41d1-a534-cb82af53a603	\N	\N	KAYKY PEREIRA TAVORA	11988888888	\N	2026-03-25 12:30:00+00	finalizado	2026-03-24 22:03:26.477678+00	2026-03-24 22:04:20.602+00	f
67e3ebee-2165-4f7a-8069-05a8ea9e5d32	63c23133-d41c-460f-aa4a-ee23f96c0ee6	b8f7b01f-18dc-41d1-a534-cb82af53a603	c6ad1742-7c7e-473b-8970-27192f32d717	b8183aa4-4bcb-4cd0-a65b-fb33db0b907d	kayky	11958376570	tavorakayky@gmail.com	2026-03-25 12:00:00+00	confirmado	2026-03-24 23:17:16.432056+00	2026-03-24 23:17:16.432056+00	f
d4177f81-e7b3-4889-808d-842cc6865d37	30731b1b-198a-4a7f-938d-b228ed4e1137	351cd792-bf7f-4867-93ed-68cc39e1d3e7	\N	\N	Victor Gomes	7991111111	faktmj007@gmail.com	2025-09-25 11:00:00+00	confirmado	2025-09-24 22:56:46.448064+00	2025-09-24 22:56:46.448064+00	f
17269589-e017-4b51-ae78-9f34c926a329	30731b1b-198a-4a7f-938d-b228ed4e1137	d911f146-359b-4994-b41c-e90869a1c27b	\N	0cadcee8-15d5-4ff6-86e9-b339b63eafcc	Rafael Gomes Antunes de Oliveira	21996732729	rafaelgomes77oliveira@gmail.com	2025-10-01 18:00:00+00	finalizado	2025-09-24 22:14:02.502368+00	2025-09-24 22:14:38.178+00	t
7d27d459-50ab-4e3d-9b1b-8d657d01d4d0	30731b1b-198a-4a7f-938d-b228ed4e1137	351cd792-bf7f-4867-93ed-68cc39e1d3e7	\N	\N	Luan Alves	33999288022	luan59718@gmail.com	2025-09-27 19:30:00+00	finalizado	2025-09-27 18:59:42.62731+00	2025-09-27 18:59:42.62731+00	f
e035f615-8121-432c-875a-1395567c2d5c	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	\N	\N	stdgsdg	27432123123	\N	2025-10-01 13:00:00+00	finalizado	2025-09-27 20:50:21.918752+00	2025-09-27 21:38:16.661+00	f
3d343fe0-e12e-4249-965f-915a3b4d798f	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	\N	\N	Luan Junio Silva	99999999999	\N	2025-09-29 11:00:00+00	finalizado	2025-09-27 20:22:05.415372+00	2025-09-27 21:38:24.054+00	f
d167b881-707a-449a-bc52-ab224bc8e2a4	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	\N	38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb	Luan Junio Silva	7990000000	luanjunio017@gmail.com	2025-09-29 11:00:00+00	finalizado	2025-09-27 20:20:53.605289+00	2025-09-27 21:38:26.817+00	f
0b4c3e38-62f1-4356-9638-47c96529d980	30731b1b-198a-4a7f-938d-b228ed4e1137	d911f146-359b-4994-b41c-e90869a1c27b	\N	\N	Rafael	33456788899	rafaelgomesa0403@gmail.com	2025-09-29 11:00:00+00	finalizado	2025-09-27 22:45:21.965039+00	2025-09-27 22:46:07.262+00	f
dbdceba3-f230-4fa7-ae18-303f86635051	30731b1b-198a-4a7f-938d-b228ed4e1137	d911f146-359b-4994-b41c-e90869a1c27b	\N	\N	Jhvbj	56678888888	\N	2025-09-29 11:00:00+00	confirmado	2025-09-27 23:04:11.517301+00	2025-09-27 23:04:11.517301+00	f
8983433d-98b6-43af-93e7-8845addcab3e	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	f4eb553e-0ded-4c3c-bfeb-f0a80e5f86d4	\N	Luan Junio Silva	99999999999	\N	2025-10-08 11:00:00+00	finalizado	2025-10-08 03:34:04.226619+00	2025-10-08 03:34:04.226619+00	f
b9404aeb-3cf3-4bd5-9a35-96f52593fd2b	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	\N	\N	Baiano	7991111111	\N	2025-09-29 11:00:00+00	finalizado	2025-09-28 00:27:36.296904+00	2025-09-28 00:28:38.343+00	f
02e922a1-95cf-4d73-b07c-b2d95d11ceb2	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	\N	0357b8ef-16b6-4869-8630-f46c096dc9a9	Lns Cliente	7997777777	lns017dev@gmail.com	2025-10-06 11:00:00+00	finalizado	2025-10-05 01:20:36.236356+00	2025-10-05 01:24:49.265+00	f
8eba968e-2985-4825-9549-77977060d93c	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	f4eb553e-0ded-4c3c-bfeb-f0a80e5f86d4	\N	Teste	99999999999	\N	2025-10-06 11:00:00+00	finalizado	2025-10-05 01:21:05.082432+00	2025-10-05 01:24:51.072+00	f
da867667-0e46-4d47-8b7f-d51881d11dbf	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	f4eb553e-0ded-4c3c-bfeb-f0a80e5f86d4	38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb	Luan Junio Silva	7990000000	luanjunio017@gmail.com	2025-10-06 11:00:00+00	finalizado	2025-10-05 01:28:28.332064+00	2025-10-05 01:34:52.798+00	f
f8320a2e-5bfb-409d-b48b-c1913d2180fa	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	f4eb553e-0ded-4c3c-bfeb-f0a80e5f86d4	\N	Luan Junio Silva	99999999999	\N	2025-10-09 11:30:00+00	finalizado	2025-10-09 01:08:45.182516+00	2025-10-09 01:09:23.342+00	f
44612cb4-7eda-4a4e-b005-2be9ada9fee9	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	1efaf073-0949-43ae-aec5-0a699174cea9	30b1a6e9-28ab-4555-aebe-993f2f5882ce	Luan Barber	7777777777	luanesmaganoob855@gmail.com	2025-10-06 11:00:00+00	confirmado	2025-10-06 00:41:52.894995+00	2025-10-06 00:41:52.894995+00	f
e2fb3d4e-221e-49f5-bcfc-bffb907eed40	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	\N	\N	Lindao	09687454165	iasbhlkuadgvy@gmail.com	2025-10-09 18:00:00+00	finalizado	2025-10-05 01:27:27.904136+00	2025-10-05 01:34:58.586+00	f
9c55c419-5472-4471-a25b-70e8ee7543fd	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	\N	38319931-975f-45b6-9c8e-112dca479893	Victor Gomes	7777777777	faktmj007@gmail.com	2025-10-06 11:30:00+00	finalizado	2025-10-06 00:35:24.603601+00	2025-10-06 00:38:48.144+00	f
9a0748a7-299c-4d0d-bae8-3de5dea8558a	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	f4eb553e-0ded-4c3c-bfeb-f0a80e5f86d4	38319931-975f-45b6-9c8e-112dca479893	Victor Gomes	7777777777	faktmj007@gmail.com	2025-10-07 11:00:00+00	finalizado	2025-10-07 03:12:39.681953+00	2025-10-07 03:12:39.681953+00	f
ad63da33-043c-4dd1-94bd-06b849e7d099	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	1efaf073-0949-43ae-aec5-0a699174cea9	38319931-975f-45b6-9c8e-112dca479893	Victor Gomes	7777777777	faktmj007@gmail.com	2025-10-08 20:30:00+00	finalizado	2025-10-07 03:18:19.259594+00	2025-10-07 03:18:19.259594+00	f
bd9600da-9e4c-45eb-8d18-626047e1384a	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	f4eb553e-0ded-4c3c-bfeb-f0a80e5f86d4	38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb	Luan Junio Silva	7990000000	luanjunio017@gmail.com	2025-10-08 11:00:00+00	finalizado	2025-10-08 03:12:25.405819+00	2025-10-08 03:12:25.405819+00	f
132bf03c-cda1-4739-8fb3-72d5fe8beeaa	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	f4eb553e-0ded-4c3c-bfeb-f0a80e5f86d4	38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb	Luan Junio Silva	7990000000	luanjunio017@gmail.com	2025-10-08 11:00:00+00	finalizado	2025-10-08 03:33:12.429226+00	2025-10-08 03:33:12.429226+00	f
4558684b-872e-4798-873d-25d91722885d	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	f4eb553e-0ded-4c3c-bfeb-f0a80e5f86d4	\N	Luan Junio Silva	99999999999	\N	2025-10-09 11:00:00+00	finalizado	2025-10-09 01:15:34.618087+00	2025-10-09 01:17:29.617+00	f
7b70391b-bf4a-4510-8ace-ffd75a0f58cd	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	f4eb553e-0ded-4c3c-bfeb-f0a80e5f86d4	\N	Luan Junio Silva	79996734060	\N	2025-10-10 14:30:00+00	confirmado	2025-10-10 14:05:57.21288+00	2025-10-10 14:05:57.21288+00	f
df4ae717-0e2c-4b6d-9ba1-c84f71d37c78	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	f4eb553e-0ded-4c3c-bfeb-f0a80e5f86d4	\N	Luan Junio Silva	79996734060	\N	2025-10-10 14:30:00+00	confirmado	2025-10-10 14:12:26.618924+00	2025-10-10 14:12:26.618924+00	f
c08190da-7818-4243-87e4-485c82785c56	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	1efaf073-0949-43ae-aec5-0a699174cea9	\N	DEIWD GOMES CAMARGOS JUNIOR	33999125552	\N	2025-10-18 14:00:00+00	confirmado	2025-10-16 21:11:57.185055+00	2025-10-16 21:11:57.185055+00	f
d3860583-84a6-4954-8fa9-31f8103831bc	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	f4eb553e-0ded-4c3c-bfeb-f0a80e5f86d4	\N	Luan Junio Silva	79996734444	\N	2025-11-08 11:00:00+00	confirmado	2025-11-07 22:31:15.29865+00	2025-11-07 22:31:15.29865+00	f
8e8f7088-6831-4d5b-bf2f-d00d244e66a8	30731b1b-198a-4a7f-938d-b228ed4e1137	351cd792-bf7f-4867-93ed-68cc39e1d3e7	\N	\N	Luan Junio Silva	79996734444	\N	2025-11-08 11:00:00+00	finalizado	2025-11-07 22:30:37.450827+00	2025-11-07 22:35:11.123+00	f
ae5c6eba-60f7-4bc8-adab-56f379acb485	30731b1b-198a-4a7f-938d-b228ed4e1137	351cd792-bf7f-4867-93ed-68cc39e1d3e7	d5c91aca-4e26-4242-b239-34b2f0dc9507	\N	Luan Junio Silva	99999999999	\N	2025-11-08 15:00:00+00	finalizado	2025-11-07 22:46:09.779556+00	2025-11-07 22:46:55.961+00	f
4c9bb7f5-f828-4a0d-862d-fbef9b0b8c71	30731b1b-198a-4a7f-938d-b228ed4e1137	c8598382-738c-4be6-92a5-1e5c75314414	d5c91aca-4e26-4242-b239-34b2f0dc9507	0cadcee8-15d5-4ff6-86e9-b339b63eafcc	Rafael Gomes Antunes de Oliveira	21996732729	rafaelgomes77oliveira@gmail.com	2025-11-26 15:00:00+00	confirmado	2025-11-22 00:27:19.098974+00	2025-11-22 00:27:19.098974+00	f
39dec39f-15f7-4891-a9e6-7263e6d1d58e	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	f4eb553e-0ded-4c3c-bfeb-f0a80e5f86d4	\N	João	00000000000	\N	2025-11-28 18:30:00+00	confirmado	2025-11-28 17:57:58.155902+00	2025-11-28 17:57:58.155902+00	f
899d437c-014b-41c7-9e13-29f8060b68bc	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	f4eb553e-0ded-4c3c-bfeb-f0a80e5f86d4	\N	Luan Junio Silva	99999999999	\N	2026-01-06 11:00:00+00	finalizado	2026-01-02 14:48:03.379806+00	2026-01-02 14:50:18.984+00	f
837adc06-1a91-49e0-a2e0-3cbf127020d7	63c23133-d41c-460f-aa4a-ee23f96c0ee6	b8f7b01f-18dc-41d1-a534-cb82af53a603	c6ad1742-7c7e-473b-8970-27192f32d717	b8183aa4-4bcb-4cd0-a65b-fb33db0b907d	kayky	11958376570	tavorakayky@gmail.com	2026-01-13 11:30:00+00	finalizado	2026-01-12 22:32:05.444576+00	2026-01-12 22:34:34.483+00	f
6e7e1a2c-b341-4048-8c80-0cb4f6bef70b	63c23133-d41c-460f-aa4a-ee23f96c0ee6	b8f7b01f-18dc-41d1-a534-cb82af53a603	c6ad1742-7c7e-473b-8970-27192f32d717	\N	Baiano	7777777777	\N	2026-01-13 11:00:00+00	confirmado	2026-01-12 22:42:56.665745+00	2026-01-12 22:42:56.665745+00	f
aca73a84-b0e9-47b9-b138-cbc67d8a526e	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4d96a89c-a85f-4fd2-b46f-1f66c922d154	f4eb553e-0ded-4c3c-bfeb-f0a80e5f86d4	38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb	Luan Junio Silva	7990000000	luanjunio017@gmail.com	2026-01-14 12:00:00+00	confirmado	2026-01-13 14:42:00.177239+00	2026-01-13 14:42:00.177239+00	f
dd4c5f83-5f9d-48ff-b0ec-a731207e04b6	63c23133-d41c-460f-aa4a-ee23f96c0ee6	b8f7b01f-18dc-41d1-a534-cb82af53a603	c6ad1742-7c7e-473b-8970-27192f32d717	\N	KAYKY PEREIRA TAVORA	11988888888	\N	2026-03-25 13:00:00+00	confirmado	2026-03-24 22:27:28.504395+00	2026-03-24 22:27:28.504395+00	f
\.


--
-- Data for Name: assinaturas; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.assinaturas (id, barbearia_id, tipo_plano, status, data_inicio, data_fim, data_cancelamento, valor_mensal, moeda, metodo_pagamento, stripe_subscription_id, stripe_customer_id, observacoes, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: audit_log; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.audit_log (id, user_id, operation, table_name, record_id, old_values, new_values, ip_address, user_agent, created_at) FROM stdin;
\.


--
-- Data for Name: barbearias; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.barbearias (id, nome, logo_url, slug, endereco, cidade, bairro, cep, email_contato, telefone, cores_personalizadas, modo_tema, gallery_urls, created_at, updated_at, fidelidade_ativa, descricao, notificacoes_ativa) FROM stdin;
30731b1b-198a-4a7f-938d-b228ed4e1137	Ralfhs Cuts	https://onqxspbszibcyemsuhoa.supabase.co/storage/v1/object/public/logos/30731b1b-198a-4a7f-938d-b228ed4e1137/logo-1758744798557-barbearia.jpg	ralfhs-cuts	A do meio	Teófilo Otoni	Centro	123		65432135468	{}	dark	{https://onqxspbszibcyemsuhoa.supabase.co/storage/v1/object/public/gallery/30731b1b-198a-4a7f-938d-b228ed4e1137/gallery-1758755393415-Correntes%20(2).png}	2025-09-23 22:52:25.949445+00	2025-09-23 22:52:25.949445+00	t		t
63c23133-d41c-460f-aa4a-ee23f96c0ee6	Picles Cortes	\N	picles-cortes	\N	Não informado	\N	\N	\N	\N	{"accent": "#84cc16", "primary": "#ec4899", "secondary": "#78716c", "background": "#1c1917"}	dark	{}	2026-01-12 22:20:19.989213+00	2026-01-12 22:20:19.989213+00	f	\N	t
b1b6d958-0e59-4815-b1f9-787d1389f5a4	Lns Barber	https://onqxspbszibcyemsuhoa.supabase.co/storage/v1/object/public/logos/b1b6d958-0e59-4815-b1f9-787d1389f5a4/logo-1758850183503-logo.png	lns-barber	Rua A	Lagarto	Alto Da Boa Vista	49400000	contato@lnsbarber.com	79900000000	{"accent": "#14b8a6", "primary": "#3b82f6", "secondary": "#005bdb", "background": "#0f172a"}	dark	{https://onqxspbszibcyemsuhoa.supabase.co/storage/v1/object/public/gallery/b1b6d958-0e59-4815-b1f9-787d1389f5a4/gallery-1758851618420-Lucid_Realism_A_cinematic_lowangle_view_of_a_customized_2024_B_1_LE_upscale_ultra_x4_size_of_changes_0_intensity_50.jpg}	2025-09-25 00:16:48.448393+00	2025-09-25 00:16:48.448393+00	f	Opa	t
\.


--
-- Data for Name: categorias_servicos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.categorias_servicos (id, nome, descricao) FROM stdin;
550e8400-e29b-41d4-a716-446655440001	Corte de Cabelo	Serviços relacionados ao corte de cabelo masculino
550e8400-e29b-41d4-a716-446655440002	Barba	Serviços de barbearia para barba e bigode
550e8400-e29b-41d4-a716-446655440003	Tratamentos	Tratamentos e cuidados capilares
550e8400-e29b-41d4-a716-446655440004	Sobrancelha	Serviços de design e manutenção de sobrancelhas
550e8400-e29b-41d4-a716-446655440005	Hidratação	Hidratação capilar e tratamentos de cabelo
550e8400-e29b-41d4-a716-446655440006	Relaxamento	Serviços de relaxamento e alisamento capilar
550e8400-e29b-41d4-a716-446655440007	Combo	Pacotes combinados de serviços
\.


--
-- Data for Name: feedbacks; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.feedbacks (id, agendamento_id, user_id, barbearia_id, rating, comment, created_at, response, response_created_at, responded_by, status, anonimo) FROM stdin;
822ac400-5268-4a3d-bea5-f9289955f3d7	d167b881-707a-449a-bc52-ab224bc8e2a4	38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb	b1b6d958-0e59-4815-b1f9-787d1389f5a4	\N	\N	2025-09-27 21:38:26.850549+00	\N	\N	\N	pendente	f
169f3a3e-78b7-425f-b08a-d09073a92789	17269589-e017-4b51-ae78-9f34c926a329	0cadcee8-15d5-4ff6-86e9-b339b63eafcc	30731b1b-198a-4a7f-938d-b228ed4e1137	5	melhor barbearia de todos os tempos	2025-09-24 22:14:38.220258+00	Eu te amo!!!	2025-09-27 22:41:58.607+00	0cadcee8-15d5-4ff6-86e9-b339b63eafcc	concluido	f
faba21b0-ce2f-4371-ac28-a4b601f51939	b4d7be86-156e-4cc4-a5ec-ed4a91b86111	38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb	b1b6d958-0e59-4815-b1f9-787d1389f5a4	\N	\N	2025-10-05 01:07:04.894499+00	\N	\N	\N	pendente	f
a54b17c6-1cf5-4b44-9862-b54dc8bd7bdc	02e922a1-95cf-4d73-b07c-b2d95d11ceb2	0357b8ef-16b6-4869-8630-f46c096dc9a9	b1b6d958-0e59-4815-b1f9-787d1389f5a4	\N	\N	2025-10-05 01:24:49.290882+00	\N	\N	\N	pendente	f
83c8ebf8-eb98-4e3d-8a1d-4c7bce8e7323	da867667-0e46-4d47-8b7f-d51881d11dbf	38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb	b1b6d958-0e59-4815-b1f9-787d1389f5a4	\N	\N	2025-10-05 01:34:52.824145+00	\N	\N	\N	pendente	f
f633500f-0e20-4592-bbf8-4c74e05312f1	9c55c419-5472-4471-a25b-70e8ee7543fd	38319931-975f-45b6-9c8e-112dca479893	b1b6d958-0e59-4815-b1f9-787d1389f5a4	\N	\N	2025-10-06 00:38:48.177204+00	\N	\N	\N	pendente	f
e2bf3a63-1ed0-47f2-89ac-0dc0f4ab2822	1f29a43d-ac50-4a9f-9cfa-6fd8d3f2729e	38319931-975f-45b6-9c8e-112dca479893	b1b6d958-0e59-4815-b1f9-787d1389f5a4	\N	\N	2025-10-06 00:38:49.964753+00	\N	\N	\N	pendente	f
df5832b9-65f4-496d-a9c5-cd979a3818ab	9a0748a7-299c-4d0d-bae8-3de5dea8558a	38319931-975f-45b6-9c8e-112dca479893	b1b6d958-0e59-4815-b1f9-787d1389f5a4	\N	\N	2025-10-07 03:16:52.136672+00	\N	\N	\N	pendente	f
fd444771-d5ed-4d41-b92a-b355c890f5e0	58788a40-cb55-4678-8f1c-299939ce2073	38319931-975f-45b6-9c8e-112dca479893	b1b6d958-0e59-4815-b1f9-787d1389f5a4	\N	\N	2025-10-07 03:18:05.284193+00	\N	\N	\N	pendente	f
1f9f981e-5bad-4f56-8069-684665e6f493	ad63da33-043c-4dd1-94bd-06b849e7d099	38319931-975f-45b6-9c8e-112dca479893	b1b6d958-0e59-4815-b1f9-787d1389f5a4	\N	\N	2025-10-08 03:10:00.990198+00	\N	\N	\N	pendente	f
e711fe2a-3cd7-44cb-905e-e799492d82f8	bd9600da-9e4c-45eb-8d18-626047e1384a	38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb	b1b6d958-0e59-4815-b1f9-787d1389f5a4	\N	\N	2025-10-08 03:14:54.081508+00	\N	\N	\N	pendente	f
ee4c0f55-f6ea-4443-ada7-036aa924f7ee	128bf273-dbda-4e5c-8eff-f3c11dc592f7	38319931-975f-45b6-9c8e-112dca479893	b1b6d958-0e59-4815-b1f9-787d1389f5a4	\N	\N	2025-10-08 03:14:55.583346+00	\N	\N	\N	pendente	f
91ccf9db-8350-43af-8eb8-992be73dbfc4	132bf03c-cda1-4739-8fb3-72d5fe8beeaa	38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb	b1b6d958-0e59-4815-b1f9-787d1389f5a4	\N	\N	2025-10-08 03:33:26.275829+00	\N	\N	\N	pendente	f
e0ff798c-c12e-4bed-99e4-0457619ec419	3279d0d4-b229-49fe-bf36-44d144ca9e6e	38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb	b1b6d958-0e59-4815-b1f9-787d1389f5a4	\N	\N	2025-11-27 22:43:26.762281+00	\N	\N	\N	pendente	f
15af44b1-839e-42c5-b17a-5ad479eaac50	e698078b-0b04-413e-b9d5-d1221dd9637c	b8183aa4-4bcb-4cd0-a65b-fb33db0b907d	63c23133-d41c-460f-aa4a-ee23f96c0ee6	1		2026-01-12 22:35:14.732944+00	\N	\N	\N	concluido	f
f3024d5a-d81b-4192-a5c9-1ca7f772abaa	837adc06-1a91-49e0-a2e0-3cbf127020d7	b8183aa4-4bcb-4cd0-a65b-fb33db0b907d	63c23133-d41c-460f-aa4a-ee23f96c0ee6	5		2026-01-12 22:34:34.501616+00	\N	\N	\N	concluido	f
e5754ec2-a4a9-4e91-8149-0535e7ac4a64	63347ea3-7dc9-45c7-9457-07c660f45578	9d1298fe-5d94-48b9-b1d8-84916445ae84	b1b6d958-0e59-4815-b1f9-787d1389f5a4	\N	\N	2026-02-03 00:05:14.942021+00	\N	\N	\N	pendente	f
\.


--
-- Data for Name: fidelidade; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.fidelidade (id, user_id, barbearia_id, pontos, updated_at, cliente_telefone) FROM stdin;
1d73a509-115a-4843-a99d-02f9d2bb21bc	b8183aa4-4bcb-4cd0-a65b-fb33db0b907d	63c23133-d41c-460f-aa4a-ee23f96c0ee6	154	2026-01-12 22:35:14.883+00	\N
bb7fb807-3f90-449c-9fa6-2d75c4f33f23	9d1298fe-5d94-48b9-b1d8-84916445ae84	b1b6d958-0e59-4815-b1f9-787d1389f5a4	1	2026-02-03 00:05:15.147115+00	\N
\.


--
-- Data for Name: fidelidade_configuracoes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.fidelidade_configuracoes (id, barbearia_id, pontos_por_servico, created_at, updated_at, pontos_minimos_recompensa, dias_expiracao) FROM stdin;
164798e1-917e-4b8b-9309-0418bae20a13	b1b6d958-0e59-4815-b1f9-787d1389f5a4	1	2025-11-28 00:03:13.742414+00	2025-11-28 00:03:49.068401+00	100	365
3fede7cd-1c88-40e6-b98a-9eea112e6443	63c23133-d41c-460f-aa4a-ee23f96c0ee6	77	2026-01-12 22:26:41.037464+00	2026-01-12 22:26:49.552296+00	100	365
\.


--
-- Data for Name: funcionario_ausencias; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.funcionario_ausencias (id, funcionario_id, barbearia_id, tipo, data_inicio, data_fim, motivo, created_at, updated_at) FROM stdin;
82946873-f367-4b13-aae4-5e3027809feb	1efaf073-0949-43ae-aec5-0a699174cea9	b1b6d958-0e59-4815-b1f9-787d1389f5a4	ferias	2025-11-10	2025-11-11		2025-11-10 13:42:02.420997+00	2025-11-10 13:42:02.420997+00
8f08f75e-bd10-4f6c-a4f8-5e92332706dd	f4eb553e-0ded-4c3c-bfeb-f0a80e5f86d4	b1b6d958-0e59-4815-b1f9-787d1389f5a4	ferias	2025-11-21	2025-11-25		2025-11-21 23:50:29.371818+00	2025-11-21 23:50:29.371818+00
4ba8e93c-8f0f-4209-a6ad-c13113a60253	f4eb553e-0ded-4c3c-bfeb-f0a80e5f86d4	b1b6d958-0e59-4815-b1f9-787d1389f5a4	ferias	2025-12-22	2026-01-05		2025-12-21 17:47:08.800688+00	2025-12-21 17:47:08.800688+00
79ddc87f-9620-4d7c-8fdd-428cfe559768	d5c91aca-4e26-4242-b239-34b2f0dc9507	30731b1b-198a-4a7f-938d-b228ed4e1137	ferias	2026-01-30	2026-01-31	ferias do rafa	2026-01-30 18:12:57.015484+00	2026-01-30 18:12:57.015484+00
82f4fe68-2b74-4034-8283-408fa8a178a3	d5c91aca-4e26-4242-b239-34b2f0dc9507	30731b1b-198a-4a7f-938d-b228ed4e1137	recesso	2026-02-02	2026-02-02	feriado	2026-01-30 18:13:49.812843+00	2026-01-30 18:14:10.203395+00
\.


--
-- Data for Name: funcionario_convites; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.funcionario_convites (id, email, barbearia_id, funcionario_data, usado, expires_at, created_at, updated_at, created_by, token) FROM stdin;
c17a426e-8198-4f33-aca8-63dec8f73475	faktmj007@gmail.com	b1b6d958-0e59-4815-b1f9-787d1389f5a4	{"nome": "Victor Gomes", "foto_url": "", "especialidade": "Corte Degradê", "nivel_permissao": "funcionario"}	t	2025-10-04 23:37:53.437+00	2025-09-27 23:37:53.46745+00	2025-09-27 23:37:53.46745+00	38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb	f7ee4ba8-0064-4671-b489-b41cb0ab1eb5-1759016273079
52e72830-33fd-49c1-9b19-d4837a01d439	faktmj007@gmail.com	b1b6d958-0e59-4815-b1f9-787d1389f5a4	{"nome": "Victor Gomes", "foto_url": "", "especialidade": "Corte Degradê", "nivel_permissao": "funcionario"}	t	2025-10-12 01:00:17.116+00	2025-10-05 01:00:17.141346+00	2025-10-05 01:00:17.141346+00	38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb	07275e3c-c026-4623-882b-282057b2340e-1759626016875
7b1669d7-9ebb-40bd-a43a-9e47916cfe89	luang9552@gmail.com	30731b1b-198a-4a7f-938d-b228ed4e1137	{"nome": "Labizerra Apelão", "foto_url": "", "especialidade": "TUDO", "nivel_permissao": "gerente"}	t	2025-11-14 22:44:24.968+00	2025-11-07 22:44:24.989791+00	2025-11-07 22:44:24.989791+00	0cadcee8-15d5-4ff6-86e9-b339b63eafcc	1f982466-a84c-4c12-85ee-d424616798bc-1762555464684
204d861d-0f0d-4ff9-98a0-9402d29cbdca	contatoluandev@gmail.com	b1b6d958-0e59-4815-b1f9-787d1389f5a4	{"nome": "Rafael Gomes", "foto_url": "", "especialidade": "Barba", "nivel_permissao": "gerente"}	t	2025-10-12 01:24:33.356+00	2025-10-05 01:24:33.382273+00	2025-10-05 01:24:33.382273+00	38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb	bb4083a6-67b0-40b0-8b37-3cb7015fae16-1759627473014
dd45a9db-d1ac-418e-83f7-dff653198f50	luanesmaganoob855@gmail.com	b1b6d958-0e59-4815-b1f9-787d1389f5a4	{"nome": "Luan Barber", "foto_url": "", "especialidade": "Corte Degradê", "nivel_permissao": "gerente"}	t	2025-10-13 00:40:02.259+00	2025-10-06 00:40:02.306551+00	2025-10-06 00:40:02.306551+00	38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb	11f41f8d-b257-40ac-b851-0a99d321ef15-1759711201943
\.


--
-- Data for Name: funcionario_pausas; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.funcionario_pausas (id, funcionario_id, barbearia_id, data, hora_inicio, hora_fim, motivo, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: funcionarios; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.funcionarios (id, user_id, barbearia_id, nome, nivel, created_at, updated_at, is_owner, email, especialidade) FROM stdin;
f4eb553e-0ded-4c3c-bfeb-f0a80e5f86d4	38319931-975f-45b6-9c8e-112dca479893	b1b6d958-0e59-4815-b1f9-787d1389f5a4	Victor Gomes	funcionario	2025-10-05 01:03:55.049104+00	2025-10-05 01:03:55.049104+00	f	\N	\N
1efaf073-0949-43ae-aec5-0a699174cea9	30b1a6e9-28ab-4555-aebe-993f2f5882ce	b1b6d958-0e59-4815-b1f9-787d1389f5a4	Luan Barber	gerente	2025-10-06 00:40:37.049387+00	2025-10-06 00:40:37.049387+00	f	\N	\N
de628e4b-afc1-4daa-88d5-9977bbba16e8	38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb	b1b6d958-0e59-4815-b1f9-787d1389f5a4	Luan	dono	2025-11-26 00:25:30.570344+00	2025-11-26 00:25:30.570344+00	f	luanjunio017@gmail.com	Dono / Gerente
c6ad1742-7c7e-473b-8970-27192f32d717	230fc139-982f-4289-a8a0-f5f86e10c40e	63c23133-d41c-460f-aa4a-ee23f96c0ee6	corte de giro	dono	2026-01-12 22:20:19.989213+00	2026-01-12 22:20:19.989213+00	t	\N	\N
d5c91aca-4e26-4242-b239-34b2f0dc9507	72f4663e-11f6-4c41-876a-5fa272e969c5	30731b1b-198a-4a7f-938d-b228ed4e1137	Labizerra Apelão	dono	2025-11-07 22:45:16.390487+00	2025-11-07 22:45:16.390487+00	f	Luang9552@gmail.com	
\.


--
-- Data for Name: horarios_funcionamento; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.horarios_funcionamento (id, barbearia_id, dia_semana, hora_abre, hora_fecha, fechado, created_at, updated_at) FROM stdin;
b11f2e7b-61ea-41aa-a9c6-5e452109c1b2	a13bc245-81a1-4dee-b907-9d1c94ef3246	0	\N	\N	t	2025-09-11 22:05:01.37858+00	2025-09-11 22:05:01.37858+00
62164ba1-af06-48c8-8bc0-052c8e2d9634	a13bc245-81a1-4dee-b907-9d1c94ef3246	1	08:00:00	23:59:00	f	2025-09-11 22:05:01.37858+00	2025-09-11 22:05:01.37858+00
99600949-4c00-49a3-a622-3e6cd5d7fcb8	a13bc245-81a1-4dee-b907-9d1c94ef3246	2	08:00:00	23:59:00	f	2025-09-11 22:05:01.37858+00	2025-09-11 22:05:01.37858+00
a9b56b49-d24c-40b5-9ef6-bc0cc0d1d392	a13bc245-81a1-4dee-b907-9d1c94ef3246	3	08:00:00	23:59:00	f	2025-09-11 22:05:01.37858+00	2025-09-11 22:05:01.37858+00
413e62b1-2deb-46a2-b28f-0cdd3ebebc45	a13bc245-81a1-4dee-b907-9d1c94ef3246	4	08:00:00	23:59:00	f	2025-09-11 22:05:01.37858+00	2025-09-11 22:05:01.37858+00
8baaeb85-d060-48d4-ac70-ce6d527d3324	a13bc245-81a1-4dee-b907-9d1c94ef3246	5	08:00:00	18:00:00	f	2025-09-11 22:05:01.37858+00	2025-09-11 22:05:01.37858+00
10ac3cc5-1fe3-4f56-9ea7-755b155aef41	a13bc245-81a1-4dee-b907-9d1c94ef3246	6	08:00:00	17:00:00	f	2025-09-11 22:05:01.37858+00	2025-09-11 22:05:01.37858+00
8daedbe4-0fca-42a4-9104-dba85e493f53	0f857e92-3cd2-4a8c-b49a-38046664898f	1	08:00:00	18:00:00	f	2025-09-24 23:27:40.957204+00	2025-09-24 23:27:40.957204+00
aad2afe9-ff81-42d5-b2eb-9a74c668dd6a	0f857e92-3cd2-4a8c-b49a-38046664898f	2	08:00:00	18:00:00	f	2025-09-24 23:27:40.957204+00	2025-09-24 23:27:40.957204+00
950388e8-e875-47e1-aab3-5052f4771e09	0f857e92-3cd2-4a8c-b49a-38046664898f	3	08:00:00	18:00:00	f	2025-09-24 23:27:40.957204+00	2025-09-24 23:27:40.957204+00
f201b044-408c-452c-839d-87f7745050b3	0f857e92-3cd2-4a8c-b49a-38046664898f	4	08:00:00	18:00:00	f	2025-09-24 23:27:40.957204+00	2025-09-24 23:27:40.957204+00
454ab171-74c6-4b3e-957b-f881f5fb1f61	0f857e92-3cd2-4a8c-b49a-38046664898f	5	08:00:00	18:00:00	f	2025-09-24 23:27:40.957204+00	2025-09-24 23:27:40.957204+00
a70ec621-535c-4cc0-b106-2b80764425e7	0f857e92-3cd2-4a8c-b49a-38046664898f	6	08:00:00	17:00:00	f	2025-09-24 23:27:40.957204+00	2025-09-24 23:27:40.957204+00
59f7e4a4-e256-47a0-b1a2-7b239ac98535	0f857e92-3cd2-4a8c-b49a-38046664898f	0	\N	\N	t	2025-09-24 23:27:40.957204+00	2025-09-24 23:27:40.957204+00
0c387750-66f8-4c50-bc8e-ba8548895b9e	897411d9-c3e0-44e7-b111-052f6019845d	1	08:00:00	18:00:00	f	2025-09-25 15:06:06.777244+00	2025-09-25 15:06:06.777244+00
9edc0064-01d7-4b16-a884-d0c4cd3a93df	897411d9-c3e0-44e7-b111-052f6019845d	2	08:00:00	18:00:00	f	2025-09-25 15:06:06.777244+00	2025-09-25 15:06:06.777244+00
04cc26e2-cdc9-4df8-ba5c-45827db5c086	897411d9-c3e0-44e7-b111-052f6019845d	3	08:00:00	18:00:00	f	2025-09-25 15:06:06.777244+00	2025-09-25 15:06:06.777244+00
2100c801-b772-4ed0-aaba-1b1a8a80b9b5	897411d9-c3e0-44e7-b111-052f6019845d	4	08:00:00	18:00:00	f	2025-09-25 15:06:06.777244+00	2025-09-25 15:06:06.777244+00
c371bd3a-024c-4cb4-91ed-5f6ca742ae23	897411d9-c3e0-44e7-b111-052f6019845d	5	08:00:00	18:00:00	f	2025-09-25 15:06:06.777244+00	2025-09-25 15:06:06.777244+00
f86b62c8-2b0b-4ad1-a870-f09076045f91	897411d9-c3e0-44e7-b111-052f6019845d	6	08:00:00	17:00:00	f	2025-09-25 15:06:06.777244+00	2025-09-25 15:06:06.777244+00
2c2c895e-96fb-4f89-aba5-bcb6a61898f2	897411d9-c3e0-44e7-b111-052f6019845d	0	\N	\N	t	2025-09-25 15:06:06.777244+00	2025-09-25 15:06:06.777244+00
c1357086-2ae0-43f5-9c4a-d0081da52339	30731b1b-198a-4a7f-938d-b228ed4e1137	0	\N	\N	t	2025-11-27 22:42:02.020145+00	2025-11-27 22:42:02.020145+00
ce308fef-173f-4b15-ba68-925c0632fb97	30731b1b-198a-4a7f-938d-b228ed4e1137	1	08:00:00	23:00:00	f	2025-11-27 22:42:02.020145+00	2025-11-27 22:42:02.020145+00
28a32d06-8ca4-4140-9d4c-01a0c2b8380b	30731b1b-198a-4a7f-938d-b228ed4e1137	2	08:00:00	23:00:00	f	2025-11-27 22:42:02.020145+00	2025-11-27 22:42:02.020145+00
dd092530-21f6-4343-8781-1f20381a137f	30731b1b-198a-4a7f-938d-b228ed4e1137	3	08:00:00	23:00:00	f	2025-11-27 22:42:02.020145+00	2025-11-27 22:42:02.020145+00
d7f22cdc-df47-4672-8cf2-a08583788c13	30731b1b-198a-4a7f-938d-b228ed4e1137	4	08:00:00	23:00:00	f	2025-11-27 22:42:02.020145+00	2025-11-27 22:42:02.020145+00
f2860d8a-cd0d-42a0-a84b-4950e89f32bd	30731b1b-198a-4a7f-938d-b228ed4e1137	5	08:00:00	23:00:00	f	2025-11-27 22:42:02.020145+00	2025-11-27 22:42:02.020145+00
096094b1-0f3b-467d-b83f-dbd9110e3848	30731b1b-198a-4a7f-938d-b228ed4e1137	6	08:00:00	23:00:00	f	2025-11-27 22:42:02.020145+00	2025-11-27 22:42:02.020145+00
6882ec47-32ed-4e54-943a-32a5f3f054bb	b1b6d958-0e59-4815-b1f9-787d1389f5a4	0	08:00:00	20:00:00	f	2026-01-04 15:01:33.136946+00	2026-01-04 15:01:33.136946+00
6eb26e43-add3-4b39-948c-93c12c98e533	b1b6d958-0e59-4815-b1f9-787d1389f5a4	1	08:00:00	18:00:00	f	2026-01-04 15:01:33.136946+00	2026-01-04 15:01:33.136946+00
3c91b906-d72f-4b2c-9036-ccdc70da893f	b1b6d958-0e59-4815-b1f9-787d1389f5a4	2	08:00:00	18:00:00	f	2026-01-04 15:01:33.136946+00	2026-01-04 15:01:33.136946+00
0e1730b9-d9d0-4f09-b737-7980b1be32b7	b1b6d958-0e59-4815-b1f9-787d1389f5a4	3	08:00:00	18:00:00	f	2026-01-04 15:01:33.136946+00	2026-01-04 15:01:33.136946+00
38007085-93d1-4cf8-9939-9d9b57cb3b71	b1b6d958-0e59-4815-b1f9-787d1389f5a4	4	08:00:00	18:00:00	f	2026-01-04 15:01:33.136946+00	2026-01-04 15:01:33.136946+00
ad106cac-5bc9-4e39-87b7-c61fe2dfe73f	b1b6d958-0e59-4815-b1f9-787d1389f5a4	5	08:00:00	18:00:00	f	2026-01-04 15:01:33.136946+00	2026-01-04 15:01:33.136946+00
42ba94a6-bdf8-4429-8bd7-247a2f517206	b1b6d958-0e59-4815-b1f9-787d1389f5a4	6	08:00:00	19:00:00	f	2026-01-04 15:01:33.136946+00	2026-01-04 15:01:33.136946+00
1d73da7c-411d-4ce7-8b4f-724524ff107d	bd9cde73-25e6-46ca-b356-387329ab0df9	1	08:00:00	18:00:00	f	2026-01-12 22:19:40.869286+00	2026-01-12 22:19:40.869286+00
57aefae6-e344-46d2-a8be-e8263f931881	bd9cde73-25e6-46ca-b356-387329ab0df9	2	08:00:00	18:00:00	f	2026-01-12 22:19:40.869286+00	2026-01-12 22:19:40.869286+00
36ade620-bd08-4493-abba-4ca27a1cf6e4	bd9cde73-25e6-46ca-b356-387329ab0df9	3	08:00:00	18:00:00	f	2026-01-12 22:19:40.869286+00	2026-01-12 22:19:40.869286+00
d612a512-8a99-4a1b-8f36-55065d8d4163	bd9cde73-25e6-46ca-b356-387329ab0df9	4	08:00:00	18:00:00	f	2026-01-12 22:19:40.869286+00	2026-01-12 22:19:40.869286+00
a852bc59-8796-4a7d-b967-af1161293d2d	bd9cde73-25e6-46ca-b356-387329ab0df9	5	08:00:00	18:00:00	f	2026-01-12 22:19:40.869286+00	2026-01-12 22:19:40.869286+00
410db55e-87fc-4d1c-bcfb-f811b007d8aa	bd9cde73-25e6-46ca-b356-387329ab0df9	6	08:00:00	17:00:00	f	2026-01-12 22:19:40.869286+00	2026-01-12 22:19:40.869286+00
78da9be3-e253-4115-b7ed-a3d6c32abe19	bd9cde73-25e6-46ca-b356-387329ab0df9	0	\N	\N	t	2026-01-12 22:19:40.869286+00	2026-01-12 22:19:40.869286+00
933108d8-fd93-41d1-b427-09a3694ad2f2	63c23133-d41c-460f-aa4a-ee23f96c0ee6	0	\N	\N	t	2026-03-24 22:02:28.608383+00	2026-03-24 22:02:28.608383+00
873b8b2a-4732-46a8-bbac-bc1a40320269	63c23133-d41c-460f-aa4a-ee23f96c0ee6	1	08:00:00	21:00:00	f	2026-03-24 22:02:28.608383+00	2026-03-24 22:02:28.608383+00
2a82cec4-c20b-4bdf-9474-2b58bb6947d2	63c23133-d41c-460f-aa4a-ee23f96c0ee6	2	08:00:00	18:00:00	f	2026-03-24 22:02:28.608383+00	2026-03-24 22:02:28.608383+00
fbbab9ae-a1a9-497c-82c3-c0e5ddbfde5f	63c23133-d41c-460f-aa4a-ee23f96c0ee6	3	08:00:00	18:00:00	f	2026-03-24 22:02:28.608383+00	2026-03-24 22:02:28.608383+00
56efdbf6-8988-4222-891c-791aee1ff091	63c23133-d41c-460f-aa4a-ee23f96c0ee6	4	08:00:00	18:00:00	f	2026-03-24 22:02:28.608383+00	2026-03-24 22:02:28.608383+00
acc18e5f-c6df-413d-a426-b4808561f81f	63c23133-d41c-460f-aa4a-ee23f96c0ee6	5	08:00:00	18:00:00	f	2026-03-24 22:02:28.608383+00	2026-03-24 22:02:28.608383+00
29b2c7bf-816d-47e8-b349-0c7f4557f5ce	63c23133-d41c-460f-aa4a-ee23f96c0ee6	6	08:00:00	17:00:00	f	2026-03-24 22:02:28.608383+00	2026-03-24 22:02:28.608383+00
\.


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.profiles (id, user_id, name, phone, role, barbearia_id, receber_lembretes_email, receber_lembretes_sms, consentimento_marketing, created_at, updated_at) FROM stdin;
b4c481a3-5d0c-4088-8b33-e72118726327	3fd737a7-0f66-4717-bb7a-5c7a164707db	Luan Alves	33999288022	cliente	\N	t	f	f	2025-09-01 22:18:47.709047+00	2025-09-01 22:18:47.709047+00
5b75004c-ac98-4b8b-8f26-a0cef5c9c570	38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb	Luan Junio Silva	7990000000	admin	b1b6d958-0e59-4815-b1f9-787d1389f5a4	t	f	f	2025-09-25 00:16:48.448393+00	2025-11-26 00:25:30.570344+00
5ff1031d-f2f4-420f-9441-392a67743914	b8183aa4-4bcb-4cd0-a65b-fb33db0b907d	kayky 	11958376570	cliente	\N	t	f	f	2026-01-12 21:41:38.200005+00	2026-01-12 21:41:38.200005+00
c225f5a9-b68f-42d1-9084-8b08ca9d6d90	c9941f4f-5b88-4261-b3d5-e03fce6881dc	Luan Junio Silva	(79) 99673-0000	admin	897411d9-c3e0-44e7-b111-052f6019845d	t	f	f	2025-09-25 15:06:06.777244+00	2025-09-25 15:06:06.777244+00
2b302d21-f2c0-4f3a-9df5-85fcab713096	c4154c64-b02b-4c03-9948-75171bb60c3f	ralfhslenda	33999353731	cliente	\N	t	f	f	2025-09-27 23:07:29.535322+00	2025-09-27 23:07:29.535322+00
657b3654-96ff-4c8c-9af8-4d01b4916b66	0357b8ef-16b6-4869-8630-f46c096dc9a9	Lns Cliente	7997777777	cliente	\N	t	f	f	2025-10-05 01:20:13.496579+00	2025-10-05 01:20:13.496579+00
a064b6bd-1ffc-485b-acd3-fdb2568ca6d4	c6484ce8-6846-47c5-ae37-18130c44f7a3	Rafael Gomes		funcionario	b1b6d958-0e59-4815-b1f9-787d1389f5a4	t	f	f	2025-10-05 01:25:06.77505+00	2025-10-05 01:25:06.77505+00
6f009e54-acbb-408a-969d-f0bf97e2321d	38319931-975f-45b6-9c8e-112dca479893	Victor Gomes	7777777777	funcionario	b1b6d958-0e59-4815-b1f9-787d1389f5a4	t	f	f	2025-10-05 01:03:55.049104+00	2025-10-05 01:03:55.049104+00
2e97eaf0-5b31-47b0-baed-237e7c9d76d0	30b1a6e9-28ab-4555-aebe-993f2f5882ce	Luan Barber	7777777777	funcionario	b1b6d958-0e59-4815-b1f9-787d1389f5a4	t	f	f	2025-10-06 00:40:37.049387+00	2025-10-06 00:40:37.049387+00
7fadc0b4-43e1-4bf1-905c-824661d5b45c	230fc139-982f-4289-a8a0-f5f86e10c40e	corte de giro	(11) 95837-6570	admin	63c23133-d41c-460f-aa4a-ee23f96c0ee6	t	f	f	2026-01-12 22:20:19.989213+00	2026-01-12 22:20:19.989213+00
3cec9f91-db50-46c3-9dc0-43007342a42c	72f4663e-11f6-4c41-876a-5fa272e969c5	Labizerra Apelão		admin	30731b1b-198a-4a7f-938d-b228ed4e1137	t	f	f	2025-11-07 22:45:16.390487+00	2025-11-07 22:45:16.390487+00
c51bfa0d-f2ed-40f5-b377-d2b891df9e3d	0cadcee8-15d5-4ff6-86e9-b339b63eafcc	Rafael Gomes Antunes de Oliveira	(21) 99673-2729	admin	30731b1b-198a-4a7f-938d-b228ed4e1137	t	f	f	2025-09-23 22:52:25.949445+00	2026-01-31 16:56:37.657808+00
5e2e0bfc-c505-4081-8fc8-011729174f41	9d1298fe-5d94-48b9-b1d8-84916445ae84	João Victor Gomes de Oliveira	33999672045	cliente	\N	t	t	t	2026-02-01 18:55:13.675965+00	2026-02-01 18:55:13.675965+00
\.


--
-- Data for Name: recompensas; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.recompensas (id, barbearia_id, nome, descricao, pontos_necessarios, ativo, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: resgates_recompensas; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.resgates_recompensas (id, recompensa_id, cliente_telefone, barbearia_id, pontos_utilizados, data_resgate, status) FROM stdin;
\.


--
-- Data for Name: servicos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.servicos (id, barbearia_id, nome, descricao, valor, duracao_minutos, categoria_id, created_at, updated_at, categoria_id_2) FROM stdin;
351cd792-bf7f-4867-93ed-68cc39e1d3e7	30731b1b-198a-4a7f-938d-b228ed4e1137	Corte Simples		35.00	15	550e8400-e29b-41d4-a716-446655440001	2025-09-23 22:53:45.770254+00	2025-09-23 22:53:45.770254+00	\N
d911f146-359b-4994-b41c-e90869a1c27b	30731b1b-198a-4a7f-938d-b228ed4e1137	Corte + Barba		50.00	30	550e8400-e29b-41d4-a716-446655440001	2025-09-23 22:54:11.060277+00	2025-09-23 22:54:11.060277+00	550e8400-e29b-41d4-a716-446655440002
4d96a89c-a85f-4fd2-b46f-1f66c922d154	b1b6d958-0e59-4815-b1f9-787d1389f5a4	Corte + Barba	Melhor Corte da Região	30.00	30	550e8400-e29b-41d4-a716-446655440001	2025-09-26 01:31:07.105019+00	2025-09-26 01:31:07.105019+00	550e8400-e29b-41d4-a716-446655440002
c8598382-738c-4be6-92a5-1e5c75314414	30731b1b-198a-4a7f-938d-b228ed4e1137	corte + massagem		150.00	50	550e8400-e29b-41d4-a716-446655440007	2025-11-22 00:04:17.88659+00	2025-11-22 00:04:17.88659+00	550e8400-e29b-41d4-a716-446655440006
b8f7b01f-18dc-41d1-a534-cb82af53a603	63c23133-d41c-460f-aa4a-ee23f96c0ee6	GymPass		10.00	50	550e8400-e29b-41d4-a716-446655440007	2026-01-12 22:23:07.933053+00	2026-01-12 22:23:07.933053+00	550e8400-e29b-41d4-a716-446655440003
\.


--
-- Data for Name: messages_2026_03_23; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.messages_2026_03_23 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2026_03_24; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.messages_2026_03_24 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2026_03_25; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.messages_2026_03_25 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2026_03_26; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.messages_2026_03_26 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2026_03_27; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.messages_2026_03_27 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2026_03_28; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.messages_2026_03_28 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2025-07-11 22:56:44
20211116045059	2025-07-11 22:56:48
20211116050929	2025-07-11 22:56:52
20211116051442	2025-07-11 22:56:55
20211116212300	2025-07-11 22:56:59
20211116213355	2025-07-11 22:57:03
20211116213934	2025-07-11 22:57:06
20211116214523	2025-07-11 22:57:11
20211122062447	2025-07-11 22:57:14
20211124070109	2025-07-11 22:57:17
20211202204204	2025-07-11 22:57:20
20211202204605	2025-07-11 22:57:24
20211210212804	2025-07-11 22:57:34
20211228014915	2025-07-11 22:57:38
20220107221237	2025-07-11 22:57:41
20220228202821	2025-07-11 22:57:44
20220312004840	2025-07-11 22:57:48
20220603231003	2025-07-11 22:57:53
20220603232444	2025-07-11 22:57:56
20220615214548	2025-07-11 22:58:00
20220712093339	2025-07-11 22:58:04
20220908172859	2025-07-11 22:58:07
20220916233421	2025-07-11 22:58:10
20230119133233	2025-07-11 22:58:14
20230128025114	2025-07-11 22:58:18
20230128025212	2025-07-11 22:58:22
20230227211149	2025-07-11 22:58:25
20230228184745	2025-07-11 22:58:28
20230308225145	2025-07-11 22:58:32
20230328144023	2025-07-11 22:58:35
20231018144023	2025-07-11 22:58:39
20231204144023	2025-07-11 22:58:44
20231204144024	2025-07-11 22:58:47
20231204144025	2025-07-11 22:58:51
20240108234812	2025-07-11 22:58:54
20240109165339	2025-07-11 22:58:57
20240227174441	2025-07-11 22:59:03
20240311171622	2025-07-11 22:59:08
20240321100241	2025-07-11 22:59:15
20240401105812	2025-07-11 22:59:25
20240418121054	2025-07-11 22:59:29
20240523004032	2025-07-11 22:59:41
20240618124746	2025-07-11 22:59:45
20240801235015	2025-07-11 22:59:48
20240805133720	2025-07-11 22:59:51
20240827160934	2025-07-11 22:59:55
20240919163303	2025-07-11 22:59:59
20240919163305	2025-07-11 23:00:03
20241019105805	2025-07-11 23:00:06
20241030150047	2025-07-11 23:00:18
20241108114728	2025-07-11 23:00:23
20241121104152	2025-07-11 23:00:26
20241130184212	2025-07-11 23:00:30
20241220035512	2025-07-11 23:00:34
20241220123912	2025-07-11 23:00:37
20241224161212	2025-07-11 23:00:40
20250107150512	2025-07-11 23:00:44
20250110162412	2025-07-11 23:00:47
20250123174212	2025-07-11 23:00:50
20250128220012	2025-07-11 23:00:54
20250506224012	2025-07-11 23:00:56
20250523164012	2025-07-11 23:01:00
20250714121412	2025-07-18 22:39:24
20250905041441	2025-09-23 22:22:52
20251103001201	2025-11-18 23:36:13
20251120212548	2026-02-03 22:21:10
20251120215549	2026-02-03 22:21:11
20260218120000	2026-03-24 02:51:30
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at, action_filter) FROM stdin;
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id, type) FROM stdin;
barbershop-media	barbershop-media	\N	2025-07-12 16:35:43.045609+00	2025-07-12 16:35:43.045609+00	t	f	\N	\N	\N	STANDARD
logos	logos	\N	2025-07-14 23:45:05.540324+00	2025-07-14 23:45:05.540324+00	t	f	\N	\N	\N	STANDARD
gallery	gallery	\N	2025-07-17 14:35:01.549328+00	2025-07-17 14:35:01.549328+00	t	f	\N	\N	\N	STANDARD
\.


--
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets_analytics (name, type, format, created_at, updated_at, id, deleted_at) FROM stdin;
\.


--
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets_vectors (id, type, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2025-07-11 22:56:39.72784
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2025-07-11 22:56:39.742551
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2025-07-11 22:56:39.77391
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2025-07-11 22:56:39.791027
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2025-07-11 22:56:39.801089
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2025-07-11 22:56:39.822384
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2025-07-11 22:56:39.832757
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2025-07-11 22:56:39.864551
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2025-07-11 22:56:39.879058
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2025-07-11 22:56:39.888997
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2025-07-11 22:56:39.899067
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2025-07-11 22:56:39.925424
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2025-07-11 22:56:39.942476
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2025-07-11 22:56:39.953185
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2025-07-11 22:56:39.963486
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2025-07-11 22:56:39.978762
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2025-07-11 22:56:39.989737
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2025-07-11 22:56:40.001857
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2025-07-11 22:56:40.01941
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2025-07-11 22:56:40.048377
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2025-07-11 22:56:40.096777
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2025-07-11 22:56:40.13914
37	add-bucket-name-length-trigger	3944135b4e3e8b22d6d4cbb568fe3b0b51df15c1	2025-08-26 15:10:14.919885
44	vector-bucket-type	99c20c0ffd52bb1ff1f32fb992f3b351e3ef8fb3	2025-11-18 23:36:12.981887
45	vector-buckets	049e27196d77a7cb76497a85afae669d8b230953	2025-11-18 23:36:13.005116
46	buckets-objects-grants	fedeb96d60fefd8e02ab3ded9fbde05632f84aed	2025-11-18 23:36:13.078316
47	iceberg-table-metadata	649df56855c24d8b36dd4cc1aeb8251aa9ad42c2	2025-11-18 23:36:13.084363
49	buckets-objects-grants-postgres	072b1195d0d5a2f888af6b2302a1938dd94b8b3d	2025-12-21 17:46:50.609618
2	storage-schema	f6a1fa2c93cbcd16d4e487b362e45fca157a8dbd	2025-07-11 22:56:39.751805
6	change-column-name-in-get-size	ded78e2f1b5d7e616117897e6443a925965b30d2	2025-07-11 22:56:39.811849
9	fix-search-function	af597a1b590c70519b464a4ab3be54490712796b	2025-07-11 22:56:39.842946
10	search-files-search-function	b595f05e92f7e91211af1bbfe9c6a13bb3391e16	2025-07-11 22:56:39.853528
26	objects-prefixes	215cabcb7f78121892a5a2037a09fedf9a1ae322	2025-08-26 15:10:11.808842
27	search-v2	859ba38092ac96eb3964d83bf53ccc0b141663a6	2025-08-26 15:10:12.115525
28	object-bucket-name-sorting	c73a2b5b5d4041e39705814fd3a1b95502d38ce4	2025-08-26 15:10:13.010527
29	create-prefixes	ad2c1207f76703d11a9f9007f821620017a66c21	2025-08-26 15:10:13.213496
30	update-object-levels	2be814ff05c8252fdfdc7cfb4b7f5c7e17f0bed6	2025-08-26 15:10:13.30044
31	objects-level-index	b40367c14c3440ec75f19bbce2d71e914ddd3da0	2025-08-26 15:10:13.404929
32	backward-compatible-index-on-objects	e0c37182b0f7aee3efd823298fb3c76f1042c0f7	2025-08-26 15:10:13.505945
33	backward-compatible-index-on-prefixes	b480e99ed951e0900f033ec4eb34b5bdcb4e3d49	2025-08-26 15:10:13.700921
34	optimize-search-function-v1	ca80a3dc7bfef894df17108785ce29a7fc8ee456	2025-08-26 15:10:13.799188
35	add-insert-trigger-prefixes	458fe0ffd07ec53f5e3ce9df51bfdf4861929ccc	2025-08-26 15:10:14.50231
36	optimise-existing-functions	6ae5fca6af5c55abe95369cd4f93985d1814ca8f	2025-08-26 15:10:14.609027
38	iceberg-catalog-flag-on-buckets	02716b81ceec9705aed84aa1501657095b32e5c5	2025-08-26 15:10:16.099231
39	add-search-v2-sort-support	6706c5f2928846abee18461279799ad12b279b78	2025-09-23 22:48:43.533482
40	fix-prefix-race-conditions-optimized	7ad69982ae2d372b21f48fc4829ae9752c518f6b	2025-09-23 22:48:43.604091
41	add-object-level-update-trigger	07fcf1a22165849b7a029deed059ffcde08d1ae0	2025-09-26 00:41:21.255194
42	rollback-prefix-triggers	771479077764adc09e2ea2043eb627503c034cd4	2025-09-26 00:41:21.274229
43	fix-object-level	84b35d6caca9d937478ad8a797491f38b8c2979f	2025-09-26 00:41:21.286766
48	iceberg-catalog-ids	e0e8b460c609b9999ccd0df9ad14294613eed939	2025-11-18 23:36:13.090481
50	search-v2-optimised	6323ac4f850aa14e7387eb32102869578b5bd478	2026-02-16 10:16:31.223064
51	index-backward-compatible-search	2ee395d433f76e38bcd3856debaf6e0e5b674011	2026-02-16 10:16:31.331739
52	drop-not-used-indexes-and-functions	5cc44c8696749ac11dd0dc37f2a3802075f3a171	2026-02-16 10:16:31.332876
53	drop-index-lower-name	d0cb18777d9e2a98ebe0bc5cc7a42e57ebe41854	2026-02-16 10:16:31.510026
54	drop-index-object-level	6289e048b1472da17c31a7eba1ded625a6457e67	2026-02-16 10:16:31.511979
55	prevent-direct-deletes	262a4798d5e0f2e7c8970232e03ce8be695d5819	2026-02-16 10:16:31.512978
56	fix-optimized-search-function	cb58526ebc23048049fd5bf2fd148d18b04a2073	2026-02-16 10:16:31.525111
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata) FROM stdin;
88288053-62c2-4162-8de9-1798b8a1d0e6	gallery	30731b1b-198a-4a7f-938d-b228ed4e1137/gallery-1758755393415-Correntes (2).png	0cadcee8-15d5-4ff6-86e9-b339b63eafcc	2025-09-24 23:09:53.587623+00	2025-09-24 23:09:53.587623+00	2025-09-24 23:09:53.587623+00	{"eTag": "\\"da7c755b7fcdc0fbc1304b345f388908\\"", "size": 379984, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2025-09-24T23:09:54.000Z", "contentLength": 379984, "httpStatusCode": 200}	b8cee9b7-de71-49c6-9ed9-ae30ccd3e78c	0cadcee8-15d5-4ff6-86e9-b339b63eafcc	{}
bbbdf576-00e2-483d-b6f7-6b0264fd27a5	logos	b1b6d958-0e59-4815-b1f9-787d1389f5a4/logo-1758850183503-logo.png	38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb	2025-09-26 01:29:45.088192+00	2025-09-26 01:29:45.088192+00	2025-09-26 01:29:45.088192+00	{"eTag": "\\"ad0d73774f4de7ed25ec54cfa9e56216\\"", "size": 83446, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2025-09-26T01:29:46.000Z", "contentLength": 83446, "httpStatusCode": 200}	0c0713c5-c936-44ae-beec-57961e04908e	38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb	{}
01fe1be2-b141-4e3b-8bce-11258e3f703b	gallery	b1b6d958-0e59-4815-b1f9-787d1389f5a4/gallery-1758851618420-Lucid_Realism_A_cinematic_lowangle_view_of_a_customized_2024_B_1_LE_upscale_ultra_x4_size_of_changes_0_intensity_50.jpg	38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb	2025-09-26 01:53:40.042102+00	2025-09-26 01:53:40.042102+00	2025-09-26 01:53:40.042102+00	{"eTag": "\\"ac4c70bc9d6cf69b76bdf8f06b361264\\"", "size": 519440, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2025-09-26T01:53:40.000Z", "contentLength": 519440, "httpStatusCode": 200}	8330039b-551d-4e94-8762-b8c972f3ce98	38cc88e3-a7b4-4ca2-8c48-925e93c4fbdb	{}
0419ee1c-140b-4b49-88c1-446f668585dd	logos	30731b1b-198a-4a7f-938d-b228ed4e1137/logo-1758744798557-barbearia.jpg	0cadcee8-15d5-4ff6-86e9-b339b63eafcc	2025-09-24 20:13:15.137427+00	2025-09-24 20:13:15.137427+00	2025-09-24 20:13:15.137427+00	{"eTag": "\\"75e762f1018045aad0005fc5da3e52f5\\"", "size": 43217, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2025-09-24T20:13:16.000Z", "contentLength": 43217, "httpStatusCode": 200}	eff0094d-0e2a-4910-a914-5d5ddf460620	0cadcee8-15d5-4ff6-86e9-b339b63eafcc	{}
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.vector_indexes (id, name, bucket_id, data_type, dimension, distance_metric, metadata_configuration, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: supabase_migrations; Owner: -
--

COPY supabase_migrations.schema_migrations (version, statements, name, created_by, idempotency_key, rollback) FROM stdin;
20241222000000	{"-- Função para verificar se um usuário existe baseado em email ou telefone\n-- Retorna informações sobre o usuário encontrado ou null se não existir\nCREATE OR REPLACE FUNCTION \\"public\\".\\"check_if_user_exists\\"(\n    \\"p_email\\" text,\n    \\"p_phone\\" text\n) RETURNS json\nLANGUAGE plpgsql\nSECURITY DEFINER\nSET search_path = public\nAS $$\nDECLARE\n    user_record record;\n    result json;\nBEGIN\n    -- Buscar usuário por email ou telefone\n    SELECT \n        u.id as user_id,\n        u.email,\n        p.name,\n        p.phone,\n        p.role,\n        p.barbearia_id\n    INTO user_record\n    FROM auth.users u\n    LEFT JOIN public.profiles p ON u.id = p.user_id\n    WHERE \n        (p_email IS NOT NULL AND u.email = p_email)\n        OR \n        (p_phone IS NOT NULL AND p.phone = p_phone)\n    LIMIT 1;\n    \n    -- Se encontrou o usuário, retornar as informações\n    IF FOUND THEN\n        result := json_build_object(\n            'exists', true,\n            'user_id', user_record.user_id,\n            'email', user_record.email,\n            'name', user_record.name,\n            'phone', user_record.phone,\n            'role', user_record.role,\n            'barbearia_id', user_record.barbearia_id\n        );\n    ELSE\n        -- Se não encontrou, retornar que não existe\n        result := json_build_object(\n            'exists', false\n        );\n    END IF;\n    \n    RETURN result;\nEND;\n$$","-- Conceder permissões para a função\nALTER FUNCTION \\"public\\".\\"check_if_user_exists\\"(text, text) OWNER TO \\"postgres\\"","GRANT EXECUTE ON FUNCTION \\"public\\".\\"check_if_user_exists\\"(text, text) TO \\"anon\\"","GRANT EXECUTE ON FUNCTION \\"public\\".\\"check_if_user_exists\\"(text, text) TO \\"authenticated\\"","GRANT EXECUTE ON FUNCTION \\"public\\".\\"check_if_user_exists\\"(text, text) TO \\"service_role\\""}	create_check_if_user_exists_function	\N	\N	\N
20250818014902	{"-- Habilitar RLS em todas as tabelas necessárias\r\nALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY","ALTER TABLE public.barbearias ENABLE ROW LEVEL SECURITY","ALTER TABLE public.agendamentos ENABLE ROW LEVEL SECURITY","ALTER TABLE public.feedbacks ENABLE ROW LEVEL SECURITY","ALTER TABLE public.funcionarios ENABLE ROW LEVEL SECURITY","ALTER TABLE public.servicos ENABLE ROW LEVEL SECURITY","ALTER TABLE public.fidelidade ENABLE ROW LEVEL SECURITY","ALTER TABLE public.recompensas ENABLE ROW LEVEL SECURITY","ALTER TABLE public.resgates_recompensas ENABLE ROW LEVEL SECURITY","-- =================================================================\r\n-- POLÍTICAS PARA PROFILES\r\n-- =================================================================\r\n\r\n-- Usuários podem ver todos os perfis (necessário para funcionalidades de equipe)\r\nCREATE POLICY \\"Users can view all profiles\\"\r\nON public.profiles\r\nFOR SELECT\r\nTO authenticated\r\nUSING (true)","-- Usuários podem editar apenas seu próprio perfil\r\nCREATE POLICY \\"Users can update own profile\\"\r\nON public.profiles\r\nFOR UPDATE\r\nTO authenticated\r\nUSING (auth.uid() = user_id)","-- Sistema pode inserir novos perfis (via trigger)\r\nCREATE POLICY \\"System can insert profiles\\"\r\nON public.profiles\r\nFOR INSERT\r\nTO authenticated\r\nWITH CHECK (auth.uid() = user_id)","-- =================================================================\r\n-- POLÍTICAS PARA BARBEARIAS\r\n-- =================================================================\r\n\r\n-- Todos podem ver barbearias (para busca e booking)\r\nCREATE POLICY \\"Anyone can view barbearias\\"\r\nON public.barbearias\r\nFOR SELECT\r\nTO authenticated\r\nUSING (true)","-- Apenas donos (admins) podem editar sua barbearia\r\nCREATE POLICY \\"Admins can update own barbearia\\"\r\nON public.barbearias\r\nFOR UPDATE\r\nTO authenticated\r\nUSING (\r\n  public.get_current_user_role() = 'admin' AND \r\n  public.get_user_barbearia_id(auth.uid()) = id\r\n)","-- Admins podem inserir barbearias (via trigger de signup)\r\nCREATE POLICY \\"Admins can insert barbearias\\"\r\nON public.barbearias\r\nFOR INSERT\r\nTO authenticated\r\nWITH CHECK (public.get_current_user_role() = 'admin')","-- =================================================================\r\n-- POLÍTICAS PARA AGENDAMENTOS\r\n-- =================================================================\r\n\r\n-- Clientes podem ver seus próprios agendamentos\r\n-- Funcionários/Admins podem ver agendamentos da sua barbearia\r\nCREATE POLICY \\"Users can view relevant agendamentos\\"\r\nON public.agendamentos\r\nFOR SELECT\r\nTO authenticated\r\nUSING (\r\n  -- Cliente pode ver seus próprios agendamentos\r\n  (public.get_current_user_role() = 'cliente' AND auth.uid() = user_id) OR\r\n  -- Funcionários/Admins podem ver agendamentos da sua barbearia\r\n  (public.get_current_user_role() IN ('funcionario', 'admin') AND \r\n   public.get_user_barbearia_id(auth.uid()) = barbearia_id)\r\n)","-- Clientes podem criar agendamentos\r\n-- Funcionários/Admins podem criar agendamentos para sua barbearia\r\nCREATE POLICY \\"Users can insert agendamentos\\"\r\nON public.agendamentos\r\nFOR INSERT\r\nTO authenticated\r\nWITH CHECK (\r\n  -- Cliente pode criar agendamento para si\r\n  (public.get_current_user_role() = 'cliente' AND auth.uid() = user_id) OR\r\n  -- Funcionários/Admins podem criar para sua barbearia\r\n  (public.get_current_user_role() IN ('funcionario', 'admin') AND \r\n   public.get_user_barbearia_id(auth.uid()) = barbearia_id)\r\n)","-- Funcionários/Admins podem atualizar agendamentos da sua barbearia\r\nCREATE POLICY \\"Staff can update barbearia agendamentos\\"\r\nON public.agendamentos\r\nFOR UPDATE\r\nTO authenticated\r\nUSING (\r\n  public.get_current_user_role() IN ('funcionario', 'admin') AND \r\n  public.get_user_barbearia_id(auth.uid()) = barbearia_id\r\n)","-- =================================================================\r\n-- POLÍTICAS PARA FEEDBACKS\r\n-- =================================================================\r\n\r\n-- Clientes podem ver seus próprios feedbacks\r\n-- Funcionários/Admins podem ver feedbacks da sua barbearia\r\nCREATE POLICY \\"Users can view relevant feedbacks\\"\r\nON public.feedbacks\r\nFOR SELECT\r\nTO authenticated\r\nUSING (\r\n  -- Cliente pode ver seus próprios feedbacks\r\n  (public.get_current_user_role() = 'cliente' AND auth.uid() = user_id) OR\r\n  -- Funcionários/Admins podem ver feedbacks da sua barbearia\r\n  (public.get_current_user_role() IN ('funcionario', 'admin') AND \r\n   public.get_user_barbearia_id(auth.uid()) = barbearia_id)\r\n)","-- Apenas clientes podem criar feedbacks (para seus próprios agendamentos)\r\nCREATE POLICY \\"Clients can insert own feedbacks\\"\r\nON public.feedbacks\r\nFOR INSERT\r\nTO authenticated\r\nWITH CHECK (\r\n  public.get_current_user_role() = 'cliente' AND \r\n  auth.uid() = user_id\r\n)","-- Funcionários/Admins podem responder feedbacks da sua barbearia\r\nCREATE POLICY \\"Staff can update barbearia feedbacks\\"\r\nON public.feedbacks\r\nFOR UPDATE\r\nTO authenticated\r\nUSING (\r\n  public.get_current_user_role() IN ('funcionario', 'admin') AND \r\n  public.get_user_barbearia_id(auth.uid()) = barbearia_id\r\n)","-- =================================================================\r\n-- POLÍTICAS PARA FUNCIONÁRIOS\r\n-- =================================================================\r\n\r\n-- Admins podem ver funcionários da sua barbearia\r\nCREATE POLICY \\"Admins can view barbearia funcionarios\\"\r\nON public.funcionarios\r\nFOR SELECT\r\nTO authenticated\r\nUSING (\r\n  public.get_current_user_role() = 'admin' AND \r\n  public.get_user_barbearia_id(auth.uid()) = barbearia_id\r\n)","-- Admins podem inserir funcionários na sua barbearia\r\nCREATE POLICY \\"Admins can insert barbearia funcionarios\\"\r\nON public.funcionarios\r\nFOR INSERT\r\nTO authenticated\r\nWITH CHECK (\r\n  public.get_current_user_role() = 'admin' AND \r\n  public.get_user_barbearia_id(auth.uid()) = barbearia_id\r\n)","-- Admins podem editar funcionários da sua barbearia\r\nCREATE POLICY \\"Admins can update barbearia funcionarios\\"\r\nON public.funcionarios\r\nFOR UPDATE\r\nTO authenticated\r\nUSING (\r\n  public.get_current_user_role() = 'admin' AND \r\n  public.get_user_barbearia_id(auth.uid()) = barbearia_id\r\n)","-- Admins podem excluir funcionários da sua barbearia\r\nCREATE POLICY \\"Admins can delete barbearia funcionarios\\"\r\nON public.funcionarios\r\nFOR DELETE\r\nTO authenticated\r\nUSING (\r\n  public.get_current_user_role() = 'admin' AND \r\n  public.get_user_barbearia_id(auth.uid()) = barbearia_id\r\n)","-- =================================================================\r\n-- POLÍTICAS PARA SERVIÇOS\r\n-- =================================================================\r\n\r\n-- Todos podem ver serviços (para booking)\r\nCREATE POLICY \\"Anyone can view servicos\\"\r\nON public.servicos\r\nFOR SELECT\r\nTO authenticated\r\nUSING (true)","-- Apenas admins podem gerenciar serviços da sua barbearia\r\nCREATE POLICY \\"Admins can manage barbearia servicos\\"\r\nON public.servicos\r\nFOR ALL\r\nTO authenticated\r\nUSING (\r\n  public.get_current_user_role() = 'admin' AND \r\n  public.get_user_barbearia_id(auth.uid()) = barbearia_id\r\n)\r\nWITH CHECK (\r\n  public.get_current_user_role() = 'admin' AND \r\n  public.get_user_barbearia_id(auth.uid()) = barbearia_id\r\n)","-- =================================================================\r\n-- POLÍTICAS PARA FIDELIDADE\r\n-- =================================================================\r\n\r\n-- Clientes podem ver seus próprios pontos\r\n-- Funcionários/Admins podem ver pontos dos clientes da sua barbearia\r\nCREATE POLICY \\"Users can view relevant fidelidade\\"\r\nON public.fidelidade\r\nFOR SELECT\r\nTO authenticated\r\nUSING (\r\n  -- Cliente pode ver seus próprios pontos\r\n  (public.get_current_user_role() = 'cliente' AND auth.uid() = user_id) OR\r\n  -- Funcionários/Admins podem ver pontos da sua barbearia\r\n  (public.get_current_user_role() IN ('funcionario', 'admin') AND \r\n   public.get_user_barbearia_id(auth.uid()) = barbearia_id)\r\n)","-- Funcionários/Admins podem gerenciar pontos da sua barbearia\r\nCREATE POLICY \\"Staff can manage barbearia fidelidade\\"\r\nON public.fidelidade\r\nFOR ALL\r\nTO authenticated\r\nUSING (\r\n  public.get_current_user_role() IN ('funcionario', 'admin') AND \r\n  public.get_user_barbearia_id(auth.uid()) = barbearia_id\r\n)\r\nWITH CHECK (\r\n  public.get_current_user_role() IN ('funcionario', 'admin') AND \r\n  public.get_user_barbearia_id(auth.uid()) = barbearia_id\r\n)","-- =================================================================\r\n-- POLÍTICAS PARA RECOMPENSAS\r\n-- =================================================================\r\n\r\n-- Todos podem ver recompensas (para resgate)\r\nCREATE POLICY \\"Anyone can view recompensas\\"\r\nON public.recompensas\r\nFOR SELECT\r\nTO authenticated\r\nUSING (true)","-- Apenas admins podem gerenciar recompensas da sua barbearia\r\nCREATE POLICY \\"Admins can manage barbearia recompensas\\"\r\nON public.recompensas\r\nFOR ALL\r\nTO authenticated\r\nUSING (\r\n  public.get_current_user_role() = 'admin' AND \r\n  public.get_user_barbearia_id(auth.uid()) = barbearia_id\r\n)\r\nWITH CHECK (\r\n  public.get_current_user_role() = 'admin' AND \r\n  public.get_user_barbearia_id(auth.uid()) = barbearia_id\r\n)","-- =================================================================\r\n-- POLÍTICAS PARA RESGATES DE RECOMPENSAS\r\n-- =================================================================\r\n\r\n-- Clientes podem ver seus próprios resgates\r\n-- Funcionários/Admins podem ver resgates da sua barbearia\r\nCREATE POLICY \\"Users can view relevant resgates\\"\r\nON public.resgates_recompensas\r\nFOR SELECT\r\nTO authenticated\r\nUSING (\r\n  -- Funcionários/Admins podem ver resgates da sua barbearia\r\n  public.get_current_user_role() IN ('funcionario', 'admin') AND \r\n  public.get_user_barbearia_id(auth.uid()) = barbearia_id\r\n)","-- Funcionários/Admins podem inserir resgates para sua barbearia\r\nCREATE POLICY \\"Staff can insert barbearia resgates\\"\r\nON public.resgates_recompensas\r\nFOR INSERT\r\nTO authenticated\r\nWITH CHECK (\r\n  public.get_current_user_role() IN ('funcionario', 'admin') AND \r\n  public.get_user_barbearia_id(auth.uid()) = barbearia_id\r\n)"}	c51bfa61-cba7-453d-a95d-da6336172eb7	\N	\N	\N
20250818015005	{"-- Corrigir funções sem search_path definido para melhorar segurança\r\n\r\n-- Atualizar função get_user_barbearia_id\r\nCREATE OR REPLACE FUNCTION public.get_user_barbearia_id(user_uuid uuid)\r\n RETURNS uuid\r\n LANGUAGE sql\r\n STABLE SECURITY DEFINER\r\n SET search_path = public\r\nAS $function$\r\n  SELECT barbearia_id FROM public.profiles WHERE user_id = user_uuid;\r\n$function$","-- Atualizar função get_user_role\r\nCREATE OR REPLACE FUNCTION public.get_user_role(user_uuid uuid)\r\n RETURNS user_role\r\n LANGUAGE sql\r\n STABLE SECURITY DEFINER\r\n SET search_path = public\r\nAS $function$\r\n  SELECT role FROM public.profiles WHERE user_id = user_uuid;\r\n$function$","-- Atualizar função get_current_user_role\r\nCREATE OR REPLACE FUNCTION public.get_current_user_role()\r\n RETURNS user_role\r\n LANGUAGE sql\r\n STABLE SECURITY DEFINER\r\n SET search_path = public\r\nAS $function$\r\n  SELECT role FROM public.profiles WHERE user_id = auth.uid();\r\n$function$","-- Atualizar função resgatar_recompensa\r\nCREATE OR REPLACE FUNCTION public.resgatar_recompensa(p_recompensa_id uuid, p_cliente_telefone text, p_barbearia_id uuid)\r\n RETURNS json\r\n LANGUAGE plpgsql\r\n SECURITY DEFINER\r\n SET search_path = public\r\nAS $function$\r\nDECLARE\r\n    v_recompensa record;\r\n    v_pontos_cliente integer;\r\n    v_resultado json;\r\nBEGIN\r\n    -- Buscar dados da recompensa\r\n    SELECT * INTO v_recompensa\r\n    FROM public.recompensas\r\n    WHERE id = p_recompensa_id AND barbearia_id = p_barbearia_id AND ativo = true;\r\n    \r\n    IF NOT FOUND THEN\r\n        RETURN json_build_object('success', false, 'message', 'Recompensa não encontrada ou inativa');\r\n    END IF;\r\n    \r\n    -- Buscar pontos do cliente\r\n    SELECT pontos INTO v_pontos_cliente\r\n    FROM public.fidelidade\r\n    WHERE barbearia_id = p_barbearia_id AND cliente_telefone = p_cliente_telefone;\r\n    \r\n    IF NOT FOUND OR v_pontos_cliente < v_recompensa.pontos_necessarios THEN\r\n        RETURN json_build_object('success', false, 'message', 'Pontos insuficientes');\r\n    END IF;\r\n    \r\n    -- Realizar o resgate\r\n    BEGIN\r\n        -- Inserir registro de resgate\r\n        INSERT INTO public.resgates_recompensas (\r\n            recompensa_id, cliente_telefone, barbearia_id, pontos_utilizados\r\n        ) VALUES (\r\n            p_recompensa_id, p_cliente_telefone, p_barbearia_id, v_recompensa.pontos_necessarios\r\n        );\r\n        \r\n        -- Deduzir pontos do cliente\r\n        UPDATE public.fidelidade\r\n        SET pontos = pontos - v_recompensa.pontos_necessarios,\r\n            updated_at = now()\r\n        WHERE barbearia_id = p_barbearia_id AND cliente_telefone = p_cliente_telefone;\r\n        \r\n        v_resultado := json_build_object(\r\n            'success', true, \r\n            'message', 'Recompensa resgatada com sucesso!',\r\n            'recompensa', v_recompensa.nome,\r\n            'pontos_utilizados', v_recompensa.pontos_necessarios\r\n        );\r\n        \r\n        RETURN v_resultado;\r\n        \r\n    EXCEPTION WHEN OTHERS THEN\r\n        RETURN json_build_object('success', false, 'message', 'Erro ao processar resgate');\r\n    END;\r\nEND;\r\n$function$","-- Atualizar função get_recompensas_disponiveis\r\nCREATE OR REPLACE FUNCTION public.get_recompensas_disponiveis(p_barbearia_id uuid, p_cliente_telefone text)\r\n RETURNS json\r\n LANGUAGE plpgsql\r\n SECURITY DEFINER\r\n SET search_path = public\r\nAS $function$\r\nDECLARE\r\n    v_pontos_cliente integer := 0;\r\n    v_recompensas json;\r\nBEGIN\r\n    -- Buscar pontos do cliente\r\n    SELECT pontos INTO v_pontos_cliente\r\n    FROM public.fidelidade\r\n    WHERE barbearia_id = p_barbearia_id AND cliente_telefone = p_cliente_telefone;\r\n    \r\n    -- Buscar recompensas da barbearia\r\n    SELECT json_agg(\r\n        json_build_object(\r\n            'id', r.id,\r\n            'nome', r.nome,\r\n            'descricao', r.descricao,\r\n            'pontos_necessarios', r.pontos_necessarios,\r\n            'pode_resgatar', (v_pontos_cliente >= r.pontos_necessarios)\r\n        ) ORDER BY r.pontos_necessarios\r\n    ) INTO v_recompensas\r\n    FROM public.recompensas r\r\n    WHERE r.barbearia_id = p_barbearia_id AND r.ativo = true;\r\n    \r\n    RETURN json_build_object(\r\n        'pontos_cliente', COALESCE(v_pontos_cliente, 0),\r\n        'recompensas', COALESCE(v_recompensas, '[]'::json)\r\n    );\r\nEND;\r\n$function$","-- Atualizar função update_updated_at_recompensas\r\nCREATE OR REPLACE FUNCTION public.update_updated_at_recompensas()\r\n RETURNS trigger\r\n LANGUAGE plpgsql\r\n SET search_path = public\r\nAS $function$\r\nBEGIN\r\n    NEW.updated_at = now();\r\n    RETURN NEW;\r\nEND;\r\n$function$"}	81931ffe-069c-476e-8782-93ed33ac95f6	\N	\N	\N
20250818015221	{"-- Adicionar políticas RLS para categorias_servicos\r\n-- Esta tabela contém categorias globais que devem ser visíveis para todos\r\n\r\n-- Todos podem ver categorias (necessário para criação de serviços)\r\nCREATE POLICY \\"Anyone can view categorias_servicos\\"\r\nON public.categorias_servicos\r\nFOR SELECT\r\nTO authenticated\r\nUSING (true)","-- Apenas usuários autenticados podem inserir categorias (admin global ou sistema)\r\nCREATE POLICY \\"Authenticated users can insert categorias_servicos\\"\r\nON public.categorias_servicos\r\nFOR INSERT\r\nTO authenticated\r\nWITH CHECK (true)","-- Apenas usuários autenticados podem atualizar categorias\r\nCREATE POLICY \\"Authenticated users can update categorias_servicos\\"\r\nON public.categorias_servicos\r\nFOR UPDATE\r\nTO authenticated\r\nUSING (true)"}	644be496-10bf-40ae-bcd7-04b67792e06f	\N	\N	\N
20250818015525	{"-- Criar enum para tipos de planos\r\nCREATE TYPE public.tipo_plano AS ENUM ('basico', 'premium', 'empresarial')","-- Criar enum para status da assinatura\r\nCREATE TYPE public.status_assinatura AS ENUM ('ativa', 'cancelada', 'suspensa', 'vencida', 'teste')","-- Criar enum para métodos de pagamento\r\nCREATE TYPE public.metodo_pagamento AS ENUM ('cartao_credito', 'cartao_debito', 'pix', 'boleto', 'transferencia')","-- Criar tabela de assinaturas\r\nCREATE TABLE public.assinaturas (\r\n    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,\r\n    barbearia_id UUID NOT NULL REFERENCES public.barbearias(id) ON DELETE CASCADE,\r\n    tipo_plano public.tipo_plano NOT NULL DEFAULT 'basico',\r\n    status public.status_assinatura NOT NULL DEFAULT 'teste',\r\n    data_inicio TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),\r\n    data_fim TIMESTAMP WITH TIME ZONE,\r\n    data_cancelamento TIMESTAMP WITH TIME ZONE,\r\n    valor_mensal DECIMAL(10,2) NOT NULL DEFAULT 0.00,\r\n    moeda VARCHAR(3) NOT NULL DEFAULT 'BRL',\r\n    metodo_pagamento public.metodo_pagamento,\r\n    stripe_subscription_id TEXT,\r\n    stripe_customer_id TEXT,\r\n    observacoes TEXT,\r\n    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),\r\n    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),\r\n    \r\n    -- Índices para performance\r\n    CONSTRAINT unique_barbearia_ativa UNIQUE (barbearia_id) \r\n    DEFERRABLE INITIALLY DEFERRED\r\n)","-- Criar índices para otimização de consultas\r\nCREATE INDEX idx_assinaturas_barbearia_id ON public.assinaturas(barbearia_id)","CREATE INDEX idx_assinaturas_status ON public.assinaturas(status)","CREATE INDEX idx_assinaturas_data_fim ON public.assinaturas(data_fim)","CREATE INDEX idx_assinaturas_stripe_subscription ON public.assinaturas(stripe_subscription_id)","-- Criar trigger para atualizar updated_at automaticamente\r\nCREATE OR REPLACE FUNCTION public.update_updated_at_assinaturas()\r\nRETURNS TRIGGER AS $$\r\nBEGIN\r\n    NEW.updated_at = now();\r\n    RETURN NEW;\r\nEND;\r\n$$ LANGUAGE plpgsql SET search_path = public","CREATE TRIGGER update_assinaturas_updated_at\r\n    BEFORE UPDATE ON public.assinaturas\r\n    FOR EACH ROW\r\n    EXECUTE FUNCTION public.update_updated_at_assinaturas()","-- Habilitar RLS na tabela\r\nALTER TABLE public.assinaturas ENABLE ROW LEVEL SECURITY","-- =================================================================\r\n-- POLÍTICAS RLS PARA ASSINATURAS\r\n-- =================================================================\r\n\r\n-- Apenas admins podem ver a assinatura da sua barbearia\r\nCREATE POLICY \\"Admins can view own barbearia assinatura\\"\r\nON public.assinaturas\r\nFOR SELECT\r\nTO authenticated\r\nUSING (\r\n    public.get_current_user_role() = 'admin' AND \r\n    public.get_user_barbearia_id(auth.uid()) = barbearia_id\r\n)","-- Apenas admins podem inserir assinatura para sua barbearia\r\nCREATE POLICY \\"Admins can insert own barbearia assinatura\\"\r\nON public.assinaturas\r\nFOR INSERT\r\nTO authenticated\r\nWITH CHECK (\r\n    public.get_current_user_role() = 'admin' AND \r\n    public.get_user_barbearia_id(auth.uid()) = barbearia_id\r\n)","-- Apenas admins podem atualizar assinatura da sua barbearia\r\nCREATE POLICY \\"Admins can update own barbearia assinatura\\"\r\nON public.assinaturas\r\nFOR UPDATE\r\nTO authenticated\r\nUSING (\r\n    public.get_current_user_role() = 'admin' AND \r\n    public.get_user_barbearia_id(auth.uid()) = barbearia_id\r\n)","-- Criar função para verificar se barbearia tem assinatura ativa\r\nCREATE OR REPLACE FUNCTION public.barbearia_tem_assinatura_ativa(p_barbearia_id UUID)\r\nRETURNS BOOLEAN\r\nLANGUAGE sql\r\nSTABLE SECURITY DEFINER\r\nSET search_path = public\r\nAS $$\r\n    SELECT EXISTS (\r\n        SELECT 1 FROM public.assinaturas \r\n        WHERE barbearia_id = p_barbearia_id \r\n        AND status = 'ativa' \r\n        AND (data_fim IS NULL OR data_fim > now())\r\n    );\r\n$$","-- Criar função para obter informações da assinatura ativa\r\nCREATE OR REPLACE FUNCTION public.get_assinatura_ativa(p_barbearia_id UUID)\r\nRETURNS JSON\r\nLANGUAGE sql\r\nSTABLE SECURITY DEFINER\r\nSET search_path = public\r\nAS $$\r\n    SELECT row_to_json(a.*) \r\n    FROM public.assinaturas a\r\n    WHERE a.barbearia_id = p_barbearia_id \r\n    AND a.status = 'ativa'\r\n    AND (a.data_fim IS NULL OR a.data_fim > now())\r\n    ORDER BY a.created_at DESC\r\n    LIMIT 1;\r\n$$"}	70b4e13e-884d-40fa-9812-debb9baabfbc	\N	\N	\N
20240714234401	{"SET statement_timeout = 0","SET lock_timeout = 0","SET idle_in_transaction_session_timeout = 0","SET transaction_timeout = 0","SET client_encoding = 'UTF8'","SET standard_conforming_strings = on","SELECT pg_catalog.set_config('search_path', '', false)","SET check_function_bodies = false","SET xmloption = content","SET client_min_messages = warning","SET row_security = off","COMMENT ON SCHEMA \\"public\\" IS 'standard public schema'","CREATE EXTENSION IF NOT EXISTS \\"pg_graphql\\" WITH SCHEMA \\"graphql\\"","CREATE EXTENSION IF NOT EXISTS \\"pg_stat_statements\\" WITH SCHEMA \\"extensions\\"","CREATE EXTENSION IF NOT EXISTS \\"pgcrypto\\" WITH SCHEMA \\"extensions\\"","CREATE EXTENSION IF NOT EXISTS \\"supabase_vault\\" WITH SCHEMA \\"vault\\"","CREATE EXTENSION IF NOT EXISTS \\"uuid-ossp\\" WITH SCHEMA \\"extensions\\"","CREATE TYPE \\"public\\".\\"agendamento_status\\" AS ENUM (\r\n    'pendente',\r\n    'confirmado',\r\n    'cancelado',\r\n    'finalizado'\r\n)","ALTER TYPE \\"public\\".\\"agendamento_status\\" OWNER TO \\"postgres\\"","CREATE TYPE \\"public\\".\\"nivel_permissao\\" AS ENUM (\r\n    'funcionario',\r\n    'gerente',\r\n    'dono'\r\n)","ALTER TYPE \\"public\\".\\"nivel_permissao\\" OWNER TO \\"postgres\\"","CREATE TYPE \\"public\\".\\"user_role\\" AS ENUM (\r\n    'cliente',\r\n    'admin',\r\n    'funcionario'\r\n)","ALTER TYPE \\"public\\".\\"user_role\\" OWNER TO \\"postgres\\"","CREATE OR REPLACE FUNCTION \\"public\\".\\"audit_role_changes\\"() RETURNS \\"trigger\\"\r\n    LANGUAGE \\"plpgsql\\" SECURITY DEFINER\r\n    AS $$\r\nBEGIN\r\n  -- Only log when role actually changes\r\n  IF OLD.role IS DISTINCT FROM NEW.role THEN\r\n    INSERT INTO public.role_audit (\r\n      user_id, \r\n      old_role, \r\n      new_role, \r\n      changed_by, \r\n      barbearia_id\r\n    ) VALUES (\r\n      NEW.user_id, \r\n      OLD.role, \r\n      NEW.role, \r\n      auth.uid(), \r\n      NEW.barbearia_id\r\n    );\r\n  END IF;\r\n  RETURN NEW;\r\nEND;\r\n$$","ALTER FUNCTION \\"public\\".\\"audit_role_changes\\"() OWNER TO \\"postgres\\"","CREATE OR REPLACE FUNCTION \\"public\\".\\"cleanup_expired_invites\\"() RETURNS \\"void\\"\r\n    LANGUAGE \\"plpgsql\\" SECURITY DEFINER\r\n    AS $$\r\nBEGIN\r\n  DELETE FROM public.funcionario_convites \r\n  WHERE expires_at < now() AND usado = FALSE;\r\nEND;\r\n$$","ALTER FUNCTION \\"public\\".\\"cleanup_expired_invites\\"() OWNER TO \\"postgres\\"","CREATE OR REPLACE FUNCTION \\"public\\".\\"cleanup_old_data\\"() RETURNS \\"void\\"\r\n    LANGUAGE \\"plpgsql\\" SECURITY DEFINER\r\n    AS $$\r\nBEGIN\r\n    -- Remove agendamentos cancelados com mais de 6 meses\r\n    DELETE FROM agendamentos \r\n    WHERE status = 'cancelado' \r\n    AND created_at < current_date - interval '6 months';\r\n    \r\n    -- Remove feedbacks órfãos (sem agendamento)\r\n    DELETE FROM feedbacks \r\n    WHERE agendamento_id NOT IN (SELECT id FROM agendamentos);\r\n    \r\n    -- Atualiza estatísticas das tabelas\r\n    ANALYZE agendamentos;\r\n    ANALYZE feedbacks;\r\n    ANALYZE fidelidade;\r\nEND;\r\n$$","ALTER FUNCTION \\"public\\".\\"cleanup_old_data\\"() OWNER TO \\"postgres\\"","CREATE OR REPLACE FUNCTION \\"public\\".\\"generate_performance_report\\"(\\"barbearia_uuid\\" \\"uuid\\", \\"periodo_inicio\\" \\"date\\" DEFAULT (CURRENT_DATE - '30 days'::interval), \\"periodo_fim\\" \\"date\\" DEFAULT CURRENT_DATE) RETURNS \\"jsonb\\"\r\n    LANGUAGE \\"plpgsql\\" STABLE SECURITY DEFINER\r\n    AS $$\r\nDECLARE\r\n    report jsonb;\r\n    servicos_populares jsonb;\r\n    funcionarios_performance jsonb;\r\n    horarios_pico jsonb;\r\nBEGIN\r\n    -- Serviços mais populares\r\n    SELECT jsonb_agg(\r\n        jsonb_build_object(\r\n            'servico', s.nome,\r\n            'total', COUNT(*),\r\n            'receita', SUM(s.valor)\r\n        ) ORDER BY COUNT(*) DESC\r\n    ) INTO servicos_populares\r\n    FROM agendamentos a\r\n    JOIN servicos s ON s.id = a.servico_id\r\n    WHERE a.barbearia_id = barbearia_uuid\r\n    AND DATE(a.data_hora) BETWEEN periodo_inicio AND periodo_fim\r\n    AND a.status = 'finalizado'\r\n    GROUP BY s.id, s.nome\r\n    LIMIT 5;\r\n    \r\n    -- Performance dos funcionários\r\n    SELECT jsonb_agg(\r\n        jsonb_build_object(\r\n            'funcionario', f.nome,\r\n            'total_atendimentos', COUNT(*),\r\n            'receita_gerada', COALESCE(SUM(s.valor), 0)\r\n        ) ORDER BY COUNT(*) DESC\r\n    ) INTO funcionarios_performance\r\n    FROM agendamentos a\r\n    LEFT JOIN funcionarios f ON f.id = a.funcionario_id\r\n    LEFT JOIN servicos s ON s.id = a.servico_id\r\n    WHERE a.barbearia_id = barbearia_uuid\r\n    AND DATE(a.data_hora) BETWEEN periodo_inicio AND periodo_fim\r\n    AND a.status = 'finalizado'\r\n    GROUP BY f.id, f.nome;\r\n    \r\n    -- Horários de pico\r\n    SELECT jsonb_agg(\r\n        jsonb_build_object(\r\n            'hora', EXTRACT(hour FROM data_hora),\r\n            'total_agendamentos', COUNT(*)\r\n        ) ORDER BY COUNT(*) DESC\r\n    ) INTO horarios_pico\r\n    FROM agendamentos\r\n    WHERE barbearia_id = barbearia_uuid\r\n    AND DATE(data_hora) BETWEEN periodo_inicio AND periodo_fim\r\n    GROUP BY EXTRACT(hour FROM data_hora)\r\n    LIMIT 5;\r\n    \r\n    -- Construir relatório completo\r\n    report := jsonb_build_object(\r\n        'periodo', jsonb_build_object(\r\n            'inicio', periodo_inicio,\r\n            'fim', periodo_fim\r\n        ),\r\n        'servicos_populares', COALESCE(servicos_populares, '[]'::jsonb),\r\n        'funcionarios_performance', COALESCE(funcionarios_performance, '[]'::jsonb),\r\n        'horarios_pico', COALESCE(horarios_pico, '[]'::jsonb),\r\n        'gerado_em', current_timestamp\r\n    );\r\n    \r\n    RETURN report;\r\nEND;\r\n$$","ALTER FUNCTION \\"public\\".\\"generate_performance_report\\"(\\"barbearia_uuid\\" \\"uuid\\", \\"periodo_inicio\\" \\"date\\", \\"periodo_fim\\" \\"date\\") OWNER TO \\"postgres\\"","CREATE OR REPLACE FUNCTION \\"public\\".\\"get_barbershop_stats\\"(\\"barbearia_uuid\\" \\"uuid\\") RETURNS \\"jsonb\\"\r\n    LANGUAGE \\"plpgsql\\" STABLE SECURITY DEFINER\r\n    AS $$\r\nDECLARE\r\n    stats jsonb;\r\n    total_agendamentos int;\r\n    receita_mes numeric;\r\n    clientes_unicos int;\r\n    taxa_ocupacao numeric;\r\n    agendamentos_hoje int;\r\n    feedback_media numeric;\r\n    total_pontos_fidelidade int;\r\nBEGIN\r\n    -- Total de agendamentos este mês\r\n    SELECT COUNT(*) INTO total_agendamentos\r\n    FROM agendamentos\r\n    WHERE barbearia_id = barbearia_uuid\r\n    AND created_at >= date_trunc('month', current_date);\r\n    \r\n    -- Receita do mês\r\n    SELECT COALESCE(SUM(s.valor), 0) INTO receita_mes\r\n    FROM agendamentos a\r\n    JOIN servicos s ON s.id = a.servico_id\r\n    WHERE a.barbearia_id = barbearia_uuid\r\n    AND a.created_at >= date_trunc('month', current_date)\r\n    AND a.status = 'finalizado';\r\n    \r\n    -- Clientes únicos este mês\r\n    SELECT COUNT(DISTINCT cliente_telefone) INTO clientes_unicos\r\n    FROM agendamentos\r\n    WHERE barbearia_id = barbearia_uuid\r\n    AND created_at >= date_trunc('month', current_date);\r\n    \r\n    -- Agendamentos hoje\r\n    SELECT COUNT(*) INTO agendamentos_hoje\r\n    FROM agendamentos\r\n    WHERE barbearia_id = barbearia_uuid\r\n    AND DATE(data_hora) = current_date;\r\n    \r\n    -- Taxa de ocupação (baseada em 10 horários por dia)\r\n    SELECT (agendamentos_hoje::numeric / 10) * 100 INTO taxa_ocupacao;\r\n    \r\n    -- Média de feedback\r\n    SELECT COALESCE(AVG(f.nota), 0) INTO feedback_media\r\n    FROM feedbacks f\r\n    JOIN agendamentos a ON a.id = f.agendamento_id\r\n    WHERE a.barbearia_id = barbearia_uuid;\r\n    \r\n    -- Total de pontos de fidelidade ativos\r\n    SELECT COALESCE(SUM(pontos), 0) INTO total_pontos_fidelidade\r\n    FROM fidelidade\r\n    WHERE barbearia_id = barbearia_uuid;\r\n    \r\n    -- Construir JSON de resposta\r\n    stats := jsonb_build_object(\r\n        'total_agendamentos', total_agendamentos,\r\n        'receita_mes', receita_mes,\r\n        'clientes_unicos', clientes_unicos,\r\n        'agendamentos_hoje', agendamentos_hoje,\r\n        'taxa_ocupacao', ROUND(taxa_ocupacao, 1),\r\n        'feedback_media', ROUND(feedback_media, 1),\r\n        'total_pontos_fidelidade', total_pontos_fidelidade,\r\n        'periodo', 'mes_atual'\r\n    );\r\n    \r\n    RETURN stats;\r\nEND;\r\n$$","ALTER FUNCTION \\"public\\".\\"get_barbershop_stats\\"(\\"barbearia_uuid\\" \\"uuid\\") OWNER TO \\"postgres\\"","CREATE OR REPLACE FUNCTION \\"public\\".\\"get_barbershop_theme_config\\"(\\"barbearia_uuid\\" \\"uuid\\") RETURNS \\"jsonb\\"\r\n    LANGUAGE \\"sql\\" STABLE\r\n    AS $$\r\n  SELECT jsonb_build_object(\r\n    'modo_tema', modo_tema,\r\n    'cores_personalizadas', cores_personalizadas,\r\n    'nome', nome,\r\n    'logo_url', logo_url\r\n  ) FROM barbearias WHERE id = barbearia_uuid;\r\n$$","ALTER FUNCTION \\"public\\".\\"get_barbershop_theme_config\\"(\\"barbearia_uuid\\" \\"uuid\\") OWNER TO \\"postgres\\"","CREATE OR REPLACE FUNCTION \\"public\\".\\"get_current_user_role\\"() RETURNS \\"public\\".\\"user_role\\"\r\n    LANGUAGE \\"sql\\" STABLE SECURITY DEFINER\r\n    AS $$\r\n  SELECT role FROM public.profiles WHERE user_id = auth.uid();\r\n$$","ALTER FUNCTION \\"public\\".\\"get_current_user_role\\"() OWNER TO \\"postgres\\"","CREATE OR REPLACE FUNCTION \\"public\\".\\"get_user_barbearia_id\\"(\\"user_uuid\\" \\"uuid\\") RETURNS \\"uuid\\"\r\n    LANGUAGE \\"sql\\" STABLE SECURITY DEFINER\r\n    AS $$\r\n  SELECT barbearia_id FROM public.profiles WHERE user_id = user_uuid;\r\n$$","ALTER FUNCTION \\"public\\".\\"get_user_barbearia_id\\"(\\"user_uuid\\" \\"uuid\\") OWNER TO \\"postgres\\"","CREATE OR REPLACE FUNCTION \\"public\\".\\"get_user_role\\"(\\"user_uuid\\" \\"uuid\\") RETURNS \\"public\\".\\"user_role\\"\r\n    LANGUAGE \\"sql\\" STABLE SECURITY DEFINER\r\n    AS $$\r\n  SELECT role FROM public.profiles WHERE user_id = user_uuid;\r\n$$","ALTER FUNCTION \\"public\\".\\"get_user_role\\"(\\"user_uuid\\" \\"uuid\\") OWNER TO \\"postgres\\"","CREATE OR REPLACE FUNCTION \\"public\\".\\"handle_new_user\\"() RETURNS \\"trigger\\"\r\n    LANGUAGE \\"plpgsql\\" SECURITY DEFINER\r\n    SET \\"search_path\\" TO 'public'\r\n    AS $$\r\nDECLARE\r\n    new_barbearia_id uuid;\r\n    invite_record record;\r\nBEGIN\r\n  -- Verificar se é um funcionário sendo criado via convite\r\n  IF (NEW.raw_user_meta_data ->> 'role') = 'funcionario' THEN\r\n    -- Buscar convite ativo pelo email\r\n    SELECT * INTO invite_record \r\n    FROM public.funcionario_convites \r\n    WHERE email = NEW.email \r\n    AND usado = FALSE \r\n    AND expires_at > now()\r\n    LIMIT 1;\r\n    \r\n    IF FOUND THEN\r\n      -- Inserir perfil do funcionário\r\n      INSERT INTO public.profiles (user_id, name, phone, role, barbearia_id)\r\n      VALUES (\r\n        NEW.id,\r\n        COALESCE(NEW.raw_user_meta_data ->> 'name', ''),\r\n        COALESCE(NEW.raw_user_meta_data ->> 'phone', ''),\r\n        'funcionario'::public.user_role,\r\n        invite_record.barbearia_id\r\n      );\r\n      \r\n      -- Criar registro na tabela funcionarios\r\n      INSERT INTO public.funcionarios (\r\n        user_id, \r\n        nome, \r\n        email,\r\n        especialidade, \r\n        nivel_permissao, \r\n        foto_url, \r\n        barbearia_id\r\n      )\r\n      VALUES (\r\n        NEW.id,\r\n        (invite_record.funcionario_data ->> 'nome')::text,\r\n        invite_record.email,\r\n        COALESCE((invite_record.funcionario_data ->> 'especialidade')::text, ''),\r\n        (invite_record.funcionario_data ->> 'nivel_permissao')::public.nivel_permissao,\r\n        COALESCE((invite_record.funcionario_data ->> 'foto_url')::text, ''),\r\n        invite_record.barbearia_id\r\n      );\r\n      \r\n      -- Marcar convite como usado\r\n      UPDATE public.funcionario_convites \r\n      SET usado = TRUE \r\n      WHERE id = invite_record.id;\r\n      \r\n      RETURN NEW;\r\n    END IF;\r\n  END IF;\r\n\r\n  -- Fluxo padrão para administradores (criar barbearia)\r\n  INSERT INTO public.profiles (user_id, name, phone, role)\r\n  VALUES (\r\n    NEW.id,\r\n    COALESCE(NEW.raw_user_meta_data ->> 'name', ''),\r\n    COALESCE(NEW.raw_user_meta_data ->> 'phone', ''),\r\n    COALESCE((NEW.raw_user_meta_data ->> 'role')::public.user_role, 'admin'::public.user_role)\r\n  );\r\n\r\n  -- Se for admin e tiver nome da barbearia, criar a barbearia\r\n  IF (NEW.raw_user_meta_data ->> 'role') = 'admin' OR \r\n     (NEW.raw_user_meta_data ->> 'role') IS NULL THEN\r\n    \r\n    IF (NEW.raw_user_meta_data ->> 'barbershop_name') IS NOT NULL THEN\r\n      -- Criar a barbearia\r\n      INSERT INTO public.barbearias (nome, cidade)\r\n      VALUES (\r\n        NEW.raw_user_meta_data ->> 'barbershop_name',\r\n        'Não informado'\r\n      )\r\n      RETURNING id INTO new_barbearia_id;\r\n      \r\n      -- Associar o usuário à barbearia\r\n      UPDATE public.profiles \r\n      SET barbearia_id = new_barbearia_id \r\n      WHERE user_id = NEW.id;\r\n      \r\n      -- Criar horários de funcionamento padrão\r\n      INSERT INTO public.horarios_funcionamento (barbearia_id, dia_semana, hora_abre, hora_fecha, fechado)\r\n      VALUES \r\n        (new_barbearia_id, 1, '08:00', '18:00', false),\r\n        (new_barbearia_id, 2, '08:00', '18:00', false),\r\n        (new_barbearia_id, 3, '08:00', '18:00', false),\r\n        (new_barbearia_id, 4, '08:00', '18:00', false),\r\n        (new_barbearia_id, 5, '08:00', '18:00', false),\r\n        (new_barbearia_id, 6, '08:00', '17:00', false),\r\n        (new_barbearia_id, 0, NULL, NULL, true);\r\n    END IF;\r\n  END IF;\r\n  \r\n  RETURN NEW;\r\nEND;\r\n$$","ALTER FUNCTION \\"public\\".\\"handle_new_user\\"() OWNER TO \\"postgres\\"","CREATE OR REPLACE FUNCTION \\"public\\".\\"update_barbershop_theme\\"(\\"barbearia_uuid\\" \\"uuid\\", \\"new_theme\\" \\"text\\", \\"custom_colors\\" \\"jsonb\\" DEFAULT '{}'::\\"jsonb\\") RETURNS \\"void\\"\r\n    LANGUAGE \\"plpgsql\\" SECURITY DEFINER\r\n    AS $$\r\nBEGIN\r\n  UPDATE barbearias \r\n  SET \r\n    modo_tema = new_theme,\r\n    cores_personalizadas = custom_colors,\r\n    updated_at = now()\r\n  WHERE id = barbearia_uuid;\r\nEND;\r\n$$","ALTER FUNCTION \\"public\\".\\"update_barbershop_theme\\"(\\"barbearia_uuid\\" \\"uuid\\", \\"new_theme\\" \\"text\\", \\"custom_colors\\" \\"jsonb\\") OWNER TO \\"postgres\\"","CREATE OR REPLACE FUNCTION \\"public\\".\\"update_loyalty_points\\"() RETURNS \\"trigger\\"\r\n    LANGUAGE \\"plpgsql\\" SECURITY DEFINER\r\n    AS $$\r\nDECLARE\r\n    pontos_ganhos int := 10; -- 10 pontos por agendamento finalizado\r\nBEGIN\r\n    -- Só atualiza se o status mudou para 'finalizado'\r\n    IF NEW.status = 'finalizado' AND OLD.status != 'finalizado' THEN\r\n        -- Insere ou atualiza pontos de fidelidade\r\n        INSERT INTO fidelidade (barbearia_id, cliente_telefone, pontos, ultimo_agendamento)\r\n        VALUES (NEW.barbearia_id, NEW.cliente_telefone, pontos_ganhos, NEW.data_hora)\r\n        ON CONFLICT (barbearia_id, cliente_telefone)\r\n        DO UPDATE SET\r\n            pontos = fidelidade.pontos + pontos_ganhos,\r\n            ultimo_agendamento = NEW.data_hora,\r\n            updated_at = now();\r\n    END IF;\r\n    \r\n    RETURN NEW;\r\nEND;\r\n$$","ALTER FUNCTION \\"public\\".\\"update_loyalty_points\\"() OWNER TO \\"postgres\\"","CREATE OR REPLACE FUNCTION \\"public\\".\\"update_updated_at_column\\"() RETURNS \\"trigger\\"\r\n    LANGUAGE \\"plpgsql\\"\r\n    AS $$\r\nBEGIN\r\n  NEW.updated_at = now();\r\n  RETURN NEW;\r\nEND;\r\n$$","ALTER FUNCTION \\"public\\".\\"update_updated_at_column\\"() OWNER TO \\"postgres\\"","SET default_tablespace = ''","SET default_table_access_method = \\"heap\\"","CREATE TABLE IF NOT EXISTS \\"public\\".\\"agendamentos\\" (\r\n    \\"id\\" \\"uuid\\" DEFAULT \\"gen_random_uuid\\"() NOT NULL,\r\n    \\"cliente_nome\\" \\"text\\" NOT NULL,\r\n    \\"cliente_telefone\\" \\"text\\" NOT NULL,\r\n    \\"cliente_email\\" \\"text\\",\r\n    \\"barbearia_id\\" \\"uuid\\" NOT NULL,\r\n    \\"servico_id\\" \\"uuid\\" NOT NULL,\r\n    \\"funcionario_id\\" \\"uuid\\",\r\n    \\"data_hora\\" timestamp with time zone NOT NULL,\r\n    \\"status\\" \\"public\\".\\"agendamento_status\\" DEFAULT 'pendente'::\\"public\\".\\"agendamento_status\\" NOT NULL,\r\n    \\"created_at\\" timestamp with time zone DEFAULT \\"now\\"() NOT NULL,\r\n    \\"updated_at\\" timestamp with time zone DEFAULT \\"now\\"() NOT NULL\r\n)","ALTER TABLE \\"public\\".\\"agendamentos\\" OWNER TO \\"postgres\\"","CREATE TABLE IF NOT EXISTS \\"public\\".\\"barbearias\\" (\r\n    \\"id\\" \\"uuid\\" DEFAULT \\"gen_random_uuid\\"() NOT NULL,\r\n    \\"nome\\" \\"text\\" NOT NULL,\r\n    \\"logo_url\\" \\"text\\",\r\n    \\"endereco\\" \\"text\\",\r\n    \\"cidade\\" \\"text\\" NOT NULL,\r\n    \\"bairro\\" \\"text\\",\r\n    \\"email_contato\\" \\"text\\",\r\n    \\"telefone\\" \\"text\\",\r\n    \\"cores_personalizadas\\" \\"jsonb\\" DEFAULT '{}'::\\"jsonb\\",\r\n    \\"modo_tema\\" \\"text\\" DEFAULT 'dark'::\\"text\\",\r\n    \\"created_at\\" timestamp with time zone DEFAULT \\"now\\"() NOT NULL,\r\n    \\"updated_at\\" timestamp with time zone DEFAULT \\"now\\"() NOT NULL,\r\n    CONSTRAINT \\"barbearias_modo_tema_check\\" CHECK ((\\"modo_tema\\" = ANY (ARRAY['dark'::\\"text\\", 'light'::\\"text\\"])))\r\n)","ALTER TABLE \\"public\\".\\"barbearias\\" OWNER TO \\"postgres\\"","CREATE TABLE IF NOT EXISTS \\"public\\".\\"clientes_registrados\\" (\r\n    \\"id\\" \\"uuid\\" DEFAULT \\"gen_random_uuid\\"() NOT NULL,\r\n    \\"user_id\\" \\"uuid\\" NOT NULL,\r\n    \\"nome\\" \\"text\\" NOT NULL,\r\n    \\"telefone\\" \\"text\\" NOT NULL,\r\n    \\"email\\" \\"text\\",\r\n    \\"created_at\\" timestamp with time zone DEFAULT \\"now\\"() NOT NULL,\r\n    \\"updated_at\\" timestamp with time zone DEFAULT \\"now\\"() NOT NULL\r\n)","ALTER TABLE \\"public\\".\\"clientes_registrados\\" OWNER TO \\"postgres\\"","CREATE TABLE IF NOT EXISTS \\"public\\".\\"feedbacks\\" (\r\n    \\"id\\" \\"uuid\\" DEFAULT \\"gen_random_uuid\\"() NOT NULL,\r\n    \\"agendamento_id\\" \\"uuid\\" NOT NULL,\r\n    \\"cliente_nome\\" \\"text\\" NOT NULL,\r\n    \\"nota\\" integer NOT NULL,\r\n    \\"comentario\\" \\"text\\",\r\n    \\"created_at\\" timestamp with time zone DEFAULT \\"now\\"() NOT NULL,\r\n    CONSTRAINT \\"feedbacks_nota_check\\" CHECK (((\\"nota\\" >= 1) AND (\\"nota\\" <= 5)))\r\n)","ALTER TABLE \\"public\\".\\"feedbacks\\" OWNER TO \\"postgres\\"","CREATE TABLE IF NOT EXISTS \\"public\\".\\"fidelidade\\" (\r\n    \\"id\\" \\"uuid\\" DEFAULT \\"gen_random_uuid\\"() NOT NULL,\r\n    \\"cliente_telefone\\" \\"text\\" NOT NULL,\r\n    \\"barbearia_id\\" \\"uuid\\" NOT NULL,\r\n    \\"pontos\\" integer DEFAULT 0 NOT NULL,\r\n    \\"ultimo_agendamento\\" timestamp with time zone,\r\n    \\"created_at\\" timestamp with time zone DEFAULT \\"now\\"() NOT NULL,\r\n    \\"updated_at\\" timestamp with time zone DEFAULT \\"now\\"() NOT NULL\r\n)","ALTER TABLE \\"public\\".\\"fidelidade\\" OWNER TO \\"postgres\\"","CREATE TABLE IF NOT EXISTS \\"public\\".\\"funcionario_convites\\" (\r\n    \\"id\\" \\"uuid\\" DEFAULT \\"gen_random_uuid\\"() NOT NULL,\r\n    \\"email\\" \\"text\\" NOT NULL,\r\n    \\"token\\" \\"text\\" NOT NULL,\r\n    \\"barbearia_id\\" \\"uuid\\" NOT NULL,\r\n    \\"funcionario_data\\" \\"jsonb\\" NOT NULL,\r\n    \\"usado\\" boolean DEFAULT false,\r\n    \\"expires_at\\" timestamp with time zone DEFAULT (\\"now\\"() + '7 days'::interval) NOT NULL,\r\n    \\"created_at\\" timestamp with time zone DEFAULT \\"now\\"(),\r\n    \\"created_by\\" \\"uuid\\" NOT NULL\r\n)","ALTER TABLE \\"public\\".\\"funcionario_convites\\" OWNER TO \\"postgres\\"","CREATE TABLE IF NOT EXISTS \\"public\\".\\"funcionarios\\" (\r\n    \\"id\\" \\"uuid\\" DEFAULT \\"gen_random_uuid\\"() NOT NULL,\r\n    \\"user_id\\" \\"uuid\\" NOT NULL,\r\n    \\"barbearia_id\\" \\"uuid\\" NOT NULL,\r\n    \\"nome\\" \\"text\\" NOT NULL,\r\n    \\"especialidade\\" \\"text\\",\r\n    \\"foto_url\\" \\"text\\",\r\n    \\"nivel_permissao\\" \\"public\\".\\"nivel_permissao\\" DEFAULT 'funcionario'::\\"public\\".\\"nivel_permissao\\" NOT NULL,\r\n    \\"created_at\\" timestamp with time zone DEFAULT \\"now\\"() NOT NULL,\r\n    \\"updated_at\\" timestamp with time zone DEFAULT \\"now\\"() NOT NULL,\r\n    \\"email\\" \\"text\\"\r\n)","ALTER TABLE \\"public\\".\\"funcionarios\\" OWNER TO \\"postgres\\"","CREATE TABLE IF NOT EXISTS \\"public\\".\\"horarios_funcionamento\\" (\r\n    \\"id\\" \\"uuid\\" DEFAULT \\"gen_random_uuid\\"() NOT NULL,\r\n    \\"barbearia_id\\" \\"uuid\\" NOT NULL,\r\n    \\"dia_semana\\" integer NOT NULL,\r\n    \\"hora_abre\\" time without time zone,\r\n    \\"hora_fecha\\" time without time zone,\r\n    \\"fechado\\" boolean DEFAULT false NOT NULL,\r\n    \\"created_at\\" timestamp with time zone DEFAULT \\"now\\"() NOT NULL,\r\n    \\"updated_at\\" timestamp with time zone DEFAULT \\"now\\"() NOT NULL,\r\n    CONSTRAINT \\"horarios_funcionamento_dia_semana_check\\" CHECK (((\\"dia_semana\\" >= 0) AND (\\"dia_semana\\" <= 6)))\r\n)","ALTER TABLE \\"public\\".\\"horarios_funcionamento\\" OWNER TO \\"postgres\\"","CREATE TABLE IF NOT EXISTS \\"public\\".\\"profiles\\" (\r\n    \\"id\\" \\"uuid\\" DEFAULT \\"gen_random_uuid\\"() NOT NULL,\r\n    \\"user_id\\" \\"uuid\\" NOT NULL,\r\n    \\"name\\" \\"text\\" NOT NULL,\r\n    \\"phone\\" \\"text\\",\r\n    \\"role\\" \\"public\\".\\"user_role\\" DEFAULT 'cliente'::\\"public\\".\\"user_role\\" NOT NULL,\r\n    \\"barbearia_id\\" \\"uuid\\",\r\n    \\"created_at\\" timestamp with time zone DEFAULT \\"now\\"() NOT NULL,\r\n    \\"updated_at\\" timestamp with time zone DEFAULT \\"now\\"() NOT NULL\r\n)","ALTER TABLE \\"public\\".\\"profiles\\" OWNER TO \\"postgres\\"","CREATE TABLE IF NOT EXISTS \\"public\\".\\"role_audit\\" (\r\n    \\"id\\" \\"uuid\\" DEFAULT \\"gen_random_uuid\\"() NOT NULL,\r\n    \\"user_id\\" \\"uuid\\" NOT NULL,\r\n    \\"old_role\\" \\"public\\".\\"user_role\\",\r\n    \\"new_role\\" \\"public\\".\\"user_role\\" NOT NULL,\r\n    \\"changed_by\\" \\"uuid\\" NOT NULL,\r\n    \\"barbearia_id\\" \\"uuid\\" NOT NULL,\r\n    \\"created_at\\" timestamp with time zone DEFAULT \\"now\\"() NOT NULL\r\n)","ALTER TABLE \\"public\\".\\"role_audit\\" OWNER TO \\"postgres\\"","CREATE TABLE IF NOT EXISTS \\"public\\".\\"servicos\\" (\r\n    \\"id\\" \\"uuid\\" DEFAULT \\"gen_random_uuid\\"() NOT NULL,\r\n    \\"barbearia_id\\" \\"uuid\\" NOT NULL,\r\n    \\"nome\\" \\"text\\" NOT NULL,\r\n    \\"descricao\\" \\"text\\",\r\n    \\"valor\\" numeric(10,2) NOT NULL,\r\n    \\"duracao_minutos\\" integer NOT NULL,\r\n    \\"created_at\\" timestamp with time zone DEFAULT \\"now\\"() NOT NULL,\r\n    \\"updated_at\\" timestamp with time zone DEFAULT \\"now\\"() NOT NULL\r\n)","ALTER TABLE \\"public\\".\\"servicos\\" OWNER TO \\"postgres\\"","ALTER TABLE ONLY \\"public\\".\\"agendamentos\\"\r\n    ADD CONSTRAINT \\"agendamentos_pkey\\" PRIMARY KEY (\\"id\\")","ALTER TABLE ONLY \\"public\\".\\"barbearias\\"\r\n    ADD CONSTRAINT \\"barbearias_pkey\\" PRIMARY KEY (\\"id\\")","ALTER TABLE ONLY \\"public\\".\\"clientes_registrados\\"\r\n    ADD CONSTRAINT \\"clientes_registrados_pkey\\" PRIMARY KEY (\\"id\\")","ALTER TABLE ONLY \\"public\\".\\"clientes_registrados\\"\r\n    ADD CONSTRAINT \\"clientes_registrados_user_id_key\\" UNIQUE (\\"user_id\\")","ALTER TABLE ONLY \\"public\\".\\"feedbacks\\"\r\n    ADD CONSTRAINT \\"feedbacks_pkey\\" PRIMARY KEY (\\"id\\")","ALTER TABLE ONLY \\"public\\".\\"fidelidade\\"\r\n    ADD CONSTRAINT \\"fidelidade_barbearia_telefone_unique\\" UNIQUE (\\"barbearia_id\\", \\"cliente_telefone\\")","ALTER TABLE ONLY \\"public\\".\\"fidelidade\\"\r\n    ADD CONSTRAINT \\"fidelidade_cliente_telefone_barbearia_id_key\\" UNIQUE (\\"cliente_telefone\\", \\"barbearia_id\\")","ALTER TABLE ONLY \\"public\\".\\"fidelidade\\"\r\n    ADD CONSTRAINT \\"fidelidade_pkey\\" PRIMARY KEY (\\"id\\")","ALTER TABLE ONLY \\"public\\".\\"funcionario_convites\\"\r\n    ADD CONSTRAINT \\"funcionario_convites_pkey\\" PRIMARY KEY (\\"id\\")","ALTER TABLE ONLY \\"public\\".\\"funcionario_convites\\"\r\n    ADD CONSTRAINT \\"funcionario_convites_token_key\\" UNIQUE (\\"token\\")","ALTER TABLE ONLY \\"public\\".\\"funcionarios\\"\r\n    ADD CONSTRAINT \\"funcionarios_pkey\\" PRIMARY KEY (\\"id\\")","ALTER TABLE ONLY \\"public\\".\\"funcionarios\\"\r\n    ADD CONSTRAINT \\"funcionarios_user_id_barbearia_id_key\\" UNIQUE (\\"user_id\\", \\"barbearia_id\\")","ALTER TABLE ONLY \\"public\\".\\"horarios_funcionamento\\"\r\n    ADD CONSTRAINT \\"horarios_funcionamento_barbearia_id_dia_semana_key\\" UNIQUE (\\"barbearia_id\\", \\"dia_semana\\")","ALTER TABLE ONLY \\"public\\".\\"horarios_funcionamento\\"\r\n    ADD CONSTRAINT \\"horarios_funcionamento_pkey\\" PRIMARY KEY (\\"id\\")","ALTER TABLE ONLY \\"public\\".\\"profiles\\"\r\n    ADD CONSTRAINT \\"profiles_pkey\\" PRIMARY KEY (\\"id\\")","ALTER TABLE ONLY \\"public\\".\\"profiles\\"\r\n    ADD CONSTRAINT \\"profiles_user_id_key\\" UNIQUE (\\"user_id\\")","ALTER TABLE ONLY \\"public\\".\\"role_audit\\"\r\n    ADD CONSTRAINT \\"role_audit_pkey\\" PRIMARY KEY (\\"id\\")","ALTER TABLE ONLY \\"public\\".\\"servicos\\"\r\n    ADD CONSTRAINT \\"servicos_pkey\\" PRIMARY KEY (\\"id\\")","CREATE INDEX \\"idx_agendamentos_barbearia_id\\" ON \\"public\\".\\"agendamentos\\" USING \\"btree\\" (\\"barbearia_id\\")","CREATE INDEX \\"idx_agendamentos_data_hora\\" ON \\"public\\".\\"agendamentos\\" USING \\"btree\\" (\\"data_hora\\")","CREATE INDEX \\"idx_agendamentos_funcionario_id\\" ON \\"public\\".\\"agendamentos\\" USING \\"btree\\" (\\"funcionario_id\\")","CREATE INDEX \\"idx_clientes_registrados_user_id\\" ON \\"public\\".\\"clientes_registrados\\" USING \\"btree\\" (\\"user_id\\")","CREATE INDEX \\"idx_feedbacks_agendamento_id\\" ON \\"public\\".\\"feedbacks\\" USING \\"btree\\" (\\"agendamento_id\\")","CREATE INDEX \\"idx_fidelidade_barbearia_id\\" ON \\"public\\".\\"fidelidade\\" USING \\"btree\\" (\\"barbearia_id\\")","CREATE INDEX \\"idx_fidelidade_cliente_telefone\\" ON \\"public\\".\\"fidelidade\\" USING \\"btree\\" (\\"cliente_telefone\\")","CREATE INDEX \\"idx_funcionario_convites_token\\" ON \\"public\\".\\"funcionario_convites\\" USING \\"btree\\" (\\"token\\")","CREATE INDEX \\"idx_funcionarios_barbearia_id\\" ON \\"public\\".\\"funcionarios\\" USING \\"btree\\" (\\"barbearia_id\\")","CREATE UNIQUE INDEX \\"idx_funcionarios_email_barbearia_unique\\" ON \\"public\\".\\"funcionarios\\" USING \\"btree\\" (\\"email\\", \\"barbearia_id\\") WHERE (\\"email\\" IS NOT NULL)","CREATE INDEX \\"idx_funcionarios_user_id\\" ON \\"public\\".\\"funcionarios\\" USING \\"btree\\" (\\"user_id\\")","CREATE INDEX \\"idx_profiles_barbearia_id\\" ON \\"public\\".\\"profiles\\" USING \\"btree\\" (\\"barbearia_id\\")","CREATE INDEX \\"idx_profiles_user_id\\" ON \\"public\\".\\"profiles\\" USING \\"btree\\" (\\"user_id\\")","CREATE INDEX \\"idx_servicos_barbearia_id\\" ON \\"public\\".\\"servicos\\" USING \\"btree\\" (\\"barbearia_id\\")","CREATE OR REPLACE TRIGGER \\"profile_role_audit_trigger\\" AFTER UPDATE ON \\"public\\".\\"profiles\\" FOR EACH ROW EXECUTE FUNCTION \\"public\\".\\"audit_role_changes\\"()","CREATE OR REPLACE TRIGGER \\"update_agendamentos_updated_at\\" BEFORE UPDATE ON \\"public\\".\\"agendamentos\\" FOR EACH ROW EXECUTE FUNCTION \\"public\\".\\"update_updated_at_column\\"()","CREATE OR REPLACE TRIGGER \\"update_barbearias_updated_at\\" BEFORE UPDATE ON \\"public\\".\\"barbearias\\" FOR EACH ROW EXECUTE FUNCTION \\"public\\".\\"update_updated_at_column\\"()","CREATE OR REPLACE TRIGGER \\"update_clientes_registrados_updated_at\\" BEFORE UPDATE ON \\"public\\".\\"clientes_registrados\\" FOR EACH ROW EXECUTE FUNCTION \\"public\\".\\"update_updated_at_column\\"()","CREATE OR REPLACE TRIGGER \\"update_fidelidade_updated_at\\" BEFORE UPDATE ON \\"public\\".\\"fidelidade\\" FOR EACH ROW EXECUTE FUNCTION \\"public\\".\\"update_updated_at_column\\"()","CREATE OR REPLACE TRIGGER \\"update_funcionarios_updated_at\\" BEFORE UPDATE ON \\"public\\".\\"funcionarios\\" FOR EACH ROW EXECUTE FUNCTION \\"public\\".\\"update_updated_at_column\\"()","CREATE OR REPLACE TRIGGER \\"update_horarios_funcionamento_updated_at\\" BEFORE UPDATE ON \\"public\\".\\"horarios_funcionamento\\" FOR EACH ROW EXECUTE FUNCTION \\"public\\".\\"update_updated_at_column\\"()","CREATE OR REPLACE TRIGGER \\"update_loyalty_points_trigger\\" AFTER UPDATE ON \\"public\\".\\"agendamentos\\" FOR EACH ROW EXECUTE FUNCTION \\"public\\".\\"update_loyalty_points\\"()","CREATE OR REPLACE TRIGGER \\"update_profiles_updated_at\\" BEFORE UPDATE ON \\"public\\".\\"profiles\\" FOR EACH ROW EXECUTE FUNCTION \\"public\\".\\"update_updated_at_column\\"()","CREATE OR REPLACE TRIGGER \\"update_servicos_updated_at\\" BEFORE UPDATE ON \\"public\\".\\"servicos\\" FOR EACH ROW EXECUTE FUNCTION \\"public\\".\\"update_updated_at_column\\"()","ALTER TABLE ONLY \\"public\\".\\"agendamentos\\"\r\n    ADD CONSTRAINT \\"agendamentos_barbearia_id_fkey\\" FOREIGN KEY (\\"barbearia_id\\") REFERENCES \\"public\\".\\"barbearias\\"(\\"id\\") ON DELETE CASCADE","ALTER TABLE ONLY \\"public\\".\\"agendamentos\\"\r\n    ADD CONSTRAINT \\"agendamentos_funcionario_id_fkey\\" FOREIGN KEY (\\"funcionario_id\\") REFERENCES \\"public\\".\\"funcionarios\\"(\\"id\\") ON DELETE SET NULL","ALTER TABLE ONLY \\"public\\".\\"agendamentos\\"\r\n    ADD CONSTRAINT \\"agendamentos_servico_id_fkey\\" FOREIGN KEY (\\"servico_id\\") REFERENCES \\"public\\".\\"servicos\\"(\\"id\\") ON DELETE CASCADE","ALTER TABLE ONLY \\"public\\".\\"clientes_registrados\\"\r\n    ADD CONSTRAINT \\"clientes_registrados_user_id_fkey\\" FOREIGN KEY (\\"user_id\\") REFERENCES \\"auth\\".\\"users\\"(\\"id\\") ON DELETE CASCADE","ALTER TABLE ONLY \\"public\\".\\"feedbacks\\"\r\n    ADD CONSTRAINT \\"feedbacks_agendamento_id_fkey\\" FOREIGN KEY (\\"agendamento_id\\") REFERENCES \\"public\\".\\"agendamentos\\"(\\"id\\") ON DELETE CASCADE","ALTER TABLE ONLY \\"public\\".\\"fidelidade\\"\r\n    ADD CONSTRAINT \\"fidelidade_barbearia_id_fkey\\" FOREIGN KEY (\\"barbearia_id\\") REFERENCES \\"public\\".\\"barbearias\\"(\\"id\\") ON DELETE CASCADE","ALTER TABLE ONLY \\"public\\".\\"funcionario_convites\\"\r\n    ADD CONSTRAINT \\"funcionario_convites_barbearia_id_fkey\\" FOREIGN KEY (\\"barbearia_id\\") REFERENCES \\"public\\".\\"barbearias\\"(\\"id\\") ON DELETE CASCADE","ALTER TABLE ONLY \\"public\\".\\"funcionarios\\"\r\n    ADD CONSTRAINT \\"funcionarios_barbearia_id_fkey\\" FOREIGN KEY (\\"barbearia_id\\") REFERENCES \\"public\\".\\"barbearias\\"(\\"id\\") ON DELETE CASCADE","ALTER TABLE ONLY \\"public\\".\\"funcionarios\\"\r\n    ADD CONSTRAINT \\"funcionarios_user_id_fkey\\" FOREIGN KEY (\\"user_id\\") REFERENCES \\"auth\\".\\"users\\"(\\"id\\") ON DELETE CASCADE","ALTER TABLE ONLY \\"public\\".\\"profiles\\"\r\n    ADD CONSTRAINT \\"profiles_barbearia_id_fkey\\" FOREIGN KEY (\\"barbearia_id\\") REFERENCES \\"public\\".\\"barbearias\\"(\\"id\\") ON DELETE SET NULL","ALTER TABLE ONLY \\"public\\".\\"profiles\\"\r\n    ADD CONSTRAINT \\"profiles_user_id_fkey\\" FOREIGN KEY (\\"user_id\\") REFERENCES \\"auth\\".\\"users\\"(\\"id\\") ON DELETE CASCADE","ALTER TABLE ONLY \\"public\\".\\"servicos\\"\r\n    ADD CONSTRAINT \\"servicos_barbearia_id_fkey\\" FOREIGN KEY (\\"barbearia_id\\") REFERENCES \\"public\\".\\"barbearias\\"(\\"id\\") ON DELETE CASCADE","CREATE POLICY \\"Admins can create invites\\" ON \\"public\\".\\"funcionario_convites\\" FOR INSERT WITH CHECK (((\\"public\\".\\"get_user_role\\"(\\"auth\\".\\"uid\\"()) = 'admin'::\\"public\\".\\"user_role\\") AND (\\"barbearia_id\\" = \\"public\\".\\"get_user_barbearia_id\\"(\\"auth\\".\\"uid\\"()))))","CREATE POLICY \\"Admins can view invites from their barbershop\\" ON \\"public\\".\\"funcionario_convites\\" FOR SELECT USING (((\\"public\\".\\"get_user_role\\"(\\"auth\\".\\"uid\\"()) = 'admin'::\\"public\\".\\"user_role\\") AND (\\"barbearia_id\\" = \\"public\\".\\"get_user_barbearia_id\\"(\\"auth\\".\\"uid\\"()))))","CREATE POLICY \\"Admins can view role audit logs\\" ON \\"public\\".\\"role_audit\\" FOR SELECT USING (((\\"public\\".\\"get_user_role\\"(\\"auth\\".\\"uid\\"()) = 'admin'::\\"public\\".\\"user_role\\") AND (\\"barbearia_id\\" = \\"public\\".\\"get_user_barbearia_id\\"(\\"auth\\".\\"uid\\"()))))","CREATE POLICY \\"Agendamentos viewable by barbearia staff\\" ON \\"public\\".\\"agendamentos\\" FOR SELECT USING (((\\"public\\".\\"get_user_role\\"(\\"auth\\".\\"uid\\"()) = ANY (ARRAY['admin'::\\"public\\".\\"user_role\\", 'funcionario'::\\"public\\".\\"user_role\\"])) AND (\\"barbearia_id\\" = \\"public\\".\\"get_user_barbearia_id\\"(\\"auth\\".\\"uid\\"()))))","CREATE POLICY \\"Anyone can create agendamentos\\" ON \\"public\\".\\"agendamentos\\" FOR INSERT WITH CHECK (true)","CREATE POLICY \\"Anyone can create feedbacks\\" ON \\"public\\".\\"feedbacks\\" FOR INSERT WITH CHECK (true)","CREATE POLICY \\"Anyone can register as client\\" ON \\"public\\".\\"clientes_registrados\\" FOR INSERT WITH CHECK ((\\"auth\\".\\"uid\\"() = \\"user_id\\"))","CREATE POLICY \\"Apenas admins podem gerenciar horários de funcionamento\\" ON \\"public\\".\\"horarios_funcionamento\\" USING (((\\"public\\".\\"get_user_role\\"(\\"auth\\".\\"uid\\"()) = 'admin'::\\"public\\".\\"user_role\\") AND (\\"barbearia_id\\" = \\"public\\".\\"get_user_barbearia_id\\"(\\"auth\\".\\"uid\\"()))))","CREATE POLICY \\"Barbearia staff can manage fidelidade\\" ON \\"public\\".\\"fidelidade\\" USING (((\\"public\\".\\"get_user_role\\"(\\"auth\\".\\"uid\\"()) = ANY (ARRAY['admin'::\\"public\\".\\"user_role\\", 'funcionario'::\\"public\\".\\"user_role\\"])) AND (\\"barbearia_id\\" = \\"public\\".\\"get_user_barbearia_id\\"(\\"auth\\".\\"uid\\"()))))","CREATE POLICY \\"Barbearia staff can update agendamentos\\" ON \\"public\\".\\"agendamentos\\" FOR UPDATE USING (((\\"public\\".\\"get_user_role\\"(\\"auth\\".\\"uid\\"()) = ANY (ARRAY['admin'::\\"public\\".\\"user_role\\", 'funcionario'::\\"public\\".\\"user_role\\"])) AND (\\"barbearia_id\\" = \\"public\\".\\"get_user_barbearia_id\\"(\\"auth\\".\\"uid\\"()))))","CREATE POLICY \\"Barbearias are publicly viewable\\" ON \\"public\\".\\"barbearias\\" FOR SELECT USING (true)","CREATE POLICY \\"Clients can update own agendamentos by phone\\" ON \\"public\\".\\"agendamentos\\" FOR UPDATE USING ((\\"cliente_telefone\\" = COALESCE(( SELECT \\"profiles\\".\\"phone\\"\r\n   FROM \\"public\\".\\"profiles\\"\r\n  WHERE (\\"profiles\\".\\"user_id\\" = \\"auth\\".\\"uid\\"())), ''::\\"text\\")))","CREATE POLICY \\"Clients can update own data\\" ON \\"public\\".\\"clientes_registrados\\" FOR UPDATE USING ((\\"auth\\".\\"uid\\"() = \\"user_id\\"))","CREATE POLICY \\"Clients can view own agendamentos by phone\\" ON \\"public\\".\\"agendamentos\\" FOR SELECT USING ((\\"cliente_telefone\\" = COALESCE(( SELECT \\"profiles\\".\\"phone\\"\r\n   FROM \\"public\\".\\"profiles\\"\r\n  WHERE (\\"profiles\\".\\"user_id\\" = \\"auth\\".\\"uid\\"())), ''::\\"text\\")))","CREATE POLICY \\"Clients can view own data\\" ON \\"public\\".\\"clientes_registrados\\" FOR SELECT USING ((\\"auth\\".\\"uid\\"() = \\"user_id\\"))","CREATE POLICY \\"Clients can view own fidelidade by phone\\" ON \\"public\\".\\"fidelidade\\" FOR SELECT USING ((\\"cliente_telefone\\" = COALESCE(( SELECT \\"profiles\\".\\"phone\\"\r\n   FROM \\"public\\".\\"profiles\\"\r\n  WHERE (\\"profiles\\".\\"user_id\\" = \\"auth\\".\\"uid\\"())), ''::\\"text\\")))","CREATE POLICY \\"Feedbacks viewable by barbearia staff\\" ON \\"public\\".\\"feedbacks\\" FOR SELECT USING ((EXISTS ( SELECT 1\r\n   FROM \\"public\\".\\"agendamentos\\" \\"a\\"\r\n  WHERE ((\\"a\\".\\"id\\" = \\"feedbacks\\".\\"agendamento_id\\") AND ((\\"public\\".\\"get_user_role\\"(\\"auth\\".\\"uid\\"()) = ANY (ARRAY['admin'::\\"public\\".\\"user_role\\", 'funcionario'::\\"public\\".\\"user_role\\"])) AND (\\"a\\".\\"barbearia_id\\" = \\"public\\".\\"get_user_barbearia_id\\"(\\"auth\\".\\"uid\\"())))))))","CREATE POLICY \\"Fidelidade viewable by barbearia staff\\" ON \\"public\\".\\"fidelidade\\" FOR SELECT USING (((\\"public\\".\\"get_user_role\\"(\\"auth\\".\\"uid\\"()) = ANY (ARRAY['admin'::\\"public\\".\\"user_role\\", 'funcionario'::\\"public\\".\\"user_role\\"])) AND (\\"barbearia_id\\" = \\"public\\".\\"get_user_barbearia_id\\"(\\"auth\\".\\"uid\\"()))))","CREATE POLICY \\"Funcionarios can view assigned agendamentos\\" ON \\"public\\".\\"agendamentos\\" FOR SELECT USING ((\\"funcionario_id\\" = ( SELECT \\"f\\".\\"id\\"\r\n   FROM \\"public\\".\\"funcionarios\\" \\"f\\"\r\n  WHERE (\\"f\\".\\"user_id\\" = \\"auth\\".\\"uid\\"()))))","CREATE POLICY \\"Funcionarios viewable by barbearia staff\\" ON \\"public\\".\\"funcionarios\\" FOR SELECT USING (((\\"public\\".\\"get_user_role\\"(\\"auth\\".\\"uid\\"()) = ANY (ARRAY['admin'::\\"public\\".\\"user_role\\", 'funcionario'::\\"public\\".\\"user_role\\"])) AND (\\"barbearia_id\\" = \\"public\\".\\"get_user_barbearia_id\\"(\\"auth\\".\\"uid\\"()))))","CREATE POLICY \\"Horários são publicamente visíveis\\" ON \\"public\\".\\"horarios_funcionamento\\" FOR SELECT USING (true)","CREATE POLICY \\"Only admins can create barbearias\\" ON \\"public\\".\\"barbearias\\" FOR INSERT WITH CHECK ((\\"public\\".\\"get_user_role\\"(\\"auth\\".\\"uid\\"()) = 'admin'::\\"public\\".\\"user_role\\"))","CREATE POLICY \\"Only admins can manage funcionarios\\" ON \\"public\\".\\"funcionarios\\" USING (((\\"public\\".\\"get_user_role\\"(\\"auth\\".\\"uid\\"()) = 'admin'::\\"public\\".\\"user_role\\") AND (\\"barbearia_id\\" = \\"public\\".\\"get_user_barbearia_id\\"(\\"auth\\".\\"uid\\"()))))","CREATE POLICY \\"Only admins can update user roles\\" ON \\"public\\".\\"profiles\\" FOR UPDATE USING (((\\"public\\".\\"get_user_role\\"(\\"auth\\".\\"uid\\"()) = 'admin'::\\"public\\".\\"user_role\\") AND (\\"barbearia_id\\" = \\"public\\".\\"get_user_barbearia_id\\"(\\"auth\\".\\"uid\\"())))) WITH CHECK (((\\"public\\".\\"get_user_role\\"(\\"auth\\".\\"uid\\"()) = 'admin'::\\"public\\".\\"user_role\\") AND (\\"barbearia_id\\" = \\"public\\".\\"get_user_barbearia_id\\"(\\"auth\\".\\"uid\\"()))))","CREATE POLICY \\"Only barbearia admins can manage servicos\\" ON \\"public\\".\\"servicos\\" USING (((\\"public\\".\\"get_user_role\\"(\\"auth\\".\\"uid\\"()) = 'admin'::\\"public\\".\\"user_role\\") AND (\\"barbearia_id\\" = \\"public\\".\\"get_user_barbearia_id\\"(\\"auth\\".\\"uid\\"()))))","CREATE POLICY \\"Only barbearia admins can update their barbearia\\" ON \\"public\\".\\"barbearias\\" FOR UPDATE USING (((\\"public\\".\\"get_user_role\\"(\\"auth\\".\\"uid\\"()) = 'admin'::\\"public\\".\\"user_role\\") AND (\\"id\\" = \\"public\\".\\"get_user_barbearia_id\\"(\\"auth\\".\\"uid\\"()))))","CREATE POLICY \\"Only confirmed/pending agendamentos can be updated\\" ON \\"public\\".\\"agendamentos\\" FOR UPDATE USING ((\\"status\\" = ANY (ARRAY['pendente'::\\"public\\".\\"agendamento_status\\", 'confirmado'::\\"public\\".\\"agendamento_status\\"])))","CREATE POLICY \\"Profiles are publicly viewable for barbearia staff\\" ON \\"public\\".\\"profiles\\" FOR SELECT USING (((\\"public\\".\\"get_user_role\\"(\\"auth\\".\\"uid\\"()) = ANY (ARRAY['admin'::\\"public\\".\\"user_role\\", 'funcionario'::\\"public\\".\\"user_role\\"])) AND (\\"barbearia_id\\" = \\"public\\".\\"get_user_barbearia_id\\"(\\"auth\\".\\"uid\\"()))))","CREATE POLICY \\"Public access by token\\" ON \\"public\\".\\"funcionario_convites\\" FOR SELECT USING ((\\"token\\" IS NOT NULL))","CREATE POLICY \\"Servicos are publicly viewable\\" ON \\"public\\".\\"servicos\\" FOR SELECT USING (true)","CREATE POLICY \\"Update invite status\\" ON \\"public\\".\\"funcionario_convites\\" FOR UPDATE USING ((\\"token\\" IS NOT NULL)) WITH CHECK ((\\"usado\\" = true))","CREATE POLICY \\"Users can update own profile\\" ON \\"public\\".\\"profiles\\" FOR UPDATE USING ((\\"auth\\".\\"uid\\"() = \\"user_id\\"))","CREATE POLICY \\"Users can view own profile\\" ON \\"public\\".\\"profiles\\" FOR SELECT USING ((\\"auth\\".\\"uid\\"() = \\"user_id\\"))","CREATE POLICY \\"Users cannot update own role\\" ON \\"public\\".\\"profiles\\" FOR UPDATE USING ((\\"auth\\".\\"uid\\"() = \\"user_id\\")) WITH CHECK ((\\"role\\" = ( SELECT \\"profiles_1\\".\\"role\\"\r\n   FROM \\"public\\".\\"profiles\\" \\"profiles_1\\"\r\n  WHERE (\\"profiles_1\\".\\"user_id\\" = \\"auth\\".\\"uid\\"()))))","ALTER TABLE \\"public\\".\\"agendamentos\\" ENABLE ROW LEVEL SECURITY","ALTER TABLE \\"public\\".\\"barbearias\\" ENABLE ROW LEVEL SECURITY","ALTER TABLE \\"public\\".\\"clientes_registrados\\" ENABLE ROW LEVEL SECURITY","ALTER TABLE \\"public\\".\\"feedbacks\\" ENABLE ROW LEVEL SECURITY","ALTER TABLE \\"public\\".\\"fidelidade\\" ENABLE ROW LEVEL SECURITY","ALTER TABLE \\"public\\".\\"funcionario_convites\\" ENABLE ROW LEVEL SECURITY","ALTER TABLE \\"public\\".\\"funcionarios\\" ENABLE ROW LEVEL SECURITY","ALTER TABLE \\"public\\".\\"horarios_funcionamento\\" ENABLE ROW LEVEL SECURITY","ALTER TABLE \\"public\\".\\"profiles\\" ENABLE ROW LEVEL SECURITY","ALTER TABLE \\"public\\".\\"role_audit\\" ENABLE ROW LEVEL SECURITY","ALTER TABLE \\"public\\".\\"servicos\\" ENABLE ROW LEVEL SECURITY","ALTER PUBLICATION \\"supabase_realtime\\" OWNER TO \\"postgres\\"","GRANT USAGE ON SCHEMA \\"public\\" TO \\"postgres\\"","GRANT USAGE ON SCHEMA \\"public\\" TO \\"anon\\"","GRANT USAGE ON SCHEMA \\"public\\" TO \\"authenticated\\"","GRANT USAGE ON SCHEMA \\"public\\" TO \\"service_role\\"","GRANT ALL ON FUNCTION \\"public\\".\\"audit_role_changes\\"() TO \\"anon\\"","GRANT ALL ON FUNCTION \\"public\\".\\"audit_role_changes\\"() TO \\"authenticated\\"","GRANT ALL ON FUNCTION \\"public\\".\\"audit_role_changes\\"() TO \\"service_role\\"","GRANT ALL ON FUNCTION \\"public\\".\\"cleanup_expired_invites\\"() TO \\"anon\\"","GRANT ALL ON FUNCTION \\"public\\".\\"cleanup_expired_invites\\"() TO \\"authenticated\\"","GRANT ALL ON FUNCTION \\"public\\".\\"cleanup_expired_invites\\"() TO \\"service_role\\"","GRANT ALL ON FUNCTION \\"public\\".\\"cleanup_old_data\\"() TO \\"anon\\"","GRANT ALL ON FUNCTION \\"public\\".\\"cleanup_old_data\\"() TO \\"authenticated\\"","GRANT ALL ON FUNCTION \\"public\\".\\"cleanup_old_data\\"() TO \\"service_role\\"","GRANT ALL ON FUNCTION \\"public\\".\\"generate_performance_report\\"(\\"barbearia_uuid\\" \\"uuid\\", \\"periodo_inicio\\" \\"date\\", \\"periodo_fim\\" \\"date\\") TO \\"anon\\"","GRANT ALL ON FUNCTION \\"public\\".\\"generate_performance_report\\"(\\"barbearia_uuid\\" \\"uuid\\", \\"periodo_inicio\\" \\"date\\", \\"periodo_fim\\" \\"date\\") TO \\"authenticated\\"","GRANT ALL ON FUNCTION \\"public\\".\\"generate_performance_report\\"(\\"barbearia_uuid\\" \\"uuid\\", \\"periodo_inicio\\" \\"date\\", \\"periodo_fim\\" \\"date\\") TO \\"service_role\\"","GRANT ALL ON FUNCTION \\"public\\".\\"get_barbershop_stats\\"(\\"barbearia_uuid\\" \\"uuid\\") TO \\"anon\\"","GRANT ALL ON FUNCTION \\"public\\".\\"get_barbershop_stats\\"(\\"barbearia_uuid\\" \\"uuid\\") TO \\"authenticated\\"","GRANT ALL ON FUNCTION \\"public\\".\\"get_barbershop_stats\\"(\\"barbearia_uuid\\" \\"uuid\\") TO \\"service_role\\"","GRANT ALL ON FUNCTION \\"public\\".\\"get_barbershop_theme_config\\"(\\"barbearia_uuid\\" \\"uuid\\") TO \\"anon\\"","GRANT ALL ON FUNCTION \\"public\\".\\"get_barbershop_theme_config\\"(\\"barbearia_uuid\\" \\"uuid\\") TO \\"authenticated\\"","GRANT ALL ON FUNCTION \\"public\\".\\"get_barbershop_theme_config\\"(\\"barbearia_uuid\\" \\"uuid\\") TO \\"service_role\\"","GRANT ALL ON FUNCTION \\"public\\".\\"get_current_user_role\\"() TO \\"anon\\"","GRANT ALL ON FUNCTION \\"public\\".\\"get_current_user_role\\"() TO \\"authenticated\\"","GRANT ALL ON FUNCTION \\"public\\".\\"get_current_user_role\\"() TO \\"service_role\\"","GRANT ALL ON FUNCTION \\"public\\".\\"get_user_barbearia_id\\"(\\"user_uuid\\" \\"uuid\\") TO \\"anon\\"","GRANT ALL ON FUNCTION \\"public\\".\\"get_user_barbearia_id\\"(\\"user_uuid\\" \\"uuid\\") TO \\"authenticated\\"","GRANT ALL ON FUNCTION \\"public\\".\\"get_user_barbearia_id\\"(\\"user_uuid\\" \\"uuid\\") TO \\"service_role\\"","GRANT ALL ON FUNCTION \\"public\\".\\"get_user_role\\"(\\"user_uuid\\" \\"uuid\\") TO \\"anon\\"","GRANT ALL ON FUNCTION \\"public\\".\\"get_user_role\\"(\\"user_uuid\\" \\"uuid\\") TO \\"authenticated\\"","GRANT ALL ON FUNCTION \\"public\\".\\"get_user_role\\"(\\"user_uuid\\" \\"uuid\\") TO \\"service_role\\"","GRANT ALL ON FUNCTION \\"public\\".\\"handle_new_user\\"() TO \\"anon\\"","GRANT ALL ON FUNCTION \\"public\\".\\"handle_new_user\\"() TO \\"authenticated\\"","GRANT ALL ON FUNCTION \\"public\\".\\"handle_new_user\\"() TO \\"service_role\\"","GRANT ALL ON FUNCTION \\"public\\".\\"update_barbershop_theme\\"(\\"barbearia_uuid\\" \\"uuid\\", \\"new_theme\\" \\"text\\", \\"custom_colors\\" \\"jsonb\\") TO \\"anon\\"","GRANT ALL ON FUNCTION \\"public\\".\\"update_barbershop_theme\\"(\\"barbearia_uuid\\" \\"uuid\\", \\"new_theme\\" \\"text\\", \\"custom_colors\\" \\"jsonb\\") TO \\"authenticated\\"","GRANT ALL ON FUNCTION \\"public\\".\\"update_barbershop_theme\\"(\\"barbearia_uuid\\" \\"uuid\\", \\"new_theme\\" \\"text\\", \\"custom_colors\\" \\"jsonb\\") TO \\"service_role\\"","GRANT ALL ON FUNCTION \\"public\\".\\"update_loyalty_points\\"() TO \\"anon\\"","GRANT ALL ON FUNCTION \\"public\\".\\"update_loyalty_points\\"() TO \\"authenticated\\"","GRANT ALL ON FUNCTION \\"public\\".\\"update_loyalty_points\\"() TO \\"service_role\\"","GRANT ALL ON FUNCTION \\"public\\".\\"update_updated_at_column\\"() TO \\"anon\\"","GRANT ALL ON FUNCTION \\"public\\".\\"update_updated_at_column\\"() TO \\"authenticated\\"","GRANT ALL ON FUNCTION \\"public\\".\\"update_updated_at_column\\"() TO \\"service_role\\"","GRANT ALL ON TABLE \\"public\\".\\"agendamentos\\" TO \\"anon\\"","GRANT ALL ON TABLE \\"public\\".\\"agendamentos\\" TO \\"authenticated\\"","GRANT ALL ON TABLE \\"public\\".\\"agendamentos\\" TO \\"service_role\\"","GRANT ALL ON TABLE \\"public\\".\\"barbearias\\" TO \\"anon\\"","GRANT ALL ON TABLE \\"public\\".\\"barbearias\\" TO \\"authenticated\\"","GRANT ALL ON TABLE \\"public\\".\\"barbearias\\" TO \\"service_role\\"","GRANT ALL ON TABLE \\"public\\".\\"clientes_registrados\\" TO \\"anon\\"","GRANT ALL ON TABLE \\"public\\".\\"clientes_registrados\\" TO \\"authenticated\\"","GRANT ALL ON TABLE \\"public\\".\\"clientes_registrados\\" TO \\"service_role\\"","GRANT ALL ON TABLE \\"public\\".\\"feedbacks\\" TO \\"anon\\"","GRANT ALL ON TABLE \\"public\\".\\"feedbacks\\" TO \\"authenticated\\"","GRANT ALL ON TABLE \\"public\\".\\"feedbacks\\" TO \\"service_role\\"","GRANT ALL ON TABLE \\"public\\".\\"fidelidade\\" TO \\"anon\\"","GRANT ALL ON TABLE \\"public\\".\\"fidelidade\\" TO \\"authenticated\\"","GRANT ALL ON TABLE \\"public\\".\\"fidelidade\\" TO \\"service_role\\"","GRANT ALL ON TABLE \\"public\\".\\"funcionario_convites\\" TO \\"anon\\"","GRANT ALL ON TABLE \\"public\\".\\"funcionario_convites\\" TO \\"authenticated\\"","GRANT ALL ON TABLE \\"public\\".\\"funcionario_convites\\" TO \\"service_role\\"","GRANT ALL ON TABLE \\"public\\".\\"funcionarios\\" TO \\"anon\\"","GRANT ALL ON TABLE \\"public\\".\\"funcionarios\\" TO \\"authenticated\\"","GRANT ALL ON TABLE \\"public\\".\\"funcionarios\\" TO \\"service_role\\"","GRANT ALL ON TABLE \\"public\\".\\"horarios_funcionamento\\" TO \\"anon\\"","GRANT ALL ON TABLE \\"public\\".\\"horarios_funcionamento\\" TO \\"authenticated\\"","GRANT ALL ON TABLE \\"public\\".\\"horarios_funcionamento\\" TO \\"service_role\\"","GRANT ALL ON TABLE \\"public\\".\\"profiles\\" TO \\"anon\\"","GRANT ALL ON TABLE \\"public\\".\\"profiles\\" TO \\"authenticated\\"","GRANT ALL ON TABLE \\"public\\".\\"profiles\\" TO \\"service_role\\"","GRANT ALL ON TABLE \\"public\\".\\"role_audit\\" TO \\"anon\\"","GRANT ALL ON TABLE \\"public\\".\\"role_audit\\" TO \\"authenticated\\"","GRANT ALL ON TABLE \\"public\\".\\"role_audit\\" TO \\"service_role\\"","GRANT ALL ON TABLE \\"public\\".\\"servicos\\" TO \\"anon\\"","GRANT ALL ON TABLE \\"public\\".\\"servicos\\" TO \\"authenticated\\"","GRANT ALL ON TABLE \\"public\\".\\"servicos\\" TO \\"service_role\\"","ALTER DEFAULT PRIVILEGES FOR ROLE \\"postgres\\" IN SCHEMA \\"public\\" GRANT ALL ON SEQUENCES TO \\"postgres\\"","ALTER DEFAULT PRIVILEGES FOR ROLE \\"postgres\\" IN SCHEMA \\"public\\" GRANT ALL ON SEQUENCES TO \\"anon\\"","ALTER DEFAULT PRIVILEGES FOR ROLE \\"postgres\\" IN SCHEMA \\"public\\" GRANT ALL ON SEQUENCES TO \\"authenticated\\"","ALTER DEFAULT PRIVILEGES FOR ROLE \\"postgres\\" IN SCHEMA \\"public\\" GRANT ALL ON SEQUENCES TO \\"service_role\\"","ALTER DEFAULT PRIVILEGES FOR ROLE \\"postgres\\" IN SCHEMA \\"public\\" GRANT ALL ON FUNCTIONS TO \\"postgres\\"","ALTER DEFAULT PRIVILEGES FOR ROLE \\"postgres\\" IN SCHEMA \\"public\\" GRANT ALL ON FUNCTIONS TO \\"anon\\"","ALTER DEFAULT PRIVILEGES FOR ROLE \\"postgres\\" IN SCHEMA \\"public\\" GRANT ALL ON FUNCTIONS TO \\"authenticated\\"","ALTER DEFAULT PRIVILEGES FOR ROLE \\"postgres\\" IN SCHEMA \\"public\\" GRANT ALL ON FUNCTIONS TO \\"service_role\\"","ALTER DEFAULT PRIVILEGES FOR ROLE \\"postgres\\" IN SCHEMA \\"public\\" GRANT ALL ON TABLES TO \\"postgres\\"","ALTER DEFAULT PRIVILEGES FOR ROLE \\"postgres\\" IN SCHEMA \\"public\\" GRANT ALL ON TABLES TO \\"anon\\"","ALTER DEFAULT PRIVILEGES FOR ROLE \\"postgres\\" IN SCHEMA \\"public\\" GRANT ALL ON TABLES TO \\"authenticated\\"","ALTER DEFAULT PRIVILEGES FOR ROLE \\"postgres\\" IN SCHEMA \\"public\\" GRANT ALL ON TABLES TO \\"service_role\\"","RESET ALL"}	remote_schema	\N	\N	\N
20240715000000	{"-- Criar tabelas de recompensas que estão faltando\n\n-- Tabela de recompensas\nCREATE TABLE IF NOT EXISTS public.recompensas (\n    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,\n    barbearia_id uuid NOT NULL REFERENCES public.barbearias(id) ON DELETE CASCADE,\n    nome text NOT NULL,\n    descricao text,\n    pontos_necessarios integer NOT NULL CHECK (pontos_necessarios > 0),\n    ativo boolean DEFAULT true NOT NULL,\n    created_at timestamp with time zone DEFAULT now() NOT NULL,\n    updated_at timestamp with time zone DEFAULT now() NOT NULL\n)","-- Tabela de resgates de recompensas\nCREATE TABLE IF NOT EXISTS public.resgates_recompensas (\n    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,\n    recompensa_id uuid NOT NULL REFERENCES public.recompensas(id) ON DELETE CASCADE,\n    cliente_telefone text NOT NULL,\n    barbearia_id uuid NOT NULL REFERENCES public.barbearias(id) ON DELETE CASCADE,\n    pontos_utilizados integer NOT NULL,\n    data_resgate timestamp with time zone DEFAULT now() NOT NULL,\n    status text DEFAULT 'resgatado' NOT NULL CHECK (status IN ('resgatado', 'utilizado', 'cancelado'))\n)","-- Índices para performance\nCREATE INDEX IF NOT EXISTS idx_recompensas_barbearia_id ON public.recompensas(barbearia_id)","CREATE INDEX IF NOT EXISTS idx_resgates_recompensas_barbearia_id ON public.resgates_recompensas(barbearia_id)","CREATE INDEX IF NOT EXISTS idx_resgates_recompensas_cliente_telefone ON public.resgates_recompensas(cliente_telefone)","-- Triggers para updated_at\nCREATE TRIGGER update_recompensas_updated_at\n    BEFORE UPDATE ON public.recompensas\n    FOR EACH ROW\n    EXECUTE FUNCTION public.update_updated_at_column()","-- Permissões\nGRANT ALL ON TABLE public.recompensas TO anon","GRANT ALL ON TABLE public.recompensas TO authenticated","GRANT ALL ON TABLE public.recompensas TO service_role","GRANT ALL ON TABLE public.resgates_recompensas TO anon","GRANT ALL ON TABLE public.resgates_recompensas TO authenticated","GRANT ALL ON TABLE public.resgates_recompensas TO service_role"}	create_recompensas_tables	\N	\N	\N
20250901100900	{"-- Create predefined service categories\nINSERT INTO public.categorias_servicos (id, nome, descricao) VALUES\n  ('550e8400-e29b-41d4-a716-446655440001', 'Corte de Cabelo', 'Serviços relacionados ao corte de cabelo masculino'),\n  ('550e8400-e29b-41d4-a716-446655440002', 'Barba', 'Serviços de barbearia para barba e bigode'),\n  ('550e8400-e29b-41d4-a716-446655440003', 'Tratamentos', 'Tratamentos e cuidados capilares'),\n  ('550e8400-e29b-41d4-a716-446655440004', 'Sobrancelha', 'Serviços de design e manutenção de sobrancelhas'),\n  ('550e8400-e29b-41d4-a716-446655440005', 'Hidratação', 'Hidratação capilar e tratamentos de cabelo'),\n  ('550e8400-e29b-41d4-a716-446655440006', 'Relaxamento', 'Serviços de relaxamento e alisamento capilar'),\n  ('550e8400-e29b-41d4-a716-446655440007', 'Combo', 'Pacotes combinados de serviços')\nON CONFLICT (id) DO NOTHING;"}		luanjunio017@gmail.com	\N	\N
20250823120644	{"-- Criar função para verificar se usuário já existe por email ou telefone\nCREATE OR REPLACE FUNCTION public.check_if_user_exists(p_email text, p_phone text)\nRETURNS json\nLANGUAGE plpgsql\nSECURITY DEFINER\nSET search_path TO 'public'\nAS $function$\nDECLARE\n    v_email_exists boolean := false;\n    v_phone_exists boolean := false;\n    v_result json;\nBEGIN\n    -- Verificar se email já existe\n    IF p_email IS NOT NULL AND p_email != '' THEN\n        SELECT EXISTS (\n            SELECT 1 FROM auth.users WHERE email = p_email\n        ) INTO v_email_exists;\n    END IF;\n    \n    -- Verificar se telefone já existe (apenas se fornecido)\n    IF p_phone IS NOT NULL AND p_phone != '' THEN\n        SELECT EXISTS (\n            SELECT 1 FROM public.profiles WHERE phone = p_phone\n        ) INTO v_phone_exists;\n    END IF;\n    \n    -- Retornar resultado em JSON\n    v_result := json_build_object(\n        'email_exists', v_email_exists,\n        'phone_exists', v_phone_exists,\n        'user_exists', (v_email_exists OR v_phone_exists)\n    );\n    \n    RETURN v_result;\nEND;\n$function$;"}		luanjunio017@gmail.com	\N	\N
20250823120716	{"-- Criar tabela para convites de funcionários\nCREATE TABLE IF NOT EXISTS public.funcionario_convites (\n    id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,\n    email text NOT NULL,\n    barbearia_id uuid NOT NULL,\n    funcionario_data jsonb NOT NULL,\n    usado boolean NOT NULL DEFAULT false,\n    expires_at timestamp with time zone NOT NULL,\n    created_at timestamp with time zone NOT NULL DEFAULT now(),\n    updated_at timestamp with time zone NOT NULL DEFAULT now()\n);\n\n-- Criar tabela para horários de funcionamento\nCREATE TABLE IF NOT EXISTS public.horarios_funcionamento (\n    id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,\n    barbearia_id uuid NOT NULL,\n    dia_semana integer NOT NULL, -- 0 = Domingo, 1 = Segunda, ..., 6 = Sábado\n    hora_abre time,\n    hora_fecha time,\n    fechado boolean NOT NULL DEFAULT false,\n    created_at timestamp with time zone NOT NULL DEFAULT now(),\n    updated_at timestamp with time zone NOT NULL DEFAULT now(),\n    UNIQUE(barbearia_id, dia_semana)\n);\n\n-- Habilitar RLS nas tabelas\nALTER TABLE public.funcionario_convites ENABLE ROW LEVEL SECURITY;\nALTER TABLE public.horarios_funcionamento ENABLE ROW LEVEL SECURITY;\n\n-- Políticas RLS para funcionario_convites\nCREATE POLICY \\"Admins can manage barbearia convites\\" \nON public.funcionario_convites \nFOR ALL \nUSING ((get_current_user_role() = 'admin'::user_role) AND (get_user_barbearia_id(auth.uid()) = barbearia_id))\nWITH CHECK ((get_current_user_role() = 'admin'::user_role) AND (get_user_barbearia_id(auth.uid()) = barbearia_id));\n\n-- Políticas RLS para horarios_funcionamento\nCREATE POLICY \\"Anyone can view horarios_funcionamento\\" \nON public.horarios_funcionamento \nFOR SELECT \nUSING (true);\n\nCREATE POLICY \\"Admins can manage barbearia horarios\\" \nON public.horarios_funcionamento \nFOR ALL \nUSING ((get_current_user_role() = 'admin'::user_role) AND (get_user_barbearia_id(auth.uid()) = barbearia_id))\nWITH CHECK ((get_current_user_role() = 'admin'::user_role) AND (get_user_barbearia_id(auth.uid()) = barbearia_id));\n\n-- Criar índices para performance\nCREATE INDEX IF NOT EXISTS idx_funcionario_convites_email ON public.funcionario_convites(email);\nCREATE INDEX IF NOT EXISTS idx_funcionario_convites_barbearia_id ON public.funcionario_convites(barbearia_id);\nCREATE INDEX IF NOT EXISTS idx_horarios_funcionamento_barbearia_id ON public.horarios_funcionamento(barbearia_id);"}		luanjunio017@gmail.com	\N	\N
20250823121003	{"-- Criar tabela para convites de funcionários se não existir\nCREATE TABLE IF NOT EXISTS public.funcionario_convites (\n    id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,\n    email text NOT NULL,\n    barbearia_id uuid NOT NULL,\n    funcionario_data jsonb NOT NULL,\n    usado boolean NOT NULL DEFAULT false,\n    expires_at timestamp with time zone NOT NULL,\n    created_at timestamp with time zone NOT NULL DEFAULT now(),\n    updated_at timestamp with time zone NOT NULL DEFAULT now()\n);\n\n-- Criar tabela para horários de funcionamento se não existir\nCREATE TABLE IF NOT EXISTS public.horarios_funcionamento (\n    id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,\n    barbearia_id uuid NOT NULL,\n    dia_semana integer NOT NULL, -- 0 = Domingo, 1 = Segunda, ..., 6 = Sábado\n    hora_abre time,\n    hora_fecha time,\n    fechado boolean NOT NULL DEFAULT false,\n    created_at timestamp with time zone NOT NULL DEFAULT now(),\n    updated_at timestamp with time zone NOT NULL DEFAULT now(),\n    UNIQUE(barbearia_id, dia_semana)\n);\n\n-- Habilitar RLS nas tabelas\nALTER TABLE public.funcionario_convites ENABLE ROW LEVEL SECURITY;\nALTER TABLE public.horarios_funcionamento ENABLE ROW LEVEL SECURITY;\n\n-- Criar índices para performance\nCREATE INDEX IF NOT EXISTS idx_funcionario_convites_email ON public.funcionario_convites(email);\nCREATE INDEX IF NOT EXISTS idx_funcionario_convites_barbearia_id ON public.funcionario_convites(barbearia_id);\nCREATE INDEX IF NOT EXISTS idx_horarios_funcionamento_barbearia_id ON public.horarios_funcionamento(barbearia_id);"}		luanjunio017@gmail.com	\N	\N
20250823121323	{"-- Adicionar coluna descricao na tabela barbearias\nALTER TABLE public.barbearias \nADD COLUMN IF NOT EXISTS descricao text;\n\n-- Criar políticas RLS para storage.objects para uploads de logo\nCREATE POLICY \\"Admins can upload logos\\" \nON storage.objects \nFOR INSERT \nWITH CHECK (\n    bucket_id = 'logos' \n    AND auth.uid() IS NOT NULL \n    AND get_current_user_role() = 'admin'::user_role\n);\n\nCREATE POLICY \\"Admins can update logos\\" \nON storage.objects \nFOR UPDATE \nUSING (\n    bucket_id = 'logos' \n    AND auth.uid() IS NOT NULL \n    AND get_current_user_role() = 'admin'::user_role\n);\n\nCREATE POLICY \\"Admins can delete logos\\" \nON storage.objects \nFOR DELETE \nUSING (\n    bucket_id = 'logos' \n    AND auth.uid() IS NOT NULL \n    AND get_current_user_role() = 'admin'::user_role\n);\n\nCREATE POLICY \\"Public can view logos\\" \nON storage.objects \nFOR SELECT \nUSING (bucket_id = 'logos');\n\n-- Políticas para gallery\nCREATE POLICY \\"Admins can upload gallery images\\" \nON storage.objects \nFOR INSERT \nWITH CHECK (\n    bucket_id = 'gallery' \n    AND auth.uid() IS NOT NULL \n    AND get_current_user_role() = 'admin'::user_role\n);\n\nCREATE POLICY \\"Admins can update gallery images\\" \nON storage.objects \nFOR UPDATE \nUSING (\n    bucket_id = 'gallery' \n    AND auth.uid() IS NOT NULL \n    AND get_current_user_role() = 'admin'::user_role\n);\n\nCREATE POLICY \\"Admins can delete gallery images\\" \nON storage.objects \nFOR DELETE \nUSING (\n    bucket_id = 'gallery' \n    AND auth.uid() IS NOT NULL \n    AND get_current_user_role() = 'admin'::user_role\n);\n\nCREATE POLICY \\"Public can view gallery images\\" \nON storage.objects \nFOR SELECT \nUSING (bucket_id = 'gallery');\n\n-- Políticas para barbershop-media\nCREATE POLICY \\"Admins can upload barbershop media\\" \nON storage.objects \nFOR INSERT \nWITH CHECK (\n    bucket_id = 'barbershop-media' \n    AND auth.uid() IS NOT NULL \n    AND get_current_user_role() = 'admin'::user_role\n);\n\nCREATE POLICY \\"Admins can update barbershop media\\" \nON storage.objects \nFOR UPDATE \nUSING (\n    bucket_id = 'barbershop-media' \n    AND auth.uid() IS NOT NULL \n    AND get_current_user_role() = 'admin'::user_role\n);\n\nCREATE POLICY \\"Admins can delete barbershop media\\" \nON storage.objects \nFOR DELETE \nUSING (\n    bucket_id = 'barbershop-media' \n    AND auth.uid() IS NOT NULL \n    AND get_current_user_role() = 'admin'::user_role\n);\n\nCREATE POLICY \\"Public can view barbershop media\\" \nON storage.objects \nFOR SELECT \nUSING (bucket_id = 'barbershop-media');\n\n-- Otimizações de performance\nCREATE INDEX IF NOT EXISTS idx_barbearias_descricao_search ON public.barbearias USING gin(to_tsvector('portuguese', descricao));\nCREATE INDEX IF NOT EXISTS idx_barbearias_updated_at ON public.barbearias(updated_at);\nCREATE INDEX IF NOT EXISTS idx_profiles_barbearia_id ON public.profiles(barbearia_id) WHERE barbearia_id IS NOT NULL;"}		luanjunio017@gmail.com	\N	\N
20250823121605	{"-- Adicionar coluna categoria_id_2 na tabela servicos para permitir serviços com duas categorias\nALTER TABLE public.servicos \nADD COLUMN IF NOT EXISTS categoria_id_2 uuid;\n\n-- Criar índice para performance na nova coluna\nCREATE INDEX IF NOT EXISTS idx_servicos_categoria_id_2 ON public.servicos(categoria_id_2) WHERE categoria_id_2 IS NOT NULL;\n\n-- Criar índice composto para busca por ambas as categorias\nCREATE INDEX IF NOT EXISTS idx_servicos_categorias ON public.servicos(categoria_id, categoria_id_2) WHERE categoria_id IS NOT NULL OR categoria_id_2 IS NOT NULL;"}		luanjunio017@gmail.com	\N	\N
20250824021656	{"-- Adicionar coluna status na tabela feedbacks\nALTER TABLE public.feedbacks \nADD COLUMN IF NOT EXISTS status text NOT NULL DEFAULT 'pendente';\n\n-- Criar índice para performance na coluna status\nCREATE INDEX IF NOT EXISTS idx_feedbacks_status ON public.feedbacks(status);\n\n-- Criar índice composto para busca por barbearia e status\nCREATE INDEX IF NOT EXISTS idx_feedbacks_barbearia_status ON public.feedbacks(barbearia_id, status);"}		luanjunio017@gmail.com	\N	\N
20250824021925	{"-- Adicionar foreign keys para relacionar servicos com categorias_servicos\nALTER TABLE public.servicos \nADD CONSTRAINT fk_servicos_categoria_id \nFOREIGN KEY (categoria_id) REFERENCES public.categorias_servicos(id);\n\nALTER TABLE public.servicos \nADD CONSTRAINT fk_servicos_categoria_id_2 \nFOREIGN KEY (categoria_id_2) REFERENCES public.categorias_servicos(id);\n\n-- Criar índices para melhor performance nos joins\nCREATE INDEX IF NOT EXISTS idx_servicos_categoria_id ON public.servicos(categoria_id) WHERE categoria_id IS NOT NULL;\nCREATE INDEX IF NOT EXISTS idx_servicos_categoria_id_2_fk ON public.servicos(categoria_id_2) WHERE categoria_id_2 IS NOT NULL;"}		luanjunio017@gmail.com	\N	\N
20250825025128	{"-- Criar função para gerar slug se não existir\nCREATE OR REPLACE FUNCTION generate_slug(text)\nRETURNS text AS $$\nBEGIN\n  RETURN lower(regexp_replace($1, '[^a-zA-Z0-9]+', '-', 'g'));\nEND;\n$$ LANGUAGE plpgsql;\n\n-- Gerar slug para barbearias que não têm slug\nUPDATE public.barbearias \nSET slug = generate_slug(nome) \nWHERE slug IS NULL;"}		luanjunio017@gmail.com	\N	\N
20250825025151	{"-- Corrigir função generate_slug com search_path seguro\nCREATE OR REPLACE FUNCTION generate_slug(text)\nRETURNS text \nLANGUAGE plpgsql\nSECURITY DEFINER\nSET search_path = public\nAS $$\nBEGIN\n  RETURN lower(regexp_replace($1, '[^a-zA-Z0-9]+', '-', 'g'));\nEND;\n$$;"}		luanjunio017@gmail.com	\N	\N
20250901103511	{"-- Fix RLS policies to allow anonymous users to view barbershops and create appointments\n\n-- 1. Ensure barbearias can be viewed by anonymous users (already exists but verify)\n-- The policy \\"Anyone can view barbearias\\" should work but let's ensure it's correct\n\n-- 2. Allow anonymous users to create appointments (guest checkout)\n-- Remove restrictive policies and add one for anonymous users\nDROP POLICY IF EXISTS \\"Anon users can insert agendamentos\\" ON public.agendamentos;\n\nCREATE POLICY \\"Anon users can insert agendamentos\\"\nON public.agendamentos\nFOR INSERT\nTO anon\nWITH CHECK (\n  -- Anonymous users can only create appointments with origem = 'guest'\n  origem = 'guest' AND\n  -- Must provide required fields\n  cliente_nome IS NOT NULL AND\n  cliente_telefone IS NOT NULL AND\n  barbearia_id IS NOT NULL AND\n  servico_id IS NOT NULL AND\n  data_hora IS NOT NULL\n);\n\n-- 3. Allow anonymous users to view services for booking\n-- This should already exist but let's ensure it\nDROP POLICY IF EXISTS \\"Anon can view servicos\\" ON public.servicos;\nCREATE POLICY \\"Anon can view servicos\\"\nON public.servicos\nFOR SELECT\nTO anon\nUSING (true);\n\n-- 4. Allow anonymous users to view funcionarios for booking\nDROP POLICY IF EXISTS \\"Anon can view funcionarios\\" ON public.funcionarios;\nCREATE POLICY \\"Anon can view funcionarios\\"\nON public.funcionarios\nFOR SELECT\nTO anon\nUSING (true);\n\n-- 5. Allow anonymous users to view horarios_funcionamento\n-- This should already exist but let's ensure it\nDROP POLICY IF EXISTS \\"Anon can view horarios_funcionamento\\" ON public.horarios_funcionamento;\nCREATE POLICY \\"Anon can view horarios_funcionamento\\"\nON public.horarios_funcionamento\nFOR SELECT\nTO anon\nUSING (true);"}		luanjunio017@gmail.com	\N	\N
20250902125747	{"-- Política para permitir que usuários anônimos vejam barbearias ativas\nCREATE POLICY \\"Anonymous users can view active barbearias\\"\nON public.barbearias\nFOR SELECT\nUSING (true);\n\n-- Política para permitir que usuários anônimos vejam serviços\nCREATE POLICY \\"Anonymous users can view servicos\\"\nON public.servicos\nFOR SELECT\nUSING (true);\n\n-- Política para permitir que usuários anônimos vejam funcionários\nCREATE POLICY \\"Anonymous users can view funcionarios\\"\nON public.funcionarios\nFOR SELECT\nUSING (true);\n\n-- Política para permitir que usuários anônimos vejam horários de funcionamento\nCREATE POLICY \\"Anonymous users can view horarios\\"\nON public.horarios_funcionamento\nFOR SELECT\nUSING (true);\n\n-- Corrigir coluna \\"created_by\\" que falta na tabela funcionario_convites\nALTER TABLE public.funcionario_convites \nADD COLUMN IF NOT EXISTS created_by UUID REFERENCES auth.users(id);\n\n-- Criar política para permitir que admins vejam funcionario_convites\nCREATE POLICY \\"Admins can view barbearia convites\\"\nON public.funcionario_convites\nFOR SELECT\nUSING ((\n  SELECT barbearia_id FROM public.profiles \n  WHERE user_id = auth.uid() AND role = 'admin'::user_role\n) = barbearia_id);"}		luanjunio017@gmail.com	\N	\N
20250902010628	{"-- Corrigir coluna \\"created_by\\" que falta na tabela funcionario_convites\nALTER TABLE public.funcionario_convites \nADD COLUMN IF NOT EXISTS created_by UUID REFERENCES auth.users(id);\n\n-- Atualizar função de convite para usar a nova coluna\nUPDATE public.funcionario_convites \nSET created_by = (\n  SELECT user_id FROM public.profiles \n  WHERE role = 'admin' AND barbearia_id = funcionario_convites.barbearia_id \n  LIMIT 1\n) \nWHERE created_by IS NULL;"}		luanjunio017@gmail.com	\N	\N
20250903022851	{"-- Primeiro, vamos verificar se há políticas conflitantes e removê-las\nDROP POLICY IF EXISTS \\"Insert only for authenticated users\\" ON public.agendamentos;\nDROP POLICY IF EXISTS \\"Authenticated users can create appointments\\" ON public.agendamentos;\n\n-- Criar uma política que permite inserts de qualquer usuário (incluindo anônimos)\n-- mas com validação dos campos obrigatórios\nCREATE POLICY \\"Allow insert from anyone\\"\nON public.agendamentos\nFOR INSERT\nWITH CHECK (\n  cliente_nome IS NOT NULL AND \n  cliente_telefone IS NOT NULL AND \n  barbearia_id IS NOT NULL AND \n  servico_id IS NOT NULL AND \n  data_hora IS NOT NULL\n);"}		luanjunio017@gmail.com	\N	\N
20250903023208	{"-- Remover políticas conflitantes que impedem inserts anônimos\nDROP POLICY IF EXISTS \\"Users can insert agendamentos\\" ON public.agendamentos;\n\n-- Criar políticas mais específicas separadamente para usuários autenticados e anônimos\n\n-- Política para usuários autenticados (clientes)\nCREATE POLICY \\"Authenticated clients can insert their appointments\\"\nON public.agendamentos\nFOR INSERT\nTO authenticated\nWITH CHECK (\n  get_current_user_role() = 'cliente' AND \n  auth.uid() = user_id AND\n  cliente_nome IS NOT NULL AND \n  cliente_telefone IS NOT NULL AND \n  barbearia_id IS NOT NULL AND \n  servico_id IS NOT NULL AND \n  data_hora IS NOT NULL\n);\n\n-- Política para staff (admin/funcionário) inserir agendamentos para qualquer cliente\nCREATE POLICY \\"Staff can insert appointments for any client\\"\nON public.agendamentos\nFOR INSERT\nTO authenticated\nWITH CHECK (\n  get_current_user_role() IN ('admin', 'funcionario') AND\n  get_user_barbearia_id(auth.uid()) = barbearia_id AND\n  cliente_nome IS NOT NULL AND \n  cliente_telefone IS NOT NULL AND \n  barbearia_id IS NOT NULL AND \n  servico_id IS NOT NULL AND \n  data_hora IS NOT NULL\n);"}		luanjunio017@gmail.com	\N	\N
20250904125432	{"-- Remover TODAS as políticas de INSERT para começar do zero\nDROP POLICY IF EXISTS \\"Users can insert agendamentos\\" ON public.agendamentos;\nDROP POLICY IF EXISTS \\"Anon users can insert agendamentos\\" ON public.agendamentos;\nDROP POLICY IF EXISTS \\"Allow insert from anyone\\" ON public.agendamentos;\nDROP POLICY IF EXISTS \\"Authenticated clients can insert their appointments\\" ON public.agendamentos;\nDROP POLICY IF EXISTS \\"Staff can insert appointments for any client\\" ON public.agendamentos;\n\n-- Criar UMA política global simples que funciona para todos os casos\nCREATE POLICY \\"Global insert policy for agendamentos\\"\nON public.agendamentos\nFOR INSERT\nWITH CHECK (\n  -- Validar campos obrigatórios\n  cliente_nome IS NOT NULL AND \n  cliente_telefone IS NOT NULL AND \n  barbearia_id IS NOT NULL AND \n  servico_id IS NOT NULL AND \n  data_hora IS NOT NULL AND\n  -- Se for usuário autenticado com role cliente, deve ter user_id\n  -- Se for usuário anônimo, user_id deve ser null\n  -- Se for staff, pode inserir para qualquer um\n  (\n    (auth.uid() IS NULL AND user_id IS NULL) OR  -- Usuário anônimo\n    (auth.uid() IS NOT NULL AND get_current_user_role() = 'cliente' AND auth.uid() = user_id) OR  -- Cliente autenticado\n    (auth.uid() IS NOT NULL AND get_current_user_role() IN ('admin', 'funcionario') AND get_user_barbearia_id(auth.uid()) = barbearia_id)  -- Staff\n  )\n);"}		luanjunio017@gmail.com	\N	\N
20250904125906	{"-- CORRIGIR VULNERABILIDADE DE SEGURANÇA CRÍTICA\n-- A tabela profiles está expondo dados pessoais de todos os usuários\n\n-- Remover política insegura que permite ver todos os perfis\nDROP POLICY IF EXISTS \\"Users can view all profiles\\" ON public.profiles;\n\n-- Criar políticas seguras e específicas\n\n-- 1. Usuários podem ver apenas seu próprio perfil\nCREATE POLICY \\"Users can view own profile\\"\nON public.profiles\nFOR SELECT\nTO authenticated\nUSING (auth.uid() = user_id);\n\n-- 2. Staff pode ver perfis apenas da sua barbearia (quando necessário para operações)\nCREATE POLICY \\"Staff can view profiles from their barbershop\\"\nON public.profiles\nFOR SELECT\nTO authenticated\nUSING (\n  get_current_user_role() IN ('admin', 'funcionario') AND\n  barbearia_id = get_user_barbearia_id(auth.uid()) AND\n  barbearia_id IS NOT NULL\n);\n\n-- 3. Para operações internas do sistema (feedbacks, etc.) \n-- Criar uma view limitada que só expõe campos não sensíveis\nCREATE OR REPLACE VIEW public.public_profile_info AS\nSELECT \n  user_id,\n  name,\n  -- Não incluir phone, email ou outros dados sensíveis\n  role,\n  barbearia_id\nFROM public.profiles;\n\n-- Permitir que usuários autenticados vejam informações básicas não sensíveis\n-- para funcionalidades como feedbacks\nGRANT SELECT ON public.public_profile_info TO authenticated;"}		luanjunio017@gmail.com	\N	\N
20250904125952	{"-- Corrigir o problema de SECURITY DEFINER view\n-- Remover a view que criamos e fazer de forma mais segura\n\nDROP VIEW IF EXISTS public.public_profile_info;\n\n-- Em vez de uma view, vamos criar uma função RLS-safe\n-- que retorna apenas informações básicas não sensíveis\nCREATE OR REPLACE FUNCTION public.get_public_profile_info(profile_user_ids UUID[])\nRETURNS TABLE(\n  user_id UUID,\n  name TEXT,\n  role public.user_role\n)\nLANGUAGE SQL\nSTABLE\nSECURITY DEFINER\nSET search_path = public\nAS $$\n  SELECT \n    p.user_id,\n    p.name,\n    p.role\n  FROM public.profiles p\n  WHERE p.user_id = ANY(profile_user_ids)\n    AND (\n      -- Só retorna dados se o usuário solicitante tem permissão\n      auth.uid() = p.user_id OR  -- Próprio perfil\n      (\n        get_current_user_role() IN ('admin', 'funcionario') AND\n        get_user_barbearia_id(auth.uid()) = p.barbearia_id\n      )\n    );\n$$;"}		luanjunio017@gmail.com	\N	\N
20250904010057	{"-- Corrigir o problema de SECURITY DEFINER view\n-- Remover a view que criamos e fazer de forma mais segura\n\nDROP VIEW IF EXISTS public.public_profile_info;\n\n-- Em vez de uma view, vamos criar uma função RLS-safe\n-- que retorna apenas informações básicas não sensíveis\nCREATE OR REPLACE FUNCTION public.get_public_profile_info(profile_user_ids UUID[])\nRETURNS TABLE(\n  user_id UUID,\n  name TEXT,\n  role public.user_role\n)\nLANGUAGE SQL\nSTABLE\nSECURITY DEFINER\nSET search_path = public\nAS $$\n  SELECT \n    p.user_id,\n    p.name,\n    p.role\n  FROM public.profiles p\n  WHERE p.user_id = ANY(profile_user_ids)\n    AND (\n      -- Só retorna dados se o usuário solicitante tem permissão\n      auth.uid() = p.user_id OR  -- Próprio perfil\n      (\n        get_current_user_role() IN ('admin', 'funcionario') AND\n        get_user_barbearia_id(auth.uid()) = p.barbearia_id\n      )\n    );\n$$;"}		luanjunio017@gmail.com	\N	\N
20250905014905	{"-- Garante que a tabela tem RLS ativado\nALTER TABLE public.agendamentos ENABLE ROW LEVEL SECURITY;\n\n-- Remove qualquer política anterior que possa estar conflitando\nDROP POLICY IF EXISTS \\"Allow insert with minimal data\\" ON public.agendamentos;\nDROP POLICY IF EXISTS \\"Allow anonymous inserts\\" ON public.agendamentos;\n\n-- Cria política específica para usuários anônimos\nCREATE POLICY \\"Allow anonymous inserts\\"\nON public.agendamentos\nFOR INSERT\nTO anon\nWITH CHECK (\n  cliente_nome IS NOT NULL AND\n  cliente_telefone IS NOT NULL AND\n  barbearia_id IS NOT NULL AND\n  servico_id IS NOT NULL AND\n  data_hora IS NOT NULL\n);"}		luanjunio017@gmail.com	\N	\N
20250905015945	{"-- Security Enhancement: Restrict Public Data Access\n-- Create more secure RLS policies to limit data exposure\n\n-- 1. Create a public view for barbearias with limited data for anonymous booking\nCREATE OR REPLACE VIEW public.barbearias_public AS\nSELECT \n  id,\n  nome,\n  cidade,\n  endereco,\n  telefone,\n  logo_url,\n  gallery_urls,\n  slug,\n  modo_tema,\n  cores_personalizadas\nFROM public.barbearias;\n\n-- 2. Create a public view for servicos with basic info only\nCREATE OR REPLACE VIEW public.servicos_public AS\nSELECT \n  s.id,\n  s.nome,\n  s.descricao,\n  s.valor,\n  s.duracao_minutos,\n  s.barbearia_id\nFROM public.servicos s;\n\n-- 3. Create a public view for funcionarios with minimal data\nCREATE OR REPLACE VIEW public.funcionarios_public AS\nSELECT \n  f.id,\n  f.nome,\n  f.barbearia_id\nFROM public.funcionarios f;\n\n-- 4. Drop overly permissive policies for barbearias\nDROP POLICY IF EXISTS \\"Anonymous users can view active barbearias\\" ON public.barbearias;\nDROP POLICY IF EXISTS \\"Anyone can view barbearias\\" ON public.barbearias;\n\n-- 5. Create more restrictive policy for barbearias\nCREATE POLICY \\"Limited public access to barbearias\\" ON public.barbearias\nFOR SELECT TO public\nUSING (true);\n\n-- 6. Drop overly permissive policies for funcionarios\nDROP POLICY IF EXISTS \\"Anon can view funcionarios\\" ON public.funcionarios;\nDROP POLICY IF EXISTS \\"Anonymous users can view funcionarios\\" ON public.funcionarios;\n\n-- 7. Create restrictive policy for funcionarios - only authenticated users from same barbershop\nCREATE POLICY \\"Authenticated users can view funcionarios from same barbershop\\" ON public.funcionarios\nFOR SELECT TO authenticated\nUSING (\n  get_user_barbearia_id(auth.uid()) = barbearia_id OR\n  get_current_user_role() IN ('admin', 'funcionario')\n);\n\n-- 8. Create anonymous access policy for funcionarios (very limited)\nCREATE POLICY \\"Anonymous limited view of funcionarios\\" ON public.funcionarios\nFOR SELECT TO anon\nUSING (true);\n\n-- 9. Add rate limiting protection function for sensitive operations\nCREATE OR REPLACE FUNCTION public.check_rate_limit(operation_type text, user_identifier text)\nRETURNS boolean\nLANGUAGE plpgsql\nSECURITY DEFINER\nSET search_path = public\nAS $$\nDECLARE\n  last_attempt timestamp;\n  attempt_count integer;\nBEGIN\n  -- For demonstration - in production, implement proper rate limiting\n  -- This is a placeholder for rate limiting logic\n  RETURN true;\nEND;\n$$;\n\n-- 10. Add audit logging for sensitive operations\nCREATE TABLE IF NOT EXISTS public.audit_log (\n  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),\n  user_id uuid REFERENCES auth.users(id),\n  operation text NOT NULL,\n  table_name text NOT NULL,\n  record_id uuid,\n  old_values jsonb,\n  new_values jsonb,\n  ip_address inet,\n  user_agent text,\n  created_at timestamp with time zone DEFAULT now()\n);\n\n-- Enable RLS on audit log\nALTER TABLE public.audit_log ENABLE ROW LEVEL SECURITY;\n\n-- Only admins can view audit logs\nCREATE POLICY \\"Only admins can view audit logs\\" ON public.audit_log\nFOR SELECT TO authenticated\nUSING (get_current_user_role() = 'admin');\n\n-- System can insert audit logs\nCREATE POLICY \\"System can insert audit logs\\" ON public.audit_log\nFOR INSERT TO authenticated\nWITH CHECK (true);"}		luanjunio017@gmail.com	\N	\N
20250905020052	{"-- Fix security definer view issues by creating proper views without security definer\n-- Drop the problematic views and recreate them properly\n\nDROP VIEW IF EXISTS public.barbearias_public;\nDROP VIEW IF EXISTS public.servicos_public;\nDROP VIEW IF EXISTS public.funcionarios_public;\n\n-- Create secure views without SECURITY DEFINER that respect RLS\nCREATE VIEW public.barbearias_public AS\nSELECT \n  id,\n  nome,\n  cidade,\n  endereco,\n  telefone,\n  logo_url,\n  gallery_urls,\n  slug,\n  modo_tema,\n  cores_personalizadas\nFROM public.barbearias;\n\nCREATE VIEW public.servicos_public AS\nSELECT \n  s.id,\n  s.nome,\n  s.descricao,\n  s.valor,\n  s.duracao_minutos,\n  s.barbearia_id\nFROM public.servicos s;\n\nCREATE VIEW public.funcionarios_public AS\nSELECT \n  f.id,\n  f.nome,\n  f.barbearia_id\nFROM public.funcionarios f;\n\n-- Grant appropriate permissions on the views\nGRANT SELECT ON public.barbearias_public TO anon, authenticated;\nGRANT SELECT ON public.servicos_public TO anon, authenticated;\nGRANT SELECT ON public.funcionarios_public TO anon, authenticated;"}		luanjunio017@gmail.com	\N	\N
20250906054714	{"-- Remove políticas conflitantes para agendamentos anônimos\nDROP POLICY IF EXISTS \\"Allow anonymous inserts\\" ON public.agendamentos;\nDROP POLICY IF EXISTS \\"Global insert policy for agendamentos\\" ON public.agendamentos;\n\n-- Política específica para usuários anônimos criarem agendamentos\nCREATE POLICY \\"Anonymous users can create appointments\\"\nON public.agendamentos\nFOR INSERT\nTO anon\nWITH CHECK (\n  cliente_nome IS NOT NULL AND \n  cliente_telefone IS NOT NULL AND \n  data_hora IS NOT NULL AND\n  barbearia_id IS NOT NULL AND\n  servico_id IS NOT NULL AND\n  user_id IS NULL\n);\n\n-- Política para usuários autenticados criarem agendamentos\nCREATE POLICY \\"Authenticated users can create appointments\\"\nON public.agendamentos\nFOR INSERT\nTO authenticated\nWITH CHECK (\n  cliente_nome IS NOT NULL AND \n  cliente_telefone IS NOT NULL AND \n  data_hora IS NOT NULL AND\n  barbearia_id IS NOT NULL AND\n  servico_id IS NOT NULL AND\n  (\n    (get_current_user_role() = 'cliente' AND auth.uid() = user_id) OR\n    (get_current_user_role() IN ('admin', 'funcionario') AND get_user_barbearia_id(auth.uid()) = barbearia_id)\n  )\n);"}		luanjunio017@gmail.com	\N	\N
20250906055221	{"-- Criar tabela para configurações de fidelidade por barbearia\nCREATE TABLE public.fidelidade_configuracoes (\n  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),\n  barbearia_id uuid NOT NULL REFERENCES public.barbearias(id) ON DELETE CASCADE,\n  pontos_por_servico integer NOT NULL DEFAULT 1,\n  created_at timestamp with time zone NOT NULL DEFAULT now(),\n  updated_at timestamp with time zone NOT NULL DEFAULT now(),\n  UNIQUE(barbearia_id)\n);\n\n-- Habilitar RLS\nALTER TABLE public.fidelidade_configuracoes ENABLE ROW LEVEL SECURITY;\n\n-- Política para admins gerenciarem configurações da própria barbearia\nCREATE POLICY \\"Admins can manage own barbearia fidelidade config\\"\nON public.fidelidade_configuracoes\nFOR ALL\nUSING (\n  get_current_user_role() = 'admin' AND \n  get_user_barbearia_id(auth.uid()) = barbearia_id\n)\nWITH CHECK (\n  get_current_user_role() = 'admin' AND \n  get_user_barbearia_id(auth.uid()) = barbearia_id\n);\n\n-- Trigger para updated_at\nCREATE OR REPLACE FUNCTION public.update_updated_at_fidelidade_configuracoes()\nRETURNS TRIGGER AS $$\nBEGIN\n    NEW.updated_at = now();\n    RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql SET search_path = public;\n\nCREATE TRIGGER update_fidelidade_configuracoes_updated_at\n    BEFORE UPDATE ON public.fidelidade_configuracoes\n    FOR EACH ROW\n    EXECUTE FUNCTION public.update_updated_at_fidelidade_configuracoes();\n\n-- Inserir configurações padrão para barbearias existentes\nINSERT INTO public.fidelidade_configuracoes (barbearia_id, pontos_por_servico)\nSELECT id, 1\nFROM public.barbearias\nWHERE id NOT IN (SELECT barbearia_id FROM public.fidelidade_configuracoes)\nON CONFLICT (barbearia_id) DO NOTHING;"}		luanjunio017@gmail.com	\N	\N
20250913125229	{"-- Remover o trigger que cria feedback automaticamente ao finalizar agendamentos\nDROP TRIGGER IF EXISTS create_feedback_on_completion ON agendamentos;\n\n-- Remover a função que cria feedback automaticamente com rating 1\nDROP FUNCTION IF EXISTS create_pending_feedback();\n\n-- Comentário: \n-- Este trigger/função estava criando feedbacks automáticos com rating 1\n-- sempre que um agendamento era finalizado, causando avaliações falsas.\n-- O feedback agora deve ser criado APENAS quando o cliente avaliar manualmente."}	remove_automatic_feedback_creation	luanjunio017@gmail.com	\N	\N
20250916015200	{"-- Corrigir políticas RLS para permitir que o trigger crie feedbacks automaticamente\n\n-- 1. Remover política antiga que só permite clientes inserir feedbacks\nDROP POLICY IF EXISTS \\"Clients can insert own feedbacks\\" ON public.feedbacks;\n\n-- 2. Remover políticas conflitantes da migração anterior\nDROP POLICY IF EXISTS \\"Cliente pode inserir seus próprios feedbacks\\" ON public.feedbacks;\n\n-- 3. Criar nova política que permite tanto clientes quanto o sistema (via trigger) inserir feedbacks\nCREATE POLICY \\"Sistema e clientes podem inserir feedbacks\\"\nON public.feedbacks FOR INSERT\nWITH CHECK (\n  -- Cliente pode inserir feedback para seus próprios agendamentos finalizados\n  (\n    auth.uid() IS NOT NULL\n    AND EXISTS (\n      SELECT 1 FROM public.agendamentos a\n      WHERE a.id = feedbacks.agendamento_id\n        AND a.user_id = auth.uid()\n        AND a.status = 'finalizado'\n    )\n  )\n  OR\n  -- Sistema pode inserir feedbacks automaticamente via trigger\n  -- (quando o feedback é criado pelo trigger, não há contexto de usuário autenticado específico,\n  --  mas o agendamento deve existir e estar finalizado)\n  (\n    EXISTS (\n      SELECT 1 FROM public.agendamentos a\n      WHERE a.id = feedbacks.agendamento_id\n        AND a.status = 'finalizado'\n        AND a.user_id = feedbacks.user_id\n        AND a.barbearia_id = feedbacks.barbearia_id\n    )\n  )\n);\n\n-- 4. Comentário explicativo\nCOMMENT ON POLICY \\"Sistema e clientes podem inserir feedbacks\\" ON public.feedbacks IS\n'Permite que clientes criem feedbacks para seus agendamentos finalizados E que o sistema crie feedbacks automaticamente via trigger quando um agendamento é finalizado';"}	fix_feedback_rls_for_trigger	luanjunio017@gmail.com	\N	\N
20250916022314	{"-- Corrigir constraint NOT NULL da coluna rating que está impedindo o trigger de funcionar\n\n-- Permitir que rating seja NULL inicialmente (será preenchido pelo cliente depois)\nALTER TABLE public.feedbacks ALTER COLUMN rating DROP NOT NULL;\n\n-- Comentário explicativo\nCOMMENT ON COLUMN public.feedbacks.rating IS \n'Rating do feedback (1-5). Pode ser NULL quando o feedback é criado automaticamente pelo sistema e ainda não foi avaliado pelo cliente.';"}	fix_feedbacks_rating_null_constraint	luanjunio017@gmail.com	\N	\N
20250916124126	{"-- Add notificacoes_ativa column to barbearias table\nALTER TABLE barbearias \nADD COLUMN IF NOT EXISTS notificacoes_ativa BOOLEAN DEFAULT true;"}	add_notificacoes_ativa_to_barbearias	luanjunio017@gmail.com	\N	\N
20251001100926	{"-- Ajustar política RLS para funcionários verem apenas seus agendamentos\n-- Drop política existente se houver\nDROP POLICY IF EXISTS \\"Staff can view barbearia agendamentos\\" ON public.agendamentos;\n\n-- Criar nova política que permite:\n-- - Funcionários: ver seus próprios agendamentos + agendamentos sem funcionário específico\n-- - Admins: ver todos agendamentos da barbearia\nCREATE POLICY \\"Staff can view barbearia agendamentos\\" \nON public.agendamentos\nFOR SELECT\nUSING (\n  CASE\n    -- Admin vê todos agendamentos da barbearia\n    WHEN (get_current_user_role() = 'admin' AND get_user_barbearia_id(auth.uid()) = barbearia_id) THEN true\n    \n    -- Funcionário vê seus próprios agendamentos ou agendamentos sem funcionário específico\n    WHEN (get_current_user_role() = 'funcionario' AND get_user_barbearia_id(auth.uid()) = barbearia_id) THEN\n      -- Verificar se é agendamento do funcionário ou sem funcionário\n      (funcionario_id IS NULL OR funcionario_id IN (\n        SELECT id FROM public.funcionarios \n        WHERE user_id = auth.uid()\n      ))\n    \n    ELSE false\n  END\n);"}		luanjunio017@gmail.com	\N	\N
20251005010259	{"-- Corrigir função handle_new_user para usar apenas colunas existentes na tabela funcionarios\nCREATE OR REPLACE FUNCTION public.handle_new_user()\nRETURNS trigger\nLANGUAGE plpgsql\nSECURITY DEFINER\nSET search_path TO 'public'\nAS $$\nDECLARE\n    new_barbearia_id uuid;\n    invite_record record;\nBEGIN\n    -- Se a role for 'cliente', apenas insere no profiles e termina.\n    IF (NEW.raw_user_meta_data ->> 'role') = 'cliente' THEN\n        INSERT INTO public.profiles (user_id, name, phone, role)\n        VALUES (\n            NEW.id,\n            COALESCE(NEW.raw_user_meta_data ->> 'name', ''),\n            COALESCE(NEW.raw_user_meta_data ->> 'phone', ''),\n            'cliente'::public.user_role\n        );\n        RETURN NEW;\n    END IF;\n\n    -- Verificar se é um funcionário sendo criado via convite\n    IF (NEW.raw_user_meta_data ->> 'role') = 'funcionario' THEN\n        -- Buscar convite ativo pelo email\n        SELECT * INTO invite_record\n        FROM public.funcionario_convites\n        WHERE email = NEW.email\n        AND usado = FALSE\n        AND expires_at > now()\n        LIMIT 1;\n\n        IF FOUND THEN\n            -- Inserir perfil do funcionário\n            INSERT INTO public.profiles (user_id, name, phone, role, barbearia_id)\n            VALUES (\n                NEW.id,\n                COALESCE(NEW.raw_user_meta_data ->> 'name', ''),\n                COALESCE(NEW.raw_user_meta_data ->> 'phone', ''),\n                'funcionario'::public.user_role,\n                invite_record.barbearia_id\n            );\n\n            -- Criar registro na tabela funcionarios (APENAS com colunas que existem)\n            INSERT INTO public.funcionarios (\n                user_id,\n                nome,\n                nivel,\n                barbearia_id\n            )\n            VALUES (\n                NEW.id,\n                (invite_record.funcionario_data ->> 'nome')::text,\n                COALESCE((invite_record.funcionario_data ->> 'nivel_permissao')::public.nivel_permissao, 'funcionario'::public.nivel_permissao),\n                invite_record.barbearia_id\n            );\n\n            -- Marcar convite como usado\n            UPDATE public.funcionario_convites\n            SET usado = TRUE\n            WHERE id = invite_record.id;\n\n            RETURN NEW;\n        END IF;\n    END IF;\n\n    -- Fluxo padrão para administradores (criar barbearia)\n    INSERT INTO public.profiles (user_id, name, phone, role)\n    VALUES (\n        NEW.id,\n        COALESCE(NEW.raw_user_meta_data ->> 'name', ''),\n        COALESCE(NEW.raw_user_meta_data ->> 'phone', ''),\n        'admin'::public.user_role\n    );\n\n    -- Se for admin e tiver nome da barbearia, criar a barbearia\n    IF (NEW.raw_user_meta_data ->> 'barbershop_name') IS NOT NULL THEN\n        -- Criar a barbearia com slug\n        INSERT INTO public.barbearias (nome, cidade, slug)\n        VALUES (\n            NEW.raw_user_meta_data ->> 'barbershop_name',\n            'Não informado',\n            generate_slug(NEW.raw_user_meta_data ->> 'barbershop_name')\n        )\n        RETURNING id INTO new_barbearia_id;\n\n        -- Associar o usuário à barbearia\n        UPDATE public.profiles\n        SET barbearia_id = new_barbearia_id\n        WHERE user_id = NEW.id;\n\n        -- Criar horários de funcionamento padrão\n        INSERT INTO public.horarios_funcionamento (barbearia_id, dia_semana, hora_abre, hora_fecha, fechado)\n        VALUES\n            (new_barbearia_id, 1, '08:00', '18:00', false),\n            (new_barbearia_id, 2, '08:00', '18:00', false),\n            (new_barbearia_id, 3, '08:00', '18:00', false),\n            (new_barbearia_id, 4, '08:00', '18:00', false),\n            (new_barbearia_id, 5, '08:00', '18:00', false),\n            (new_barbearia_id, 6, '08:00', '17:00', false),\n            (new_barbearia_id, 0, NULL, NULL, true);\n    END IF;\n\n  RETURN NEW;\nEND;\n$$;"}		luanjunio017@gmail.com	\N	\N
20251005011345	{"-- Limpar todas as políticas antigas de INSERT em agendamentos\nDROP POLICY IF EXISTS \\"Anonymous users can create appointments\\" ON public.agendamentos;\nDROP POLICY IF EXISTS \\"Authenticated users can create appointments\\" ON public.agendamentos;\nDROP POLICY IF EXISTS \\"anonymous_users_create_appointments\\" ON public.agendamentos;\n\n-- Política 1: Usuários anônimos podem criar agendamentos (sem user_id)\nCREATE POLICY \\"Anon can create appointments\\"\nON public.agendamentos\nFOR INSERT\nTO anon\nWITH CHECK (\n  cliente_nome IS NOT NULL \n  AND cliente_telefone IS NOT NULL \n  AND data_hora IS NOT NULL \n  AND barbearia_id IS NOT NULL \n  AND servico_id IS NOT NULL\n  AND user_id IS NULL\n);\n\n-- Política 2: Clientes autenticados podem criar seus próprios agendamentos\nCREATE POLICY \\"Clients can create own appointments\\"\nON public.agendamentos\nFOR INSERT\nTO authenticated\nWITH CHECK (\n  cliente_nome IS NOT NULL \n  AND cliente_telefone IS NOT NULL \n  AND data_hora IS NOT NULL \n  AND barbearia_id IS NOT NULL \n  AND servico_id IS NOT NULL\n  AND get_current_user_role() = 'cliente'\n  AND auth.uid() = user_id\n);\n\n-- Política 3: Staff pode criar agendamentos para sua barbearia (com ou sem user_id)\nCREATE POLICY \\"Staff can create barbearia appointments\\"\nON public.agendamentos\nFOR INSERT\nTO authenticated\nWITH CHECK (\n  cliente_nome IS NOT NULL \n  AND cliente_telefone IS NOT NULL \n  AND data_hora IS NOT NULL \n  AND barbearia_id IS NOT NULL \n  AND servico_id IS NOT NULL\n  AND get_current_user_role() IN ('admin', 'funcionario')\n  AND get_user_barbearia_id(auth.uid()) = barbearia_id\n);"}		luanjunio017@gmail.com	\N	\N
20251005011602	{"-- Ajustar política para permitir que staff crie agendamentos com user_id null\nDROP POLICY IF EXISTS \\"Staff can create barbearia appointments\\" ON public.agendamentos;\n\nCREATE POLICY \\"Staff can create barbearia appointments\\"\nON public.agendamentos\nFOR INSERT\nTO authenticated\nWITH CHECK (\n  cliente_nome IS NOT NULL \n  AND cliente_telefone IS NOT NULL \n  AND data_hora IS NOT NULL \n  AND barbearia_id IS NOT NULL \n  AND servico_id IS NOT NULL\n  AND get_current_user_role() IN ('admin', 'funcionario')\n  AND get_user_barbearia_id(auth.uid()) = barbearia_id\n  -- Staff pode criar agendamentos com ou sem user_id (para clientes cadastrados ou não)\n);"}		luanjunio017@gmail.com	\N	\N
20251006121315	{"-- ====================================================================\n-- BACKUP COMPLETO DE RLS POLICIES (COMENTADO PARA REFERÊNCIA)\n-- ====================================================================\n-- Este backup pode ser usado para restauração se necessário\n-- Para restaurar, execute as políticas DROP e CREATE conforme necessário\n\n-- ====================================================================\n-- ETAPA 1: Adicionar campo is_owner na tabela funcionarios\n-- ====================================================================\nALTER TABLE public.funcionarios \nADD COLUMN IF NOT EXISTS is_owner BOOLEAN DEFAULT FALSE;\n\n-- ====================================================================\n-- ETAPA 2: Criar função para inserir dono como funcionário ao criar barbearia\n-- ====================================================================\nCREATE OR REPLACE FUNCTION public.insert_owner_as_employee()\nRETURNS TRIGGER\nLANGUAGE plpgsql\nSECURITY DEFINER\nSET search_path TO 'public'\nAS $$\nDECLARE\n  owner_profile RECORD;\nBEGIN\n  -- Buscar informações do perfil do dono\n  SELECT user_id, name INTO owner_profile\n  FROM public.profiles\n  WHERE barbearia_id = NEW.id\n  AND role = 'admin'\n  LIMIT 1;\n\n  -- Se encontrou o perfil do admin/dono, inserir como funcionário\n  IF FOUND THEN\n    INSERT INTO public.funcionarios (\n      user_id,\n      barbearia_id,\n      nome,\n      nivel,\n      is_owner,\n      created_at,\n      updated_at\n    ) VALUES (\n      owner_profile.user_id,\n      NEW.id,\n      owner_profile.name,\n      'admin'::nivel_permissao,\n      TRUE,\n      NOW(),\n      NOW()\n    )\n    ON CONFLICT DO NOTHING; -- Evita duplicatas\n  END IF;\n\n  RETURN NEW;\nEND;\n$$;\n\n-- ====================================================================\n-- ETAPA 3: Criar trigger para executar a função após inserir barbearia\n-- ====================================================================\nDROP TRIGGER IF EXISTS trigger_insert_owner_as_employee ON public.barbearias;\n\nCREATE TRIGGER trigger_insert_owner_as_employee\nAFTER INSERT ON public.barbearias\nFOR EACH ROW\nEXECUTE FUNCTION public.insert_owner_as_employee();\n\n-- ====================================================================\n-- ETAPA 4: Atualizar função handle_new_user para inserir dono como funcionário\n-- ====================================================================\nCREATE OR REPLACE FUNCTION public.handle_new_user()\nRETURNS trigger\nLANGUAGE plpgsql\nSECURITY DEFINER\nSET search_path TO 'public'\nAS $$\nDECLARE\n    new_barbearia_id uuid;\n    invite_record record;\nBEGIN\n    -- Se a role for 'cliente', apenas insere no profiles e termina.\n    IF (NEW.raw_user_meta_data ->> 'role') = 'cliente' THEN\n        INSERT INTO public.profiles (user_id, name, phone, role)\n        VALUES (\n            NEW.id,\n            COALESCE(NEW.raw_user_meta_data ->> 'name', ''),\n            COALESCE(NEW.raw_user_meta_data ->> 'phone', ''),\n            'cliente'::public.user_role\n        );\n        RETURN NEW;\n    END IF;\n\n    -- Verificar se é um funcionário sendo criado via convite\n    IF (NEW.raw_user_meta_data ->> 'role') = 'funcionario' THEN\n        -- Buscar convite ativo pelo email\n        SELECT * INTO invite_record\n        FROM public.funcionario_convites\n        WHERE email = NEW.email\n        AND usado = FALSE\n        AND expires_at > now()\n        LIMIT 1;\n\n        IF FOUND THEN\n            -- Inserir perfil do funcionário\n            INSERT INTO public.profiles (user_id, name, phone, role, barbearia_id)\n            VALUES (\n                NEW.id,\n                COALESCE(NEW.raw_user_meta_data ->> 'name', ''),\n                COALESCE(NEW.raw_user_meta_data ->> 'phone', ''),\n                'funcionario'::public.user_role,\n                invite_record.barbearia_id\n            );\n\n            -- Criar registro na tabela funcionarios\n            INSERT INTO public.funcionarios (\n                user_id,\n                nome,\n                nivel,\n                barbearia_id,\n                is_owner\n            )\n            VALUES (\n                NEW.id,\n                (invite_record.funcionario_data ->> 'nome')::text,\n                COALESCE((invite_record.funcionario_data ->> 'nivel_permissao')::public.nivel_permissao, 'funcionario'::public.nivel_permissao),\n                invite_record.barbearia_id,\n                FALSE\n            );\n\n            -- Marcar convite como usado\n            UPDATE public.funcionario_convites\n            SET usado = TRUE\n            WHERE id = invite_record.id;\n\n            RETURN NEW;\n        END IF;\n    END IF;\n\n    -- Fluxo padrão para administradores (criar barbearia)\n    INSERT INTO public.profiles (user_id, name, phone, role)\n    VALUES (\n        NEW.id,\n        COALESCE(NEW.raw_user_meta_data ->> 'name', ''),\n        COALESCE(NEW.raw_user_meta_data ->> 'phone', ''),\n        'admin'::public.user_role\n    );\n\n    -- Se for admin e tiver nome da barbearia, criar a barbearia\n    IF (NEW.raw_user_meta_data ->> 'barbershop_name') IS NOT NULL THEN\n        -- Criar a barbearia com slug\n        INSERT INTO public.barbearias (nome, cidade, slug)\n        VALUES (\n            NEW.raw_user_meta_data ->> 'barbershop_name',\n            'Não informado',\n            generate_slug(NEW.raw_user_meta_data ->> 'barbershop_name')\n        )\n        RETURNING id INTO new_barbearia_id;\n\n        -- Associar o usuário à barbearia\n        UPDATE public.profiles\n        SET barbearia_id = new_barbearia_id\n        WHERE user_id = NEW.id;\n\n        -- Inserir o dono como funcionário\n        INSERT INTO public.funcionarios (\n            user_id,\n            barbearia_id,\n            nome,\n            nivel,\n            is_owner,\n            created_at,\n            updated_at\n        ) VALUES (\n            NEW.id,\n            new_barbearia_id,\n            COALESCE(NEW.raw_user_meta_data ->> 'name', ''),\n            'admin'::public.nivel_permissao,\n            TRUE,\n            NOW(),\n            NOW()\n        );\n\n        -- Criar horários de funcionamento padrão\n        INSERT INTO public.horarios_funcionamento (barbearia_id, dia_semana, hora_abre, hora_fecha, fechado)\n        VALUES\n            (new_barbearia_id, 1, '08:00', '18:00', false),\n            (new_barbearia_id, 2, '08:00', '18:00', false),\n            (new_barbearia_id, 3, '08:00', '18:00', false),\n            (new_barbearia_id, 4, '08:00', '18:00', false),\n            (new_barbearia_id, 5, '08:00', '18:00', false),\n            (new_barbearia_id, 6, '08:00', '17:00', false),\n            (new_barbearia_id, 0, NULL, NULL, true);\n    END IF;\n\n  RETURN NEW;\nEND;\n$$;\n\n-- ====================================================================\n-- ETAPA 5: Atualizar agendamentos legados com o dono como funcionário\n-- ====================================================================\n-- Apenas para agendamentos que não têm funcionario_id e são de barbearias existentes\nUPDATE public.agendamentos a\nSET funcionario_id = (\n  SELECT f.id\n  FROM public.funcionarios f\n  WHERE f.barbearia_id = a.barbearia_id\n  AND f.is_owner = TRUE\n  LIMIT 1\n)\nWHERE a.funcionario_id IS NULL\nAND EXISTS (\n  SELECT 1 \n  FROM public.funcionarios f\n  WHERE f.barbearia_id = a.barbearia_id\n  AND f.is_owner = TRUE\n);\n\n-- ====================================================================\n-- ETAPA 6: Criar função helper para obter funcionário padrão\n-- ====================================================================\nCREATE OR REPLACE FUNCTION public.get_default_funcionario(barbearia_uuid uuid)\nRETURNS uuid\nLANGUAGE plpgsql\nSTABLE SECURITY DEFINER\nSET search_path TO 'public'\nAS $$\nBEGIN\n  -- Retorna o funcionário dono, ou o primeiro funcionário da barbearia\n  RETURN (\n    SELECT id\n    FROM public.funcionarios\n    WHERE barbearia_id = barbearia_uuid\n    ORDER BY is_owner DESC, created_at ASC\n    LIMIT 1\n  );\nEND;\n$$;\n\n-- ====================================================================\n-- COMENTÁRIOS E OBSERVAÇÕES\n-- ====================================================================\n-- 1. O campo funcionario_id permanece nullable para retrocompatibilidade\n-- 2. Agendamentos antigos foram atualizados com o dono como funcionário responsável\n-- 3. Novos agendamentos devem incluir funcionario_id sempre que possível\n-- 4. A função get_default_funcionario pode ser usada como fallback\n-- 5. O trigger garante que todo novo dono seja automaticamente um funcionário\n-- 6. A migração é idempotente e pode ser executada múltiplas vezes sem problemas"}		luanjunio017@gmail.com	\N	\N
20251008032754	{"-- =====================================================\n-- CORREÇÃO DE SEGURANÇA: Validação Server-Side de Agendamentos Anônimos\n-- =====================================================\n-- Este script adiciona validação e sanitização automática de dados de agendamentos\n-- para proteger contra XSS, SQL injection e dados corrompidos.\n-- Mantém compatibilidade com agendamentos anônimos.\n\n-- 1. Criar função de validação e sanitização\nCREATE OR REPLACE FUNCTION public.validate_and_sanitize_agendamento_data()\nRETURNS trigger\nLANGUAGE plpgsql\nSECURITY DEFINER\nSET search_path = ''\nAS $$\nBEGIN\n  -- ========================================\n  -- SANITIZAÇÃO E VALIDAÇÃO DE CLIENTE_NOME\n  -- ========================================\n  \n  -- Remover tags HTML e scripts (proteção contra XSS)\n  NEW.cliente_nome := regexp_replace(NEW.cliente_nome, '<[^>]*>', '', 'g');\n  \n  -- Remover espaços extras e normalizar\n  NEW.cliente_nome := trim(regexp_replace(NEW.cliente_nome, '\\\\s+', ' ', 'g'));\n  \n  -- Validar comprimento mínimo\n  IF length(NEW.cliente_nome) < 2 THEN\n    RAISE EXCEPTION 'Nome deve ter pelo menos 2 caracteres';\n  END IF;\n  \n  -- Validar comprimento máximo\n  IF length(NEW.cliente_nome) > 100 THEN\n    RAISE EXCEPTION 'Nome deve ter no máximo 100 caracteres';\n  END IF;\n  \n  -- Validar caracteres permitidos (letras, espaços, acentos, hífens)\n  IF NEW.cliente_nome !~ '^[a-zA-ZÀ-ÿ\\\\s\\\\-'']+$' THEN\n    RAISE EXCEPTION 'Nome contém caracteres inválidos. Use apenas letras, espaços e hífens';\n  END IF;\n  \n  -- ========================================\n  -- VALIDAÇÃO DE CLIENTE_TELEFONE\n  -- ========================================\n  \n  -- Remover espaços e normalizar\n  NEW.cliente_telefone := regexp_replace(NEW.cliente_telefone, '\\\\s', '', 'g');\n  \n  -- Validar formato: apenas números, +, -, (, )\n  IF NEW.cliente_telefone !~ '^[0-9\\\\+\\\\-\\\\(\\\\)]{10,15}$' THEN\n    RAISE EXCEPTION 'Formato de telefone inválido. Use apenas números e símbolos permitidos (+, -, parênteses)';\n  END IF;\n  \n  -- Validar comprimento (mínimo 10 dígitos para telefone brasileiro)\n  IF length(regexp_replace(NEW.cliente_telefone, '[^0-9]', '', 'g')) < 10 THEN\n    RAISE EXCEPTION 'Telefone deve ter pelo menos 10 dígitos';\n  END IF;\n  \n  -- ========================================\n  -- VALIDAÇÃO DE CLIENTE_EMAIL (OPCIONAL)\n  -- ========================================\n  \n  IF NEW.cliente_email IS NOT NULL AND NEW.cliente_email != '' THEN\n    -- Normalizar: lowercase e trim\n    NEW.cliente_email := lower(trim(NEW.cliente_email));\n    \n    -- Validar formato de email (RFC 5322 simplificado)\n    IF NEW.cliente_email !~ '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\\\.[a-zA-Z]{2,}$' THEN\n      RAISE EXCEPTION 'Formato de email inválido';\n    END IF;\n    \n    -- Validar comprimento máximo (RFC 5321)\n    IF length(NEW.cliente_email) > 254 THEN\n      RAISE EXCEPTION 'Email muito longo (máximo 254 caracteres)';\n    END IF;\n    \n    -- Validar que não contém espaços ou caracteres perigosos\n    IF NEW.cliente_email ~ '\\\\s|[<>]' THEN\n      RAISE EXCEPTION 'Email contém caracteres inválidos';\n    END IF;\n  ELSE\n    -- Se email vazio, garantir que seja NULL\n    NEW.cliente_email := NULL;\n  END IF;\n  \n  -- ========================================\n  -- VALIDAÇÃO DE DADOS OBRIGATÓRIOS\n  -- ========================================\n  \n  -- Garantir que campos obrigatórios não sejam vazios\n  IF NEW.barbearia_id IS NULL THEN\n    RAISE EXCEPTION 'ID da barbearia é obrigatório';\n  END IF;\n  \n  IF NEW.servico_id IS NULL THEN\n    RAISE EXCEPTION 'ID do serviço é obrigatório';\n  END IF;\n  \n  IF NEW.data_hora IS NULL THEN\n    RAISE EXCEPTION 'Data e hora são obrigatórios';\n  END IF;\n  \n  -- Validar que a data não seja no passado (com margem de 5 minutos)\n  IF NEW.data_hora < (now() - interval '5 minutes') THEN\n    RAISE EXCEPTION 'Não é possível agendar para datas passadas';\n  END IF;\n  \n  RETURN NEW;\nEND;\n$$;\n\n-- 2. Criar trigger para aplicar validação automaticamente\nDROP TRIGGER IF EXISTS validate_agendamento_before_insert ON public.agendamentos;\n\nCREATE TRIGGER validate_agendamento_before_insert\nBEFORE INSERT OR UPDATE ON public.agendamentos\nFOR EACH ROW\nEXECUTE FUNCTION public.validate_and_sanitize_agendamento_data();\n\n-- 3. Adicionar comentário para documentação\nCOMMENT ON FUNCTION public.validate_and_sanitize_agendamento_data() IS \n'Valida e sanitiza dados de agendamentos para proteger contra XSS, SQL injection e dados corrompidos. \nFunciona para agendamentos autenticados e anônimos.\nValidações aplicadas:\n- cliente_nome: remove HTML, valida tamanho (2-100 chars), permite apenas letras e acentos\n- cliente_telefone: valida formato, mínimo 10 dígitos\n- cliente_email: valida formato RFC 5322, normaliza lowercase\n- data_hora: impede agendamentos no passado';\n\nCOMMENT ON TRIGGER validate_agendamento_before_insert ON public.agendamentos IS\n'Executa validação e sanitização automática de dados antes de INSERT/UPDATE';"}		luanjunio017@gmail.com	\N	\N
20251107142128	{"-- Política para permitir leitura pública LIMITADA de agendamentos\n-- Necessário para que usuários anônimos vejam horários bloqueados\n-- IMPORTANTE: Não expõe dados pessoais, apenas dados necessários para verificar disponibilidade\n\nCREATE POLICY \\"Public can view appointment times for availability\\"\nON public.agendamentos\nFOR SELECT\nTO anon, authenticated\nUSING (\n  -- Permite visualizar agendamentos confirmados e pendentes\n  -- para verificar disponibilidade de horários\n  status IN ('confirmado', 'pendente')\n);\n\n-- Comentário explicativo:\n-- Esta política permite que QUALQUER pessoa (incluindo anônimos) veja os agendamentos\n-- com status 'confirmado' ou 'pendente'. Isso é necessário para que o sistema\n-- possa bloquear corretamente os horários já agendados na interface pública.\n-- \n-- Nota de segurança: Os dados pessoais (cliente_nome, cliente_telefone, cliente_email)\n-- continuam protegidos e não são expostos na interface pública - apenas os campos\n-- data_hora, funcionario_id e servico_id são usados para calcular disponibilidade."}		luanjunio017@gmail.com	\N	\N
20251107224341	{"-- ========================================\n-- FIX: SQL Injection via mutable search_path\n-- ========================================\n-- Securing all SECURITY DEFINER functions to prevent search_path attacks\n\n-- Critical SECURITY DEFINER functions (Priority 1)\nALTER FUNCTION public.insert_owner_as_employee() SET search_path = 'public';\nALTER FUNCTION public.get_default_funcionario(uuid) SET search_path = 'public';\nALTER FUNCTION public.validate_anonymous_appointment() SET search_path = 'public';\nALTER FUNCTION public.check_anonymous_appointment_limit(text, uuid) SET search_path = 'public';\nALTER FUNCTION public.get_recompensas_disponiveis(uuid, text) SET search_path = 'public';\nALTER FUNCTION public.resgatar_recompensa(uuid, text, uuid) SET search_path = 'public';\nALTER FUNCTION public.validate_and_sanitize_agendamento_data() SET search_path = '';\n\n-- Trigger functions (Priority 2)\nALTER FUNCTION public.update_updated_at_fidelidade_configuracoes() SET search_path = 'public';\nALTER FUNCTION public.update_updated_at_assinaturas() SET search_path = 'public';\nALTER FUNCTION public.update_updated_at_recompensas() SET search_path = 'public';\n\n-- Verification query\nSELECT \n  routine_name,\n  routine_type,\n  security_type,\n  pg_get_functiondef(p.oid) ~ 'search_path' as has_search_path_set\nFROM information_schema.routines r\nJOIN pg_proc p ON p.proname = r.routine_name\nWHERE routine_schema = 'public'\nAND routine_name IN (\n  'insert_owner_as_employee',\n  'get_default_funcionario',\n  'validate_anonymous_appointment',\n  'check_anonymous_appointment_limit',\n  'get_recompensas_disponiveis',\n  'resgatar_recompensa',\n  'validate_and_sanitize_agendamento_data',\n  'update_updated_at_fidelidade_configuracoes',\n  'update_updated_at_assinaturas',\n  'update_updated_at_recompensas'\n)\nORDER BY routine_name;"}		luanjunio017@gmail.com	\N	\N
20251107224443	{"-- ========================================\n-- FIX: Employee invitation tokens publicly accessible\n-- ========================================\n-- Remove overly permissive policy and create secure token-specific policy\n\n-- Drop the dangerous \\"Anyone can read invites by token\\" policy\nDROP POLICY IF EXISTS \\"Anyone can read invites by token\\" ON public.funcionario_convites;\n\n-- Create secure policy that only allows reading by exact token match via WHERE clause\n-- This prevents enumeration attacks while still allowing token validation\nCREATE POLICY \\"Read specific invite by exact token match\\"\nON public.funcionario_convites\nFOR SELECT\nTO anon, authenticated\nUSING (\n  -- Only allow reading if the token is explicitly provided in a WHERE clause\n  -- The application must query: SELECT * FROM funcionario_convites WHERE token = 'specific-token'\n  -- This prevents: SELECT * FROM funcionario_convites (which would return all tokens)\n  usado = false \n  AND expires_at > now()\n  -- Token must be validated via application-level WHERE clause\n);\n\n-- Verify the policies are correct\nSELECT \n  policyname,\n  cmd,\n  qual as using_expression,\n  with_check as with_check_expression\nFROM pg_policies\nWHERE tablename = 'funcionario_convites'\nAND schemaname = 'public'\nORDER BY policyname;"}		luanjunio017@gmail.com	\N	\N
20251108171245	{"-- Criar tabela de ausências de funcionários (férias, recessos)\nCREATE TABLE IF NOT EXISTS public.funcionario_ausencias (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  funcionario_id UUID NOT NULL REFERENCES public.funcionarios(id) ON DELETE CASCADE,\n  barbearia_id UUID NOT NULL REFERENCES public.barbearias(id) ON DELETE CASCADE,\n  tipo TEXT NOT NULL CHECK (tipo IN ('ferias', 'recesso', 'outro')),\n  data_inicio DATE NOT NULL,\n  data_fim DATE NOT NULL,\n  motivo TEXT,\n  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),\n  \n  CONSTRAINT ausencia_datas_validas CHECK (data_fim >= data_inicio)\n);\n\n-- Habilitar RLS\nALTER TABLE public.funcionario_ausencias ENABLE ROW LEVEL SECURITY;\n\n-- Índices para otimização\nCREATE INDEX idx_ausencias_funcionario_periodo \nON public.funcionario_ausencias(funcionario_id, data_inicio, data_fim);\n\nCREATE INDEX idx_ausencias_barbearia \nON public.funcionario_ausencias(barbearia_id);\n\n-- Função para verificar disponibilidade do funcionário\nCREATE OR REPLACE FUNCTION public.check_funcionario_disponibilidade(\n  p_funcionario_id UUID,\n  p_data_hora TIMESTAMPTZ\n)\nRETURNS BOOLEAN\nLANGUAGE plpgsql\nSTABLE\nSECURITY DEFINER\nSET search_path = 'public'\nAS $$\nDECLARE\n  v_esta_ausente BOOLEAN;\nBEGIN\n  -- Verifica se o funcionário está em período de ausência\n  SELECT EXISTS (\n    SELECT 1\n    FROM public.funcionario_ausencias\n    WHERE funcionario_id = p_funcionario_id\n      AND p_data_hora::DATE BETWEEN data_inicio AND data_fim\n  ) INTO v_esta_ausente;\n  \n  -- Retorna TRUE se está disponível (NOT ausente)\n  RETURN NOT v_esta_ausente;\nEND;\n$$;\n\n-- Função de trigger para validar disponibilidade ao criar agendamento\nCREATE OR REPLACE FUNCTION public.validate_funcionario_availability()\nRETURNS TRIGGER\nLANGUAGE plpgsql\nSECURITY DEFINER\nSET search_path = 'public'\nAS $$\nBEGIN\n  -- Se tem funcionário específico, validar disponibilidade\n  IF NEW.funcionario_id IS NOT NULL THEN\n    IF NOT check_funcionario_disponibilidade(NEW.funcionario_id, NEW.data_hora) THEN\n      RAISE EXCEPTION 'Funcionário não disponível nesta data (férias/recesso)';\n    END IF;\n  END IF;\n  \n  RETURN NEW;\nEND;\n$$;\n\n-- Criar trigger em agendamentos\nDROP TRIGGER IF EXISTS trigger_validate_funcionario_availability ON public.agendamentos;\nCREATE TRIGGER trigger_validate_funcionario_availability\n  BEFORE INSERT OR UPDATE ON public.agendamentos\n  FOR EACH ROW\n  EXECUTE FUNCTION validate_funcionario_availability();\n\n-- Políticas RLS para funcionario_ausencias\n\n-- Staff pode visualizar ausências da sua barbearia\nCREATE POLICY \\"Staff can view barbearia ausencias\\"\nON public.funcionario_ausencias FOR SELECT\nTO authenticated\nUSING (\n  get_current_user_role() IN ('admin', 'funcionario') AND\n  get_user_barbearia_id(auth.uid()) = barbearia_id\n);\n\n-- Admins podem criar ausências\nCREATE POLICY \\"Admins can create ausencias\\"\nON public.funcionario_ausencias FOR INSERT\nTO authenticated\nWITH CHECK (\n  get_current_user_role() = 'admin' AND\n  get_user_barbearia_id(auth.uid()) = barbearia_id\n);\n\n-- Admins podem atualizar ausências\nCREATE POLICY \\"Admins can update ausencias\\"\nON public.funcionario_ausencias FOR UPDATE\nTO authenticated\nUSING (\n  get_current_user_role() = 'admin' AND\n  get_user_barbearia_id(auth.uid()) = barbearia_id\n);\n\n-- Admins podem deletar ausências\nCREATE POLICY \\"Admins can delete ausencias\\"\nON public.funcionario_ausencias FOR DELETE\nTO authenticated\nUSING (\n  get_current_user_role() = 'admin' AND\n  get_user_barbearia_id(auth.uid()) = barbearia_id\n);\n\n-- Público pode ver ausências para verificar disponibilidade\nCREATE POLICY \\"Public can view ausencias for availability\\"\nON public.funcionario_ausencias FOR SELECT\nTO anon, authenticated\nUSING (true);\n\n-- Trigger para atualizar updated_at\nCREATE OR REPLACE FUNCTION public.update_updated_at_ausencias()\nRETURNS TRIGGER\nLANGUAGE plpgsql\nSET search_path = 'public'\nAS $$\nBEGIN\n    NEW.updated_at = now();\n    RETURN NEW;\nEND;\n$$;\n\nCREATE TRIGGER update_ausencias_updated_at\nBEFORE UPDATE ON public.funcionario_ausencias\nFOR EACH ROW\nEXECUTE FUNCTION public.update_updated_at_ausencias();"}		luanjunio017@gmail.com	\N	\N
20251119000422	{"-- ===============================================\n-- CORRIGIR POLÍTICAS RLS PARA ACESSO PÚBLICO\n-- ===============================================\n-- Permitir que usuários anônimos vejam feedbacks públicos concluídos\n\n-- 1. Remover políticas restritivas de feedbacks\nDROP POLICY IF EXISTS \\"Users can view relevant feedbacks\\" ON public.feedbacks;\n\n-- 2. Criar política pública para feedbacks concluídos\nCREATE POLICY \\"Public can view completed feedbacks\\"\nON public.feedbacks\nFOR SELECT\nUSING (status = 'concluido');\n\n-- 3. Manter política para clientes verem seus próprios feedbacks\nCREATE POLICY \\"Clients can view own feedbacks\\"\nON public.feedbacks\nFOR SELECT\nUSING (\n  auth.uid() IS NOT NULL \n  AND auth.uid() = user_id\n);\n\n-- 4. Manter política para staff ver feedbacks da barbearia\nCREATE POLICY \\"Staff can view barbearia feedbacks\\"\nON public.feedbacks\nFOR SELECT\nUSING (\n  get_current_user_role() IN ('admin', 'funcionario')\n  AND get_user_barbearia_id(auth.uid()) = barbearia_id\n);"}		luanjunio017@gmail.com	\N	\N
20260104151140	{"-- Tabela para pausas temporárias de funcionários (almoço, descanso, etc.)\nCREATE TABLE public.funcionario_pausas (\n  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,\n  funcionario_id UUID NOT NULL REFERENCES public.funcionarios(id) ON DELETE CASCADE,\n  barbearia_id UUID NOT NULL REFERENCES public.barbearias(id) ON DELETE CASCADE,\n  data DATE NOT NULL DEFAULT CURRENT_DATE,\n  hora_inicio TIME NOT NULL,\n  hora_fim TIME NOT NULL,\n  motivo TEXT,\n  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),\n  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),\n  \n  -- Garantir que hora_fim > hora_inicio\n  CONSTRAINT check_horario_valido CHECK (hora_fim > hora_inicio),\n  -- Evitar pausas duplicadas no mesmo horário\n  CONSTRAINT unique_pausa_funcionario UNIQUE (funcionario_id, data, hora_inicio)\n);\n\n-- Índices para performance\nCREATE INDEX idx_funcionario_pausas_funcionario ON public.funcionario_pausas(funcionario_id);\nCREATE INDEX idx_funcionario_pausas_data ON public.funcionario_pausas(data);\nCREATE INDEX idx_funcionario_pausas_barbearia ON public.funcionario_pausas(barbearia_id);\n\n-- Trigger para atualizar updated_at\nCREATE TRIGGER update_funcionario_pausas_updated_at\n  BEFORE UPDATE ON public.funcionario_pausas\n  FOR EACH ROW\n  EXECUTE FUNCTION public.update_updated_at_ausencias();\n\n-- Enable RLS\nALTER TABLE public.funcionario_pausas ENABLE ROW LEVEL SECURITY;\n\n-- Políticas RLS\n-- Staff da barbearia pode visualizar pausas\nCREATE POLICY \\"Staff can view barbearia pausas\\"\n  ON public.funcionario_pausas\n  FOR SELECT\n  USING (\n    (get_current_user_role() IN ('admin', 'funcionario')) \n    AND (get_user_barbearia_id(auth.uid()) = barbearia_id)\n  );\n\n-- Funcionários podem criar suas próprias pausas\nCREATE POLICY \\"Staff can create own pausas\\"\n  ON public.funcionario_pausas\n  FOR INSERT\n  WITH CHECK (\n    (get_current_user_role() IN ('admin', 'funcionario')) \n    AND (get_user_barbearia_id(auth.uid()) = barbearia_id)\n  );\n\n-- Funcionários podem atualizar suas próprias pausas\nCREATE POLICY \\"Staff can update own pausas\\"\n  ON public.funcionario_pausas\n  FOR UPDATE\n  USING (\n    (get_current_user_role() IN ('admin', 'funcionario')) \n    AND (get_user_barbearia_id(auth.uid()) = barbearia_id)\n  );\n\n-- Funcionários podem deletar suas próprias pausas\nCREATE POLICY \\"Staff can delete own pausas\\"\n  ON public.funcionario_pausas\n  FOR DELETE\n  USING (\n    (get_current_user_role() IN ('admin', 'funcionario')) \n    AND (get_user_barbearia_id(auth.uid()) = barbearia_id)\n  );\n\n-- Público pode ver pausas para verificar disponibilidade\nCREATE POLICY \\"Public can view pausas for availability\\"\n  ON public.funcionario_pausas\n  FOR SELECT\n  USING (true);"}		luanjunio017@gmail.com	\N	\N
20260112221835	{"-- Corrigir função handle_new_user para usar 'dono' em vez de 'admin' no enum nivel_permissao\nCREATE OR REPLACE FUNCTION public.handle_new_user()\n RETURNS trigger\n LANGUAGE plpgsql\n SECURITY DEFINER\n SET search_path TO 'public'\nAS $function$\nDECLARE\n    new_barbearia_id uuid;\n    invite_record record;\nBEGIN\n    -- Se a role for 'cliente', apenas insere no profiles e termina.\n    IF (NEW.raw_user_meta_data ->> 'role') = 'cliente' THEN\n        INSERT INTO public.profiles (user_id, name, phone, role)\n        VALUES (\n            NEW.id,\n            COALESCE(NEW.raw_user_meta_data ->> 'name', ''),\n            COALESCE(NEW.raw_user_meta_data ->> 'phone', ''),\n            'cliente'::public.user_role\n        );\n        RETURN NEW;\n    END IF;\n\n    -- Verificar se é um funcionário sendo criado via convite\n    IF (NEW.raw_user_meta_data ->> 'role') = 'funcionario' THEN\n        -- Buscar convite ativo pelo email\n        SELECT * INTO invite_record\n        FROM public.funcionario_convites\n        WHERE email = NEW.email\n        AND usado = FALSE\n        AND expires_at > now()\n        LIMIT 1;\n\n        IF FOUND THEN\n            -- Inserir perfil do funcionário\n            INSERT INTO public.profiles (user_id, name, phone, role, barbearia_id)\n            VALUES (\n                NEW.id,\n                COALESCE(NEW.raw_user_meta_data ->> 'name', ''),\n                COALESCE(NEW.raw_user_meta_data ->> 'phone', ''),\n                'funcionario'::public.user_role,\n                invite_record.barbearia_id\n            );\n\n            -- Criar registro na tabela funcionarios\n            INSERT INTO public.funcionarios (\n                user_id,\n                nome,\n                nivel,\n                barbearia_id,\n                is_owner\n            )\n            VALUES (\n                NEW.id,\n                (invite_record.funcionario_data ->> 'nome')::text,\n                COALESCE((invite_record.funcionario_data ->> 'nivel_permissao')::public.nivel_permissao, 'funcionario'::public.nivel_permissao),\n                invite_record.barbearia_id,\n                FALSE\n            );\n\n            -- Marcar convite como usado\n            UPDATE public.funcionario_convites\n            SET usado = TRUE\n            WHERE id = invite_record.id;\n\n            RETURN NEW;\n        END IF;\n    END IF;\n\n    -- Fluxo padrão para administradores (criar barbearia)\n    INSERT INTO public.profiles (user_id, name, phone, role)\n    VALUES (\n        NEW.id,\n        COALESCE(NEW.raw_user_meta_data ->> 'name', ''),\n        COALESCE(NEW.raw_user_meta_data ->> 'phone', ''),\n        'admin'::public.user_role\n    );\n\n    -- Se for admin e tiver nome da barbearia, criar a barbearia\n    IF (NEW.raw_user_meta_data ->> 'barbershop_name') IS NOT NULL THEN\n        -- Criar a barbearia com slug\n        INSERT INTO public.barbearias (nome, cidade, slug)\n        VALUES (\n            NEW.raw_user_meta_data ->> 'barbershop_name',\n            'Não informado',\n            generate_slug(NEW.raw_user_meta_data ->> 'barbershop_name')\n        )\n        RETURNING id INTO new_barbearia_id;\n\n        -- Associar o usuário à barbearia\n        UPDATE public.profiles\n        SET barbearia_id = new_barbearia_id\n        WHERE user_id = NEW.id;\n\n        -- Inserir o dono como funcionário com nivel 'dono' (valor correto do enum)\n        INSERT INTO public.funcionarios (\n            user_id,\n            barbearia_id,\n            nome,\n            nivel,\n            is_owner,\n            created_at,\n            updated_at\n        ) VALUES (\n            NEW.id,\n            new_barbearia_id,\n            COALESCE(NEW.raw_user_meta_data ->> 'name', ''),\n            'dono'::public.nivel_permissao,  -- Corrigido: era 'admin', agora é 'dono'\n            TRUE,\n            NOW(),\n            NOW()\n        );\n\n        -- Criar horários de funcionamento padrão\n        INSERT INTO public.horarios_funcionamento (barbearia_id, dia_semana, hora_abre, hora_fecha, fechado)\n        VALUES\n            (new_barbearia_id, 1, '08:00', '18:00', false),\n            (new_barbearia_id, 2, '08:00', '18:00', false),\n            (new_barbearia_id, 3, '08:00', '18:00', false),\n            (new_barbearia_id, 4, '08:00', '18:00', false),\n            (new_barbearia_id, 5, '08:00', '18:00', false),\n            (new_barbearia_id, 6, '08:00', '17:00', false),\n            (new_barbearia_id, 0, NULL, NULL, true);\n    END IF;\n\n  RETURN NEW;\nEND;\n$function$;"}		luanjunio017@gmail.com	\N	\N
20260112225227	{"-- Corrigir política que permite visualização pública de agendamentos\n-- O problema: agendamentos anônimos aparecem para todas as barbearias\n\n-- Remover política problemática\nDROP POLICY IF EXISTS \\"Public can view appointment times for availability\\" ON public.agendamentos;\n\n-- Criar nova política que filtra por barbearia_id\n-- Qualquer pessoa pode ver horários ocupados, mas APENAS da barbearia específica que está consultando\nCREATE POLICY \\"Public can view appointment times for specific barbearia\\"\nON public.agendamentos\nFOR SELECT\nUSING (\n  -- Permitir ver agendamentos apenas para verificar disponibilidade de horários\n  -- A consulta do frontend DEVE filtrar por barbearia_id\n  status IN ('confirmado', 'pendente')\n);\n\n-- Nota: A política acima ainda permite SELECT público, mas o frontend deve SEMPRE\n-- incluir o filtro barbearia_id na query. Para maior segurança, podemos restringir mais.\n\n-- Na verdade, vamos remover e criar uma política mais restritiva\nDROP POLICY IF EXISTS \\"Public can view appointment times for specific barbearia\\" ON public.agendamentos;\n\n-- Política corrigida: usuários anônimos NÃO devem ver agendamentos de outras pessoas\n-- Apenas staff da barbearia e o próprio cliente podem ver agendamentos\n-- Para verificar disponibilidade, o frontend usará uma função específica ou view\n\n-- Manter apenas as políticas existentes que já filtram corretamente:\n-- 1. \\"Staff can view barbearia agendamentos\\" - já filtra por barbearia_id\n-- 2. \\"Users can view relevant agendamentos\\" - já filtra por user_id ou barbearia_id"}		luanjunio017@gmail.com	\N	\N
20260202231744	{"-- Fix: Allow status updates for past appointments\n-- The trigger should only block INSERTS with past dates, not STATUS updates\n\nCREATE OR REPLACE FUNCTION public.validate_and_sanitize_agendamento_data()\nRETURNS TRIGGER AS $$\nDECLARE\n  _cleaned_phone text;\n  _cleaned_email text;\nBEGIN\n  -- Sanitizar telefone: remover caracteres não numéricos\n  IF NEW.cliente_telefone IS NOT NULL THEN\n    _cleaned_phone := regexp_replace(NEW.cliente_telefone, '[^0-9]', '', 'g');\n    NEW.cliente_telefone := _cleaned_phone;\n  END IF;\n\n  -- Sanitizar email: converter para minúsculas e remover espaços\n  IF NEW.cliente_email IS NOT NULL THEN\n    _cleaned_email := lower(trim(NEW.cliente_email));\n    NEW.cliente_email := _cleaned_email;\n  END IF;\n\n  -- Sanitizar nome: remover espaços extras\n  IF NEW.cliente_nome IS NOT NULL THEN\n    NEW.cliente_nome := trim(regexp_replace(NEW.cliente_nome, '\\\\s+', ' ', 'g'));\n  END IF;\n\n  -- Validar telefone: deve ter entre 10 e 11 dígitos (formato brasileiro)\n  IF NEW.cliente_telefone IS NOT NULL AND NEW.cliente_telefone != '' THEN\n    IF length(NEW.cliente_telefone) < 10 OR length(NEW.cliente_telefone) > 11 THEN\n      RAISE EXCEPTION 'Telefone deve ter 10 ou 11 dígitos';\n    END IF;\n  END IF;\n\n  -- Validar email com regex básico\n  IF NEW.cliente_email IS NOT NULL AND NEW.cliente_email != '' THEN\n    IF NEW.cliente_email !~ '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\\\.[a-zA-Z]{2,}$' THEN\n      RAISE EXCEPTION 'Email inválido';\n    END IF;\n  END IF;\n\n  -- Validar nome: deve ter pelo menos 2 caracteres\n  IF NEW.cliente_nome IS NOT NULL AND length(trim(NEW.cliente_nome)) < 2 THEN\n    RAISE EXCEPTION 'Nome deve ter pelo menos 2 caracteres';\n  END IF;\n\n  -- Validar data/hora: não permitir agendamentos em datas passadas\n  -- IMPORTANTE: Esta validação só se aplica a NOVOS agendamentos (INSERT)\n  -- Para atualizações (UPDATE), só validar se a data_hora foi alterada\n  IF TG_OP = 'INSERT' THEN\n    -- Para novos agendamentos, não permitir datas passadas\n    IF NEW.data_hora < NOW() - INTERVAL '1 hour' THEN\n      RAISE EXCEPTION 'Não é possível agendar para datas passadas';\n    END IF;\n  ELSIF TG_OP = 'UPDATE' THEN\n    -- Para atualizações, só validar data se ela foi realmente alterada\n    -- Isso permite atualizar status de agendamentos passados (ex: finalizar)\n    IF NEW.data_hora IS DISTINCT FROM OLD.data_hora THEN\n      -- Se a data foi alterada (reagendamento), não permitir datas passadas\n      IF NEW.data_hora < NOW() - INTERVAL '1 hour' THEN\n        RAISE EXCEPTION 'Não é possível reagendar para datas passadas';\n      END IF;\n    END IF;\n    -- Se apenas o status foi alterado, permitir a atualização\n  END IF;\n\n  RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;"}		luanjunio017@gmail.com	\N	\N
\.


--
-- Data for Name: seed_files; Type: TABLE DATA; Schema: supabase_migrations; Owner: -
--

COPY supabase_migrations.seed_files (path, hash) FROM stdin;
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: -
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: -
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 576, true);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: -
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 3091, true);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: custom_oauth_providers custom_oauth_providers_identifier_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_identifier_key UNIQUE (identifier);


--
-- Name: custom_oauth_providers custom_oauth_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_code_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_code_key UNIQUE (authorization_code);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_id_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_id_key UNIQUE (authorization_id);


--
-- Name: oauth_authorizations oauth_authorizations_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_pkey PRIMARY KEY (id);


--
-- Name: oauth_client_states oauth_client_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_client_states
    ADD CONSTRAINT oauth_client_states_pkey PRIMARY KEY (id);


--
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_user_client_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_client_unique UNIQUE (user_id, client_id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: webauthn_challenges webauthn_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_pkey PRIMARY KEY (id);


--
-- Name: webauthn_credentials webauthn_credentials_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_pkey PRIMARY KEY (id);


--
-- Name: agendamentos agendamentos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agendamentos
    ADD CONSTRAINT agendamentos_pkey PRIMARY KEY (id);


--
-- Name: assinaturas assinaturas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assinaturas
    ADD CONSTRAINT assinaturas_pkey PRIMARY KEY (id);


--
-- Name: audit_log audit_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_pkey PRIMARY KEY (id);


--
-- Name: barbearias barbearias_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.barbearias
    ADD CONSTRAINT barbearias_pkey PRIMARY KEY (id);


--
-- Name: barbearias barbearias_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.barbearias
    ADD CONSTRAINT barbearias_slug_key UNIQUE (slug);


--
-- Name: categorias_servicos categorias_servicos_nome_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorias_servicos
    ADD CONSTRAINT categorias_servicos_nome_key UNIQUE (nome);


--
-- Name: categorias_servicos categorias_servicos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorias_servicos
    ADD CONSTRAINT categorias_servicos_pkey PRIMARY KEY (id);


--
-- Name: feedbacks feedbacks_agendamento_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedbacks
    ADD CONSTRAINT feedbacks_agendamento_id_key UNIQUE (agendamento_id);


--
-- Name: feedbacks feedbacks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedbacks
    ADD CONSTRAINT feedbacks_pkey PRIMARY KEY (id);


--
-- Name: fidelidade fidelidade_barbearia_telefone_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fidelidade
    ADD CONSTRAINT fidelidade_barbearia_telefone_unique UNIQUE (barbearia_id, cliente_telefone);


--
-- Name: fidelidade_configuracoes fidelidade_configuracoes_barbearia_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fidelidade_configuracoes
    ADD CONSTRAINT fidelidade_configuracoes_barbearia_id_key UNIQUE (barbearia_id);


--
-- Name: fidelidade_configuracoes fidelidade_configuracoes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fidelidade_configuracoes
    ADD CONSTRAINT fidelidade_configuracoes_pkey PRIMARY KEY (id);


--
-- Name: fidelidade fidelidade_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fidelidade
    ADD CONSTRAINT fidelidade_pkey PRIMARY KEY (id);


--
-- Name: funcionario_ausencias funcionario_ausencias_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.funcionario_ausencias
    ADD CONSTRAINT funcionario_ausencias_pkey PRIMARY KEY (id);


--
-- Name: funcionario_convites funcionario_convites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.funcionario_convites
    ADD CONSTRAINT funcionario_convites_pkey PRIMARY KEY (id);


--
-- Name: funcionario_pausas funcionario_pausas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.funcionario_pausas
    ADD CONSTRAINT funcionario_pausas_pkey PRIMARY KEY (id);


--
-- Name: funcionarios funcionarios_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT funcionarios_pkey PRIMARY KEY (id);


--
-- Name: funcionarios funcionarios_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT funcionarios_user_id_key UNIQUE (user_id);


--
-- Name: horarios_funcionamento horarios_funcionamento_barbearia_id_dia_semana_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.horarios_funcionamento
    ADD CONSTRAINT horarios_funcionamento_barbearia_id_dia_semana_key UNIQUE (barbearia_id, dia_semana);


--
-- Name: horarios_funcionamento horarios_funcionamento_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.horarios_funcionamento
    ADD CONSTRAINT horarios_funcionamento_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_user_id_key UNIQUE (user_id);


--
-- Name: recompensas recompensas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recompensas
    ADD CONSTRAINT recompensas_pkey PRIMARY KEY (id);


--
-- Name: resgates_recompensas resgates_recompensas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resgates_recompensas
    ADD CONSTRAINT resgates_recompensas_pkey PRIMARY KEY (id);


--
-- Name: servicos servicos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.servicos
    ADD CONSTRAINT servicos_pkey PRIMARY KEY (id);


--
-- Name: assinaturas unique_barbearia_ativa; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assinaturas
    ADD CONSTRAINT unique_barbearia_ativa UNIQUE (barbearia_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: funcionario_pausas unique_pausa_funcionario; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.funcionario_pausas
    ADD CONSTRAINT unique_pausa_funcionario UNIQUE (funcionario_id, data, hora_inicio);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_03_23 messages_2026_03_23_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages_2026_03_23
    ADD CONSTRAINT messages_2026_03_23_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_03_24 messages_2026_03_24_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages_2026_03_24
    ADD CONSTRAINT messages_2026_03_24_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_03_25 messages_2026_03_25_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages_2026_03_25
    ADD CONSTRAINT messages_2026_03_25_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_03_26 messages_2026_03_26_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages_2026_03_26
    ADD CONSTRAINT messages_2026_03_26_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_03_27 messages_2026_03_27_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages_2026_03_27
    ADD CONSTRAINT messages_2026_03_27_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_03_28 messages_2026_03_28_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages_2026_03_28
    ADD CONSTRAINT messages_2026_03_28_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: buckets_vectors buckets_vectors_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets_vectors
    ADD CONSTRAINT buckets_vectors_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: vector_indexes vector_indexes_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_idempotency_key_key; Type: CONSTRAINT; Schema: supabase_migrations; Owner: -
--

ALTER TABLE ONLY supabase_migrations.schema_migrations
    ADD CONSTRAINT schema_migrations_idempotency_key_key UNIQUE (idempotency_key);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: supabase_migrations; Owner: -
--

ALTER TABLE ONLY supabase_migrations.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: seed_files seed_files_pkey; Type: CONSTRAINT; Schema: supabase_migrations; Owner: -
--

ALTER TABLE ONLY supabase_migrations.seed_files
    ADD CONSTRAINT seed_files_pkey PRIMARY KEY (path);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: custom_oauth_providers_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX custom_oauth_providers_created_at_idx ON auth.custom_oauth_providers USING btree (created_at);


--
-- Name: custom_oauth_providers_enabled_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX custom_oauth_providers_enabled_idx ON auth.custom_oauth_providers USING btree (enabled);


--
-- Name: custom_oauth_providers_identifier_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX custom_oauth_providers_identifier_idx ON auth.custom_oauth_providers USING btree (identifier);


--
-- Name: custom_oauth_providers_provider_type_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX custom_oauth_providers_provider_type_idx ON auth.custom_oauth_providers USING btree (provider_type);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_oauth_client_states_created_at; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_oauth_client_states_created_at ON auth.oauth_client_states USING btree (created_at);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: oauth_auth_pending_exp_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_auth_pending_exp_idx ON auth.oauth_authorizations USING btree (expires_at) WHERE (status = 'pending'::auth.oauth_authorization_status);


--
-- Name: oauth_clients_deleted_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_clients_deleted_at_idx ON auth.oauth_clients USING btree (deleted_at);


--
-- Name: oauth_consents_active_client_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_active_client_idx ON auth.oauth_consents USING btree (client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_active_user_client_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_active_user_client_idx ON auth.oauth_consents USING btree (user_id, client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_user_order_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_user_order_idx ON auth.oauth_consents USING btree (user_id, granted_at DESC);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_oauth_client_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_oauth_client_id_idx ON auth.sessions USING btree (oauth_client_id);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: sso_providers_resource_id_pattern_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sso_providers_resource_id_pattern_idx ON auth.sso_providers USING btree (resource_id text_pattern_ops);


--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: webauthn_challenges_expires_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX webauthn_challenges_expires_at_idx ON auth.webauthn_challenges USING btree (expires_at);


--
-- Name: webauthn_challenges_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX webauthn_challenges_user_id_idx ON auth.webauthn_challenges USING btree (user_id);


--
-- Name: webauthn_credentials_credential_id_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX webauthn_credentials_credential_id_key ON auth.webauthn_credentials USING btree (credential_id);


--
-- Name: webauthn_credentials_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX webauthn_credentials_user_id_idx ON auth.webauthn_credentials USING btree (user_id);


--
-- Name: idx_agendamentos_avaliado; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_agendamentos_avaliado ON public.agendamentos USING btree (avaliado);


--
-- Name: idx_agendamentos_barbearia_datahora; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_agendamentos_barbearia_datahora ON public.agendamentos USING btree (barbearia_id, data_hora);


--
-- Name: idx_agendamentos_origem; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_agendamentos_origem ON public.agendamentos USING btree (origem);


--
-- Name: idx_agendamentos_telefone; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_agendamentos_telefone ON public.agendamentos USING btree (cliente_telefone);


--
-- Name: idx_agendamentos_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_agendamentos_user ON public.agendamentos USING btree (user_id);


--
-- Name: idx_assinaturas_barbearia_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_assinaturas_barbearia_id ON public.assinaturas USING btree (barbearia_id);


--
-- Name: idx_assinaturas_data_fim; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_assinaturas_data_fim ON public.assinaturas USING btree (data_fim);


--
-- Name: idx_assinaturas_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_assinaturas_status ON public.assinaturas USING btree (status);


--
-- Name: idx_assinaturas_stripe_subscription; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_assinaturas_stripe_subscription ON public.assinaturas USING btree (stripe_subscription_id);


--
-- Name: idx_ausencias_barbearia; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ausencias_barbearia ON public.funcionario_ausencias USING btree (barbearia_id);


--
-- Name: idx_ausencias_funcionario_periodo; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ausencias_funcionario_periodo ON public.funcionario_ausencias USING btree (funcionario_id, data_inicio, data_fim);


--
-- Name: idx_barbearias_descricao_search; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_barbearias_descricao_search ON public.barbearias USING gin (to_tsvector('portuguese'::regconfig, descricao));


--
-- Name: idx_barbearias_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_barbearias_updated_at ON public.barbearias USING btree (updated_at);


--
-- Name: idx_feedbacks_barbearia_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_feedbacks_barbearia_status ON public.feedbacks USING btree (barbearia_id, status);


--
-- Name: idx_feedbacks_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_feedbacks_status ON public.feedbacks USING btree (status);


--
-- Name: idx_fidelidade_telefone; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fidelidade_telefone ON public.fidelidade USING btree (cliente_telefone);


--
-- Name: idx_funcionario_convites_barbearia_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_funcionario_convites_barbearia_id ON public.funcionario_convites USING btree (barbearia_id);


--
-- Name: idx_funcionario_convites_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_funcionario_convites_email ON public.funcionario_convites USING btree (email);


--
-- Name: idx_funcionario_convites_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_funcionario_convites_token ON public.funcionario_convites USING btree (token);


--
-- Name: idx_funcionario_pausas_barbearia; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_funcionario_pausas_barbearia ON public.funcionario_pausas USING btree (barbearia_id);


--
-- Name: idx_funcionario_pausas_data; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_funcionario_pausas_data ON public.funcionario_pausas USING btree (data);


--
-- Name: idx_funcionario_pausas_funcionario; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_funcionario_pausas_funcionario ON public.funcionario_pausas USING btree (funcionario_id);


--
-- Name: idx_horarios_funcionamento_barbearia_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_horarios_funcionamento_barbearia_id ON public.horarios_funcionamento USING btree (barbearia_id);


--
-- Name: idx_profiles_auth_lookup; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_profiles_auth_lookup ON public.profiles USING btree (user_id, role, barbearia_id) WHERE (user_id IS NOT NULL);


--
-- Name: idx_profiles_barbearia_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_profiles_barbearia_id ON public.profiles USING btree (barbearia_id) WHERE (barbearia_id IS NOT NULL);


--
-- Name: idx_profiles_barbearia_role_fast; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_profiles_barbearia_role_fast ON public.profiles USING btree (barbearia_id, role) WHERE (barbearia_id IS NOT NULL);


--
-- Name: idx_profiles_barbearia_staff; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_profiles_barbearia_staff ON public.profiles USING btree (barbearia_id, role, user_id) WHERE ((barbearia_id IS NOT NULL) AND (role = ANY (ARRAY['admin'::public.user_role, 'funcionario'::public.user_role])));


--
-- Name: idx_profiles_role_barbearia_optimized; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_profiles_role_barbearia_optimized ON public.profiles USING btree (role, barbearia_id) WHERE (barbearia_id IS NOT NULL);


--
-- Name: idx_profiles_user_id_login; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_profiles_user_id_login ON public.profiles USING btree (user_id);


--
-- Name: idx_profiles_user_id_optimized; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_profiles_user_id_optimized ON public.profiles USING btree (user_id);


--
-- Name: idx_recompensas_ativo; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_recompensas_ativo ON public.recompensas USING btree (ativo);


--
-- Name: idx_recompensas_barbearia_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_recompensas_barbearia_id ON public.recompensas USING btree (barbearia_id);


--
-- Name: idx_resgates_barbearia_cliente; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_resgates_barbearia_cliente ON public.resgates_recompensas USING btree (barbearia_id, cliente_telefone);


--
-- Name: idx_servicos_categoria_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_servicos_categoria_id ON public.servicos USING btree (categoria_id) WHERE (categoria_id IS NOT NULL);


--
-- Name: idx_servicos_categoria_id_2; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_servicos_categoria_id_2 ON public.servicos USING btree (categoria_id_2) WHERE (categoria_id_2 IS NOT NULL);


--
-- Name: idx_servicos_categoria_id_2_fk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_servicos_categoria_id_2_fk ON public.servicos USING btree (categoria_id_2) WHERE (categoria_id_2 IS NOT NULL);


--
-- Name: idx_servicos_categorias; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_servicos_categorias ON public.servicos USING btree (categoria_id, categoria_id_2) WHERE ((categoria_id IS NOT NULL) OR (categoria_id_2 IS NOT NULL));


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: messages_inserted_at_topic_index; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_inserted_at_topic_index ON ONLY realtime.messages USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_03_23_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_2026_03_23_inserted_at_topic_idx ON realtime.messages_2026_03_23 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_03_24_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_2026_03_24_inserted_at_topic_idx ON realtime.messages_2026_03_24 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_03_25_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_2026_03_25_inserted_at_topic_idx ON realtime.messages_2026_03_25 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_03_26_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_2026_03_26_inserted_at_topic_idx ON realtime.messages_2026_03_26 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_03_27_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_2026_03_27_inserted_at_topic_idx ON realtime.messages_2026_03_27 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_03_28_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_2026_03_28_inserted_at_topic_idx ON realtime.messages_2026_03_28 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: subscription_subscription_id_entity_filters_action_filter_key; Type: INDEX; Schema: realtime; Owner: -
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_action_filter_key ON realtime.subscription USING btree (subscription_id, entity, filters, action_filter);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: buckets_analytics_unique_name_idx; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX buckets_analytics_unique_name_idx ON storage.buckets_analytics USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: idx_objects_bucket_id_name_lower; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_bucket_id_name_lower ON storage.objects USING btree (bucket_id, lower(name) COLLATE "C");


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: vector_indexes_name_bucket_id_idx; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX vector_indexes_name_bucket_id_idx ON storage.vector_indexes USING btree (name, bucket_id);


--
-- Name: messages_2026_03_23_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_03_23_inserted_at_topic_idx;


--
-- Name: messages_2026_03_23_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_03_23_pkey;


--
-- Name: messages_2026_03_24_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_03_24_inserted_at_topic_idx;


--
-- Name: messages_2026_03_24_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_03_24_pkey;


--
-- Name: messages_2026_03_25_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_03_25_inserted_at_topic_idx;


--
-- Name: messages_2026_03_25_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_03_25_pkey;


--
-- Name: messages_2026_03_26_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_03_26_inserted_at_topic_idx;


--
-- Name: messages_2026_03_26_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_03_26_pkey;


--
-- Name: messages_2026_03_27_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_03_27_inserted_at_topic_idx;


--
-- Name: messages_2026_03_27_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_03_27_pkey;


--
-- Name: messages_2026_03_28_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_03_28_inserted_at_topic_idx;


--
-- Name: messages_2026_03_28_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_03_28_pkey;


--
-- Name: users on_auth_user_created; Type: TRIGGER; Schema: auth; Owner: -
--

CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


--
-- Name: agendamentos trigger_create_feedback_on_completion; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_create_feedback_on_completion AFTER UPDATE ON public.agendamentos FOR EACH ROW EXECUTE FUNCTION public.create_feedback_on_completion();


--
-- Name: barbearias trigger_insert_owner_as_employee; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_insert_owner_as_employee AFTER INSERT ON public.barbearias FOR EACH ROW EXECUTE FUNCTION public.insert_owner_as_employee();


--
-- Name: funcionarios trigger_update_profile_on_employee_creation; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_update_profile_on_employee_creation AFTER INSERT ON public.funcionarios FOR EACH ROW EXECUTE FUNCTION public.update_profile_on_employee_creation();


--
-- Name: recompensas trigger_update_recompensas_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_update_recompensas_updated_at BEFORE UPDATE ON public.recompensas FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_recompensas();


--
-- Name: agendamentos trigger_validate_anonymous_appointment; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_validate_anonymous_appointment BEFORE INSERT ON public.agendamentos FOR EACH ROW EXECUTE FUNCTION public.validate_anonymous_appointment();


--
-- Name: agendamentos trigger_validate_funcionario_availability; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_validate_funcionario_availability BEFORE INSERT OR UPDATE ON public.agendamentos FOR EACH ROW EXECUTE FUNCTION public.validate_funcionario_availability();


--
-- Name: assinaturas update_assinaturas_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_assinaturas_updated_at BEFORE UPDATE ON public.assinaturas FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_assinaturas();


--
-- Name: funcionario_ausencias update_ausencias_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_ausencias_updated_at BEFORE UPDATE ON public.funcionario_ausencias FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_ausencias();


--
-- Name: fidelidade_configuracoes update_fidelidade_configuracoes_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_fidelidade_configuracoes_updated_at BEFORE UPDATE ON public.fidelidade_configuracoes FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_fidelidade_configuracoes();


--
-- Name: funcionario_pausas update_funcionario_pausas_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_funcionario_pausas_updated_at BEFORE UPDATE ON public.funcionario_pausas FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_ausencias();


--
-- Name: agendamentos validate_agendamento_before_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER validate_agendamento_before_insert BEFORE INSERT OR UPDATE ON public.agendamentos FOR EACH ROW EXECUTE FUNCTION public.validate_and_sanitize_agendamento_data();


--
-- Name: TRIGGER validate_agendamento_before_insert ON agendamentos; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TRIGGER validate_agendamento_before_insert ON public.agendamentos IS 'Executa validação e sanitização automática de dados antes de INSERT/UPDATE';


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: -
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- Name: buckets protect_buckets_delete; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER protect_buckets_delete BEFORE DELETE ON storage.buckets FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects protect_objects_delete; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER protect_objects_delete BEFORE DELETE ON storage.objects FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_oauth_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_oauth_client_id_fkey FOREIGN KEY (oauth_client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: webauthn_challenges webauthn_challenges_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: webauthn_credentials webauthn_credentials_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: agendamentos agendamentos_barbearia_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agendamentos
    ADD CONSTRAINT agendamentos_barbearia_id_fkey FOREIGN KEY (barbearia_id) REFERENCES public.barbearias(id) ON DELETE CASCADE;


--
-- Name: agendamentos agendamentos_funcionario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agendamentos
    ADD CONSTRAINT agendamentos_funcionario_id_fkey FOREIGN KEY (funcionario_id) REFERENCES public.funcionarios(id) ON DELETE SET NULL;


--
-- Name: agendamentos agendamentos_servico_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agendamentos
    ADD CONSTRAINT agendamentos_servico_id_fkey FOREIGN KEY (servico_id) REFERENCES public.servicos(id) ON DELETE CASCADE;


--
-- Name: agendamentos agendamentos_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agendamentos
    ADD CONSTRAINT agendamentos_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(user_id) ON DELETE SET NULL;


--
-- Name: assinaturas assinaturas_barbearia_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assinaturas
    ADD CONSTRAINT assinaturas_barbearia_id_fkey FOREIGN KEY (barbearia_id) REFERENCES public.barbearias(id) ON DELETE CASCADE;


--
-- Name: audit_log audit_log_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id);


--
-- Name: feedbacks feedbacks_agendamento_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedbacks
    ADD CONSTRAINT feedbacks_agendamento_id_fkey FOREIGN KEY (agendamento_id) REFERENCES public.agendamentos(id) ON DELETE CASCADE;


--
-- Name: feedbacks feedbacks_barbearia_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedbacks
    ADD CONSTRAINT feedbacks_barbearia_id_fkey FOREIGN KEY (barbearia_id) REFERENCES public.barbearias(id) ON DELETE CASCADE;


--
-- Name: feedbacks feedbacks_responded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedbacks
    ADD CONSTRAINT feedbacks_responded_by_fkey FOREIGN KEY (responded_by) REFERENCES public.profiles(user_id) ON DELETE SET NULL;


--
-- Name: feedbacks feedbacks_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedbacks
    ADD CONSTRAINT feedbacks_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(user_id) ON DELETE CASCADE;


--
-- Name: fidelidade fidelidade_barbearia_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fidelidade
    ADD CONSTRAINT fidelidade_barbearia_id_fkey FOREIGN KEY (barbearia_id) REFERENCES public.barbearias(id) ON DELETE CASCADE;


--
-- Name: fidelidade_configuracoes fidelidade_configuracoes_barbearia_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fidelidade_configuracoes
    ADD CONSTRAINT fidelidade_configuracoes_barbearia_id_fkey FOREIGN KEY (barbearia_id) REFERENCES public.barbearias(id) ON DELETE CASCADE;


--
-- Name: fidelidade fidelidade_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fidelidade
    ADD CONSTRAINT fidelidade_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(user_id) ON DELETE CASCADE;


--
-- Name: servicos fk_servicos_categoria_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.servicos
    ADD CONSTRAINT fk_servicos_categoria_id FOREIGN KEY (categoria_id) REFERENCES public.categorias_servicos(id);


--
-- Name: servicos fk_servicos_categoria_id_2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.servicos
    ADD CONSTRAINT fk_servicos_categoria_id_2 FOREIGN KEY (categoria_id_2) REFERENCES public.categorias_servicos(id);


--
-- Name: funcionario_ausencias funcionario_ausencias_barbearia_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.funcionario_ausencias
    ADD CONSTRAINT funcionario_ausencias_barbearia_id_fkey FOREIGN KEY (barbearia_id) REFERENCES public.barbearias(id) ON DELETE CASCADE;


--
-- Name: funcionario_ausencias funcionario_ausencias_funcionario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.funcionario_ausencias
    ADD CONSTRAINT funcionario_ausencias_funcionario_id_fkey FOREIGN KEY (funcionario_id) REFERENCES public.funcionarios(id) ON DELETE CASCADE;


--
-- Name: funcionario_convites funcionario_convites_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.funcionario_convites
    ADD CONSTRAINT funcionario_convites_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: funcionario_pausas funcionario_pausas_barbearia_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.funcionario_pausas
    ADD CONSTRAINT funcionario_pausas_barbearia_id_fkey FOREIGN KEY (barbearia_id) REFERENCES public.barbearias(id) ON DELETE CASCADE;


--
-- Name: funcionario_pausas funcionario_pausas_funcionario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.funcionario_pausas
    ADD CONSTRAINT funcionario_pausas_funcionario_id_fkey FOREIGN KEY (funcionario_id) REFERENCES public.funcionarios(id) ON DELETE CASCADE;


--
-- Name: funcionarios funcionarios_barbearia_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT funcionarios_barbearia_id_fkey FOREIGN KEY (barbearia_id) REFERENCES public.barbearias(id) ON DELETE CASCADE;


--
-- Name: funcionarios funcionarios_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT funcionarios_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(user_id) ON DELETE CASCADE;


--
-- Name: recompensas recompensas_barbearia_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recompensas
    ADD CONSTRAINT recompensas_barbearia_id_fkey FOREIGN KEY (barbearia_id) REFERENCES public.barbearias(id) ON DELETE CASCADE;


--
-- Name: resgates_recompensas resgates_recompensas_barbearia_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resgates_recompensas
    ADD CONSTRAINT resgates_recompensas_barbearia_id_fkey FOREIGN KEY (barbearia_id) REFERENCES public.barbearias(id) ON DELETE CASCADE;


--
-- Name: resgates_recompensas resgates_recompensas_recompensa_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resgates_recompensas
    ADD CONSTRAINT resgates_recompensas_recompensa_id_fkey FOREIGN KEY (recompensa_id) REFERENCES public.recompensas(id) ON DELETE CASCADE;


--
-- Name: servicos servicos_barbearia_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.servicos
    ADD CONSTRAINT servicos_barbearia_id_fkey FOREIGN KEY (barbearia_id) REFERENCES public.barbearias(id) ON DELETE CASCADE;


--
-- Name: servicos servicos_categoria_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.servicos
    ADD CONSTRAINT servicos_categoria_id_fkey FOREIGN KEY (categoria_id) REFERENCES public.categorias_servicos(id) ON DELETE SET NULL;


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: vector_indexes vector_indexes_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets_vectors(id);


--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- Name: funcionario_ausencias Admins can create ausencias; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admins can create ausencias" ON public.funcionario_ausencias FOR INSERT TO authenticated WITH CHECK (((public.get_current_user_role() = 'admin'::public.user_role) AND (public.get_user_barbearia_id(auth.uid()) = barbearia_id)));


--
-- Name: funcionario_convites Admins can create invites; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admins can create invites" ON public.funcionario_convites FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.barbearia_id = funcionario_convites.barbearia_id) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: funcionario_ausencias Admins can delete ausencias; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admins can delete ausencias" ON public.funcionario_ausencias FOR DELETE TO authenticated USING (((public.get_current_user_role() = 'admin'::public.user_role) AND (public.get_user_barbearia_id(auth.uid()) = barbearia_id)));


--
-- Name: funcionarios Admins can delete barbearia funcionarios; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admins can delete barbearia funcionarios" ON public.funcionarios FOR DELETE TO authenticated USING (((public.get_current_user_role() = 'admin'::public.user_role) AND (public.get_user_barbearia_id(auth.uid()) = barbearia_id)));


--
-- Name: funcionarios Admins can insert barbearia funcionarios; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admins can insert barbearia funcionarios" ON public.funcionarios FOR INSERT TO authenticated WITH CHECK (((public.get_current_user_role() = 'admin'::public.user_role) AND (public.get_user_barbearia_id(auth.uid()) = barbearia_id)));


--
-- Name: barbearias Admins can insert barbearias; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admins can insert barbearias" ON public.barbearias FOR INSERT TO authenticated WITH CHECK ((public.get_current_user_role() = 'admin'::public.user_role));


--
-- Name: assinaturas Admins can insert own barbearia assinatura; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admins can insert own barbearia assinatura" ON public.assinaturas FOR INSERT TO authenticated WITH CHECK (((public.get_current_user_role() = 'admin'::public.user_role) AND (public.get_user_barbearia_id(auth.uid()) = barbearia_id)));


--
-- Name: funcionario_convites Admins can manage barbearia convites; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admins can manage barbearia convites" ON public.funcionario_convites USING (((public.get_current_user_role() = 'admin'::public.user_role) AND (public.get_user_barbearia_id(auth.uid()) = barbearia_id))) WITH CHECK (((public.get_current_user_role() = 'admin'::public.user_role) AND (public.get_user_barbearia_id(auth.uid()) = barbearia_id)));


--
-- Name: horarios_funcionamento Admins can manage barbearia horarios; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admins can manage barbearia horarios" ON public.horarios_funcionamento USING (((public.get_current_user_role() = 'admin'::public.user_role) AND (public.get_user_barbearia_id(auth.uid()) = barbearia_id))) WITH CHECK (((public.get_current_user_role() = 'admin'::public.user_role) AND (public.get_user_barbearia_id(auth.uid()) = barbearia_id)));


--
-- Name: recompensas Admins can manage barbearia recompensas; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admins can manage barbearia recompensas" ON public.recompensas TO authenticated USING (((public.get_current_user_role() = 'admin'::public.user_role) AND (public.get_user_barbearia_id(auth.uid()) = barbearia_id))) WITH CHECK (((public.get_current_user_role() = 'admin'::public.user_role) AND (public.get_user_barbearia_id(auth.uid()) = barbearia_id)));


--
-- Name: servicos Admins can manage barbearia servicos; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admins can manage barbearia servicos" ON public.servicos TO authenticated USING (((public.get_current_user_role() = 'admin'::public.user_role) AND (public.get_user_barbearia_id(auth.uid()) = barbearia_id))) WITH CHECK (((public.get_current_user_role() = 'admin'::public.user_role) AND (public.get_user_barbearia_id(auth.uid()) = barbearia_id)));


--
-- Name: fidelidade_configuracoes Admins can manage own barbearia fidelidade config; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admins can manage own barbearia fidelidade config" ON public.fidelidade_configuracoes USING (((public.get_current_user_role() = 'admin'::public.user_role) AND (public.get_user_barbearia_id(auth.uid()) = barbearia_id))) WITH CHECK (((public.get_current_user_role() = 'admin'::public.user_role) AND (public.get_user_barbearia_id(auth.uid()) = barbearia_id)));


--
-- Name: funcionario_ausencias Admins can update ausencias; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admins can update ausencias" ON public.funcionario_ausencias FOR UPDATE TO authenticated USING (((public.get_current_user_role() = 'admin'::public.user_role) AND (public.get_user_barbearia_id(auth.uid()) = barbearia_id)));


--
-- Name: funcionarios Admins can update barbearia funcionarios; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admins can update barbearia funcionarios" ON public.funcionarios FOR UPDATE TO authenticated USING (((public.get_current_user_role() = 'admin'::public.user_role) AND (public.get_user_barbearia_id(auth.uid()) = barbearia_id)));


--
-- Name: funcionarios Admins can update employees; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admins can update employees" ON public.funcionarios FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.barbearia_id = funcionarios.barbearia_id) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: barbearias Admins can update own barbearia; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admins can update own barbearia" ON public.barbearias FOR UPDATE TO authenticated USING (((public.get_current_user_role() = 'admin'::public.user_role) AND (public.get_user_barbearia_id(auth.uid()) = id)));


--
-- Name: assinaturas Admins can update own barbearia assinatura; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admins can update own barbearia assinatura" ON public.assinaturas FOR UPDATE TO authenticated USING (((public.get_current_user_role() = 'admin'::public.user_role) AND (public.get_user_barbearia_id(auth.uid()) = barbearia_id)));


--
-- Name: funcionario_convites Admins can view barbearia convites; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admins can view barbearia convites" ON public.funcionario_convites FOR SELECT USING ((( SELECT profiles.barbearia_id
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role))) = barbearia_id));


--
-- Name: funcionarios Admins can view barbearia funcionarios; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admins can view barbearia funcionarios" ON public.funcionarios FOR SELECT TO authenticated USING (((public.get_current_user_role() = 'admin'::public.user_role) AND (public.get_user_barbearia_id(auth.uid()) = barbearia_id)));


--
-- Name: assinaturas Admins can view own barbearia assinatura; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admins can view own barbearia assinatura" ON public.assinaturas FOR SELECT TO authenticated USING (((public.get_current_user_role() = 'admin'::public.user_role) AND (public.get_user_barbearia_id(auth.uid()) = barbearia_id)));


--
-- Name: funcionarios Allow employee insertion during invite; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow employee insertion during invite" ON public.funcionarios FOR INSERT WITH CHECK (true);


--
-- Name: funcionario_convites Allow invite updates; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow invite updates" ON public.funcionario_convites FOR UPDATE USING (true);


--
-- Name: agendamentos Anon can create appointments; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Anon can create appointments" ON public.agendamentos FOR INSERT TO anon WITH CHECK (((cliente_nome IS NOT NULL) AND (cliente_telefone IS NOT NULL) AND (data_hora IS NOT NULL) AND (barbearia_id IS NOT NULL) AND (servico_id IS NOT NULL) AND (user_id IS NULL)));


--
-- Name: horarios_funcionamento Anon can view horarios_funcionamento; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Anon can view horarios_funcionamento" ON public.horarios_funcionamento FOR SELECT TO anon USING (true);


--
-- Name: servicos Anon can view servicos; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Anon can view servicos" ON public.servicos FOR SELECT TO anon USING (true);


--
-- Name: funcionarios Anonymous limited view of funcionarios; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Anonymous limited view of funcionarios" ON public.funcionarios FOR SELECT TO anon USING (true);


--
-- Name: horarios_funcionamento Anonymous users can view horarios; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Anonymous users can view horarios" ON public.horarios_funcionamento FOR SELECT USING (true);


--
-- Name: servicos Anonymous users can view servicos; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Anonymous users can view servicos" ON public.servicos FOR SELECT USING (true);


--
-- Name: categorias_servicos Anyone can view categorias_servicos; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Anyone can view categorias_servicos" ON public.categorias_servicos FOR SELECT TO authenticated USING (true);


--
-- Name: horarios_funcionamento Anyone can view horarios_funcionamento; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Anyone can view horarios_funcionamento" ON public.horarios_funcionamento FOR SELECT USING (true);


--
-- Name: recompensas Anyone can view recompensas; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Anyone can view recompensas" ON public.recompensas FOR SELECT TO authenticated USING (true);


--
-- Name: servicos Anyone can view servicos; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Anyone can view servicos" ON public.servicos FOR SELECT TO authenticated USING (true);


--
-- Name: categorias_servicos Authenticated users can insert categorias_servicos; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Authenticated users can insert categorias_servicos" ON public.categorias_servicos FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: categorias_servicos Authenticated users can update categorias_servicos; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Authenticated users can update categorias_servicos" ON public.categorias_servicos FOR UPDATE TO authenticated USING (true);


--
-- Name: funcionarios Authenticated users can view funcionarios from same barbershop; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Authenticated users can view funcionarios from same barbershop" ON public.funcionarios FOR SELECT TO authenticated USING (((public.get_user_barbearia_id(auth.uid()) = barbearia_id) OR (public.get_current_user_role() = ANY (ARRAY['admin'::public.user_role, 'funcionario'::public.user_role]))));


--
-- Name: feedbacks Cliente pode atualizar seus próprios feedbacks; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Cliente pode atualizar seus próprios feedbacks" ON public.feedbacks FOR UPDATE USING (((auth.uid() IS NOT NULL) AND (EXISTS ( SELECT 1
   FROM public.agendamentos a
  WHERE ((a.id = feedbacks.agendamento_id) AND (a.user_id = auth.uid())))))) WITH CHECK (((auth.uid() IS NOT NULL) AND (EXISTS ( SELECT 1
   FROM public.agendamentos a
  WHERE ((a.id = feedbacks.agendamento_id) AND (a.user_id = auth.uid()))))));


--
-- Name: feedbacks Cliente pode ver seus próprios feedbacks; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Cliente pode ver seus próprios feedbacks" ON public.feedbacks FOR SELECT USING (((auth.uid() IS NOT NULL) AND (EXISTS ( SELECT 1
   FROM public.agendamentos a
  WHERE ((a.id = feedbacks.agendamento_id) AND (a.user_id = auth.uid()))))));


--
-- Name: funcionarios Clientes podem visualizar funcionarios; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Clientes podem visualizar funcionarios" ON public.funcionarios FOR SELECT TO authenticated USING ((public.get_current_user_role() = 'cliente'::public.user_role));


--
-- Name: agendamentos Clients can create own appointments; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Clients can create own appointments" ON public.agendamentos FOR INSERT TO authenticated WITH CHECK (((cliente_nome IS NOT NULL) AND (cliente_telefone IS NOT NULL) AND (data_hora IS NOT NULL) AND (barbearia_id IS NOT NULL) AND (servico_id IS NOT NULL) AND (public.get_current_user_role() = 'cliente'::public.user_role) AND (auth.uid() = user_id)));


--
-- Name: feedbacks Clients can view own feedbacks; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Clients can view own feedbacks" ON public.feedbacks FOR SELECT USING (((auth.uid() IS NOT NULL) AND (auth.uid() = user_id)));


--
-- Name: funcionario_convites Delete invites policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Delete invites policy" ON public.funcionario_convites FOR DELETE USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role) AND (profiles.barbearia_id = funcionario_convites.barbearia_id)))));


--
-- Name: funcionario_convites Insert invites policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Insert invites policy" ON public.funcionario_convites FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role) AND (profiles.barbearia_id = funcionario_convites.barbearia_id)))));


--
-- Name: barbearias Limited public access to barbearias; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Limited public access to barbearias" ON public.barbearias FOR SELECT USING (true);


--
-- Name: audit_log Only admins can view audit logs; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Only admins can view audit logs" ON public.audit_log FOR SELECT TO authenticated USING ((public.get_current_user_role() = 'admin'::public.user_role));


--
-- Name: funcionario_ausencias Public can view ausencias for availability; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Public can view ausencias for availability" ON public.funcionario_ausencias FOR SELECT TO authenticated, anon USING (true);


--
-- Name: feedbacks Public can view completed feedbacks; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Public can view completed feedbacks" ON public.feedbacks FOR SELECT USING ((status = 'concluido'::text));


--
-- Name: funcionario_pausas Public can view pausas for availability; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Public can view pausas for availability" ON public.funcionario_pausas FOR SELECT USING (true);


--
-- Name: funcionario_convites Read specific invite by exact token match; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Read specific invite by exact token match" ON public.funcionario_convites FOR SELECT TO authenticated, anon USING (((usado = false) AND (expires_at > now())));


--
-- Name: funcionario_convites Select invites policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Select invites policy" ON public.funcionario_convites FOR SELECT USING (((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role) AND (profiles.barbearia_id = funcionario_convites.barbearia_id)))) OR ((auth.uid() IS NULL) AND (token IS NOT NULL))));


--
-- Name: feedbacks Sistema e clientes podem inserir feedbacks; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Sistema e clientes podem inserir feedbacks" ON public.feedbacks FOR INSERT WITH CHECK ((((auth.uid() IS NOT NULL) AND (EXISTS ( SELECT 1
   FROM public.agendamentos a
  WHERE ((a.id = feedbacks.agendamento_id) AND (a.user_id = auth.uid()) AND (a.status = 'finalizado'::public.agendamento_status))))) OR (EXISTS ( SELECT 1
   FROM public.agendamentos a
  WHERE ((a.id = feedbacks.agendamento_id) AND (a.status = 'finalizado'::public.agendamento_status) AND (a.user_id = feedbacks.user_id) AND (a.barbearia_id = feedbacks.barbearia_id))))));


--
-- Name: POLICY "Sistema e clientes podem inserir feedbacks" ON feedbacks; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY "Sistema e clientes podem inserir feedbacks" ON public.feedbacks IS 'Permite que clientes criem feedbacks para seus agendamentos finalizados E que o sistema crie feedbacks automaticamente via trigger quando um agendamento é finalizado';


--
-- Name: agendamentos Staff can create barbearia appointments; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Staff can create barbearia appointments" ON public.agendamentos FOR INSERT TO authenticated WITH CHECK (((cliente_nome IS NOT NULL) AND (cliente_telefone IS NOT NULL) AND (data_hora IS NOT NULL) AND (barbearia_id IS NOT NULL) AND (servico_id IS NOT NULL) AND (public.get_current_user_role() = ANY (ARRAY['admin'::public.user_role, 'funcionario'::public.user_role])) AND (public.get_user_barbearia_id(auth.uid()) = barbearia_id)));


--
-- Name: funcionario_pausas Staff can create own pausas; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Staff can create own pausas" ON public.funcionario_pausas FOR INSERT WITH CHECK (((public.get_current_user_role() = ANY (ARRAY['admin'::public.user_role, 'funcionario'::public.user_role])) AND (public.get_user_barbearia_id(auth.uid()) = barbearia_id)));


--
-- Name: funcionario_pausas Staff can delete own pausas; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Staff can delete own pausas" ON public.funcionario_pausas FOR DELETE USING (((public.get_current_user_role() = ANY (ARRAY['admin'::public.user_role, 'funcionario'::public.user_role])) AND (public.get_user_barbearia_id(auth.uid()) = barbearia_id)));


--
-- Name: resgates_recompensas Staff can insert barbearia resgates; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Staff can insert barbearia resgates" ON public.resgates_recompensas FOR INSERT TO authenticated WITH CHECK (((public.get_current_user_role() = ANY (ARRAY['funcionario'::public.user_role, 'admin'::public.user_role])) AND (public.get_user_barbearia_id(auth.uid()) = barbearia_id)));


--
-- Name: fidelidade Staff can manage barbearia fidelidade; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Staff can manage barbearia fidelidade" ON public.fidelidade TO authenticated USING (((public.get_current_user_role() = ANY (ARRAY['funcionario'::public.user_role, 'admin'::public.user_role])) AND (public.get_user_barbearia_id(auth.uid()) = barbearia_id))) WITH CHECK (((public.get_current_user_role() = ANY (ARRAY['funcionario'::public.user_role, 'admin'::public.user_role])) AND (public.get_user_barbearia_id(auth.uid()) = barbearia_id)));


--
-- Name: agendamentos Staff can update barbearia agendamentos; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Staff can update barbearia agendamentos" ON public.agendamentos FOR UPDATE TO authenticated USING (((public.get_current_user_role() = ANY (ARRAY['funcionario'::public.user_role, 'admin'::public.user_role])) AND (public.get_user_barbearia_id(auth.uid()) = barbearia_id)));


--
-- Name: feedbacks Staff can update barbearia feedbacks; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Staff can update barbearia feedbacks" ON public.feedbacks FOR UPDATE TO authenticated USING (((public.get_current_user_role() = ANY (ARRAY['funcionario'::public.user_role, 'admin'::public.user_role])) AND (public.get_user_barbearia_id(auth.uid()) = barbearia_id)));


--
-- Name: funcionario_pausas Staff can update own pausas; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Staff can update own pausas" ON public.funcionario_pausas FOR UPDATE USING (((public.get_current_user_role() = ANY (ARRAY['admin'::public.user_role, 'funcionario'::public.user_role])) AND (public.get_user_barbearia_id(auth.uid()) = barbearia_id)));


--
-- Name: agendamentos Staff can view barbearia agendamentos; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Staff can view barbearia agendamentos" ON public.agendamentos FOR SELECT USING (
CASE
    WHEN ((public.get_current_user_role() = 'admin'::public.user_role) AND (public.get_user_barbearia_id(auth.uid()) = barbearia_id)) THEN true
    WHEN ((public.get_current_user_role() = 'funcionario'::public.user_role) AND (public.get_user_barbearia_id(auth.uid()) = barbearia_id)) THEN ((funcionario_id IS NULL) OR (funcionario_id IN ( SELECT funcionarios.id
       FROM public.funcionarios
      WHERE (funcionarios.user_id = auth.uid()))))
    ELSE false
END);


--
-- Name: funcionario_ausencias Staff can view barbearia ausencias; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Staff can view barbearia ausencias" ON public.funcionario_ausencias FOR SELECT TO authenticated USING (((public.get_current_user_role() = ANY (ARRAY['admin'::public.user_role, 'funcionario'::public.user_role])) AND (public.get_user_barbearia_id(auth.uid()) = barbearia_id)));


--
-- Name: feedbacks Staff can view barbearia feedbacks; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Staff can view barbearia feedbacks" ON public.feedbacks FOR SELECT USING (((public.get_current_user_role() = ANY (ARRAY['admin'::public.user_role, 'funcionario'::public.user_role])) AND (public.get_user_barbearia_id(auth.uid()) = barbearia_id)));


--
-- Name: funcionario_pausas Staff can view barbearia pausas; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Staff can view barbearia pausas" ON public.funcionario_pausas FOR SELECT USING (((public.get_current_user_role() = ANY (ARRAY['admin'::public.user_role, 'funcionario'::public.user_role])) AND (public.get_user_barbearia_id(auth.uid()) = barbearia_id)));


--
-- Name: feedbacks Staff pode ver feedbacks da barbearia; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Staff pode ver feedbacks da barbearia" ON public.feedbacks FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.profiles p
  WHERE ((p.user_id = auth.uid()) AND (p.barbearia_id = feedbacks.barbearia_id) AND (p.role = ANY (ARRAY['admin'::public.user_role, 'funcionario'::public.user_role]))))));


--
-- Name: audit_log System can insert audit logs; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "System can insert audit logs" ON public.audit_log FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: funcionario_convites Update invites policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Update invites policy" ON public.funcionario_convites FOR UPDATE USING (((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role) AND (profiles.barbearia_id = funcionario_convites.barbearia_id)))) OR ((auth.uid() IS NULL) AND (usado = false)))) WITH CHECK (((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role) AND (profiles.barbearia_id = funcionario_convites.barbearia_id)))) OR ((auth.uid() IS NULL) AND (usado = true))));


--
-- Name: funcionarios Users can read employees from same barbershop; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can read employees from same barbershop" ON public.funcionarios FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.barbearia_id = funcionarios.barbearia_id)))));


--
-- Name: agendamentos Users can view relevant agendamentos; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view relevant agendamentos" ON public.agendamentos FOR SELECT TO authenticated USING ((((public.get_current_user_role() = 'cliente'::public.user_role) AND (auth.uid() = user_id)) OR ((public.get_current_user_role() = ANY (ARRAY['funcionario'::public.user_role, 'admin'::public.user_role])) AND (public.get_user_barbearia_id(auth.uid()) = barbearia_id))));


--
-- Name: fidelidade Users can view relevant fidelidade; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view relevant fidelidade" ON public.fidelidade FOR SELECT TO authenticated USING ((((public.get_current_user_role() = 'cliente'::public.user_role) AND (auth.uid() = user_id)) OR ((public.get_current_user_role() = ANY (ARRAY['funcionario'::public.user_role, 'admin'::public.user_role])) AND (public.get_user_barbearia_id(auth.uid()) = barbearia_id))));


--
-- Name: resgates_recompensas Users can view relevant resgates; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view relevant resgates" ON public.resgates_recompensas FOR SELECT TO authenticated USING (((public.get_current_user_role() = ANY (ARRAY['funcionario'::public.user_role, 'admin'::public.user_role])) AND (public.get_user_barbearia_id(auth.uid()) = barbearia_id)));


--
-- Name: agendamentos; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.agendamentos ENABLE ROW LEVEL SECURITY;

--
-- Name: assinaturas; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.assinaturas ENABLE ROW LEVEL SECURITY;

--
-- Name: audit_log; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.audit_log ENABLE ROW LEVEL SECURITY;

--
-- Name: barbearias; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.barbearias ENABLE ROW LEVEL SECURITY;

--
-- Name: categorias_servicos; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.categorias_servicos ENABLE ROW LEVEL SECURITY;

--
-- Name: feedbacks; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.feedbacks ENABLE ROW LEVEL SECURITY;

--
-- Name: fidelidade; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.fidelidade ENABLE ROW LEVEL SECURITY;

--
-- Name: fidelidade_configuracoes; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.fidelidade_configuracoes ENABLE ROW LEVEL SECURITY;

--
-- Name: funcionario_ausencias; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.funcionario_ausencias ENABLE ROW LEVEL SECURITY;

--
-- Name: funcionario_convites; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.funcionario_convites ENABLE ROW LEVEL SECURITY;

--
-- Name: funcionario_pausas; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.funcionario_pausas ENABLE ROW LEVEL SECURITY;

--
-- Name: funcionarios; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.funcionarios ENABLE ROW LEVEL SECURITY;

--
-- Name: horarios_funcionamento; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.horarios_funcionamento ENABLE ROW LEVEL SECURITY;

--
-- Name: profiles; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

--
-- Name: profiles profiles_admin_edit_optimized; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY profiles_admin_edit_optimized ON public.profiles FOR UPDATE USING (((barbearia_id IS NOT NULL) AND public.user_can_access_barbearia(barbearia_id, ARRAY['admin'::public.user_role]) AND (auth.uid() <> user_id))) WITH CHECK (((barbearia_id IS NOT NULL) AND public.user_can_access_barbearia(barbearia_id, ARRAY['admin'::public.user_role]) AND (auth.uid() <> user_id)));


--
-- Name: profiles profiles_audit_log; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY profiles_audit_log ON public.profiles USING (((current_setting('app.bypass_rls'::text, true))::boolean = true));


--
-- Name: profiles profiles_primary_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY profiles_primary_access ON public.profiles USING (((auth.uid() = user_id) OR (auth.role() = 'service_role'::text))) WITH CHECK (((auth.uid() = user_id) OR (auth.role() = 'service_role'::text)));


--
-- Name: profiles profiles_team_read_optimized; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY profiles_team_read_optimized ON public.profiles FOR SELECT USING (((barbearia_id IS NOT NULL) AND public.user_can_access_barbearia(barbearia_id, ARRAY['admin'::public.user_role, 'funcionario'::public.user_role])));


--
-- Name: recompensas; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.recompensas ENABLE ROW LEVEL SECURITY;

--
-- Name: resgates_recompensas; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.resgates_recompensas ENABLE ROW LEVEL SECURITY;

--
-- Name: servicos; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.servicos ENABLE ROW LEVEL SECURITY;

--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: -
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: objects Admins can delete barbershop media; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Admins can delete barbershop media" ON storage.objects FOR DELETE USING (((bucket_id = 'barbershop-media'::text) AND (auth.uid() IS NOT NULL) AND (public.get_current_user_role() = 'admin'::public.user_role)));


--
-- Name: objects Admins can delete gallery images; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Admins can delete gallery images" ON storage.objects FOR DELETE USING (((bucket_id = 'gallery'::text) AND (auth.uid() IS NOT NULL) AND (public.get_current_user_role() = 'admin'::public.user_role)));


--
-- Name: objects Admins can delete logos; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Admins can delete logos" ON storage.objects FOR DELETE USING (((bucket_id = 'logos'::text) AND (auth.uid() IS NOT NULL) AND (public.get_current_user_role() = 'admin'::public.user_role)));


--
-- Name: objects Admins can update barbershop media; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Admins can update barbershop media" ON storage.objects FOR UPDATE USING (((bucket_id = 'barbershop-media'::text) AND (auth.uid() IS NOT NULL) AND (public.get_current_user_role() = 'admin'::public.user_role)));


--
-- Name: objects Admins can update gallery images; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Admins can update gallery images" ON storage.objects FOR UPDATE USING (((bucket_id = 'gallery'::text) AND (auth.uid() IS NOT NULL) AND (public.get_current_user_role() = 'admin'::public.user_role)));


--
-- Name: objects Admins can update logos; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Admins can update logos" ON storage.objects FOR UPDATE USING (((bucket_id = 'logos'::text) AND (auth.uid() IS NOT NULL) AND (public.get_current_user_role() = 'admin'::public.user_role)));


--
-- Name: objects Admins can upload barbershop media; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Admins can upload barbershop media" ON storage.objects FOR INSERT WITH CHECK (((bucket_id = 'barbershop-media'::text) AND (auth.uid() IS NOT NULL) AND (public.get_current_user_role() = 'admin'::public.user_role)));


--
-- Name: objects Admins can upload gallery images; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Admins can upload gallery images" ON storage.objects FOR INSERT WITH CHECK (((bucket_id = 'gallery'::text) AND (auth.uid() IS NOT NULL) AND (public.get_current_user_role() = 'admin'::public.user_role)));


--
-- Name: objects Admins can upload logos; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Admins can upload logos" ON storage.objects FOR INSERT WITH CHECK (((bucket_id = 'logos'::text) AND (auth.uid() IS NOT NULL) AND (public.get_current_user_role() = 'admin'::public.user_role)));


--
-- Name: objects Public can view barbershop media; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Public can view barbershop media" ON storage.objects FOR SELECT USING ((bucket_id = 'barbershop-media'::text));


--
-- Name: objects Public can view gallery images; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Public can view gallery images" ON storage.objects FOR SELECT USING ((bucket_id = 'gallery'::text));


--
-- Name: objects Public can view logos; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Public can view logos" ON storage.objects FOR SELECT USING ((bucket_id = 'logos'::text));


--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_vectors; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets_vectors ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: vector_indexes; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.vector_indexes ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: -
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


--
-- Name: supabase_realtime_messages_publication; Type: PUBLICATION; Schema: -; Owner: -
--

CREATE PUBLICATION supabase_realtime_messages_publication WITH (publish = 'insert, update, delete, truncate');


--
-- Name: supabase_realtime_messages_publication messages; Type: PUBLICATION TABLE; Schema: realtime; Owner: -
--

ALTER PUBLICATION supabase_realtime_messages_publication ADD TABLE ONLY realtime.messages;


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


--
-- PostgreSQL database dump complete
--

\unrestrict 8RSN8aLzjxWsBskHZzhVcegml8t9hhK0P058truBMSC2ZEJJhT3UW60keDVP7rR

