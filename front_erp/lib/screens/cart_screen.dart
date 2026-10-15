import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final items = appState.cartItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Panier"),
      ),
      body: items.isEmpty
          ? const Center(child: Text("Votre panier est vide"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ListTile(
                        leading: (item.article.image.isNotEmpty)
                            ? Image.network(
                                item.article.image,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => const Icon(Icons.image_not_supported),
                              )
                            : const Icon(Icons.image_not_supported),
                        title: Text(item.article.name),
                        subtitle: Text("${item.article.price.toStringAsFixed(2)} € x ${item.quantity}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => appState.decrementQuantity(item),
                            ),
                            Text('${item.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => appState.addToCart(item.article),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: const Border(top: BorderSide(color: Colors.grey)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total: ${appState.cartTotal.toStringAsFixed(2)} €",
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          appState.clearCart();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Commande validée !")),
                          );
                          Navigator.pop(context);
                        },
                        child: const Text("Valider"),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
