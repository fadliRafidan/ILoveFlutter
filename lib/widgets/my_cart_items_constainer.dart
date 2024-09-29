import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/color.dart';
import 'package:flutter_application_1/utils/convert_to_rupiah.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

// ignore: must_be_immutable
class MyCartItemsContainer extends StatefulWidget {
  MyCartItemsContainer({
    super.key,
    required this.cartId,
    required this.image,
    required this.itemName,
    required this.itemPrice,
    required this.itemQuantity,
    required this.onQuantityUpdated,
    required this.onItemDelete,
  });

  final String cartId;
  final String image;
  final String itemName;
  final num itemPrice;
  int itemQuantity;
  final ValueChanged<int> onQuantityUpdated;
  final VoidCallback onItemDelete;

  @override
  State<MyCartItemsContainer> createState() => _MyCartItemsContainerState();
}

class _MyCartItemsContainerState extends State<MyCartItemsContainer> {
  Future<void> _updateCartItemQuantity(String cartId, int newQuantity) async {
    try {
      await supabase
          .from('cart')
          .update({'quantity': newQuantity})
          .eq('cart_id', cartId)
          .order('created_at', ascending: true);
    } catch (error) {
      if (kDebugMode) {
        print('error');
      }
    } finally {
      widget.onQuantityUpdated(widget.itemQuantity);
    }
  }

  Future<void> _deleteCartItem(String cartId) async {
    try {
      await supabase.from('cart').delete().eq('cart_id', cartId);
    } catch (error) {
      if (kDebugMode) {
        print('error');
      }
    } finally {
      widget.onItemDelete();
    }
  }

  void _incrementQuantity() async {
    setState(() {
      widget.itemQuantity++;
    });
    widget.onQuantityUpdated(widget.itemQuantity);

    await _updateCartItemQuantity(widget.cartId, widget.itemQuantity);
  }

  void _deleteFromCart() async {
    await _deleteCartItem(widget.cartId);
  }

  void _decrementQuantity() async {
    if (widget.itemQuantity > 1) {
      setState(() {
        widget.itemQuantity--;
      });
      widget.onQuantityUpdated(widget.itemQuantity);
      await _updateCartItemQuantity(widget.cartId, widget.itemQuantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: lightGreen,
      margin: const EdgeInsets.only(bottom: 15, left: 5, right: 5),
      child: Container(
        decoration: const BoxDecoration(
            color: lightGreen,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Image.network(widget.image,
                    fit: BoxFit.contain, width: 50, height: 50),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.itemName,
                        style: const TextStyle(
                            color: lightBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        formatRupiah(widget.itemPrice),
                        style: const TextStyle(
                          color: darkText,
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.center,
              width: 130,
              height: 25,
              child: Row(children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey.shade500),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _decrementQuantity,
                          child: Image.asset(
                            'assets/icons/min.png',
                            color: Colors.grey.shade500,
                            height: 15,
                          ),
                        ),
                        Center(
                          child: Expanded(
                            child: Text(
                              '${widget.itemQuantity}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _incrementQuantity,
                          child: Image.asset(
                            'assets/icons/add.png',
                            color: Colors.grey.shade500,
                            height: 15,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey.shade500),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _deleteFromCart,
                        child: Image.asset(
                          'assets/icons/trash.png',
                          color: Colors.red,
                          height: 25,
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
