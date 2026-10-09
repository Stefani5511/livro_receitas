class Receita {
  final int? id;
  final String nome;
  final String tipo;
  final String ingredientes;
  final String modoFazer;
  final String img;
  final double custoAproximado;

  const Receita({
    this.id,
    required this.nome,
    required this.tipo,
    required this.ingredientes,
    required this.modoFazer,
    this.img = '',
    this.custoAproximado = 0,
  });

  factory Receita.fromJson(Map<String, dynamic> json) => Receita(
    id: int.tryParse('${json['id'] ?? ''}'),
    nome: '${json['nome'] ?? 'Receita sem nome'}',
    tipo: '${json['tipo'] ?? 'SALGADA'}',
    ingredientes: _asText(json['ingredientes']),
    modoFazer: _asText(json['modoFazer']),
    img: '${json['img'] ?? ''}',
    custoAproximado: double.tryParse('${json['custoAproximado'] ?? 0}'.replaceAll(',', '.')) ?? 0,
  );

  static String _asText(dynamic value) {
    if (value == null) return '';
    if (value is List) return value.map((e) => '$e').join('\n');
    return '$value';
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'nome': nome,
    'tipo': tipo,
    'ingredientes': ingredientes,
    'modoFazer': modoFazer,
    'img': img,
    'custoAproximado': custoAproximado,
  };
}
