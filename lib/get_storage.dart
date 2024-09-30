import 'package:get_storage/get_storage.dart';

writeCart(int totalItems) {
  final box = GetStorage();
  box.write('total_cart_items', totalItems);
}

readCart() {
  final box = GetStorage();
  return box.read('total_cart_items') ?? 0;
}
