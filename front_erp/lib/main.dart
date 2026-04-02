import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boutique IUT',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), useMaterial3: true),
      home: const ProductsPage(),
    );
  }
}

class DetailsPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const DetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product['name'] ?? 'Détails')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product['image'] != null && product['image'].toString().isNotEmpty)
              Image.network(product['image'], height: 180, errorBuilder: (c, e, s) => const Icon(Icons.image_not_supported)),
            const SizedBox(height: 16),
            Text(product['name'] ?? 'Sans nom', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(product['description'] ?? 'Pas de description'),
            const SizedBox(height: 8),
            Text("${product['price'] ?? 0} €", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState(); // Utilisation d'un StatefulWidget [cite: 169, 174]
}

class _ProductsPageState extends State<ProductsPage> {
  // Fonction pour appeler l'API de l'ERP [cite: 114, 115]
  Future<List<dynamic>> getProducts() async {
    final response = await http.get(Uri.parse('http://polyedre.eu:8000/polyfx/cgi/getart.cgi?frs=401000394'));

    if (response.statusCode == 200) {
      return json.decode(response.body); // On décode le JSON reçu [cite: 88, 116]
    } else {
      throw Exception('Erreur de chargement des produits');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Boutique IUT - Articles ERP")),
      body: FutureBuilder<List<dynamic>>(
        future: getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          } else {
      // Affichage de la liste des produits [cite: 119, 120, 121]
      return ListView.builder(
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          final product = snapshot.data![index];
          return ListTile(
            leading: (product['image'] != null && product['image'].toString().isNotEmpty)
              ? Image.network(product['image'], width: 50, errorBuilder: (c, e, s) => const Icon(Icons.image_not_supported))
              : const Icon(Icons.image_not_supported),
            title: Text(product['name']),
            subtitle: Text(product['description'] ?? ""),
            trailing: Text("${product['price']} €", style: const TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsPage(product: product),
                ),
              );
            },
          );
        },
      );
    }
  },
),
    );
  }
}