class Conta {
  final String id;
  final String titulo;
  final double valor;
  final String categoria;
  final DateTime vencimento;
  final bool paga;
  final DateTime? dataPagamento;

  const Conta({
    required this.id,
    required this.titulo,
    required this.valor,
    required this.categoria,
    required this.vencimento,
    this.paga = false,
    this.dataPagamento,
  });

  bool get atrasada {
    final hoje = DateTime.now();
    final dataAtual = DateTime(hoje.year, hoje.month, hoje.day);
    final dataVencimento =
        DateTime(vencimento.year, vencimento.month, vencimento.day);
    return !paga && dataVencimento.isBefore(dataAtual);
  }

  Conta alterarPagamento(bool novoEstado) {
    return Conta(
      id: id,
      titulo: titulo,
      valor: valor,
      categoria: categoria,
      vencimento: vencimento,
      paga: novoEstado,
      dataPagamento: novoEstado ? DateTime.now() : null,
    );
  }

  Map<String, dynamic> paraMapa() => {
        'id': id,
        'titulo': titulo,
        'valor': valor,
        'categoria': categoria,
        'vencimento': vencimento.toIso8601String(),
        'paga': paga,
        'dataPagamento': dataPagamento?.toIso8601String(),
      };

  factory Conta.deMapa(Map<String, dynamic> mapa) => Conta(
        id: mapa['id'] as String,
        titulo: mapa['titulo'] as String,
        valor: (mapa['valor'] as num).toDouble(),
        categoria: mapa['categoria'] as String,
        vencimento: DateTime.parse(mapa['vencimento'] as String),
        paga: mapa['paga'] as bool? ?? false,
        dataPagamento: mapa['dataPagamento'] == null
            ? null
            : DateTime.parse(mapa['dataPagamento'] as String),
      );
}
