import { useState, useEffect } from "react";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription, DialogFooter, DialogClose } from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Input } from "@/components/ui/input";
import { supabase } from "@/integrations/supabase/client";
import { useToast } from "@/hooks/use-toast";
import { useQueryClient } from "@tanstack/react-query";
import { useAuth } from "@/contexts/AuthContext";

interface RescheduleModalProps {
  isOpen: boolean;
  onOpenChange: (open: boolean) => void;
  appointmentId: string | null;
  currentDate: string | null;
  onSuccess?: () => void;
}

const availableTimes = [ "08:00", "08:30", "09:00", "09:30", "10:00", "10:30", "11:00", "11:30", "12:00", "12:30", "13:00", "13:30", "14:00", "14:30", "15:00", "15:30", "16:00", "16:30", "17:00", "17:30", "18:00", "18:30", "19:00", "19:30" ];

const parseLocalDate = (isoString: string) => {
	// Parse a DB UTC ISO string manually so that we display the exact date in the UI
	// instead of shifting the timezone
	try {
		const parts = isoString.split('T');
		const timeStr = parts[1].substring(0, 5); 
		return { date: parts[0], time: timeStr };
	} catch {
		return { date: "", time: "" };
	}
};

export function RescheduleModal({ isOpen, onOpenChange, appointmentId, currentDate, onSuccess }: RescheduleModalProps) {
  const { role } = useAuth();
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const [date, setDate] = useState("");
  const [time, setTime] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);

  useEffect(() => {
    if (currentDate && isOpen) {
       const parsed = parseLocalDate(currentDate);
       setDate(parsed.date);
       setTime(parsed.time);
    }
  }, [currentDate, isOpen]);

  const handleReschedule = async () => {
    if (!appointmentId || !date || !time) {
      toast({ title: "Preencha todos os campos", variant: "destructive" });
      return;
    }

    setIsSubmitting(true);
    try {
      const dataHoraFormated = new Date(`${date}T${time}:00`).toISOString();
      const newStatus = (role === 'admin' || role === 'funcionario') ? 'aguardando_cliente' : 'pendente';

      const { error } = await supabase
        .from('agendamentos')
        .update({ data_hora: dataHoraFormated, status: newStatus as any }) // status
        .eq('id', appointmentId);

      if (error) throw error;

      toast({ title: "Sucesso!", description: "O agendamento foi reajustado com sucesso." });
      onOpenChange(false);
      queryClient.invalidateQueries();
      if (onSuccess) onSuccess();
    } catch (error) {
      console.error(error);
      toast({ title: "Erro ao reajustar", description: "Tente novamente mais tarde.", variant: "destructive" });
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <Dialog open={isOpen} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-[425px]">
        <DialogHeader>
          <DialogTitle>Reajustar Horário</DialogTitle>
          <DialogDescription>
            Escolha uma nova data e hora para este agendamento.
          </DialogDescription>
        </DialogHeader>
        <div className="grid gap-4 py-4">
          <div className="grid grid-cols-4 items-center gap-4">
            <Label htmlFor="date" className="text-right">Data</Label>
            <Input
              id="date"
              type="date"
              className="col-span-3"
              value={date}
              onChange={(e) => setDate(e.target.value)}
              min={new Date().toISOString().split('T')[0]}
            />
          </div>
          <div className="grid grid-cols-4 items-center gap-4">
            <Label htmlFor="time" className="text-right">Hora</Label>
            <Select value={time} onValueChange={setTime}>
              <SelectTrigger className="col-span-3">
                <SelectValue placeholder="Selecione o horário" />
              </SelectTrigger>
              <SelectContent className="max-h-[200px]">
                {availableTimes.map(t => (
                  <SelectItem key={t} value={t}>{t}</SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
        </div>
        <DialogFooter>
          <DialogClose asChild>
            <Button variant="outline" disabled={isSubmitting}>Cancelar</Button>
          </DialogClose>
          <Button onClick={handleReschedule} disabled={isSubmitting || !date || !time}>
            {isSubmitting ? "Salvando..." : "Confirmar Reajuste"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
