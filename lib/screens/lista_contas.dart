import 'package:flutter/material.dart';
import '../controllers/controlador_contas.dart';
import '../models/conta.dart';
import '../widgets/cartao_conta.dart';
import 'formulario_conta.dart';

class ListaContas extends StatefulWidget {
  final ControladorContas controlador;

  const ListaContas({super.key, required this.controlador});

  @override
  State<ListaContas> createState() => _ListaContasEstado();
}

class _ListaContasEstado extends State<ListaContas> {
  String _filtro = 'Todas';
  String _pesquisa = '';

  Future<void> _executar(Future<void> Function() acao) async {
    try {
      await acao();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Não foi possível concluir a operação.'),
          ),
        );
      }
    }
  }

  Future<void> _excluir(Conta conta) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (contexto) => AlertDialog(
        title: const Text('Excluir conta?'),
        content: Text('Deseja excluir "${conta.titulo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(contexto, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(contexto, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await _executar(() => widget.controlador.remover(conta.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final contas = widget.controlador.contas.where((conta) {
      final corresponde =
          conta.titulo.toLowerCase().contains(_pesquisa.toLowerCase());

      final situacao = switch (_filtro) {
        'Pagas' => conta.paga,
        'Pendentes' => !conta.paga,
        'Atrasadas' => conta.atrasada,
        _ => true,
      };

      return corresponde && situacao;
    }).toList()
      ..sort((a, b) => a.vencimento.compareTo(b.vencimento));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          decoration: const InputDecoration(
            hintText: 'Pesquisar conta',
            prefixIcon: Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
          ),
          onChanged: (texto) => setState(() => _pesquisa = texto),
        ),
        const SizedBox(height: 14),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final filtro in ['Todas', 'Pendentes', 'Pagas', 'Atrasadas'])
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(filtro),
                    selected: _filtro == filtro,
                    onSelected: (_) => setState(() => _filtro = filtro),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '${contas.length} conta(s)',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        if (contas.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 60),
            child: Center(
              child: Text('Nenhuma conta encontrada.'),
            ),
          ),
        for (final conta in contas)
          CartaoConta(
            key: ValueKey(conta.id),
            conta: conta,
            aoEditar: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FormularioConta(
                  controlador: widget.controlador,
                  conta: conta,
                ),
              ),
            ),
            aoExcluir: () => _excluir(conta),
            aoMarcarPagamento: (paga) => _executar(
              () => widget.controlador.definirPagamento(conta, paga),
            ),
          ),
      ],
    );
  }
}
