import 'package:get/get.dart';

class CartController extends GetxController {
  var cartItems = <dynamic>[].obs;
  var totalItems = 0.obs;

  void addToCart(dynamic product) {
    cartItems.add(product);
    totalItems.value = cartItems.length;
  }

  void clearCart() {
    cartItems.clear();
    totalItems.value = 0;
  }

  void removeFromCart(dynamic product) {
    cartItems.remove(product);
    totalItems.value = cartItems.length;
  }

  int get cartItemCount => totalItems.value;
}
