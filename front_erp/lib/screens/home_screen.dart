import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/supplier.dart';
import '../models/article.dart';
import '../services/api_service.dart';
import '../providers/app_state.dart';
import '../widgets/supplier_banner.dart';
import '../widgets/article_card.dart';
import 'details_screen.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Supplier>> _suppliersFuture;

  @override
  void initState() {
    super.initState();
    _suppliersFuture = _apiService.fetchSuppliers();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Boutique IUT"),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                if (appState.cartItems.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${appState.cartItems.fold(0, (sum, item) => sum + item.quantity)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          FutureBuilder<List<Supplier>>(
            future: _suppliersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(child: Text("Erreur: ${snapshot.error}")),
                );
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                if (appState.selectedSupplier == null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    appState.selectSupplier(snapshot.data!.first);
                  });
                }
                return SupplierBanner(suppliers: snapshot.data!);
              } else {
                return const SizedBox();
              }
            },
          ),
          Expanded(
            child: appState.selectedSupplier == null
                ? const Center(child: Text("Veuillez sélectionner un fournisseur"))
                : FutureBuilder<List<Article>>(
                    future: _apiService.fetchArticles(appState.selectedSupplier!.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Erreur: ${snapshot.error}"));
                      } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final article = snapshot.data![index];
                            return ArticleCard(
                              article: article,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailsScreen(article: article),
                                  ),
                                );
                              },
                              onAddToCart: () {
                                appState.addToCart(article);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("${article.name} ajouté au panier"),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      } else {
                        return const Center(child: Text("Aucun article trouvé."));
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
