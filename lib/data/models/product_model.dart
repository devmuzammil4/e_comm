import 'package:e_comm/domain/entities/product_entity.dart';

// Model hamesha Entity ko extends karta hai taake data structures isolated aur clean rahein
class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.imageUrl,
    required super.rating,
    required super.stockCount,
    required super.isAvailable,
  });

  // Factory Constructor: Remote databases/APIs se aane wale raw JSON data ko parse karna
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"]?.toString() ?? "",
      title: json["title"]?.toString() ?? "",
      description: json["description"]?.toString() ?? "",

      // Price agar int ban kar aaye ya double, app crash se bachane ke liye toDouble cast lagaya
      price: (json["price"] as num?)?.toDouble() ?? 0.0,

      // Production Rule: Alternate schemas handle karna agar server se key badal jaye (imageUrl vs image_url)
      imageUrl: json["imageUrl"]?.toString() ?? json["image_url"]?.toString() ?? "",
      rating: (json["rating"] as num?)?.toDouble() ?? 0.0,

      // Stock count agar API se String format `"25"` mein aaye to use safely integer banana
      stockCount: json["stockCount"] is int
          ? json["stockCount"] as int
          : int.tryParse(json["stockCount"]?.toString() ?? "") ?? 0,

      // Status boolean field ko strict binary interpret karna taake null ya integer values par code break na ho
      isAvailable: json["isAvailable"] is bool
          ? json["isAvailable"] as bool
          : (json["isAvailable"]?.toString().toLowerCase() == 'true' || json["isAvailable"] == 1),
    );
  }

  // Model ke internal dynamic variables ko wapas network payload stream (JSON/Map) mein badalna
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'rating': rating,
      'stockCount': stockCount,
      'isAvailable': isAvailable,
    };
  }
}
