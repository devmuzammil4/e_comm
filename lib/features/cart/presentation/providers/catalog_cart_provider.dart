import 'package:flutter/foundation.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/usecases/manage_cart_usecase.dart';

enum CartStateStatus { initial, loading, loaded, error }

/// Enterprise State Architecture managing real-time product adjustments inside the cart framework.
/// Engineered for massive horizontal scaling across Web browser processes and Desktop runner windows.
class CartProvider extends ChangeNotifier {
  final ManageCartUseCase _manageCartUseCase;

  CartProvider({required ManageCartUseCase manageCartUseCase})
      : _manageCartUseCase = manageCartUseCase;

  // Internal Immutable Cache State Elements
  CartStateStatus _status = CartStateStatus.initial;
  List<CartItemEntity> _cartItems = const [];
  String _errorMessage = '';

  // Public Encapsulated Getters
  CartStateStatus get status => _status;
  List<CartItemEntity> get cartItems => _cartItems;
  String get errorMessage => _errorMessage;

  // ---------------------------------------------------------------------------
  // Global Accumulated Price Math Calculators (15+ Years Exp Architecture)
  // ---------------------------------------------------------------------------

  /// Summarizes total transactional currency value across all dynamic tracking items inside the system.
  double get totalCartAmount {
    return _cartItems.fold(0.0, (sum, item) => sum + item.totalLinePrice);
  }

  /// Extracts complete quantitative unit weights currently active in memory buffers.
  int get totalItemsCount {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  // ---------------------------------------------------------------------------
  // Reactive Business Operations Workflows Flow Pipelines
  // ---------------------------------------------------------------------------

  /// Pulls existing cached lists straight from local storage framework containers.
  Future<void> loadCart() async {
    _status = CartStateStatus.loading;
    _errorMessage = '';
    notifyListeners();

    final result = await _manageCartUseCase.executeGet();

    result.fold(
          (failure) {
        _status = CartStateStatus.error;
        _errorMessage = failure.message;
      },
          (items) {
        _status = CartStateStatus.loaded;
        _cartItems = items;
      },
    );

    notifyListeners();
  }

  /// PolyMorphic Item Insertion Thread Pipeline.
  /// Handles deduplication logic automatically matching variable metadata tokens.
  Future<void> addToCart(CartItemEntity targetItem) async {
    _status = CartStateStatus.loading;
    notifyListeners();

    final List<CartItemEntity> temporaryList = List.from(_cartItems);

    // Locates exact matching index points by scanning generated polymorphic unique tracking keys
    final int existingIndex = temporaryList.indexWhere(
          (item) => item.uniqueCartItemId == targetItem.uniqueCartItemId,
    );

    if (existingIndex >= 0) {
      // Line item collision identified -> executes clean quantitative structural merge
      final existingItem = temporaryList[existingIndex];
      temporaryList[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + targetItem.quantity,
      );
    } else {
      // Fresh unique structure permutation -> injects brand new data track entry row
      temporaryList.add(targetItem);
    }

    // Commits calculated local memory buffer state down into storage adapters safely
    final result = await _manageCartUseCase.executeSave(temporaryList);

    result.fold(
          (failure) {
        _status = CartStateStatus.error;
        _errorMessage = failure.message;
      },
          (_) {
        _status = CartStateStatus.loaded;
        _cartItems = temporaryList;
      },
    );

    notifyListeners();
  }

  /// PolyMorphic Row Extraction or Quantity Reduction.
  Future<void> removeFromCart(String uniqueCartItemId) async {
    _status = CartStateStatus.loading;
    notifyListeners();

    final List<CartItemEntity> temporaryList = List.from(_cartItems);

    final int targetIndex = temporaryList.indexWhere(
          (item) => item.uniqueCartItemId == uniqueCartItemId,
    );

    if (targetIndex >= 0) {
      final currentItem = temporaryList[targetIndex];
      if (currentItem.quantity > 1) {
        temporaryList[targetIndex] = currentItem.copyWith(
          quantity: currentItem.quantity - 1,
        );
      } else {
        temporaryList.removeAt(targetIndex);
      }
    }

    final result = await _manageCartUseCase.executeSave(temporaryList);

    result.fold(
          (failure) {
        _status = CartStateStatus.error;
        _errorMessage = failure.message;
      },
          (_) {
        _status = CartStateStatus.loaded;
        _cartItems = temporaryList;
      },
    );

    notifyListeners();
  }

  /// Flushes entire active cache maps immediately.
  Future<void> clearEntireCart() async {
    _status = CartStateStatus.loading;
    notifyListeners();

    final result = await _manageCartUseCase.executeClear();

    result.fold(
          (failure) {
        _status = CartStateStatus.error;
        _errorMessage = failure.message;
      },
          (_) {
        _status = CartStateStatus.loaded;
        _cartItems = const [];
      },
    );

    notifyListeners();
  }
}
