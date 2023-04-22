// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/drawer.dart';
import 'package:shop_app/widgets/my_text.dart';
import '../provider/orders.dart' show Orders;
import '../utils/app_colors.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  /* bool _isloading = false;
  @override
  void initState() {
    final provider = Provider.of<Orders>(context, listen: false);

    _isloading = true;

    provider.fetchAndSetProduct().then((_) {
      setState(
        () {
          _isloading = false;
        },
      );
      if (provider.isNulll.endsWith('ull')) {
        Get.snackbar(
          'No orders yet!',
          'move to home page and start shopping.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
        );
      }
    }).catchError((_) {
      setState(() {
        _isloading = false;
      });
      Get.snackbar(
        'Faild to to fetch your orders!',
        'Somthing went wrong in the server, will be solved soon.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
      Get.off(ProductsScreen());
    });

    super.initState();
  }*/

  @override
  Widget build(BuildContext context) {
    final _orderProvider = Provider.of<Orders>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
        backgroundColor: AppColors.mainColor,
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _orderProvider.fetchAndSetProduct(),
        builder: (context, dataSnapsoht) {
          if (dataSnapsoht.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapsoht.error != null) {
              return Center(
                child: MyText(
                  text: 'Something wrong in server \nit will be solved soon!',
                  size: 20,
                  isBold: true,
                ),
              );
            } else {
              if (_orderProvider.isNulll.endsWith('ull')) {
                return Center(
                  child: MyText(
                    text: 'No Orders Yet!',
                    size: 20,
                    isBold: true,
                  ),
                );
              } else {
                return Consumer<Orders>(
                  builder: (context, order, child) {
                    return ListView.builder(
                      itemCount: order.ordersLength,
                      itemBuilder: (context, i) {
                        return OrderItem(
                          order: order.orders[i],
                        );
                      },
                    );
                  },
                );
              }
            }
          }
        },
      ),
    );
  }
}
