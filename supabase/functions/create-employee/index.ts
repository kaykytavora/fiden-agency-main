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

    const { email, password, nome, especialidade, nivel_permissao, barbearia_id, foto_url } = await req.json();

    if (!email || !password || !nome || !barbearia_id) {
      return new Response(
        JSON.stringify({ error: "Campos obrigatórios faltando" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const role = nivel_permissao === "gerente" || nivel_permissao === "dono" ? "admin" : "funcionario";

    // Criar usuário no auth
    const { data: authData, error: authError } = await supabase.auth.admin.createUser({
      email,
      password,
      email_confirm: true,
      user_metadata: {
        full_name: nome,
        role: role
      }
    });

    if (authError) {
      return new Response(
        JSON.stringify({ error: authError.message }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const userId = authData.user.id;

    // Criar perfil
    const { error: profileError } = await supabase.from("profiles").insert({
      user_id: userId,
      name: nome,
      role: role,
      barbearia_id: barbearia_id
    });

    if (profileError) {
      // Se falhar o perfil,刪除 usuário criado
      await supabase.auth.admin.deleteUser(userId);
      return new Response(
        JSON.stringify({ error: "Erro ao criar perfil: " + profileError.message }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Criar funcionário
    const { error: employeeError } = await supabase.from("funcionarios").insert({
      barbearia_id: barbearia_id,
      user_id: userId,
      nome: nome,
      email: email,
      especialidade: especialidade || null,
      nivel: nivel_permissao,
      foto_url: foto_url || null
    });

    if (employeeError) {
      return new Response(
        JSON.stringify({ error: "Erro ao criar funcionário: " + employeeError.message }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    return new Response(
      JSON.stringify({ success: true, userId }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );

  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
