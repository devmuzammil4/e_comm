import 'package:e_comm/domain/entities/product_entity.dart';

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

  factory ProductModel.fromJson(Map<String, dynamic>json){
    return ProductModel(id: json["id"]?.toString() ?? "",
        title: json["title"] ?? "",
        description: json["description"]?.toString() ?? "",
        price: (json["price"] as num?)?.toDouble() ?? 0.0,
        imageUrl: json["imageUrl"] ?? json["imageUrl"] ?? "",
        rating: (json["rating"] as num?)?.toDouble() ?? 0.0,
        stockCount: json["stockCount"] ?? 0,
        isAvailable: json["isAvailable"] ?? false);
  }
Map<String, dynamic> toJson() {
  return {
    'id': id,
    'title': title,
    'description': description,
    'price': price,
    'image_url': imageUrl,
    'rating': rating,
    'stock_count': stockCount,
    'is_available': isAvailable,
  };
}
}
