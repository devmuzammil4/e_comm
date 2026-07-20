import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../entities/cart_item_entity.dart';

/// Abstract Data Access Interface defining system structural actions for Cart features.
/// Completely decoupled from low-level storage frameworks, filesystems, or databases.
abstract interface class CartRepository {

  /// Retrieves the current collection of items stored inside the persistent cart space.
  Future<Either<Failure, List<CartItemEntity>>> getCartItems();

  /// Persists a clean updated collection of line items back down into the local cache engine.
  Future<Either<Failure, void>> saveCartItems(List<CartItemEntity> items);

  /// Synchronizes cache operations to safely reset the cart state space back to a blank map.
  Future<Either<Failure, void>> clearCart();
}
