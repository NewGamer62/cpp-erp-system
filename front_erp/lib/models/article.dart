class Article {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;

  Article({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Sans nom',
      description: json['description']?.toString() ?? 'Pas de description',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      image: json['image']?.toString() ?? '',
    );
  }
}
