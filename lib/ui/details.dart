import 'package:flutter/material.dart';
import '../models/receita.dart';

class DetailsScreen extends StatelessWidget {
  final Receita receita;
  const DetailsScreen({super.key, required this.receita});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_rounded)), title: const Text('Detalhes', style: TextStyle(fontWeight: FontWeight.w800))),
    body: ListView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 30), children: [
      Text(receita.nome, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, height: 1.15)), const SizedBox(height: 10),
      Align(alignment: Alignment.centerLeft, child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: const Color(0xFFFFE7D6), borderRadius: BorderRadius.circular(20)), child: Text(receita.tipo, style: const TextStyle(color: Color(0xFF9D482B), fontWeight: FontWeight.w800, fontSize: 12)))),
      const SizedBox(height: 18), ClipRRect(borderRadius: BorderRadius.circular(24), child: AspectRatio(aspectRatio: 1.5, child: receita.img.isNotEmpty ? Image.network(receita.img, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _placeholder()) : _placeholder())),
      const SizedBox(height: 22), _section('Ingredientes', Icons.shopping_basket_outlined), const SizedBox(height: 8), _content(receita.ingredientes),
      const SizedBox(height: 20), _section('Modo de preparo', Icons.soup_kitchen_outlined), const SizedBox(height: 8), _content(receita.modoFazer),
      if (receita.custoAproximado > 0) ...[const SizedBox(height: 20), _section('Custo aproximado', Icons.payments_outlined), const SizedBox(height: 8), _content('R\$ ${receita.custoAproximado.toStringAsFixed(2).replaceAll('.', ',')}')],
    ]),
  );
  Widget _placeholder() => Container(color: const Color(0xFFFFE7D6), child: const Center(child: Icon(Icons.restaurant_rounded, size: 76, color: Color(0xFFB85C38))));
  Widget _section(String title, IconData icon) => Row(children: [Icon(icon, color: const Color(0xFFB85C38)), const SizedBox(width: 8), Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800))]);
  Widget _content(String value) => Container(width: double.infinity, padding: const EdgeInsets.all(17), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)), child: Text(value.isEmpty ? 'Não informado.' : value, style: const TextStyle(fontSize: 15, height: 1.6)));
}
