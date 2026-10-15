import 'package:flutter/material.dart';
import '../models/article.dart';

class ArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  const ArticleCard({
    super.key,
    required this.article,
    required this.onTap,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: (article.image.isNotEmpty)
            ? Image.network(
                article.image,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => const Icon(Icons.image_not_supported),
              )
            : const Icon(Icons.image_not_supported),
        title: Text(article.name),
        subtitle: Text("${article.price.toStringAsFixed(2)} €"),
        trailing: IconButton(
          icon: const Icon(Icons.add_shopping_cart),
          onPressed: onAddToCart,
        ),
        onTap: onTap,
      ),
    );
  }
}
