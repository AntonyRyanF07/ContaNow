import 'package:flutter/material.dart';
import '../models/conta.dart';
import '../utils/formatadores.dart';
import 'etiqueta_situacao.dart';

class CartaoConta extends StatelessWidget {
  final Conta conta;
  final VoidCallback aoEditar;
  final VoidCallback aoExcluir;
  final ValueChanged<bool> aoMarcarPagamento;

  const CartaoConta(
      {super.key,
      required this.conta,
      required this.aoEditar,
      required this.aoExcluir,
      required this.aoMarcarPagamento});

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(children: [
            Row(children: [
              CircleAvatar(child: Icon(_iconeCategoria(conta.categoria))),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(conta.titulo,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    Text(
                        '${conta.categoria} • ${formatarData(conta.vencimento)}',
                        style: Theme.of(context).textTheme.bodySmall),
                  ])),
              const SizedBox(width: 8),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(formatarMoeda(conta.valor),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                EtiquetaSituacao(conta: conta),
              ]),
            ]),
            const Divider(height: 18),
            Row(children: [
              Checkbox(
                  value: conta.paga,
                  onChanged: (valor) {
                    if (valor != null) aoMarcarPagamento(valor);
                  }),
              Expanded(
                  child: Text(
                      conta.paga ? 'Pagamento confirmado' : 'Marcar como paga',
                      style: Theme.of(context).textTheme.bodySmall)),
              IconButton(
                  tooltip: 'Editar',
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: aoEditar),
              IconButton(
                  tooltip: 'Excluir',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: aoExcluir),
            ]),
          ]),
        ),
      );

  IconData _iconeCategoria(String categoria) => switch (categoria) {
        'Água' => Icons.water_drop_outlined,
        'Energia' => Icons.bolt_outlined,
        'Internet' => Icons.wifi,
        'Aluguel' => Icons.home_outlined,
        'Telefone' => Icons.phone_android_outlined,
        'Cartão' => Icons.credit_card,
        'Educação' => Icons.school_outlined,
        'Transporte' => Icons.directions_car_outlined,
        _ => Icons.receipt_long_outlined,
      };
}
