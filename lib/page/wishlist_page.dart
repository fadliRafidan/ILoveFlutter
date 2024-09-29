import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/color.dart';
// import 'package:flutter_application_1/data/wishlist_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

// ignore: must_be_immutable
class WishListPage extends StatefulWidget {
  const WishListPage({
    super.key,
  });

  @override
  State<WishListPage> createState() => WishlistScreen();
}

class WishlistScreen extends State<WishListPage> {
  bool isLoadingMainFavorit = false;
  List<dynamic> productsFavoritList = [];

  Future<void> _fetchWishlist() async {
    setState(() {
      isLoadingMainFavorit = true;
    });
    final response =
        await supabase.from('products').select('*').eq('is_favorit', true);

    setState(() {
      productsFavoritList = response;
      isLoadingMainFavorit = false;
    });
  }

  Future<void> _addToCart(String id) async {
    try {
      await supabase.from('cart').insert({'product_id': id, 'quantity': 1});
      if (mounted) {
        showDialog(
            context: context,
            builder: (context) {
              return const CupertinoAlertDialog(
                title: Text('Berhasil'),
                content: Text('Produk ditambahkan ke keranjang'),
              );
            });
      }
    } on PostgrestException {
      if (mounted) {
        showDialog(
            context: context,
            builder: (context) {
              return const CupertinoAlertDialog(
                title: Text('Gagal'),
                content: Text('Produk gagal ditambahkan'),
              );
            });
      }
    } catch (error) {
      if (mounted) {
        showDialog(
            context: context,
            builder: (context) {
              return const CupertinoAlertDialog(
                title: Text('Gagal'),
                content: Text('Produk gagal ditambahkan'),
              );
            });
      }
    } finally {}
  }

  @override
  void initState() {
    _fetchWishlist();
    super.initState();
  }

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
        padding:
            const EdgeInsets.only(bottom: 100, left: 15, right: 15, top: 0),
        child: isLoadingMainFavorit
            ? const Center(
                child: CircularProgressIndicator(
                  color: green,
                ),
              )
            : productsFavoritList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/Empty-bro.png',
                          height: 200,
                          width: 200,
                        ),
                        const Text('No favorite products found.',
                            style: TextStyle(color: green)),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: productsFavoritList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          _buildWishlistItem(
                            productsFavoritList[index]["product_id"],
                            productsFavoritList[index]["name"],
                            productsFavoritList[index]["price"],
                            productsFavoritList[index]["image"],
                            productsFavoritList[index]["is_favorit"],
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    },
                  ),
      ),
    );
  }

  Widget _buildWishlistItem(String productId, String productName, num price,
      String imagePath, bool isFavorit) {
    return Card(
      color: lightGreen,
      margin: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Image.network(imagePath,
                fit: BoxFit.contain, width: 80.0, height: 80.0),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: const TextStyle(
                      color: lightBlue,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    price.toString(),
                    style: TextStyle(
                      color: black.withOpacity(0.7),
                      fontSize: 16,
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
              child: GestureDetector(
                onTap: () async {
                  bool newFavoritStatus = !isFavorit;
                  await supabase
                      .from('products')
                      .update({'is_favorit': newFavoritStatus}).eq(
                          'product_id', productId);
                  await _fetchWishlist();
                },
                child: Image.asset(
                  'assets/icons/heart.png',
                  color: white,
                ),
              ),
            ),
            const SizedBox(width: 10),
            CircleAvatar(
              backgroundColor: green,
              radius: 15,
              child: GestureDetector(
                onTap: () async {
                  await _addToCart(productId);
                  await _fetchWishlist();
                },
                child: Image.asset(
                  'assets/icons/add.png',
                  color: white,
                  height: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
