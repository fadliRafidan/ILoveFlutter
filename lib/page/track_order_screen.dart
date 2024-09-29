import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/color.dart';
import 'package:flutter_application_1/widgets/image_and_text_container.dart';

class TrackOrderScreen extends StatelessWidget {
  const TrackOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        leading: const Icon(
          Icons.arrow_back_ios_new,
          color: lightBlue,
        ),
        foregroundColor: darkText,
        elevation: 0,
        title: const Text(
          'Track Order',
          style: TextStyle(color: darkText),
        ),
        // leading: Icon(),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
// column of text and images
            Column(
              children: [
                // Column of text
                const SizedBox(
                  height: 40,
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Your Order is on its way',
                      style: TextStyle(
                          color: darkText,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Order will arrive in 3 days',
                        style: TextStyle(
                          fontSize: 16,
                        )),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                // Container Text
                SizedBox(
                  width: double.infinity,
                  child: const Text(
                    'Products',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 16,
                        color: darkText,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),

                // Row of text
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '#90876532',
                      style: TextStyle(
                          // fontSize: 16,
                          color: darkText,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'In progress',
                      style: TextStyle(color: inProgressColor),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                // Row
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // column of image and text
                    ImageAndText(
                        image: 'assets/images/snicker.png',
                        text: 'Nike Sneaker'),
                    ImageAndText(
                        image: 'assets/images/apple.png', text: 'Apple Laptop'),
                    ImageAndText(
                        image: 'assets/images/lady.png', text: 'Lady Shoe')
                  ],
                ),
              ],
            ),

            // container button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: lightBlue),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Container',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: backgroundColor, fontSize: 20),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color: backgroundColor,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
