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

    const { employee_user_id } = await req.json();

    if (!employee_user_id) {
      return new Response(
        JSON.stringify({ error: "ID do funcionário é obrigatório" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Buscar o funcionário
    const { data: employee, error: employeeError } = await supabase
      .from("funcionarios")
      .select("id, user_id, barbearia_id")
      .eq("user_id", employee_user_id)
      .single();

    if (employeeError || !employee) {
      return new Response(
        JSON.stringify({ error: "Funcionário não encontrado" }),
        { status: 404, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Deletear funcionário
    const { error: deleteEmployeeError } = await supabase
      .from("funcionarios")
      .delete()
      .eq("id", employee.id);

    if (deleteEmployeeError) {
      return new Response(
        JSON.stringify({ error: "Erro ao deletar funcionário: " + deleteEmployeeError.message }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Deletear perfil
    const { error: deleteProfileError } = await supabase
      .from("profiles")
      .delete()
      .eq("user_id", employee_user_id);

    if (deleteProfileError) {
      console.error("Erro ao deletar perfil:", deleteProfileError);
    }

    // Deletear usuário do auth
    const { error: deleteAuthError } = await supabase.auth.admin.deleteUser(employee_user_id);

    if (deleteAuthError) {
      console.error("Erro ao deletar usuário do auth:", deleteAuthError);
    }

    return new Response(
      JSON.stringify({ success: true }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );

  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});