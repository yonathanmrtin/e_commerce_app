import 'package:flutter/foundation.dart';
import '../data/db_helper.dart';
import '../models/product_model.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  final DbHelper _dbHelper = DbHelper();
  bool _isLoading = false;
  Exception? _error;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  Exception? get error => _error;

  ProductProvider() {
    _loadProducts();
  }
  
  Future<void> _loadProducts() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final products = await _dbHelper.getProducts();
      _products = products;
    } catch (e) {
      _error = e as Exception;
      debugPrint('Error loading products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> fetchProducts() async {
    if (_isLoading) return; // Prevent multiple simultaneous loads
    await _loadProducts();
  }

  Future<bool> addProduct(Product product) async {
    try {
      await _dbHelper.addProduct(product);
      await fetchProducts();
      return true;
    } catch (e) {
      _error = e as Exception;
      debugPrint('Error adding product: $e');
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(Product product) async {
    try {
      await _dbHelper.updateProduct(product);
      await fetchProducts();
      return true;
    } catch (e) {
      _error = e as Exception;
      debugPrint('Error updating product: $e');
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProduct(int id) async {
    try {
      await _dbHelper.deleteProduct(id);
      await fetchProducts();
      return true;
    } catch (e) {
      _error = e as Exception;
      debugPrint('Error deleting product: $e');
      notifyListeners();
      return false;
    }
  }
  
  Product? findById(int id) {
    try {
      return _products.firstWhere((prod) => prod.id == id);
    } catch (e) {
      debugPrint('Product not found with id: $id');
      return null;
    }
  }
}