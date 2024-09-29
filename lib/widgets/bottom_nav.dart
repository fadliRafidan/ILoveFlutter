import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/color.dart';
import 'package:flutter_application_1/data/bottom_menu.dart';
import 'package:flutter_application_1/page/cart_screen.dart';
import 'package:flutter_application_1/page/home_page.dart';
import 'package:flutter_application_1/page/profil_page.dart';
import 'package:flutter_application_1/page/wishlist_page.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  PageController pageController = PageController();
  int selectIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            itemCount: child.length,
            controller: pageController,
            onPageChanged: (value) => setState(() => selectIndex = value),
            itemBuilder: (context, index) {
              return Container(
                child: child[index],
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 65,
              margin: const EdgeInsets.only(
                right: 24,
                left: 24,
                bottom: 24,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 20,
                      spreadRadius: 10)
                ],
              ),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < bottomMenu.length; i++)
                      Expanded(
                          child: Material(
                              color: Colors.transparent,
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      pageController.jumpToPage(i);
                                      selectIndex = i;
                                    });
                                  },
                                  child: Container(
                                    height: 350,
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      height: 25,
                                      width: 25,
                                      color: selectIndex == i
                                          ? green
                                          : grey.withOpacity(0.5),
                                      bottomMenu[i].imagePath,
                                      fit: BoxFit.contain,
                                    ),
                                  ))))
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}

List<Widget> child = [
  const HomePage(),
  const WishListPage(),
  const CartPage(),
  const ProfilePage(),
];
