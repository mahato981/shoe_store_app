import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../database/database_helper.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];
  bool _isLoading = false;

  List<CartItem> get items => _items;
  bool get isLoading => _isLoading;

  int get itemCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  Future<void> loadCart() async {
    _isLoading = true;
    notifyListeners();

    try {
      _items = await DatabaseHelper.instance.getCartItems();
    } catch (e) {
      print('Error loading cart: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addItem(CartItem item) async {
    try {
      final addedItem = await DatabaseHelper.instance.addToCart(item);
      
      // Update local list
      final existingIndex = _items.indexWhere(
        (i) => i.shoeId == item.shoeId && i.size == item.size && i.color == item.color,
      );

      if (existingIndex >= 0) {
        _items[existingIndex] = addedItem;
      } else {
        _items.add(addedItem);
      }

      notifyListeners();
    } catch (e) {
      print('Error adding to cart: $e');
      rethrow;
    }
  }

  Future<void> updateQuantity(int itemId, int newQuantity) async {
    try {
      final itemIndex = _items.indexWhere((item) => item.id == itemId);
      
      if (itemIndex >= 0) {
        if (newQuantity <= 0) {
          await removeItem(itemId);
        } else {
          final updatedItem = _items[itemIndex].copyWith(quantity: newQuantity);
          await DatabaseHelper.instance.updateCartItem(updatedItem);
          _items[itemIndex] = updatedItem;
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error updating quantity: $e');
      rethrow;
    }
  }

  Future<void> removeItem(int itemId) async {
    try {
      await DatabaseHelper.instance.deleteCartItem(itemId);
      _items.removeWhere((item) => item.id == itemId);
      notifyListeners();
    } catch (e) {
      print('Error removing item: $e');
      rethrow;
    }
  }

  Future<void> clearCart() async {
    try {
      await DatabaseHelper.instance.clearCart();
      _items.clear();
      notifyListeners();
    } catch (e) {
      print('Error clearing cart: $e');
      rethrow;
    }
  }
}
