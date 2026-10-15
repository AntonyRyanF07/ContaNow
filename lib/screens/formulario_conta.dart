import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../controllers/controlador_contas.dart';
import '../models/conta.dart';
import '../utils/formatadores.dart';

class FormularioConta extends StatefulWidget {
  final ControladorContas controlador;
  final Conta? conta;

  const FormularioConta({super.key, required this.controlador, this.conta});

  @override
  State<FormularioConta> createState() => _FormularioContaEstado();
}

class _FormularioContaEstado extends State<FormularioConta> {
  final _formulario = GlobalKey<FormState>();
  final _titulo = TextEditingController();
  final _valor = TextEditingController();

  final _categorias = [
    'Água',
    'Energia',
    'Internet',
    'Aluguel',
    'Telefone',
    'Cartão',
    'Educação',
    'Transporte',
    'Outros'
  ];

  String _categoria = 'Outros';
  DateTime _vencimento = DateTime.now();
  bool _paga = false;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    final conta = widget.conta;

    if (conta != null) {
      _titulo.text = conta.titulo;
      _valor.text = conta.valor.toStringAsFixed(2).replaceAll('.', ',');
      _categoria = conta.categoria;
      _vencimento = conta.vencimento;
      _paga = conta.paga;
    }
  }

  @override
  void dispose() {
    _titulo.dispose();
    _valor.dispose();
    super.dispose();
  }

  Future<void> _escolherData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: _vencimento,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('pt', 'BR'),
    );

    if (data != null && mounted) {
      setState(() => _vencimento = data);
    }
  }

  Future<void> _salvar() async {
    if (!_formulario.currentState!.validate() || _salvando) {
      return;
    }

    setState(() => _salvando = true);

    final valor = double.parse(_valor.text.replaceAll(',', '.'));
    final anterior = widget.conta;

    final conta = Conta(
      id: anterior?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      titulo: _titulo.text.trim(),
      valor: valor,
      categoria: _categoria,
      vencimento: _vencimento,
      paga: _paga,
      dataPagamento: _paga
          ? (anterior?.paga == true ? anterior!.dataPagamento : DateTime.now())
          : null,
    );

    try {
      if (anterior == null) {
        await widget.controlador.adicionar(conta);
      } else {
        await widget.controlador.editar(conta);
      }

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Não foi possível salvar a conta.'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _salvando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.conta == null ? 'Nova conta' : 'Editar conta'),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formulario,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  TextFormField(
                    controller: _titulo,
                    maxLength: 70,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Descrição',
                      hintText: 'Ex.: Conta de internet',
                      prefixIcon: Icon(Icons.description_outlined),
                    ),
                    validator: (texto) => texto == null || texto.trim().isEmpty
                        ? 'Informe uma descrição.'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _valor,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]'))
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Valor (R\$)',
                      hintText: 'Ex.: 120,50',
                      prefixIcon: Icon(Icons.payments_outlined),
                    ),
                    validator: (texto) {
                      final numero =
                          double.tryParse((texto ?? '').replaceAll(',', '.'));

                      if (numero == null || !numero.isFinite || numero <= 0) {
                        return 'Informe um valor maior que zero.';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  DropdownButtonFormField<String>(
                    initialValue: _categoria,
                    decoration: const InputDecoration(
                      labelText: 'Categoria',
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
                    items: _categorias
                        .map(
                          (categoria) => DropdownMenuItem(
                            value: categoria,
                            child: Text(categoria),
                          ),
                        )
                        .toList(),
                    onChanged: (valor) {
                      if (valor != null) {
                        setState(() => _categoria = valor);
                      }
                    },
                  ),
                  const SizedBox(height: 18),
                  OutlinedButton.icon(
                    onPressed: _escolherData,
                    icon: const Icon(Icons.calendar_month_outlined),
                    label: Text('Vencimento: ${formatarData(_vencimento)}'),
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    title: const Text('Conta já paga'),
                    value: _paga,
                    onChanged: (valor) => setState(() => _paga = valor),
                  ),
                  const SizedBox(height: 22),
                  FilledButton.icon(
                    onPressed: _salvando ? null : _salvar,
                    icon: const Icon(Icons.save_outlined),
                    label: Text(_salvando ? 'Salvando...' : 'Salvar conta'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
