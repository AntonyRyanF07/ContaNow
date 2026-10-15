import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'controllers/controlador_contas.dart';
import 'screens/formulario_conta.dart';
import 'screens/inicio.dart';
import 'screens/lista_contas.dart';
import 'services/armazenamento_contas.dart';
import 'theme/tema_aplicativo.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ContaNow());
}

class ContaNow extends StatefulWidget {
  const ContaNow({super.key});
  @override
  State<ContaNow> createState() => _ContaNowEstado();
}

class _ContaNowEstado extends State<ContaNow> {
  late final ControladorContas _controlador;
  int _pagina = 0;

  @override
  void initState() {
    super.initState();
    _controlador = ControladorContas(ArmazenamentoContas());
    _controlador.addListener(_atualizar);
    _controlador.iniciar();
  }

  void _atualizar() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controlador.removeListener(_atualizar);
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'ContaNow',
        debugShowCheckedModeBanner: false,
        theme: TemaAplicativo.tema,
        locale: const Locale('pt', 'BR'),
        supportedLocales: const [Locale('pt', 'BR')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Builder(
            builder: (context) => Scaffold(
                  appBar: AppBar(
                      title: const Text('ContaNow',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  body: _controlador.carregando
                      ? const Center(child: CircularProgressIndicator())
                      : _controlador.erro != null
                          ? Center(
                              child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Text(_controlador.erro!,
                                      textAlign: TextAlign.center)))
                          : Center(
                              child: ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(maxWidth: 850),
                                  child: _pagina == 0
                                      ? Inicio(controlador: _controlador)
                                      : ListaContas(
                                          controlador: _controlador))),
                  bottomNavigationBar: NavigationBar(
                    selectedIndex: _pagina,
                    onDestinationSelected: (pagina) =>
                        setState(() => _pagina = pagina),
                    destinations: const [
                      NavigationDestination(
                          icon: Icon(Icons.home_outlined),
                          selectedIcon: Icon(Icons.home),
                          label: 'Início'),
                      NavigationDestination(
                          icon: Icon(Icons.receipt_long_outlined),
                          selectedIcon: Icon(Icons.receipt_long),
                          label: 'Minhas contas'),
                    ],
                  ),
                  floatingActionButton: FloatingActionButton.extended(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                FormularioConta(controlador: _controlador))),
                    icon: const Icon(Icons.add),
                    label: const Text('Nova conta'),
                  ),
                )),
      );
}
