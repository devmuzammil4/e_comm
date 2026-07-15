import 'package:e_comm/data/models/product_model.dart';

// Internet/API se data khinchne ke liye interface contract
abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProductsFromApi();
  Future<ProductModel> getProductByIdFromApi(String id);
}

// Asli worker class jo abhi fake data return kare gi lekin real model standard par
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  // Fake Database items jo bilkul live server ke response jaisa behaves karte hain
  final List<Map<String, dynamic>> _mockProducts = [
    {
      "id": "1",
      "title": "Wireless Headphones",
      "description": "Premium noise cancelling wireless over-ear headphones.",
      "price": 299.99,
      "imageUrl": "https://unsplash.com",
      "rating": 4.5,
      "stockCount": 14,
      "isAvailable": true,
    },
    {
      "id": "2",
      "title": "Minimalist Watch",
      "description": "Elegant design analog watch with leather straps.",
      "price": 149.50,
      "imageUrl": "https://unsplash.com",
      "rating": 0.0,
      "stockCount": 0,
      "isAvailable": false,
    }
  ];

  @override
  Future<List<ProductModel>> getProductsFromApi() async {
    // 1 second ka network delay dalna taake real internet loading feel ho
    await Future.delayed(const Duration(seconds: 1));
    // Raw Map data par loop chala kar use pure ProductModel ki list mein convert karna
    return _mockProducts.map((json) => ProductModel.fromJson(json)).toList();
  }

  @override
  Future<ProductModel> getProductByIdFromApi(String id) async {
    // 1 second ka delay simulate karna single items ke lookup ke liye
    await Future.delayed(const Duration(seconds: 1));

    // List mein se product dhoondna, agar na mile to orElse ke zariye crash se bachana
    final rawProduct = _mockProducts.firstWhere(
          (json) => json['id'] == id,
      orElse: () => throw Exception("Product with ID $id was not found in the remote database."),
    );

    return ProductModel.fromJson(rawProduct);
  }
}
