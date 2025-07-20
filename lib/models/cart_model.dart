// lib/models/cart_model.dart
import 'product_model.dart';

class CartItem {
  final String id; // ID unik untuk item keranjang, bisa dibuat dari id produk
  final Product product;
  int quantity;

  CartItem({
    required this.id,
    required this.product,
    this.quantity = 1,
  });
}