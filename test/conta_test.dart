import 'package:flutter_test/flutter_test.dart';
import 'package:contanow/models/conta.dart';

void main() {
  test('Converte conta em mapa e recupera seus dados', () {
    final original = Conta(id: '1', titulo: 'Internet', valor: 120.5, categoria: 'Internet', vencimento: DateTime(2026, 10, 20));
    final recuperada = Conta.deMapa(original.paraMapa());
    expect(recuperada.titulo, 'Internet');
    expect(recuperada.valor, 120.5);
    expect(recuperada.paga, false);
  });

  test('Marca a conta como paga e permite desfazer', () {
    final conta = Conta(id: '2', titulo: 'Água', valor: 80, categoria: 'Água', vencimento: DateTime(2026, 10, 22));
    final paga = conta.alterarPagamento(true);
    expect(paga.paga, true);
    expect(paga.dataPagamento, isNotNull);
    final pendente = paga.alterarPagamento(false);
    expect(pendente.paga, false);
    expect(pendente.dataPagamento, isNull);
  });

  test('Conta futura não é atrasada', () {
    final conta = Conta(id: '3', titulo: 'Energia', valor: 150, categoria: 'Energia', vencimento: DateTime.now().add(const Duration(days: 10)));
    expect(conta.atrasada, false);
  });
}
