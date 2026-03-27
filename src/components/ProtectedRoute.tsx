import { useEffect, useState } from "react";
import { useAuth } from "@/contexts/AuthContext";
import { Navigate } from "react-router-dom";
import PageLoader from "./PageLoader";
import { useToast } from "@/hooks/use-toast";

interface ProtectedRouteProps {
  children: React.ReactNode;
  requiredRole?: 'admin' | 'funcionario' | 'cliente';
}

export default function ProtectedRoute({ children, requiredRole }: ProtectedRouteProps) {
  const { user, role, loading } = useAuth();
  const { toast } = useToast();
  const [showedAlert, setShowedAlert] = useState(false);

  useEffect(() => {
    if (!loading && user && requiredRole && role !== requiredRole) {
      const isAdminAccessingEmployee = requiredRole === 'funcionario' && role === 'admin';
      
      if (!isAdminAccessingEmployee && !showedAlert) {
        setShowedAlert(true);
        toast({
          title: "Acesso Restrito",
          description: "Você não tem permissão para acessar esta área. Entre em contato com o administrador.",
          variant: "destructive",
          duration: 5000,
        });
      }
    }
  }, [loading, user, requiredRole, role, toast, showedAlert]);

  if (loading) {
    return <PageLoader />;
  }

  if (!user) {
    return <Navigate to="/login" replace />;
  }

  if (requiredRole) {
    if (role !== requiredRole) {
        if (requiredRole === 'funcionario' && role === 'admin') {
            return <>{children}</>;
        }
        return <Navigate to="/unauthorized" replace />;
    }
  }

  return <>{children}</>;
}