import 'package:flutter/material.dart';
import '../models/receita.dart';
import '../root/receitas_api.dart';
import 'form.dart';
import 'details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ReceitasApi _api = ReceitasApi();
  late Future<List<Receita>> _future;
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    _future = _api.listar();
  }

  void _reload() {
    setState(() => _future = _api.listar());
  }

  Future<void> _novaReceita() async {
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const FormScreen()),
    );
    if (ok == true && mounted) _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Meu caderno', style: TextStyle(fontSize: 13, color: Color(0xFF9A7B6C), fontWeight: FontWeight.w500)),
            Text('Receitas', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Nova receita',
            onPressed: _novaReceita,
            icon: const Icon(Icons.add_circle_outline_rounded, size: 32),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _tab == 1 ? _about() : _recipeList(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (value) => setState(() => _tab = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Início'),
          NavigationDestination(icon: Icon(Icons.info_outline_rounded), label: 'Sobre'),
        ],
      ),
    );
  }

  Widget _recipeList() {
    return RefreshIndicator(
      onRefresh: () async => _reload(),
      child: FutureBuilder<List<Receita>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const SizedBox(height: 75),
                Icon(Icons.wifi_off_rounded, size: 54, color: Colors.brown.shade200),
                const SizedBox(height: 16),
                const Center(child: Text('Não foi possível carregar as receitas.')),
                const SizedBox(height: 8),
                Center(
                  child: TextButton.icon(
                    onPressed: _reload,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tentar novamente'),
                  ),
                ),
              ],
            );
          }

          final receitas = snapshot.data ?? <Receita>[];
          if (receitas.isEmpty) {
            return ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const SizedBox(height: 75),
                Icon(Icons.menu_book_rounded, size: 70, color: Colors.brown.shade200),
                const SizedBox(height: 14),
                const Center(child: Text('Ainda não há receitas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                const Center(child: Text('Toque no + para cadastrar a primeira!')),
              ],
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFB85C38),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Feito em casa,', style: TextStyle(color: Colors.white70)),
                          Text('com carinho.', style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w800)),
                          SizedBox(height: 8),
                          Text('Encontre sua próxima receita favorita.', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                    Icon(Icons.restaurant_menu_rounded, size: 64, color: Colors.white.withOpacity(.9)),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Text(
                '${receitas.length} ${receitas.length == 1 ? 'receita disponível' : 'receitas disponíveis'}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              ...receitas.map((receita) => _recipeCard(receita)),
            ],
          );
        },
      ),
    );
  }

  Widget _recipeCard(Receita receita) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DetailsScreen(receita: receita)),
          ),
          child: Row(
            children: [
              _thumbnail(receita.img),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        receita.tipo,
                        style: const TextStyle(color: Color(0xFFB85C38), fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        receita.nome,
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        receita.ingredientes.replaceAll('\n', ', '),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.brown.shade400, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(Icons.chevron_right_rounded, color: Color(0xFFB85C38)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _thumbnail(String url) {
    return Container(
      width: 100,
      height: 105,
      color: const Color(0xFFFFE7D6),
      child: url.isNotEmpty
          ? Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.restaurant_rounded, size: 38, color: Color(0xFFB85C38)),
            )
          : const Icon(Icons.restaurant_rounded, size: 38, color: Color(0xFFB85C38)),
    );
  }

  Widget _about() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book_rounded, size: 64, color: Color(0xFFB85C38)),
            SizedBox(height: 12),
            Text('Livro de Receitas', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
            SizedBox(height: 8),
            Text('Um cantinho para descobrir, cadastrar e compartilhar receitas deliciosas.', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
