import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/color.dart';
import 'package:flutter_application_1/utils/convert_to_rupiah.dart';
import 'package:flutter_application_1/widgets/my_cart_items_constainer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => MyCartScreen();
}

class MyCartScreen extends State<CartPage> {
  PageController controller = PageController();
  bool isLoadingMainCart = false;
  List<dynamic> productsCartList = [];

  Future<void> _fetchCart() async {
    setState(() {
      isLoadingMainCart = true;
    });
    final response = await supabase
        .from('cart')
        .select('*,products:product_id(*)')
        .order('created_at', ascending: true);
    ;

    setState(() {
      productsCartList = response.toList();
      isLoadingMainCart = false;
    });
  }

  @override
  void initState() {
    controller = PageController(viewportFraction: 0.6, initialPage: 0);
    _fetchCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          title: const Text("Cart"),
          backgroundColor: white,
          automaticallyImplyLeading: false,
        ),
        body: isLoadingMainCart
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        bottom: 100, left: 15, right: 15, top: 0),
                    child: Column(
                      children: [
                        Expanded(
                          child: isLoadingMainCart
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: green,
                                  ),
                                )
                              : productsCartList.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/add-to-cart-amico.png',
                                            height: 200,
                                            width: 200,
                                          ),
                                          const Text(
                                              'your cart is still empty.',
                                              style: TextStyle(color: green)),
                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: productsCartList.length,
                                      itemBuilder: (context, index) {
                                        final cartItem =
                                            productsCartList[index];
                                        final product = cartItem['products'];
                                        return MyCartItemsContainer(
                                          cartId: cartItem['cart_id'] ?? "",
                                          image: product['image'] ??
                                              'assets/images/Asset1.png',
                                          itemName:
                                              product['name'] ?? 'Product Name',
                                          itemPrice: product['price'] ?? 0,
                                          itemQuantity:
                                              cartItem['quantity'] ?? 1,
                                          onQuantityUpdated: (newQuantity) {
                                            setState(() {
                                              productsCartList[index]
                                                  ['quantity'] = newQuantity;
                                            });
                                          },
                                          onItemDelete: _fetchCart,
                                        );
                                      },
                                    ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            if (productsCartList.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Total',
                                    style: TextStyle(
                                        fontSize: 16, color: lightBlue),
                                  ),
                                  Text(
                                    _calculateTotalPrice(),
                                    style: const TextStyle(
                                        color: darkText,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            if (productsCartList.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.all(15),
                                width: 150,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: lightBlue,
                                    borderRadius: BorderRadius.circular(25)),
                                child: const Text(
                                  'Checkout',
                                  style: TextStyle(
                                      color: backgroundColor,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ));
  }

  String _calculateTotalPrice() {
    double total = 0;
    for (var cartItem in productsCartList) {
      final product = cartItem['products'];
      total += (product['price'] ?? 0) * (cartItem['quantity'] ?? 1);
    }
    return formatRupiah(total);
  }
}
