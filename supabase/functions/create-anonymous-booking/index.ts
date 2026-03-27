import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    
    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    const bookingData = await req.json();

    if (!bookingData.barbearia_id || !bookingData.servico_id || !bookingData.cliente_nome || !bookingData.cliente_telefone || !bookingData.data_hora) {
      return new Response(
        JSON.stringify({ success: false, error: "Campos obrigatórios faltando" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const insertData = {
      barbearia_id: bookingData.barbearia_id,
      servico_id: bookingData.servico_id,
      funcionario_id: bookingData.funcionario_id || null,
      data_hora: bookingData.data_hora,
      cliente_nome: bookingData.cliente_nome,
      cliente_telefone: bookingData.cliente_telefone,
      cliente_email: bookingData.cliente_email || null,
      status: bookingData.status || 'confirmado',
      user_id: bookingData.user_id || null,
      origem: 'cliente_anonymous'
    };

    const { data, error } = await supabase
      .from("agendamentos")
      .insert(insertData)
      .select()
      .single();

    if (error) {
      return new Response(
        JSON.stringify({ success: false, error: error.message }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    return new Response(
      JSON.stringify({ success: true, data }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );

  } catch (error) {
    return new Response(
      JSON.stringify({ success: false, error: error.message }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
