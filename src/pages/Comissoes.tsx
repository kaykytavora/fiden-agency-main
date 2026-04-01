import { useState, useEffect } from 'react';
import { DashboardLayout } from '@/layouts/DashboardLayout';
import { supabase } from '@/integrations/supabase/client';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription, DialogFooter } from '@/components/ui/dialog';
import { useToast } from '@/hooks/use-toast';
import { Users, TrendingUp, Plus, Edit, Save, User } from 'lucide-react';
import { useUserRole } from '@/hooks/useUserRole';

interface Funcionario {
  id: string;
  nome: string;
  comissao_percentual: number;
  especialidade: string;
}

interface Atendimento {
  id: string;
  data_atendimento: string;
  cliente_nome: string;
  servico_nome: string;
  valor: number;
  comissao_percentual: number;
  comissao_valor: number;
  funcionario_id: string;
}

export default function Comissoes() {
  const { barbeariaId } = useUserRole();
  const { toast } = useToast();
  const [funcionarios, setFuncionarios] = useState<Funcionario[]>([]);
  const [atendimentos, setAtendimentos] = useState<Atendimento[]>([]);
  const [loading, setLoading] = useState(true);
  const [editingFuncionario, setEditingFuncionario] = useState<Funcionario | null>(null);
  const [isDialogOpen, setIsDialogOpen] = useState(false);
  const [comissaoTemp, setComissaoTemp] = useState('');

  const [formData, setFormData] = useState({
    cliente_nome: '',
    servico_nome: '',
    valor: '',
    comissao_percentual: '',
    data_atendimento: new Date().toISOString().split('T')[0]
  });
  const [isAddDialogOpen, setIsAddDialogOpen] = useState(false);
  const [selectedFuncionarioId, setSelectedFuncionarioId] = useState('');

  useEffect(() => {
    if (barbeariaId) {
      loadData();
    }
  }, [barbeariaId]);

  const loadData = async () => {
    if (!barbeariaId) return;
    setLoading(true);

    const { data: funcData } = await supabase
      .from('funcionarios')
      .select('id, nome, comissao_percentual, especialidade')
      .eq('barbearia_id', barbeariaId)
      .order('nome');

    setFuncionarios(funcData || []);

    const { data: attData } = await supabase
      .from('funcionarios_atendimentos' as any)
      .select('*')
      .eq('barbearia_id', barbeariaId)
      .order('data_atendimento', { ascending: false })
      .limit(50);

    setAtendimentos(attData || []);
    setLoading(false);
  };

  const handleSaveComissao = async () => {
    if (!editingFuncionario) return;

    const { error } = await supabase
      .from('funcionarios')
      .update({ comissao_percentual: parseFloat(comissaoTemp) })
      .eq('id', editingFuncionario.id);

    if (error) {
      toast({ title: 'Erro', description: 'Falha ao salvar comissão', variant: 'destructive' });
    } else {
      toast({ title: 'Sucesso', description: 'Comissão atualizada!' });
      loadData();
    }
    setIsDialogOpen(false);
  };

  const handleAddAtendimento = async () => {
    if (!barbeariaId || !formData.valor || !formData.comissao_percentual || !selectedFuncionarioId) {
      toast({ title: 'Erro', description: 'Preencha todos os campos', variant: 'destructive' });
      return;
    }

    const valor = parseFloat(formData.valor);
    const comissaoPercentual = parseFloat(formData.comissao_percentual);
    const comissaoValor = valor * (comissaoPercentual / 100);

    const { error } = await supabase
      .from('funcionarios_atendimentos' as any)
      .insert({
        barbearia_id: barbeariaId,
        funcionario_id: selectedFuncionarioId,
        servico_nome: formData.servico_nome,
        cliente_nome: formData.cliente_nome,
        valor: valor,
        comissao_percentual: comissaoPercentual,
        comissao_valor: comissaoValor,
        data_atendimento: formData.data_atendimento
      });

    if (error) {
      toast({ title: 'Erro', description: 'Falha ao registrar: ' + error.message, variant: 'destructive' });
    } else {
      toast({ title: 'Sucesso', description: 'Atendimento registrado!' });
      setIsAddDialogOpen(false);
      setFormData({ cliente_nome: '', servico_nome: '', valor: '', comissao_percentual: '', data_atendimento: new Date().toISOString().split('T')[0] });
      setSelectedFuncionarioId('');
      loadData();
    }
  };

  const openEditDialog = (func: Funcionario) => {
    setEditingFuncionario(func);
    setComissaoTemp(func.comissao_percentual?.toString() || '0');
    setIsDialogOpen(true);
  };

  const handleFuncionarioChange = (funcId: string) => {
    const func = funcionarios.find(f => f.id === funcId);
    setSelectedFuncionarioId(funcId);
    setFormData({
      ...formData,
      comissao_percentual: func?.comissao_percentual?.toString() || '0'
    });
  };

  const totalReceita = atendimentos.reduce((sum, att) => sum + att.valor, 0);
  const totalComissao = atendimentos.reduce((sum, att) => sum + att.comissao_valor, 0);

  // Calcular total de comissões por funcionário
  const comissoesPorFuncionario = funcionarios.map(func => {
    const attsFuncionario = atendimentos.filter((att: any) => att.funcionario_id === func.id);
    const total = attsFuncionario.reduce((sum: number, att: any) => sum + (att.comissao_valor || 0), 0);
    return { ...func, total_comissao: total };
  });

  if (loading) {
    return (
      <DashboardLayout>
        <div className="flex items-center justify-center min-h-96">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
        </div>
      </DashboardLayout>
    );
  }

  return (
    <DashboardLayout>
      <div className="p-4 sm:p-6 space-y-6">
        <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
          <div>
            <h1 className="text-2xl sm:text-3xl font-bold">Comissões</h1>
            <p className="text-muted-foreground">Gerencie comissões dos funcionários</p>
          </div>
          <Button onClick={() => setIsAddDialogOpen(true)}>
            <Plus className="w-4 h-4 mr-2" />
            Registrar Atendimento
          </Button>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-sm font-medium text-muted-foreground">Total em Serviços</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">R$ {totalReceita.toFixed(2)}</div>
            </CardContent>
          </Card>
          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-sm font-medium text-muted-foreground">Total em Comissões</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold text-green-600">R$ {totalComissao.toFixed(2)}</div>
            </CardContent>
          </Card>
          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-sm font-medium text-muted-foreground">Funcionários</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{funcionarios.length}</div>
            </CardContent>
          </Card>
        </div>

        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Users className="w-5 h-5" />
              Configuração de Comissões
            </CardTitle>
          </CardHeader>
          <CardContent>
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Funcionário</TableHead>
                  <TableHead>Especialidade</TableHead>
                  <TableHead>% Comissão</TableHead>
                  <TableHead className="text-right">Total a Receber</TableHead>
                  <TableHead className="text-right">Ações</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {comissoesPorFuncionario.map((func) => (
                  <TableRow key={func.id}>
                    <TableCell className="font-medium">{func.nome}</TableCell>
                    <TableCell>{func.especialidade || '-'}</TableCell>
                    <TableCell>{func.comissao_percentual || 0}%</TableCell>
                    <TableCell className="text-right font-medium text-green-600">
                      R$ {func.total_comissao.toFixed(2)}
                    </TableCell>
                    <TableCell className="text-right">
                      <Button variant="outline" size="sm" onClick={() => openEditDialog(func)}>
                        <Edit className="w-4 h-4 mr-1" />
                        Editar
                      </Button>
                    </TableCell>
                  </TableRow>
                ))}
                {funcionarios.length === 0 && (
                  <TableRow>
                    <TableCell colSpan={4} className="text-center text-muted-foreground">
                      Nenhum funcionário cadastrado
                    </TableCell>
                  </TableRow>
                )}
              </TableBody>
            </Table>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <TrendingUp className="w-5 h-5" />
              Histórico de Atendimentos
            </CardTitle>
          </CardHeader>
          <CardContent>
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Data / Profissional</TableHead>
                  <TableHead>Cliente</TableHead>
                  <TableHead>Serviço</TableHead>
                  <TableHead className="text-right">Valor</TableHead>
                  <TableHead className="text-right">Comissão</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {atendimentos.map((att) => {
                  const profNome = funcionarios.find(f => f.id === att.funcionario_id)?.nome || '-';
                  return (
                  <TableRow key={att.id}>
                    <TableCell>
                      <div className="font-medium">{new Date(att.data_atendimento + 'T12:00:00').toLocaleDateString('pt-BR')}</div>
                      <div className="text-xs text-muted-foreground flex items-center gap-1 mt-0.5">
                        <User className="w-3 h-3" />
                        {profNome}
                      </div>
                    </TableCell>
                    <TableCell>{att.cliente_nome || '-'}</TableCell>
                    <TableCell>{att.servico_nome || '-'}</TableCell>
                    <TableCell className="text-right">R$ {att.valor.toFixed(2)}</TableCell>
                    <TableCell className="text-right text-green-600 font-medium">R$ {att.comissao_valor.toFixed(2)}</TableCell>
                  </TableRow>
                  );
                })}
                {atendimentos.length === 0 && (
                  <TableRow>
                    <TableCell colSpan={5} className="text-center text-muted-foreground">
                      Nenhum atendimento registrado
                    </TableCell>
                  </TableRow>
                )}
              </TableBody>
            </Table>
          </CardContent>
        </Card>

        <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
          <DialogContent>
            <DialogHeader>
              <DialogTitle>Editar Comissão</DialogTitle>
              <DialogDescription>
                Configure o percentual de comissão para {editingFuncionario?.nome}
              </DialogDescription>
            </DialogHeader>
            <div className="space-y-4 py-4">
              <div>
                <Label>Percentual de Comissão (%)</Label>
                <Input
                  type="number"
                  min="0"
                  max="100"
                  step="0.01"
                  value={comissaoTemp}
                  onChange={(e) => setComissaoTemp(e.target.value)}
                  placeholder="Ex: 40"
                />
                <p className="text-sm text-muted-foreground mt-1">
                  Ex: 40% = R$ 40,00 de comissão em serviço de R$ 100,00
                </p>
              </div>
            </div>
            <DialogFooter>
              <Button variant="outline" onClick={() => setIsDialogOpen(false)}>Cancelar</Button>
              <Button onClick={handleSaveComissao}>
                <Save className="w-4 h-4 mr-2" />
                Salvar
              </Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>

        <Dialog open={isAddDialogOpen} onOpenChange={setIsAddDialogOpen}>
          <DialogContent>
            <DialogHeader>
              <DialogTitle>Registrar Atendimento</DialogTitle>
              <DialogDescription>
                Registre um atendimento para calcular a comissão
              </DialogDescription>
            </DialogHeader>
            <div className="space-y-4 py-4">
              <div>
                <Label>Funcionário</Label>
                <select
                  className="w-full p-2 border rounded-md"
                  value={selectedFuncionarioId}
                  onChange={(e) => handleFuncionarioChange(e.target.value)}
                >
                  <option value="">Selecione...</option>
                  {funcionarios.map(f => (
                    <option key={f.id} value={f.id}>
                      {f.nome} ({f.comissao_percentual || 0}%)
                    </option>
                  ))}
                </select>
              </div>
              <div>
                <Label>Cliente</Label>
                <Input
                  value={formData.cliente_nome}
                  onChange={(e) => setFormData({ ...formData, cliente_nome: e.target.value })}
                  placeholder="Nome do cliente"
                />
              </div>
              <div>
                <Label>Serviço</Label>
                <Input
                  value={formData.servico_nome}
                  onChange={(e) => setFormData({ ...formData, servico_nome: e.target.value })}
                  placeholder="Ex: Corte Masculino"
                />
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <Label>Valor (R$)</Label>
                  <Input
                    type="number"
                    step="0.01"
                    value={formData.valor}
                    onChange={(e) => setFormData({ ...formData, valor: e.target.value })}
                    placeholder="0,00"
                  />
                </div>
                <div>
                  <Label>Data</Label>
                  <Input
                    type="date"
                    value={formData.data_atendimento}
                    onChange={(e) => setFormData({ ...formData, data_atendimento: e.target.value })}
                  />
                </div>
              </div>
              {formData.valor && formData.comissao_percentual && (
                <div className="p-3 bg-green-50 rounded-lg">
                  <p className="text-sm text-green-700">
                    Comissão: <strong>R$ {(parseFloat(formData.valor) * parseFloat(formData.comissao_percentual) / 100).toFixed(2)}</strong>
                  </p>
                </div>
              )}
            </div>
            <DialogFooter>
              <Button variant="outline" onClick={() => setIsAddDialogOpen(false)}>Cancelar</Button>
              <Button onClick={handleAddAtendimento}>Registrar</Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>
      </div>
    </DashboardLayout>
  );
}
