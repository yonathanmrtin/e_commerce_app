import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';
import '../../providers/cart_provider.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Konten Utama yang bisa di-scroll
          CustomScrollView(
            slivers: [
              // AppBar Dinamis dengan Gambar Produk
              SliverAppBar(
                expandedHeight: 350.0,
                pinned: true,
                backgroundColor: Colors.teal.shade400,
                elevation: 4,
                // Judul di AppBar ini hanya akan muncul saat di-scroll ke atas
                title: Text(product.name),
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: product.id!,
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => const Icon(
                            Icons.broken_image,
                            size: 100,
                            color: Colors.grey,
                          ),
                    ),
                  ),
                ),
              ),

              // Daftar Konten Detail Produk
              SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 20),

                  // Nama Produk sekarang menjadi judul utama di konten
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                  // Harga Produk
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Rp ${product.price.toStringAsFixed(0)}',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.teal.shade800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Garis pemisah
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Divider(),
                  ),
                  const SizedBox(height: 12),
                  // Deskripsi
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      product.description,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 120), // Ruang untuk tombol di bawah
                ]),
              ),
            ],
          ),

          // Tombol "Tambah ke Keranjang" yang Mengambang
          _buildBottomAddToCartButton(context),
        ],
      ),
    );
  }

  // Helper widget untuk tombol di bagian bawah
  Widget _buildBottomAddToCartButton(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(
          16,
        ).copyWith(bottom: MediaQuery.of(context).padding.bottom + 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: ElevatedButton.icon(
          icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
          label: const Text(
            'Tambah ke Keranjang',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            final cart = Provider.of<CartProvider>(context, listen: false);
            cart.addItem(product);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${product.name} ditambahkan!'),
                action: SnackBarAction(
                  label: 'LIHAT KERANJANG',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => const CartScreen()),
                    );
                  },
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.amber[700],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
