import 'package:flutter/material.dart';
import '../utils/formatadores.dart';

class CartaoResumo extends StatelessWidget {
  final String titulo;
  final double valor;
  final IconData icone;
  final Color cor;

  const CartaoResumo(
      {super.key,
      required this.titulo,
      required this.valor,
      required this.icone,
      required this.cor});

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(icone, color: cor),
            const SizedBox(height: 12),
            Text(titulo, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 4),
            FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(formatarMoeda(valor),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold))),
          ]),
        ),
      );
}
