import 'package:flutter/foundation.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount {
    // Menghitung total kuantitas, bukan hanya jumlah item unik
    var totalCount = 0;
    _items.forEach((key, cartItem) {
      totalCount += cartItem.quantity;
    });
    return totalCount;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.product.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id.toString())) {
      // Hanya tambah kuantitas
      _items.update(
        product.id.toString(),
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          product: existingCartItem.product,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      // Tambah produk baru ke keranjang
      _items.putIfAbsent(
        product.id.toString(),
        () => CartItem(id: DateTime.now().toString(), product: product),
      );
    }
    notifyListeners();
  }

  // FUNGSI BARU: Untuk mengurangi kuantitas atau menghapus item
  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId]!.quantity > 1) {
      // Jika kuantitas lebih dari 1, kurangi saja
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          product: existingCartItem.product,
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      // Jika kuantitas 1, hapus item dari keranjang
      _items.remove(productId);
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
