import 'article.dart';

class CartItem {
  final Article article;
  int quantity;

  CartItem({
    required this.article,
    this.quantity = 1,
  });
}
