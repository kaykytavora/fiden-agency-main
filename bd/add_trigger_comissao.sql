-- ===================================================================
-- Trigger para registrar automaticamente comissões ao finalizar agendamento
-- ===================================================================

-- Função que cria registro de comissão ao finalizar agendamento
CREATE OR REPLACE FUNCTION public.registrar_comissao_agendamento()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = 'public'
AS $$
DECLARE
  v_funcionario_id UUID;
  v_servico RECORD;
  v_barbearia_id UUID;
  v_comissao_percentual DECIMAL(5,2);
  v_comissao_valor DECIMAL(10,2);
BEGIN
  -- Apenas dispara quando o status muda para 'finalizado'
  -- e o agendamento tem um funcionário associado
  IF NEW.status = 'finalizado' AND OLD.status != 'finalizado' AND NEW.funcionario_id IS NOT NULL THEN
    
    v_funcionario_id := NEW.funcionario_id;
    v_barbearia_id := NEW.barbearia_id;
    
    -- Buscar o percentual de comissão do funcionário
    SELECT f.comissao_percentual INTO v_comissao_percentual
    FROM public.funcionarios f
    WHERE f.id = v_funcionario_id;
    
    -- Se o funcionário não tem comissão configurada, usa 0
    IF v_comissao_percentual IS NULL THEN
      v_comissao_percentual := 0;
    END IF;
    
    -- Buscar dados do serviço
    SELECT s.nome, s.preco INTO v_servico
    FROM public.servicos s
    WHERE s.id = NEW.servico_id;
    
    -- Calcular valor da comissão
    v_comissao_valor := COALESCE(v_servico.preco, 0) * (v_comissao_percentual / 100);
    
    -- Inserir registro de comissão
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
      COALESCE(v_servico.preco, 0),
      v_comissao_percentual,
      v_comissao_valor,
      NEW.data_hora::date,
      NEW.id
    );
    
  END IF;
  
  RETURN NEW;
END;
$$;

-- Criar trigger
DROP TRIGGER IF EXISTS trigger_registrar_comissao ON public.agendamentos;

CREATE TRIGGER trigger_registrar_comissao
AFTER UPDATE ON public.agendamentos
FOR EACH ROW
EXECUTE FUNCTION public.registrar_comissao_agendamento();
