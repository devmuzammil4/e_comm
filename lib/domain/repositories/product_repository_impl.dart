import 'package:flutter/material.dart';
import 'package:e_comm/domain/entities/product_entity.dart';
import 'package:e_comm/domain/repositories/product_repositories.dart';
import 'package:e_comm/data/models/product_remote.dart';
import 'package:e_comm/data/models/product_model.dart';

// Yeh implementation class core domain contracts ko poora karti hai
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  // Constructor Injection: Core operational worker class bahar se receive karna
  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ProductEntity>> getProducts() async {
    try {
      // Data source se standard remote model items khinch kar lana
      final List<ProductModel> productModels = await remoteDataSource.getProductsFromApi();

      // Production Rule: Explicit array conversion lgana taake collection structures runtime failure se safe rahein
      return productModels.map((model) => model as ProductEntity).toList();
    } catch (error, stackTrace) {
      // Diagnostic System: Stack trace capture karna debug consoles par errors trace karne ke liye
      debugPrint("Repository GetProducts Error: $error\n$stackTrace");
      throw Exception('Server se products load karne mein masla aaya hai.');
    }
  }

  @override
  Future<ProductEntity> getProductById(String id) async {
    try {
      // Single specific payload object data fetch query execute karna
      final ProductModel productModel = await remoteDataSource.getProductByIdFromApi(id);
      return productModel;
    } catch (error, stackTrace) {
      debugPrint("Repository GetProductById Error: $error\n$stackTrace");
      throw Exception('Is product ki details is waqt maujood nahi hain.');
    }
  }
}
