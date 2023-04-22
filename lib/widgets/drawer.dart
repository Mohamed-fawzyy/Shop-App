// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/products_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';
import 'package:shop_app/utils/app_colors.dart';
import 'package:shop_app/utils/dimensions.dart';
import 'package:shop_app/widgets/my_text.dart';

import '../provider/auth.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Shop_App'),
            backgroundColor: AppColors.mainColor,
            automaticallyImplyLeading: false, //mt7otsh zorar el list
          ),
          Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: MyText(text: 'Shop', size: Dimensions.font18, isBold: true),
            onTap: () {
              Get.off(ProductsScreen());
            },
          ),
          Divider(
            height: 0.6,
            color: Color.fromARGB(189, 0, 0, 0),
          ),
          ListTile(
            leading: const Icon(Icons.payment_outlined),
            title:
                MyText(text: 'Orders', size: Dimensions.font18, isBold: true),
            onTap: () {
              Get.off(OrdersScreen());
            },
          ),
          Divider(
            height: 0.6,
            color: Color.fromARGB(189, 0, 0, 0),
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: MyText(
                text: 'Manage Products', size: Dimensions.font18, isBold: true),
            onTap: () {
              Get.off(() => const UserProductScreen());
            },
          ),
          Divider(
            height: 0.6,
            color: Color.fromARGB(189, 0, 0, 0),
          ),
          ListTile(
            leading: const Icon(Icons.logout_sharp),
            title:
                MyText(text: 'Log Out', size: Dimensions.font18, isBold: true),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logOut();
            },
          ),
        ],
      ),
    );
  }
}
