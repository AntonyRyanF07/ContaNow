import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../controllers/controlador_contas.dart';
import '../models/conta.dart';
import '../theme/tema_aplicativo.dart';
import '../utils/formatadores.dart';
import '../widgets/cartao_resumo.dart';

class Inicio extends StatefulWidget {
  final ControladorContas controlador;

  const Inicio({super.key, required this.controlador});

  @override
  State<Inicio> createState() => _InicioEstado();
}

class _InicioEstado extends State<Inicio> {
  DateTime _mes = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime _diaSelecionado = DateTime.now();

  bool _mesmaData(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  List<Conta> _contasNaData(DateTime data) {
    return widget.controlador.contas
        .where((conta) => _mesmaData(conta.vencimento, data))
        .toList();
  }

  void _mudarMes(int deslocamento) {
    final novoMes = DateTime(_mes.year, _mes.month + deslocamento);

    if (novoMes.year < 2020 || novoMes.year > 2100) return;

    setState(() {
      _mes = novoMes;
      _diaSelecionado = DateTime(novoMes.year, novoMes.month, 1);
    });
  }

  Widget _indicador(Color cor, String texto) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, color: cor, size: 10),
        const SizedBox(width: 6),
        Text(texto),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final controlador = widget.controlador;
    final contas = controlador.contasDoMes(_mes);

    final proximas = contas.where((conta) => !conta.paga).toList()
      ..sort((a, b) => a.vencimento.compareTo(b.vencimento));

    final atrasadas = contas.where((conta) => conta.atrasada).length;

    final contasDoDia = _contasNaData(_diaSelecionado);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: TemaAplicativo.roxo,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total de contas do mês',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    formatarMoeda(controlador.total(contas)),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  '${contas.length} conta(s) cadastrada(s)',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              tooltip: 'Mês anterior',
              onPressed: () => _mudarMes(-1),
              icon: const Icon(Icons.chevron_left),
            ),
            Expanded(
              child: Text(
                formatarMes(_mes),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            IconButton(
              tooltip: 'Próximo mês',
              onPressed: () => _mudarMes(1),
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, dimensoes) {
            final largura = (dimensoes.maxWidth - 12) / 2;

            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: largura,
                  child: CartaoResumo(
                    titulo: 'Pagas',
                    valor: controlador.totalPago(contas),
                    icone: Icons.check_circle_outline,
                    cor: TemaAplicativo.verde,
                  ),
                ),
                SizedBox(
                  width: largura,
                  child: CartaoResumo(
                    titulo: 'Pendentes',
                    valor: controlador.totalPendente(contas),
                    icone: Icons.schedule,
                    cor: TemaAplicativo.roxo,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const Icon(
              Icons.warning_amber_rounded,
              color: TemaAplicativo.vermelho,
            ),
            title: const Text('Contas atrasadas neste mês'),
            trailing: Text(
              '$atrasadas',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Calendário de vencimentos',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: TableCalendar<Conta>(
              locale: 'pt_BR',
              firstDay: DateTime(2020),
              lastDay: DateTime(2100, 12, 31),
              focusedDay: _mes,
              headerVisible: false,
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.sunday,
              availableCalendarFormats: const {
                CalendarFormat.month: 'Mês',
              },
              selectedDayPredicate: (dia) {
                return _mesmaData(dia, _diaSelecionado);
              },
              eventLoader: _contasNaData,
              calendarStyle: const CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: TemaAplicativo.roxo,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Color(0xFFB49AE8),
                  shape: BoxShape.circle,
                ),
                outsideDaysVisible: false,
              ),
              onDaySelected: (dia, mesFocado) {
                setState(() {
                  _diaSelecionado = dia;
                  _mes = DateTime(
                    mesFocado.year,
                    mesFocado.month,
                  );
                });
              },
              onPageChanged: (mesFocado) {
                setState(() {
                  _mes = DateTime(
                    mesFocado.year,
                    mesFocado.month,
                  );
                  _diaSelecionado = DateTime(
                    mesFocado.year,
                    mesFocado.month,
                    1,
                  );
                });
              },
              calendarBuilders: CalendarBuilders<Conta>(
                markerBuilder: (context, dia, eventos) {
                  if (eventos.isEmpty) return null;

                  final cores = <Color>[];

                  if (eventos.any((conta) => conta.paga)) {
                    cores.add(TemaAplicativo.verde);
                  }

                  if (eventos.any(
                    (conta) => !conta.paga && !conta.atrasada,
                  )) {
                    cores.add(Colors.orange);
                  }

                  if (eventos.any((conta) => conta.atrasada)) {
                    cores.add(TemaAplicativo.vermelho);
                  }

                  return Positioned(
                    bottom: 4,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (final cor in cores)
                          Container(
                            width: 7,
                            height: 7,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 2,
                            ),
                            decoration: BoxDecoration(
                              color: cor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 18,
          runSpacing: 8,
          children: [
            _indicador(TemaAplicativo.verde, 'Paga'),
            _indicador(Colors.orange, 'Pendente'),
            _indicador(TemaAplicativo.vermelho, 'Atrasada'),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Contas do dia ${formatarData(_diaSelecionado)}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        if (contasDoDia.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text('Nenhuma conta vence nesta data.'),
            ),
          ),
        for (final conta in contasDoDia)
          Card(
            child: ListTile(
              leading: Icon(
                conta.paga
                    ? Icons.check_circle
                    : conta.atrasada
                        ? Icons.warning_amber_rounded
                        : Icons.schedule,
                color: conta.paga
                    ? TemaAplicativo.verde
                    : conta.atrasada
                        ? TemaAplicativo.vermelho
                        : Colors.orange,
              ),
              title: Text(conta.titulo),
              subtitle: Text(
                conta.paga
                    ? 'Paga'
                    : conta.atrasada
                        ? 'Atrasada'
                        : 'Pendente',
              ),
              trailing: Text(
                formatarMoeda(conta.valor),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        const SizedBox(height: 24),
        Text(
          'Vencimentos pendentes',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        if (proximas.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text('Nenhuma conta pendente neste mês.'),
            ),
          ),
        for (final conta in proximas.take(5))
          Card(
            child: ListTile(
              title: Text(conta.titulo),
              subtitle: Text(
                'Vence em ${formatarData(conta.vencimento)}',
              ),
              trailing: Text(
                formatarMoeda(conta.valor),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
