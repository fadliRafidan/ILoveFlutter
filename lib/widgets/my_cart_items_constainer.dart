import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/color.dart';

// ignore: must_be_immutable
class MyCartItemsContainer extends StatelessWidget {
  MyCartItemsContainer(
      {Key? key,
      required this.image,
      required this.itemName,
      required this.itemPrice,
      required this.itemQuantity})
      : super(key: key);
  String image;
  String itemName;
  String itemPrice;
  String itemQuantity;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image(
                fit: BoxFit.contain,
                image: AssetImage(image),
                width: 50, // Atur sesuai kebutuhan
                height: 50, // Atur sesuai kebutuhan
              ),
              Column(
                children: [
                  Text(
                    itemName,
                    style: const TextStyle(
                        color: lightBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    itemPrice,
                    style: const TextStyle(
                      color: darkText,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ],
          ),
          // button
          Container(
            padding: const EdgeInsets.all(8),
            width: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: lightBlue)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(
                  Icons.remove,
                  size: 15,
                  color: lightBlue,
                ),
                Text(
                  itemQuantity,
                  style: const TextStyle(
                    fontSize: 20,
                    color: lightBlue,
                  ),
                ),
                const Icon(
                  Icons.add,
                  size: 15,
                  color: lightBlue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
