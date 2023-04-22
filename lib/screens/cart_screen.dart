// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/provider/orders.dart';
import 'package:shop_app/utils/dimensions.dart';
import 'package:shop_app/widgets/my_text.dart';

import '../utils/app_colors.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Your cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(Dimensions.height15),
            child: Padding(
              padding: EdgeInsets.all(Dimensions.height10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText(
                    text: 'Total',
                    size: Dimensions.font20,
                    isBold: true,
                  ),
                  Spacer(),
                  Chip(
                    backgroundColor: AppColors.mainColor,
                    label: MyText(
                      text: '\$${cart.totalPrice.toStringAsFixed(2)}',
                      size: Dimensions.font15,
                      color: Colors.white,
                    ),
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          SizedBox(height: Dimensions.height15),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemsCount,
              itemBuilder: (context, i) {
                return CartItem(
                  id: cart.items.values.toList()[i].id,
                  productId: cart.items.keys.toList()[i],
                  price: cart.items.values.toList()[i].price,
                  quantity: cart.items.values.toList()[i].quantity,
                  title: cart.items.values.toList()[i].title,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.totalPrice <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              try {
                await Provider.of<Orders>(
                  context,
                  listen: false,
                ).addOrder(
                  widget.cart.items.values.toList(),
                  widget.cart.totalPrice,
                );
                setState(() {
                  _isLoading = false;
                });
                widget.cart.clear();
              } catch (er) {
                Get.snackbar(
                  'Faild to make an order!',
                  'Somthing went wrong in the server, will be solved soon.',
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 4),
                );
              }
            },
      child: _isLoading
          ? CircularProgressIndicator()
          : MyText(
              text: 'ORDER NOW',
              size: Dimensions.font15,
              color: widget.cart.isCartClear
                  ? Colors.grey.shade600
                  : AppColors.mainColor,
            ),
    );
  }
}
