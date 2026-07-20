import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';

/// Single unified interactor managing core business operations for the cart module.
/// Decoupled from state management updates or raw database framework modifications.
class ManageCartUseCase {
  final CartRepository _repository;

  ManageCartUseCase({required CartRepository repository}) : _repository = repository;

  /// Retrieves the current collection of items stored inside the local device persistence layer.
  Future<Either<Failure, List<CartItemEntity>>> executeGet() async {
    return await _repository.getCartItems();
  }

  /// Commits the entire calculated tracking layout array state safely to local storage targets.
  Future<Either<Failure, void>> executeSave(List<CartItemEntity> items) async {
    return await _repository.saveCartItems(items);
  }

  /// Resets internal local database profiles back into an absolute clean blueprint block state.
  Future<Either<Failure, void>> executeClear() async {
    return await _repository.clearCart();
  }
}
