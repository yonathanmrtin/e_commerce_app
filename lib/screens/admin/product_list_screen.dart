import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';
import '../../providers/product_provider.dart';
import 'product_form_screen.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  // Fungsi untuk memicu refresh
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductProvider>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Produk'),
        backgroundColor: Colors.indigo.shade700,
      ),
      // Tombol Aksi Terapung untuk menambah produk baru
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => ProductFormScreen(),
          ));
        },
        backgroundColor: Colors.amber[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
            onRefresh: () => _refreshProducts(context),
            child: Consumer<ProductProvider>(
              builder: (ctx, productProvider, _) {
                if (productProvider.products.isEmpty) {
                  return buildEmptyState(context);
                }
                return buildProductList(productProvider);
              },
            ),
          );
        },
      ),
    );
  }

  // Widget untuk daftar produk
  Widget buildProductList(ProductProvider productProvider) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0).copyWith(bottom: 80), // Padding bawah untuk FAB
      itemCount: productProvider.products.length,
      itemBuilder: (_, i) {
        final product = productProvider.products[i];
        return buildProductCard(product, i);
      },
    );
  }

  // Widget untuk satu kartu produk
  Widget buildProductCard(Product product, int index) {
    return Builder(builder: (context) {
      return Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) => const Icon(Icons.image, size: 80, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Rp ${product.price.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.indigo.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              // Tombol Aksi (Edit & Hapus)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit_note, color: Colors.blue.shade600),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => ProductFormScreen(product: product),
                      ));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_forever, color: Colors.red.shade600),
                    onPressed: () => _showDeleteDialog(context, product),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  // Widget untuk tampilan saat daftar kosong
  Widget buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 120, color: Colors.grey.shade400),
          const SizedBox(height: 20),
          const Text(
            'Belum Ada Produk',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Klik tombol + di bawah untuk menambahkan produk pertama Anda.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk menampilkan dialog konfirmasi hapus
  void _showDeleteDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Konfirmasi Hapus'),
        content: Text('Anda yakin ingin menghapus "${product.name}" secara permanen?'),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
            onPressed: () {
              Provider.of<ProductProvider>(context, listen: false).deleteProduct(product.id!);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('"${product.name}" berhasil dihapus.')),
              );
            },
          ),
        ],
      ),
    );
  }
}
