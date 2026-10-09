import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/receita.dart';

class ReceitasApi {
  static const baseUrl = 'https://receitasapi-b-2025.vercel.app';
  static const _cacheKey = 'receitas_cache_v1';

  Future<List<Receita>> listar() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/receitas')).timeout(const Duration(seconds: 15));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('A API respondeu com status ${response.statusCode}.');
      }
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      final List<dynamic> items = decoded is List ? decoded : (decoded['receitas'] as List? ?? []);
      final receitas = items.whereType<Map<String, dynamic>>().map(Receita.fromJson).toList();
      await _salvarCache(receitas);
      return receitas;
    } catch (_) {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString(_cacheKey);
      if (cached != null) {
        final items = jsonDecode(cached) as List<dynamic>;
        if (items.isNotEmpty) return items.map((e) => Receita.fromJson(Map<String, dynamic>.from(e))).toList();
      }
      rethrow;
    }
  }

  Future<Receita> buscarPorId(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/receitas/$id')).timeout(const Duration(seconds: 15));
    if (response.statusCode < 200 || response.statusCode >= 300) throw Exception('Não foi possível carregar a receita.');
    return Receita.fromJson(Map<String, dynamic>.from(jsonDecode(utf8.decode(response.bodyBytes))));
  }

  Future<void> criar(Receita receita) async {
    final response = await http.post(
      Uri.parse('$baseUrl/receitas'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(receita.toJson()),
    ).timeout(const Duration(seconds: 15));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Não foi possível cadastrar (HTTP ${response.statusCode}). Confira os campos e tente novamente.');
    }
  }

  Future<void> _salvarCache(List<Receita> receitas) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cacheKey, jsonEncode(receitas.map((r) => r.toJson()).toList()));
  }
}
