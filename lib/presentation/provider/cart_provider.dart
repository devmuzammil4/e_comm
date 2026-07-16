import 'package:flutter/material.dart';
import 'package:e_comm/domain/entities/cart_item_entity.dart';

class CartProvider with ChangeNotifier {
  // 1. Private Map jahan cart ka sara data (Product ID aur Item) save hoga
  final Map<String, CartItemEntity> _items = {};

  // 2. Public Getter taake UI screens is data ko sirf read kar sakein, modify nahi
  Map<String, CartItemEntity> get items => {..._items};

  // 3. Cart mein items ki total tadad (types) maloom karne ke liye getter
  int get itemCount => _items.length;

  // 4. Cart mein naya item add karne ya pehle se majood item ki quantity barhane ka function
  void addToCart(String productId, String title, double price, String imageUrl) {
    if (_items.containsKey(productId)) {
      // Agar item pehle se cart mein hai, to uski quantity mein +1 ka izafa karein
      _items[productId]!.quantity = _items[productId]!.quantity + 1;
    } else {
      // Agar naya item hai, to map mein naya CartItemEntity object insert karein
      _items[productId] = CartItemEntity(
        id: productId,
        title: title,
        price: price,
        imageUrl: imageUrl,
      );
    }
    // UI ko signal bhejta hai ke data change ho gaya hai, screen refresh karo
    notifyListeners();
  }

  // 5. Minus (-) button ke liye logic: quantity kam karna ya item delete karna
  void removeSingleItem(String productId) {
    // Agar woh product cart mein hai hi nahi, to function se wapas nikal jao
    if (!_items.containsKey(productId)) return;

    if (_items[productId]!.quantity > 1) {
      // Agar quantity 1 se zyada hai, to sirf -1 kam karein
      _items[productId]!.quantity = _items[productId]!.quantity - 1;
    } else {
      // Agar quantity exact 1 hai aur user minus dabaye, to item ko cart se khatam kar dein
      _items.remove(productId);
    }
    // UI ko batane ke liye ke badli hui quantity screen par dikhao
    notifyListeners();
  }

  // 6. Poora item aik hi dafa cart se delete karne ka function (Delete/Trash Button ke liye)
  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  // 7. Poore cart ka total bill (amount) calculate karne ka getter
  double get totalAmount {
    double total = 0.0;
    // Map ke andar majood har item par loop chalega
    _items.forEach((key, cartItem) {
      // Har item ki price ko uski quantity se multiply karke total mein plus karein
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  // 8. Order complete hone par cart ko khali (clear) karne ka function
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
