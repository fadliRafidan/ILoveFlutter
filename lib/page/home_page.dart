import 'package:flutter_application_1/utils/convert_to_rupiah.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/color.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController controller = PageController();
  String? picture;
  bool isLoadingMainProduct = true;
  bool isLoadingPopularProduct = true;
  List<dynamic> products = [];
  List<dynamic> popularProducts = [];
  List<dynamic> categoriList = [];

  Future<void> _getProfile() async {
    final response = await supabase.auth.getUser();
    if (response.user != null) {
      setState(() {
        picture = response.user?.userMetadata!['picture'] as String;
      });
    }
  }

  Future<void> _fetchProducts(String? categoryId) async {
    setState(() {
      isLoadingMainProduct = true;
    });
    final response =
        await supabase.from('products').select('*,categories:categori_id(*)');

    if (categoryId != null && categoryId != 'all') {
      products = response
          .where((product) => product['categori_id'] == categoryId)
          .toList();
      isLoadingMainProduct = false;
    } else {
      products = response;
      isLoadingMainProduct = false;
    }

    setState(() {});
  }

  Future<void> _fetchPopularProducts() async {
    setState(() {
      isLoadingPopularProduct = true;
    });
    List<String> categoriesToFetch = [
      '40b55525-9554-45db-b65f-5bae0cbb50ce',
      '87a4e587-9061-4b20-8dad-413d8c632fe3',
      '47a9e472-a0aa-471b-bec5-279dd7b76951'
    ];
    final response = await supabase
        .from('products')
        .select('*,categories:categori_id(*)')
        .inFilter('categori_id', categoriesToFetch);

    if (response.isNotEmpty) {
      Map<String, dynamic> uniqueProducts = {};
      for (var product in response) {
        if (!uniqueProducts.containsKey(product['categori_id'])) {
          uniqueProducts[product['categori_id']] = product;
        }
      }
      popularProducts = uniqueProducts.values.toList();
    } else {
      popularProducts = [];
    }
    isLoadingPopularProduct = false;
    setState(() {});
  }

  Future<void> _fetchCategories() async {
    final response = await supabase.from('categories').select('*').limit(4);
    setState(() {
      categoriList = response;
      categoriList.insert(0, {'categori_id': 'all', 'name': 'All'});
    });
  }

  Future<void> _filterDataCategori(String id) async {
    await _fetchProducts(id);
  }

  @override
  void initState() {
    controller = PageController(viewportFraction: 0.6, initialPage: 0);
    _getProfile();
    _fetchProducts('all');
    _fetchCategories();
    _fetchPopularProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: white,
        automaticallyImplyLeading: false,
        leadingWidth: 40,
        leading: TextButton(
          onPressed: () {},
          child: Image.asset(
            'assets/icons/menu.png',
          ),
        ),
        actions: [
          Container(
            height: 40.0,
            width: 40.0,
            margin: const EdgeInsets.only(right: 20, top: 10, bottom: 5),
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: picture != null
                    ? NetworkImage(picture!)
                    : const AssetImage('assets/icons/profil.png')
                        as ImageProvider,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45.0,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        color: white,
                        border: Border.all(color: green),
                        boxShadow: [
                          BoxShadow(
                            color: green.withOpacity(0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 0),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search',
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0,
                                ),
                              ),
                            ),
                          ),
                          Image.asset(
                            'assets/icons/search.png',
                            height: 25,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 35.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categoriList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectId = categoriList[index]['categori_id'];
                                  _filterDataCategori(selectId);
                                });
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    categoriList[index]['name'],
                                    style: TextStyle(
                                      color: selectId ==
                                              categoriList[index]['categori_id']
                                          ? green
                                          : black.withOpacity(0.7),
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  if (selectId ==
                                      categoriList[index]['categori_id'])
                                    const CircleAvatar(
                                      radius: 3,
                                      backgroundColor: green,
                                    ),
                                  if (selectId !=
                                      categoriList[index]['categori_id'])
                                    const CircleAvatar(
                                      radius: 3,
                                      backgroundColor: Colors.transparent,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 320.0,
              child: isLoadingMainProduct
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: green,
                      ),
                    )
                  : products.isEmpty
                      ? const Center(
                          child: Text(
                            'Data tidak ditemukan',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        )
                      : PageView.builder(
                          itemCount: products.length,
                          controller: controller,
                          physics: const BouncingScrollPhysics(),
                          padEnds: false,
                          pageSnapping: true,
                          onPageChanged: (value) =>
                              setState(() => activePage = value),
                          itemBuilder: (context, index) {
                            bool active = index == activePage;
                            return slider(active, index);
                          },
                        ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Popular',
                    style: TextStyle(
                      color: black.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  Image.asset(
                    'assets/icons/more.png',
                    color: green,
                    height: 20,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 130.0,
              child: ListView.builder(
                itemCount: popularProducts.length,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(left: 20.0),
                scrollDirection: Axis.horizontal,
                itemBuilder: (itemBuilder, index) {
                  return Container(
                    width: 200.0,
                    margin: const EdgeInsets.only(right: 20, bottom: 10),
                    decoration: BoxDecoration(
                      color: lightGreen,
                      boxShadow: [
                        BoxShadow(
                          color: green.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            Image.network(
                              popularProducts[index]['image'],
                              fit: BoxFit.contain,
                              width: 70,
                              height: 70,
                            ),
                            const SizedBox(width: 10.0),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    popularProducts[index]['name'],
                                    style: TextStyle(
                                      color: black.withOpacity(0.7),
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Text(
                                    formatRupiah(
                                        popularProducts[index]['price']),
                                    style: TextStyle(
                                      color: black.withOpacity(0.4),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          right: 20,
                          bottom: 20,
                          child: GestureDetector(
                            onTap: () async {
                              final response = await supabase
                                  .from('cart')
                                  .insert({
                                'product_id': popularProducts[index]
                                    ['product_id'],
                                'quantity': 1
                              });
                              // if (response.error == null) {
                              //   showDialog(
                              //     context: context,
                              //     builder: (BuildContext context) {
                              //       return AlertDialog(
                              //         title: const Text('Success'),
                              //         content: const Text(
                              //             'Product added to cart successfully!'),
                              //         actions: [
                              //           TextButton(
                              //             onPressed: () {
                              //               Navigator.of(context)
                              //                   .pop(); // Close the dialog
                              //             },
                              //             child: const Text('OK'),
                              //           ),
                              //         ],
                              //       );
                              //     },
                              //   );
                              // } else {
                              //   print('Error: ${response.error?.message}');
                              // }
                            },
                            child: CircleAvatar(
                              backgroundColor: green,
                              radius: 15,
                              child: Image.asset(
                                'assets/icons/add.png',
                                color: white,
                                height: 15,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<User?> getUserInfo() async {
    final response = await supabase.auth.getUser();
    return response.user;
  }

  Widget slider(active, index) {
    double margin = active ? 20 : 30;
    if (products.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      margin:
          EdgeInsets.only(top: margin, left: margin, bottom: margin, right: 5),
      child: mainPlantsCard(index),
    );
  }

  Widget mainPlantsCard(index) {
    final product = products[index];
    return GestureDetector(
      // onTap: () {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (builder) => DetailsPage(plant: product),
      //     ),
      //   );
      // },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: white,
          boxShadow: [
            BoxShadow(
              color: black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(5, 5),
            ),
          ],
          border: Border.all(color: green, width: 2),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: lightGreen,
                boxShadow: [
                  BoxShadow(
                    color: black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(5, 5),
                  ),
                ],
                borderRadius: BorderRadius.circular(25.0),
                image: DecorationImage(
                  image: NetworkImage(product['image']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: CircleAvatar(
                backgroundColor: green,
                radius: 15,
                child: Image.asset(
                  'assets/icons/add.png',
                  color: white,
                  height: 15,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5, left: 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        '${product['name']}',
                        style: TextStyle(
                          color: black.withOpacity(0.7),
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        formatRupiah(product['price']),
                        style: TextStyle(
                          color: black.withOpacity(0.7),
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          color: green,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          product['categories'] != null
                              ? '${product['categories']['name']}'
                              : 'No category',
                          style: const TextStyle(
                            color: white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String selectId = "all";
  int activePage = 0;
}
