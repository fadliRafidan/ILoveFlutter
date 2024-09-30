import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/color.dart';
import 'package:flutter_application_1/data/product_model.dart';
import 'package:flutter_application_1/utils/convert_to_rupiah.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class DetailsPage extends StatefulWidget {
  final String productId;
  const DetailsPage({super.key, required this.productId});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool isLoadingMainProduct = false;
  Product? product;

Future<void> _addToCart(String id) async {
    try {
      final response = await supabase
          .from('cart')
          .select('cart_id, quantity')
          .eq('product_id', id);
      if (response.isEmpty) {
        await supabase.from('cart').insert({'product_id': id, 'quantity': 1});
      } else {
        await supabase
            .from('cart')
            .update({'quantity': response[0]['quantity'] + 1}).eq(
                'cart_id', response[0]['cart_id']);
      }
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
    super.initState();
    _fetchProduct(widget.productId);
  }

  Future<void> _fetchProduct(String productId) async {
    setState(() {
      isLoadingMainProduct = true;
    });

    try {
      final response = await supabase
          .from('products')
          .select('*, categories:categori_id(*)')
          .eq('product_id', productId)
          .single();
      setState(() {
        product = Product.fromMap(response) as Product?;
        isLoadingMainProduct = false;
      });
    } catch (error) {
      setState(() {
        isLoadingMainProduct = false;
      });
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: product == null
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: height / 2,
                        decoration: BoxDecoration(
                          color: lightGreen,
                          boxShadow: [
                            BoxShadow(
                              color: green.withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(60),
                            bottomRight: Radius.circular(60),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(product?.imageUrl ?? ''),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product!.name,
                                        style: TextStyle(
                                          color: black.withOpacity(0.8),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 2.0),
                                        decoration: BoxDecoration(
                                          color: green,
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        child: Text(
                                          product?.category != null
                                              ? '${product?.category.name}'
                                              : 'No category',
                                          style: const TextStyle(
                                            color: white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(children: [
                                  GestureDetector(
                                    onTap: () async {
                                      bool newFavoritStatus =
                                          !product!.is_favorit;
                                      await supabase.from('products').update({
                                        'is_favorit': newFavoritStatus
                                      }).eq('product_id', product!.productId);
                                      _showSnackBar('Success, add to favorit');
                                      setState(() {
                                        product!.is_favorit = newFavoritStatus;
                                      });
                                    },
                                    child: Container(
                                      height: 30.0,
                                      width: 30.0,
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: product!.is_favorit
                                            ? green
                                            : Colors.grey.shade400,
                                        boxShadow: [
                                          BoxShadow(
                                            color: product!.is_favorit
                                                ? green
                                                : Colors.grey.shade400,
                                            blurRadius: 15,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Image.asset(
                                        'assets/icons/heart.png',
                                        color: white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      _addToCart(product!.productId);
                                    },
                                    child: Container(
                                      height: 30.0,
                                      width: 30.0,
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: green,
                                        boxShadow: const [
                                          BoxShadow(
                                            color: green,
                                            blurRadius: 15,
                                            offset: Offset(0, 5),
                                          ),
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Image.asset(
                                        'assets/icons/add.png',
                                        color: white,
                                      ),
                                    ),
                                  ),
                                ]),
                              ],
                            ),
                            const SizedBox(height: 20.0),
                            RichText(
                              text: TextSpan(
                                text: product?.description,
                                style: TextStyle(
                                  color: black.withOpacity(0.5),
                                  fontSize: 15.0,
                                  height: 1.4,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Text(
                              'Treatment',
                              style: TextStyle(
                                color: black.withOpacity(0.9),
                                fontSize: 18.0,
                                height: 1.4,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset('assets/icons/sun.png',
                                    color: black, height: 24.0),
                                Image.asset('assets/icons/drop.png',
                                    color: black, height: 24.0),
                                Image.asset('assets/icons/temperature.png',
                                    color: black, height: 24.0),
                                Image.asset('assets/icons/up_arrow.png',
                                    color: black, height: 24.0),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                      Image.asset('assets/icons/cart.png',
                          color: black, height: 40.0),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50.0, vertical: 15.0),
                      decoration: BoxDecoration(
                        color: green,
                        boxShadow: [
                          BoxShadow(
                            color: green.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, -5),
                          ),
                        ],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(60),
                        ),
                      ),
                      child: Text(
                        formatRupiah(product!.price),
                        style: TextStyle(
                          color: white.withOpacity(0.9),
                          fontSize: 18.0,
                          height: 1.4,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
