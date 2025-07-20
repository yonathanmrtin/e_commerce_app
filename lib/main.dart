import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
// Impor halaman pemilihan yang baru dibuat
import 'screens/selection_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => ProductProvider()),
        ChangeNotifierProvider(create: (ctx) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'E-Commerce App',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.indigo,
          ).copyWith(secondary: Colors.amber),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // Jadikan SelectionScreen sebagai halaman utama
        home: const SelectionScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
