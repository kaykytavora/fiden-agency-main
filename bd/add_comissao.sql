-- ===================================================================
-- Tabela de Comissões de Funcionários
-- ===================================================================

-- Adicionar campo de comissão na tabela funcionarios (porcentagem 0-100)
ALTER TABLE public.funcionarios 
ADD COLUMN IF NOT EXISTS comissao_percentual DECIMAL(5,2) DEFAULT 0;

-- Tabela para registrar atendimentos e calcular comissões
CREATE TABLE IF NOT EXISTS public.funcionarios_atendimentos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  barbearia_id UUID NOT NULL REFERENCES public.barbearias(id) ON DELETE CASCADE,
  funcionario_id UUID NOT NULL REFERENCES public.funcionarios(id) ON DELETE CASCADE,
  servico_id UUID REFERENCES public.servicos(id) ON DELETE SET NULL,
  agendamento_id UUID REFERENCES public.agendamentos(id) ON DELETE SET NULL,
  cliente_nome TEXT,
  cliente_telefone TEXT,
  servico_nome TEXT,
  valor DECIMAL(10,2) NOT NULL,
  comissao_percentual DECIMAL(5,2) NOT NULL,
  comissao_valor DECIMAL(10,2) NOT NULL,
  data_atendimento DATE NOT NULL DEFAULT CURRENT_DATE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  observacoes TEXT
);

-- Habilitar RLS
ALTER TABLE public.funcionarios_atendimentos ENABLE ROW LEVEL SECURITY;

-- Índices
CREATE INDEX idx_atendimentos_funcionario ON public.funcionarios_atendimentos(funcionario_id);
CREATE INDEX idx_atendimentos_barbearia ON public.funcionarios_atendimentos(barbearia_id);
CREATE INDEX idx_atendimentos_data ON public.funcionarios_atendimentos(data_atendimento);

-- Políticas RLS
-- Admin pode gerenciar
CREATE POLICY "Admins can manage atendimentos"
ON public.funcionarios_atendimentos
FOR ALL
USING (
  get_current_user_role() = 'admin' 
  AND get_user_barbearia_id(auth.uid()) = barbearia_id
)
WITH CHECK (
  get_current_user_role() = 'admin' 
  AND get_user_barbearia_id(auth.uid()) = barbearia_id
);

-- Grant permissions
GRANT SELECT ON public.funcionarios_atendimentos TO authenticated;
GRANT INSERT ON public.funcionarios_atendimentos TO authenticated;
GRANT UPDATE ON public.funcionarios_atendimentos TO authenticated;
GRANT DELETE ON public.funcionarios_atendimentos TO authenticated;

-- Grant para funcionário (apenas visualização)
CREATE POLICY "Staff can view atendimentos"
ON public.funcionarios_atendimentos
FOR SELECT
USING (
  get_current_user_role() IN ('admin', 'funcionario')
  AND get_user_barbearia_id(auth.uid()) = barbearia_id
);
