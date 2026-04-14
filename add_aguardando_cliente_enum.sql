-- Adicionando 'aguardando_cliente' ao enum 'agendamento_status'
ALTER TYPE public.agendamento_status ADD VALUE IF NOT EXISTS 'aguardando_cliente';
