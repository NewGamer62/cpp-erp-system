import 'package:flutter/foundation.dart';
import '../models/supplier.dart';
import '../models/cart_item.dart';
import '../models/article.dart';

class AppState extends ChangeNotifier {
  Supplier? _selectedSupplier;
  final List<CartItem> _cartItems = [];

  Supplier? get selectedSupplier => _selectedSupplier;
  List<CartItem> get cartItems => _cartItems;

  void selectSupplier(Supplier supplier) {
    _selectedSupplier = supplier;
    notifyListeners();
  }

  void addToCart(Article article) {
    final existingIndex = _cartItems.indexWhere((item) => item.article.id == article.id && article.id.isNotEmpty);
    if (existingIndex != -1) {
      _cartItems[existingIndex].quantity++;
    } else {
      final indexByName = _cartItems.indexWhere((item) => item.article.name == article.name);
      if (indexByName != -1) {
        _cartItems[indexByName].quantity++;
      } else {
        _cartItems.add(CartItem(article: article));
      }
    }
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _cartItems.remove(item);
    notifyListeners();
  }
  
  void decrementQuantity(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
      notifyListeners();
    } else {
      removeFromCart(item);
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  double get cartTotal {
    return _cartItems.fold(0, (total, item) => total + (item.article.price * item.quantity));
  }
}
