import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/badge.dart' as custom;
import '../../widgets/product_card.dart'; // Impor widget kartu baru kita
import 'cart_screen.dart';

class ProductCatalogScreen extends StatelessWidget {
  const ProductCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Latar Belakang Gradien
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade50, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: CustomScrollView(
          slivers: [
            // AppBar yang lebih menarik
            SliverAppBar(
              title: const Text(
                'Toko Sembako',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              floating: true,
              pinned: true,
              snap: false,
              elevation: 4,
              backgroundColor: Colors.teal.shade400,
              actions: [
                Consumer<CartProvider>(
                  builder:
                      (_, cart, ch) => custom.Badge(
                        value: cart.itemCount.toString(),
                        color: Colors.amber,
                        child: ch!,
                      ),
                  child: IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined),
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).push(MaterialPageRoute(builder: (ctx) => CartScreen()));
                    },
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),

            // Konten utama (Grid Produk)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: FutureBuilder(
                  future:
                      Provider.of<ProductProvider>(
                        context,
                        listen: false,
                      ).fetchProducts(),
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        heightFactor: 10,
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.error != null) {
                      return const Center(child: Text('Gagal memuat produk.'));
                    }

                    return Consumer<ProductProvider>(
                      builder: (ctx, productProvider, child) {
                        if (productProvider.products.isEmpty) {
                          return const Center(
                            heightFactor: 10,
                            child: Text('Belum ada produk tersedia.'),
                          );
                        }
                        // Menggunakan GridView biasa di dalam Sliver
                        return GridView.builder(
                          shrinkWrap: true, // Penting di dalam CustomScrollView
                          physics:
                              const NeverScrollableScrollPhysics(), // Penting di dalam CustomScrollView
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio:
                                    0.75, // Sesuaikan rasio untuk desain baru
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                          itemCount: productProvider.products.length,
                          itemBuilder: (ctx, i) {
                            final product = productProvider.products[i];
                            // Menggunakan widget ProductCard baru kita
                            return ProductCard(product: product, index: i);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
