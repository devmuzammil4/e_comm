import 'package:e_comm/domain/entities/product_entity.dart';

// Yeh class sirf ek naqsha ya contract hai jo batati hai ke products ke liye kya kya kaam hona hai
abstract class ProductRepository {

  // Server ya database se saare products ki list laane ka method (waada)
  Future<List<ProductEntity>> getProducts();

  // Kisi ek makhsoos product ki ID bhej kar us ki poori detail laane ka method (waada)
  Future<ProductEntity> getProductById(String id);
}
