import 'package:flutter/material.dart';
import '../models/receita.dart';
import '../root/receitas_api.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});
  @override
  State<FormScreen> createState() => _FormScreenState();
}
class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nome = TextEditingController(); final _ingredientes = TextEditingController(); final _modo = TextEditingController(); final _img = TextEditingController(); final _custo = TextEditingController();
  String _tipo = 'SALGADA'; bool _enviando = false;
  @override
  void dispose() { _nome.dispose(); _ingredientes.dispose(); _modo.dispose(); _img.dispose(); _custo.dispose(); super.dispose(); }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _enviando = true);
    try {
      await ReceitasApi().criar(Receita(nome: _nome.text.trim(), tipo: _tipo, ingredientes: _ingredientes.text.trim(), modoFazer: _modo.text.trim(), img: _img.text.trim(), custoAproximado: double.tryParse(_custo.text.trim().replaceAll(',', '.')) ?? 0));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Receita cadastrada com sucesso!')));
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao cadastrar: ${e.toString().replaceFirst('Exception: ', '')}'), duration: const Duration(seconds: 5)));
    } finally { if (mounted) setState(() => _enviando = false); }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Nova receita', style: TextStyle(fontWeight: FontWeight.w800))),
    body: Form(key: _formKey, child: ListView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 30), children: [
      Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: const Color(0xFFFFE7D6), borderRadius: BorderRadius.circular(22)), child: const Row(children: [Icon(Icons.edit_note_rounded, size: 38, color: Color(0xFFB85C38)), SizedBox(width: 12), Expanded(child: Text('Compartilhe aquela receita especial com todo mundo!', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)))])),
      const SizedBox(height: 22), const Text('Nome da receita', style: TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 8), TextFormField(controller: _nome, textCapitalization: TextCapitalization.sentences, decoration: const InputDecoration(hintText: 'Ex.: Brigadeiro tradicional', prefixIcon: Icon(Icons.restaurant_menu)), validator: (v) => v == null || v.trim().isEmpty ? 'Informe o nome da receita.' : null),
      const SizedBox(height: 16), const Text('Tipo', style: TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 8), DropdownButtonFormField<String>(value: _tipo, decoration: const InputDecoration(prefixIcon: Icon(Icons.category_outlined)), items: const [DropdownMenuItem(value: 'DOCE', child: Text('Doce')), DropdownMenuItem(value: 'SALGADA', child: Text('Salgada')), DropdownMenuItem(value: 'BEBIDA', child: Text('Bebida'))], onChanged: (v) => setState(() => _tipo = v ?? 'SALGADA')),
      const SizedBox(height: 16), const Text('Ingredientes', style: TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 8), TextFormField(controller: _ingredientes, minLines: 3, maxLines: 5, decoration: const InputDecoration(hintText: 'Liste os ingredientes, um por linha', alignLabelWithHint: true), validator: (v) => v == null || v.trim().isEmpty ? 'Informe os ingredientes.' : null),
      const SizedBox(height: 16), const Text('Modo de preparo', style: TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 8), TextFormField(controller: _modo, minLines: 4, maxLines: 7, decoration: const InputDecoration(hintText: 'Explique o preparo passo a passo', alignLabelWithHint: true), validator: (v) => v == null || v.trim().isEmpty ? 'Informe o modo de preparo.' : null),
      const SizedBox(height: 16), const Text('URL da imagem (opcional)', style: TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 8), TextFormField(controller: _img, keyboardType: TextInputType.url, decoration: const InputDecoration(hintText: 'https://... ', prefixIcon: Icon(Icons.image_outlined)), validator: (v) { if (v == null || v.trim().isEmpty) return null; final uri = Uri.tryParse(v.trim()); return uri != null && (uri.scheme == 'http' || uri.scheme == 'https') ? null : 'Informe uma URL válida iniciando com http(s).'; }),
      const SizedBox(height: 16), const Text('Custo aproximado em R\$ (opcional)', style: TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 8), TextFormField(controller: _custo, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(hintText: 'Ex.: 15,50', prefixIcon: Icon(Icons.payments_outlined)), validator: (v) => v != null && v.trim().isNotEmpty && double.tryParse(v.trim().replaceAll(',', '.')) == null ? 'Informe um valor numérico válido.' : null),
      const SizedBox(height: 26), SizedBox(height: 54, child: FilledButton.icon(onPressed: _enviando ? null : _salvar, icon: _enviando ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.send_rounded), label: Text(_enviando ? 'Enviando...' : 'Cadastrar receita', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)))),
    ])),
  );
}
