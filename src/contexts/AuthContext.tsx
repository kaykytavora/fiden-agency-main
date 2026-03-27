import { createContext, useContext, useEffect, useState, useCallback } from 'react';
import { User, Session } from '@supabase/supabase-js';
import { supabase } from '@/integrations/supabase/client';
import type { Database } from '@/integrations/supabase/types';
import { logger } from '@/lib/logger';

type UserRole = Database['public']['Enums']['user_role'];
type Profile = Database['public']['Tables']['profiles']['Row'];

interface AuthContextType {
  user: User | null;
  session: Session | null;
  role: UserRole | null;
  profile: Profile | null;
  barbeariaId: string | null;
  loading: boolean; // Continuará sendo a flag principal para os componentes
  signUp: (email: string, password: string, options?: { data?: Record<string, unknown> }) => Promise<{ error: Error | null }>;
  signIn: (email: string, password: string) => Promise<{ error: Error | null }>;
  signOut: () => Promise<{ error: Error | null }>;
  resetPassword: (email: string) => Promise<{ error: Error | null }>;
  verifyCodeAndUpdatePassword: (email: string, code: string, password: string) => Promise<{ error: Error | null }>;
  refreshProfile: () => Promise<void>;
}

// Default values for when useAuth is called outside AuthProvider
const defaultAuthContext: AuthContextType = {
  user: null,
  session: null,
  role: null,
  profile: null,
  barbeariaId: null,
  loading: false,
  signUp: async () => ({ error: null }),
  signIn: async () => ({ error: null }),
  signOut: async () => ({ error: null }),
  resetPassword: async () => ({ error: null }),
  verifyCodeAndUpdatePassword: async () => ({ error: null }),
  refreshProfile: async () => {},
};

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [session, setSession] = useState<Session | null>(null);
  const [role, setRole] = useState<UserRole | null>(null);
  const [profile, setProfile] = useState<Profile | null>(null);
  const [barbeariaId, setBarbeariaId] = useState<string | null>(null);
  const [authLoading, setAuthLoading] = useState(true); // Carregamento da autenticação
  const [profileLoading, setProfileLoading] = useState(true); // Carregamento do perfil

  // Memoiza a função de busca de sessão e perfil para evitar recriações desnecessárias
  const fetchSessionAndProfile = useCallback(async () => {
    console.log('fetchSessionAndProfile called');

    try {
      const { data: { session }, error: sessionError } = await supabase.auth.getSession();

      if (sessionError) {
        logger.error("Error fetching session", sessionError);
        setAuthLoading(false);
        setProfileLoading(false);
        return;
      }

      const currentUser = session?.user ?? null;

      setSession(session);
      setUser(currentUser);
      setAuthLoading(false); // Auth carregado

      console.log('Current user ID:', currentUser?.id);

      // Apenas busque o perfil se houver um usuário na sessão atual
      if (currentUser) {
        try {
          // Tentar buscar perfil com timeout para evitar travamentos
          const profilePromise = supabase
            .from('profiles')
            .select('*')
            .eq('user_id', currentUser.id)
            .single();

          const timeoutPromise = new Promise((_, reject) =>
            setTimeout(() => reject(new Error('Profile fetch timeout')), 10000)
          );

        const { data: profileData, error: profileError } = await Promise.race([
            profilePromise,
            timeoutPromise
          ]) as any;

          if (profileError) {
            if (profileError.code !== 'PGRST116') {
              logger.error("Error fetching profile", {
                error: profileError,
                userId: currentUser.id,
                code: profileError.code,
                message: profileError.message,
                details: profileError.details
              });
            }

            // Para erro 500 ou problemas de RLS, verificar funcionários primeiro
            if (profileError.code === 'PGRST301' ||
                profileError.message?.includes('500') ||
                profileError.code === '42501' ||
                profileError.details?.includes('500')) {
              logger.warn("RLS/500 error detected, checking employee data via RPC");

              let userRole = currentUser.user_metadata?.role || 'cliente';
              let userBarbeariaId: string | null = null;

              // Buscar dados do funcionário via RPC
              try {
                const { data: funcData } = await supabase.rpc('get_funcionario_data', {
                  user_uuid: currentUser.id
                }) as { data: any };

                if (funcData && funcData.barbearia_id) {
                  userBarbeariaId = funcData.barbearia_id;
                  if (funcData.nivel === 'dono' || funcData.nivel === 'gerente') {
                    userRole = 'admin';
                  } else {
                    userRole = 'funcionario';
                  }
                  logger.info("Employee found via RPC, role:", userRole, "barbearia:", userBarbeariaId);
                }
              } catch (e) {
                logger.warn("RPC failed, trying cache:", e);
              }

              // Se encontrou dados do funcionário, usar
              if (userBarbeariaId) {
                const empProfile = {
                  id: currentUser.id,
                  user_id: currentUser.id,
                  name: currentUser.user_metadata?.full_name || currentUser.user_metadata?.name || currentUser.email?.split('@')[0] || 'Usuário',
                  phone: currentUser.user_metadata?.phone || null,
                  role: userRole,
                  barbearia_id: userBarbeariaId,
                  receber_lembretes_email: true,
                  receber_lembretes_sms: false,
                  consentimento_marketing: false,
                  created_at: new Date().toISOString(),
                  updated_at: new Date().toISOString()
                };
                setProfile(empProfile as any);
                setRole(userRole as any);
                setBarbeariaId(userBarbeariaId);
                localStorage.setItem(`user_profile_${currentUser.id}`, JSON.stringify(empProfile));
              } else {
                // Tentar cache local
                const cachedProfile = localStorage.getItem(`user_profile_${currentUser.id}`);
                if (cachedProfile) {
                  try {
                    const parsedProfile = JSON.parse(cachedProfile);
                    logger.info("Using cached profile data");
                    setProfile(parsedProfile);
                    setRole(parsedProfile.role);
                    setBarbeariaId(parsedProfile.barbearia_id);
                  } catch {
                    // Fallback para cliente
                    setProfile({
                      id: '',
                      user_id: currentUser.id,
                      name: currentUser.user_metadata?.name || currentUser.email?.split('@')[0] || 'Usuário',
                      phone: null,
                      role: 'cliente' as any,
                      barbearia_id: null,
                      receber_lembretes_email: true,
                      receber_lembretes_sms: false,
                      consentimento_marketing: false,
                      created_at: new Date().toISOString(),
                      updated_at: new Date().toISOString()
                    });
                    setRole('cliente' as any);
                    setBarbeariaId(null);
                  }
                } else {
                  // Definir como cliente
                  setProfile({
                    id: '',
                    user_id: currentUser.id,
                    name: currentUser.user_metadata?.name || currentUser.email?.split('@')[0] || 'Usuário',
                    phone: null,
                    role: 'cliente' as any,
                    barbearia_id: null,
                    receber_lembretes_email: true,
                    receber_lembretes_sms: false,
                    consentimento_marketing: false,
                    created_at: new Date().toISOString(),
                    updated_at: new Date().toISOString()
                  });
                  setRole('cliente' as any);
                  setBarbeariaId(null);
                }
              }
          } else if (profileError.code === 'PGRST116') {
            logger.warn("Profile not found, checking if user is a employee");
            
            let userRole = currentUser.user_metadata?.role || 'cliente';
            let userBarbeariaId: string | null = currentUser.user_metadata?.barbearia_id || null;

            // Usar RPC para buscar dados do funcionário (funciona mesmo com RLS)
            try {
              const { data: funcData } = await supabase.rpc('get_funcionario_data', {
                user_uuid: currentUser.id
              }) as { data: any };

              if (funcData && funcData.barbearia_id) {
                userBarbeariaId = funcData.barbearia_id;
                if (funcData.nivel === 'dono' || funcData.nivel === 'gerente') {
                  userRole = 'admin';
                } else {
                  userRole = 'funcionario';
                }
                logger.info("User is employee, role:", userRole, "barbearia:", userBarbeariaId);
              } else {
                logger.warn("User is not an employee, defaulting to cliente");
              }
            } catch (e) {
              logger.warn("Could not fetch employee data via RPC:", e);
            }

            // Tentar inserir perfil (pode falhar por RLS, mas tentamos)
            const { data: newProfile, error: createError } = await supabase
              .from('profiles')
              .insert({
                user_id: currentUser.id,
                name: currentUser.user_metadata?.full_name || currentUser.user_metadata?.name || currentUser.email?.split('@')[0] || 'Usuário',
                phone: currentUser.user_metadata?.phone || null,
                role: userRole,
                barbearia_id: userBarbeariaId,
                receber_lembretes_email: true,
                receber_lembretes_sms: false,
                consentimento_marketing: false
              })
              .select()
              .single();

            if (createError) {
              // Se falhar por RLS, criar perfil虚拟 no estado local
              logger.warn("Could not create profile in DB due to RLS, using metadata-based profile", createError);
              
              // Criar perfil virtual baseado nos metadados
              const virtualProfile = {
                id: currentUser.id,
                user_id: currentUser.id,
                name: currentUser.user_metadata?.full_name || currentUser.user_metadata?.name || currentUser.email?.split('@')[0] || 'Usuário',
                phone: currentUser.user_metadata?.phone || null,
                role: userRole,
                barbearia_id: userBarbeariaId,
                receber_lembretes_email: true,
                receber_lembretes_sms: false,
                consentimento_marketing: false,
                created_at: new Date().toISOString(),
                updated_at: new Date().toISOString()
              };
              
              setProfile(virtualProfile as any);
              setRole(userRole as any);
              setBarbeariaId(userBarbeariaId);
              localStorage.setItem(`user_profile_${currentUser.id}`, JSON.stringify(virtualProfile));
            } else if (newProfile) {
              logger.info("Profile created successfully");
              setProfile(newProfile);
              setRole(newProfile.role);
              setBarbeariaId(newProfile.barbearia_id);
              localStorage.setItem(`user_profile_${currentUser.id}`, JSON.stringify(newProfile));
            }
          } else {
            // Outros erros - limpa o estado
            setProfile(null);
            setRole(null);
            setBarbeariaId(null);
          }
        } else {
          // Sucesso: mas ainda verificar se é funcionário para garantir dados corretos
          let finalRole = profileData.role;
          let finalBarbeariaId = profileData.barbearia_id;

          // Verificar via RPC se é funcionário
          try {
            const { data: funcData } = await supabase.rpc('get_funcionario_data', {
              user_uuid: currentUser.id
            }) as { data: any };

            if (funcData && funcData.barbearia_id) {
              // Usar dados da tabela funcionários
              finalBarbeariaId = funcData.barbearia_id;
              if (funcData.nivel === 'dono' || funcData.nivel === 'gerente') {
                finalRole = 'admin';
              } else {
                finalRole = 'funcionario';
              }
              logger.info("Overriding profile with employee data, role:", finalRole);
            }
          } catch (e) {
            // Ignorar erro, usar dados do perfil
          }

          const finalProfile = { ...profileData, role: finalRole, barbearia_id: finalBarbeariaId };
          setProfile(finalProfile);
          setRole(finalRole);
          setBarbeariaId(finalBarbeariaId);

          // Salvar no cache local
          try {
            localStorage.setItem(`user_profile_${currentUser.id}`, JSON.stringify(finalProfile));
          } catch (cacheError) {
            logger.error("Error caching profile data", cacheError);
          }
        }
        } catch (error: any) {
          logger.error("Unexpected error fetching profile", {
            error: error.message,
            userId: currentUser.id,
            stack: error.stack
          });

          // Tentar recuperar do cache local primeiro
          const cachedProfile = localStorage.getItem(`user_profile_${currentUser.id}`);
          if (cachedProfile) {
            try {
              const parsedProfile = JSON.parse(cachedProfile);
              logger.info("Using cached profile data during unexpected error");
              setProfile(parsedProfile);
              setRole(parsedProfile.role);
              setBarbeariaId(parsedProfile.barbearia_id);
            } catch (cacheError) {
              logger.error("Error parsing cached profile during fallback", cacheError);
              // Para qualquer erro (incluindo 500, timeout, etc), definir valores padrão
              setProfile({
                id: '',
                user_id: currentUser.id,
                name: currentUser.user_metadata?.name || currentUser.email?.split('@')[0] || 'Usuário',
                phone: null,
                role: 'cliente' as any,
                barbearia_id: null,
                receber_lembretes_email: true,
                receber_lembretes_sms: false,
                consentimento_marketing: false,
                created_at: new Date().toISOString(),
                updated_at: new Date().toISOString()
              });
              setRole('cliente' as any);
              setBarbeariaId(null);
            }
          } else {
            logger.warn("No cached profile found during unexpected error, using default values");
            setProfile({
              id: '',
              user_id: currentUser.id,
              name: currentUser.user_metadata?.name || currentUser.email?.split('@')[0] || 'Usuário',
              phone: null,
              role: 'cliente' as any,
              barbearia_id: null,
              receber_lembretes_email: true,
              receber_lembretes_sms: false,
              consentimento_marketing: false,
              created_at: new Date().toISOString(),
              updated_at: new Date().toISOString()
            });
            setRole('cliente' as any);
            setBarbeariaId(null);
          }
        }
      } else {
        // Se não houver usuário, garanta que todo o estado relacionado seja nulo.
        setProfile(null);
        setRole(null);
        setBarbeariaId(null);
      }
    } catch (error) {
      logger.error("Error in fetchSessionAndProfile", error);
      setUser(null);
      setSession(null);
      setProfile(null);
      setRole(null);
      setBarbeariaId(null);
      setAuthLoading(false);
    } finally {
      setProfileLoading(false); // Perfil carregado
    }
  }, []);

  useEffect(() => {
    fetchSessionAndProfile();

    const { data: { subscription } } = supabase.auth.onAuthStateChange(
      (event, session) => {
        console.log('Auth state change:', event, session?.user?.id);

        if (event === 'SIGNED_OUT') {
          // Garantir limpeza imediata no logout
          setUser(null);
          setSession(null);
          setProfile(null);
          setRole(null);
          setBarbeariaId(null);
          setAuthLoading(false);
          setProfileLoading(false);
        } else if (event === 'SIGNED_IN') {
          // Só buscar perfil quando usuário fizer login
          fetchSessionAndProfile();
        }
        // Ignorar TOKEN_REFRESHED e INITIAL_SESSION para evitar calls desnecessários
      }
    );

    return () => subscription.unsubscribe();
  }, [fetchSessionAndProfile]);

  const refreshProfile = useCallback(async () => {
    if (user) {
      setProfileLoading(true);
      try {
        // Tentar buscar perfil com timeout
        const profilePromise = supabase
          .from('profiles')
          .select('*')
          .eq('user_id', user.id)
          .single();

        const timeoutPromise = new Promise((_, reject) =>
          setTimeout(() => reject(new Error('Profile refresh timeout')), 10000)
        );

        const { data: profileData, error: profileError } = await Promise.race([
          profilePromise,
          timeoutPromise
        ]) as any;

        if (profileError) {
          if (profileError.code !== 'PGRST116') {
            logger.error("Error refreshing profile", {
              error: profileError,
              userId: user.id,
              code: profileError.code,
              message: profileError.message
            });
          }

          // Para erro 500 ou problemas de RLS, verificar funcionários primeiro
          if (profileError.code === 'PGRST301' ||
              profileError.message?.includes('500') ||
              profileError.code === '42501' ||
              profileError.details?.includes('500')) {
            logger.warn("RLS/500 error detected during refresh, checking employee data via RPC");

            let userRole = user.user_metadata?.role || 'cliente';
            let userBarbeariaId: string | null = null;

            // Buscar dados do funcionário via RPC
            try {
              const { data: funcData } = await supabase.rpc('get_funcionario_data', {
                user_uuid: user.id
              }) as { data: any };

              if (funcData && funcData.barbearia_id) {
                userBarbeariaId = funcData.barbearia_id;
                if (funcData.nivel === 'dono' || funcData.nivel === 'gerente') {
                  userRole = 'admin';
                } else {
                  userRole = 'funcionario';
                }
                logger.info("Employee found via RPC during refresh, role:", userRole);
              }
            } catch (e) {
              logger.warn("RPC failed during refresh:", e);
            }

            if (userBarbeariaId) {
              const empProfile = {
                id: user.id,
                user_id: user.id,
                name: user.user_metadata?.full_name || user.user_metadata?.name || user.email?.split('@')[0] || 'Usuário',
                phone: user.user_metadata?.phone || null,
                role: userRole,
                barbearia_id: userBarbeariaId,
                receber_lembretes_email: true,
                receber_lembretes_sms: false,
                consentimento_marketing: false,
                created_at: new Date().toISOString(),
                updated_at: new Date().toISOString()
              };
              setProfile(empProfile as any);
              setRole(userRole as any);
              setBarbeariaId(userBarbeariaId);
              localStorage.setItem(`user_profile_${user.id}`, JSON.stringify(empProfile));
            } else {
              // Tentar cache
              const cachedProfile = localStorage.getItem(`user_profile_${user.id}`);
              if (cachedProfile) {
                try {
                  const parsedProfile = JSON.parse(cachedProfile);
                  setProfile(parsedProfile);
                  setRole(parsedProfile.role);
                  setBarbeariaId(parsedProfile.barbearia_id);
                } catch {
                  setProfile({
                    id: '',
                    user_id: user.id,
                    name: user.user_metadata?.name || user.email?.split('@')[0] || 'Usuário',
                    phone: null,
                    role: 'cliente' as any,
                    barbearia_id: null,
                    receber_lembretes_email: true,
                    receber_lembretes_sms: false,
                    consentimento_marketing: false,
                    created_at: new Date().toISOString(),
                    updated_at: new Date().toISOString()
                  });
                  setRole('cliente' as any);
                  setBarbeariaId(null);
                }
              } else {
                setProfile({
                  id: '',
                  user_id: user.id,
                  name: user.user_metadata?.name || user.email?.split('@')[0] || 'Usuário',
                  phone: null,
                  role: 'cliente' as any,
                  barbearia_id: null,
                  receber_lembretes_email: true,
                  receber_lembretes_sms: false,
                  consentimento_marketing: false,
                  created_at: new Date().toISOString(),
                  updated_at: new Date().toISOString()
                });
                setRole('cliente' as any);
                setBarbeariaId(null);
              }
            }
          } else if (profileError.code === 'PGRST116') {
            logger.warn("Profile not found during refresh, checking employee data");
            
            let userRole = user.user_metadata?.role || 'cliente';
            let userBarbeariaId: string | null = user.user_metadata?.barbearia_id || null;

            // Usar RPC para buscar dados do funcionário
            try {
              const { data: funcData } = await supabase.rpc('get_funcionario_data', {
                user_uuid: user.id
              }) as { data: any };

              if (funcData && funcData.barbearia_id) {
                userBarbeariaId = funcData.barbearia_id;
                if (funcData.nivel === 'dono' || funcData.nivel === 'gerente') {
                  userRole = 'admin';
                } else {
                  userRole = 'funcionario';
                }
              }
            } catch (e) {
              logger.warn("Could not fetch employee data via RPC:", e);
            }

            const { data: newProfile, error: createError } = await supabase
              .from('profiles')
              .insert({
                user_id: user.id,
                name: user.user_metadata?.full_name || user.user_metadata?.name || user.email?.split('@')[0] || 'Usuário',
                phone: user.user_metadata?.phone || null,
                role: userRole,
                barbearia_id: userBarbeariaId,
                receber_lembretes_email: true,
                receber_lembretes_sms: false,
                consentimento_marketing: false
              })
              .select()
              .single();

            if (createError) {
              logger.warn("Could not create profile in DB due to RLS during refresh, using metadata-based profile");
              
              const virtualProfile = {
                id: user.id,
                user_id: user.id,
                name: user.user_metadata?.full_name || user.user_metadata?.name || user.email?.split('@')[0] || 'Usuário',
                phone: user.user_metadata?.phone || null,
                role: userRole,
                barbearia_id: userBarbeariaId,
                receber_lembretes_email: true,
                receber_lembretes_sms: false,
                consentimento_marketing: false,
                created_at: new Date().toISOString(),
                updated_at: new Date().toISOString()
              };
              
              setProfile(virtualProfile as any);
              setRole(userRole as any);
              setBarbeariaId(userBarbeariaId);
              localStorage.setItem(`user_profile_${user.id}`, JSON.stringify(virtualProfile));
            } else if (newProfile) {
              logger.info("Profile created successfully during refresh");
              setProfile(newProfile);
              setRole(newProfile.role);
              setBarbeariaId(newProfile.barbearia_id);
              localStorage.setItem(`user_profile_${user.id}`, JSON.stringify(newProfile));
            }
          } else {
            setProfile(null);
            setRole(null);
            setBarbeariaId(null);
          }
        } else {
          // Sucesso: mas ainda verificar se é funcionário para garantir dados corretos
          let finalRole = profileData.role;
          let finalBarbeariaId = profileData.barbearia_id;

          try {
            const { data: funcData } = await supabase.rpc('get_funcionario_data', {
              user_uuid: user.id
            }) as { data: any };

            if (funcData && funcData.barbearia_id) {
              finalBarbeariaId = funcData.barbearia_id;
              if (funcData.nivel === 'dono' || funcData.nivel === 'gerente') {
                finalRole = 'admin';
              } else {
                finalRole = 'funcionario';
              }
            }
          } catch (e) {
            // Ignorar erro
          }

          const finalProfile = { ...profileData, role: finalRole, barbearia_id: finalBarbeariaId };
          setProfile(finalProfile);
          setRole(finalRole);
          setBarbeariaId(finalBarbeariaId);
          try {
            localStorage.setItem(`user_profile_${user.id}`, JSON.stringify(finalProfile));
          } catch (cacheError) {
            logger.error("Error caching profile data during refresh", cacheError);
          }
        }
      } catch (error: any) {
        logger.error("Unexpected error refreshing profile", {
          error: error.message,
          userId: user.id
        });

        // Em caso de erro crítico, tentar recuperar do cache primeiro
        const cachedProfile = localStorage.getItem(`user_profile_${user.id}`);
        if (cachedProfile) {
          try {
            const parsedProfile = JSON.parse(cachedProfile);
            logger.info("Using cached profile data during refresh unexpected error");
            setProfile(parsedProfile);
            setRole(parsedProfile.role);
            setBarbeariaId(parsedProfile.barbearia_id);
          } catch (cacheError) {
            logger.error("Error parsing cached profile during refresh fallback", cacheError);
            setProfile({
              id: '',
              user_id: user.id,
              name: user.user_metadata?.name || user.email?.split('@')[0] || 'Usuário',
              phone: null,
              role: 'cliente' as any,
              barbearia_id: null,
              receber_lembretes_email: true,
              receber_lembretes_sms: false,
              consentimento_marketing: false,
              created_at: new Date().toISOString(),
              updated_at: new Date().toISOString()
            });
            setRole('cliente' as any);
            setBarbeariaId(null);
          }
        } else {
          logger.warn("No cached profile found during refresh unexpected error, using default values");
          setProfile({
            id: '',
            user_id: user.id,
            name: user.user_metadata?.name || user.email?.split('@')[0] || 'Usuário',
            phone: null,
            role: 'cliente' as any,
            barbearia_id: null,
            receber_lembretes_email: true,
            receber_lembretes_sms: false,
            consentimento_marketing: false,
            created_at: new Date().toISOString(),
            updated_at: new Date().toISOString()
          });
          setRole('cliente' as any);
          setBarbeariaId(null);
        }
      } finally {
        setProfileLoading(false);
      }
    }
  }, [user]);

  const signUp = async (email: string, password: string, options?: { data?: Record<string, unknown> }) => {
    try {
      // Limpar tokens corrompidos do localStorage antes do signup
      try {
        localStorage.removeItem('sb-agendem-auth-token');
        localStorage.removeItem('supabase.auth.token');
        // Limpar outras chaves relacionadas ao supabase
        Object.keys(localStorage).forEach(key => {
          if (key.includes('supabase') || key.includes('sb-')) {
            localStorage.removeItem(key);
          }
        });
      } catch (storageError) {
        logger.error("Error clearing localStorage:", storageError);
      }

      const { data, error } = await supabase.auth.signUp({
        email,
        password,
        options: {
          data: options?.data
        }
      });
      
      if (error) {
        logger.error("SignUp error:", error);
        return { error };
      }
      
      // O trigger handle_new_user no banco cria barbearia e vínculo automaticamente
      // Aguardar o trigger processar
      if (data.user) {
        await new Promise(resolve => setTimeout(resolve, 2000));
        await fetchSessionAndProfile();
      }
      
      return { error: null };
    } catch (err) {
      const error = err instanceof Error ? err : new Error(String(err));
      logger.error("SignUp unexpected error:", error);
      return { error };
    }
  };

  const signIn = async (email: string, password: string) => {
    const { data, error } = await supabase.auth.signInWithPassword({
      email,
      password,
    });

    // Se o login for bem-sucedido, o onAuthStateChange será acionado.
    // A chamada a seguir garante que o perfil seja buscado imediatamente,
    // o que pode ajudar em alguns cenários de tempo.
    if (!error && data.user) {
      await refreshProfile();
    }

    return { error };
  };

  const signOut = async () => {
    try {
      // Forçar logout completo com escopo 'global'
      const { error } = await supabase.auth.signOut({ scope: 'global' });
      
      // Limpeza manual e imediata do estado
      setUser(null);
      setSession(null);
      setProfile(null);
      setRole(null);
      setBarbeariaId(null);
      setAuthLoading(false);
      setProfileLoading(false);
      
      // Preservar tema antes de limpar
      const currentTheme = localStorage.getItem('agendem-theme');
      
      // Limpar localStorage e sessionStorage, mas preservar dados não relacionados ao usuário
      Object.keys(localStorage).forEach(key => {
        if (key.includes('supabase') || key.includes('sb-') || key.startsWith('user_profile_')) {
          localStorage.removeItem(key);
        }
      });
      sessionStorage.clear();
      
      // Restaurar tema
      if (currentTheme) {
        localStorage.setItem('agendem-theme', currentTheme);
      }
      
      // Limpar cookies relacionados ao Supabase
      document.cookie.split(";").forEach((c) => {
        const eqPos = c.indexOf("=");
        const name = eqPos > -1 ? c.substr(0, eqPos) : c;
        if (name.trim().includes('supabase') || name.trim().includes('sb-')) {
          document.cookie = `${name}=;expires=Thu, 01 Jan 1970 00:00:00 GMT;path=/`;
        }
      });
      
      // Forçar reload da página após um pequeno delay para garantir limpeza
      setTimeout(() => {
        window.location.href = '/';
      }, 100);
      
      return { error };
    } catch (err) {
      logger.error('Erro durante logout', err);
      // Preservar tema antes de limpar
      const currentTheme = localStorage.getItem('agendem-theme');
      
      // Mesmo se houver erro, limpar o estado e redirecionar
      setUser(null);
      setSession(null);
      setProfile(null);
      setRole(null);
      setBarbeariaId(null);
      
      // Restaurar tema
      if (currentTheme) {
        localStorage.setItem('agendem-theme', currentTheme);
      }
      
      window.location.href = '/';
      return { error: err instanceof Error ? err : new Error(String(err)) };
    }
  };

  const resetPassword = async (email: string) => {
    const { error } = await supabase.auth.resetPasswordForEmail(email);
    return { error };
  };

  const verifyCodeAndUpdatePassword = async (email: string, code: string, password: string) => {
    const { error } = await supabase.auth.verifyOtp({
      email,
      token: code,
      type: 'recovery'
    });

    if (error) {
      return { error };
    }

    const { error: updateError } = await supabase.auth.updateUser({
      password
    });

    return { error: updateError };
  };

  const value = {
    user,
    session,
    role,
    profile,
    barbeariaId,
    loading: authLoading || profileLoading, // Combina os dois loadings
    signUp,
    signIn,
    signOut,
    resetPassword,
    verifyCodeAndUpdatePassword,
    refreshProfile,
  };

  return (
    <AuthContext.Provider value={value}>
      {children}
    </AuthContext.Provider>
  );
}

export const useAuth = (): AuthContextType => {
  const context = useContext(AuthContext);
  // Return default context if not within AuthProvider (allows usage outside provider)
  if (context === undefined) {
    return defaultAuthContext;
  }
  return context;
};