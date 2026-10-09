import 'package:flutter/material.dart';
import 'home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..forward();
  late final Animation<double> _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  late final Animation<double> _scale = Tween<double>(begin: .65, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2300), () {
      if (mounted) Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
    });
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFFFE7D6), Color(0xFFFFF9F3), Color(0xFFF5D2B9)])),
      child: FadeTransition(opacity: _fade, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        ScaleTransition(scale: _scale, child: Container(width: 124, height: 124, decoration: BoxDecoration(color: const Color(0xFFB85C38), borderRadius: BorderRadius.circular(36), boxShadow: [BoxShadow(color: const Color(0xFFB85C38).withValues(alpha: .25), blurRadius: 30, offset: const Offset(0, 14))]), child: const Icon(Icons.soup_kitchen_rounded, size: 70, color: Colors.white))),
        const SizedBox(height: 28), const Text('Livro de Receitas', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF33251F))),
        const SizedBox(height: 8), const Text('Receitas para compartilhar momentos', style: TextStyle(color: Color(0xFF80695D))),
        const SizedBox(height: 36), const SizedBox(width: 26, height: 26, child: CircularProgressIndicator(strokeWidth: 2.5, color: Color(0xFFB85C38))),
      ])),
    ),
  );
}
