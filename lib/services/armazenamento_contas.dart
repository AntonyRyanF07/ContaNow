import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/conta.dart';

class ArmazenamentoContas {
  static const _chave = 'contanow_contas_v1';
  final SharedPreferencesAsync _preferencias = SharedPreferencesAsync();

  Future<List<Conta>> carregar() async {
    final conteudo = await _preferencias.getString(_chave);
    if (conteudo == null || conteudo.isEmpty) return [];
    final registros = jsonDecode(conteudo) as List<dynamic>;
    return registros
        .map((item) => Conta.deMapa(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  Future<void> salvar(List<Conta> contas) async {
    final conteudo =
        jsonEncode(contas.map((conta) => conta.paraMapa()).toList());
    await _preferencias.setString(_chave, conteudo);
  }
}
