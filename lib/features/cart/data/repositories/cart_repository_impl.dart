import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../models/cart_item_model.dart';

/// Concrete Enterprise Data Coordination Layer for Cart Persistence.
/// Manages system configurations safely by caching elements in high-speed runtime arrays.
class CartRepositoryImpl implements CartRepository {

  // High-performance volatile memory allocation buffer acting as primary device storage simulation.
  // In production, this can be seamlessly swapped out with explicit Hive, Isar or SharedPreferences trackers.
  static final Map<String, String> _localVolatileCache = {};
  static const String _cartStorageCacheKey = 'active_tenant_persistent_cart_v1';

  const CartRepositoryImpl();

  @override
  Future<Either<Failure, List<CartItemEntity>>> getCartItems() async {
    try {
      if (!_localVolatileCache.containsKey(_cartStorageCacheKey)) {
        return const Right([]);
      }

      final String? rawJsonString = _localVolatileCache[_cartStorageCacheKey];
      if (rawJsonString == null || rawJsonString.isEmpty) {
        return const Right([]);
      }

      // Safe deep extraction parsing from local runtime memory partitions
      final List<dynamic> decodedList = jsonDecode(rawJsonString) as List<dynamic>;

      final List<CartItemModel> modelsList = decodedList
          .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
          .toList();

      return Right(modelsList);
    } catch (error) {
      return Left(CacheFailure(
        message: "Failed to deserialize local cache profiles cleanly: ${error.toString()}",
      ));
    }
  }

  @override
  Future<Either<Failure, void>> saveCartItems(List<CartItemEntity> items) async {
    try {
      // Maps each domain entity profile up to a serialization model target instance
      final List<Map<String, dynamic>> structuralModelsMap = items
          .map((entity) => CartItemModel.fromEntity(entity).toJson())
          .toList();

      final String encryptedJsonPayload = jsonEncode(structuralModelsMap);
      _localVolatileCache[_cartStorageCacheKey] = encryptedJsonPayload;

      return const Right(null);
    } catch (error) {
      return Left(CacheFailure(
        message: "Unable to commit structural payload changes down to persistent array targets: ${error.toString()}",
      ));
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      _localVolatileCache.remove(_cartStorageCacheKey);
      return const Right(null);
    } catch (error) {
      return Left(CacheFailure(
        message: "Unexpected error encountered while attempting to flush internal cache registers: ${error.toString()}",
      ));
    }
  }
}
