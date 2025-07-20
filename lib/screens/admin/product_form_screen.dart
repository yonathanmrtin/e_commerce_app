import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';
import '../../providers/product_provider.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;

  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;

  // Menggunakan TextEditingController untuk setiap field
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data produk yang ada (jika mode edit)
    _nameController = TextEditingController(text: widget.product?.name);
    _priceController = TextEditingController(
      text: widget.product?.price.toString(),
    );
    _descriptionController = TextEditingController(
      text: widget.product?.description,
    );
    _imageUrlController = TextEditingController(text: widget.product?.imageUrl);

    // Menambahkan listener ke imageUrlController untuk update UI pratinjau
    _imageUrlController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Penting untuk membuang controller saat widget tidak lagi digunakan
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );

    try {
      if (widget.product == null) {
        // Tambah Produk Baru
        final newProduct = Product(
          name: _nameController.text,
          description: _descriptionController.text,
          price: double.parse(_priceController.text),
          imageUrl: _imageUrlController.text,
        );
        await productProvider.addProduct(newProduct);
      } else {
        // Update Produk
        final updatedProduct = Product(
          id: widget.product!.id,
          name: _nameController.text,
          description: _descriptionController.text,
          price: double.parse(_priceController.text),
          imageUrl: _imageUrlController.text,
        );
        await productProvider.updateProduct(updatedProduct);
      }
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (error) {
      await showDialog(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: const Text('Terjadi Kesalahan!'),
              content: Text('Gagal menyimpan produk: $error'),
              actions: [
                TextButton(
                  child: const Text('Oke'),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.product != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Produk' : 'Tambah Produk Baru'),
        backgroundColor: Colors.indigo.shade700,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Pratinjau Gambar
                _buildImagePreview(),
                const SizedBox(height: 24),
                // Field Nama Produk
                _buildTextField(
                  controller: _nameController,
                  label: 'Nama Produk',
                  icon: Icons.label_important_outline,
                  validator:
                      (value) =>
                          (value == null || value.isEmpty)
                              ? 'Nama tidak boleh kosong.'
                              : null,
                ),
                const SizedBox(height: 16),
                // Field Harga
                _buildTextField(
                  controller: _priceController,
                  label: 'Harga',
                  icon: Icons.attach_money,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Harga tidak boleh kosong.';
                    if (double.tryParse(value) == null)
                      return 'Masukkan angka yang valid.';
                    if (double.parse(value) <= 0)
                      return 'Harga harus lebih dari 0.';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Field Deskripsi
                _buildTextField(
                  controller: _descriptionController,
                  label: 'Deskripsi',
                  icon: Icons.description_outlined,
                  maxLines: 4,
                  validator:
                      (value) =>
                          (value == null || value.isEmpty)
                              ? 'Deskripsi tidak boleh kosong.'
                              : null,
                ),
                const SizedBox(height: 16),
                // Field URL Gambar
                _buildTextField(
                  controller: _imageUrlController,
                  label: 'URL Gambar',
                  icon: Icons.link,
                  keyboardType: TextInputType.url,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'URL tidak boleh kosong.';
                    if (!value.startsWith('http'))
                      return 'Masukkan URL yang valid.';
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                // Tombol Simpan
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save_alt, color: Colors.white),
                    label: Text(
                      isEditMode ? 'Simpan Perubahan' : 'Tambah Produk',
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    onPressed: _saveForm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.indigo.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget untuk membuat TextFormField yang seragam
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.indigo.shade300),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.indigo.shade700, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
      ),
      validator: validator,
    );
  }

  // Helper widget untuk pratinjau gambar
  Widget _buildImagePreview() {
    final imageUrl = _imageUrlController.text;
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 1),
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade200,
      ),
      child:
          imageUrl.isEmpty
              ? const Center(
                child: Text(
                  'Pratinjau Gambar',
                  style: TextStyle(color: Colors.grey),
                ),
              )
              : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (ctx, err, stack) => const Center(
                        child: Text(
                          'Gagal memuat gambar',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                ),
              ),
    );
  }
}
