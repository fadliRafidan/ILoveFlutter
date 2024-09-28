import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/color.dart';
import 'package:flutter_application_1/data/wishlist_data.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: const Text("Wishlist"),
        automaticallyImplyLeading: false,
        backgroundColor: white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: ListView.builder(
          itemCount: wishlistItems.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                _buildWishlistItem(
                  wishlistItems[index]["productName"],
                  wishlistItems[index]["rating"],
                  wishlistItems[index]["price"],
                  wishlistItems[index]["imagePath"],
                ),
                const SizedBox(height: 10), // Jarak antar Card
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildWishlistItem(
      String productName, double rating, int price, String imagePath) {
    return Card(
      color: lightGreen,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Image.asset(
              imagePath,
              width: 80.0,
              height: 80.0,
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 16.0,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        rating.toString(),
                        style: const TextStyle(fontSize: 14.0),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    price.toString(),
                    style: TextStyle(
                      color: black.withOpacity(0.7),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 30.0,
              width: 30.0,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: green,
                boxShadow: [
                  BoxShadow(
                    color: green.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Image.asset(
                'assets/icons/heart.png',
                color: white,
              ),
            ),
            const SizedBox(width: 10),
            CircleAvatar(
              backgroundColor: green,
              radius: 15,
              child: Image.asset(
                'assets/icons/add.png',
                color: white,
                height: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
