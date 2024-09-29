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
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Column(
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
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Products',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 16,
                        color: darkText,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '#90876532',
                      style: TextStyle(
                          color: darkText,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'In progress',
                      style: TextStyle(color: inProgressColor),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
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
