import 'package:flutter/material.dart';
import '../models/conta.dart';
import '../theme/tema_aplicativo.dart';

class EtiquetaSituacao extends StatelessWidget {
  final Conta conta;
  const EtiquetaSituacao({super.key, required this.conta});

  @override
  Widget build(BuildContext context) {
    final texto = conta.paga
        ? 'Paga'
        : conta.atrasada
            ? 'Atrasada'
            : 'Pendente';
    final cor = conta.paga
        ? TemaAplicativo.verde
        : conta.atrasada
            ? TemaAplicativo.vermelho
            : TemaAplicativo.roxo;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: cor.withValues(alpha: 0.11),
          borderRadius: BorderRadius.circular(20)),
      child: Text(texto,
          style:
              TextStyle(color: cor, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}
