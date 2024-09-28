import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/color.dart';
import 'package:flutter_application_1/widgets/my_cart_items_constainer.dart';

class MyCartScreen extends StatelessWidget {
  const MyCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.maxFinite,
        color: myCartBackgroundColor,
        child: Center(
          child: Container(
            decoration: const BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                // row of text and icon
                const SizedBox(
                  height: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MyCartItemsContainer(
                        image: 'assets/images/Asset1.png',
                        itemName: 'Nike Sneaker',
                        itemPrice: 'NGN250,000',
                        itemQuantity: '2'),
                    MyCartItemsContainer(
                        image: 'assets/images/Asset1.png',
                        itemName: 'Apple Laptop',
                        itemPrice: 'NGN350,000',
                        itemQuantity: '1'),
                    MyCartItemsContainer(
                        image: 'assets/images/Asset1.png',
                        itemName: 'Nike Sneaker',
                        itemPrice: 'NGN50,000',
                        itemQuantity: '1')
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                // row of text and button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // column of text
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(fontSize: 16, color: lightBlue),
                        ),
                        Text(
                          'NGN750,000',
                          style: TextStyle(
                              color: darkText,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    // button
                    Container(
                      padding: EdgeInsets.all(15),
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
        ),
      ),
    );
  }
}
