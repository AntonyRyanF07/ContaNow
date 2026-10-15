import 'package:flutter/foundation.dart';
import '../models/conta.dart';
import '../services/armazenamento_contas.dart';

class ControladorContas extends ChangeNotifier {
  final ArmazenamentoContas _armazenamento;
  ControladorContas(this._armazenamento);

  List<Conta> _contas = [];
  bool carregando = true;
  String? erro;

  List<Conta> get contas => List.unmodifiable(_contas);

  Future<void> iniciar() async {
    try {
      _contas = await _armazenamento.carregar();
      erro = null;
    } catch (_) {
      erro = 'Não foi possível carregar as contas salvas.';
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<void> _atualizar(List<Conta> atualizadas) async {
    await _armazenamento.salvar(atualizadas);
    _contas = atualizadas;
    notifyListeners();
  }

  Future<void> adicionar(Conta conta) async => _atualizar([..._contas, conta]);

  Future<void> editar(Conta conta) async => _atualizar([
        for (final atual in _contas)
          if (atual.id == conta.id) conta else atual,
      ]);

  Future<void> remover(String id) async =>
      _atualizar(_contas.where((conta) => conta.id != id).toList());

  Future<void> definirPagamento(Conta conta, bool paga) async =>
      editar(conta.alterarPagamento(paga));

  List<Conta> contasDoMes(DateTime mes) => _contas
      .where((conta) =>
          conta.vencimento.year == mes.year &&
          conta.vencimento.month == mes.month)
      .toList();

  double total(List<Conta> lista) =>
      lista.fold(0, (soma, conta) => soma + conta.valor);
  double totalPago(List<Conta> lista) =>
      total(lista.where((conta) => conta.paga).toList());
  double totalPendente(List<Conta> lista) =>
      total(lista.where((conta) => !conta.paga).toList());
}
