import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/article.dart';
import '../providers/app_state.dart';

class DetailsScreen extends StatelessWidget {
  final Article article;

  const DetailsScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(article.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.image.isNotEmpty)
              Center(
                child: Image.network(
                  article.image,
                  height: 180,
                  errorBuilder: (c, e, s) => const Icon(Icons.image_not_supported, size: 180),
                ),
              ),
            const SizedBox(height: 16),
            Text(article.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(article.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text("${article.price.toStringAsFixed(2)} €", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<AppState>(context, listen: false).addToCart(article);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${article.name} ajouté au panier')),
                  );
                },
                child: const Text("Ajouter au panier"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
