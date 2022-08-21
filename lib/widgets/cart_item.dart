// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/utils/app_colors.dart';
import 'package:shop_app/utils/dimensions.dart';
import 'package:shop_app/widgets/my_text.dart';

import '../provider/cart.dart';

class CartItem extends StatelessWidget {
  final String title;
  final String id;
  final String productId;
  final double price;
  final int quantity;

  const CartItem({
    Key? key,
    required this.title,
    required this.id,
    required this.productId,
    required this.price,
    required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id), // to render ui and delete the card u need
      background: Container(
        color: Colors.red,
        child: Icon(
          Icons.delete_forever,
          size: Dimensions.width40,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: Dimensions.width15),
        margin: EdgeInsets.symmetric(
          horizontal: Dimensions.width15,
          vertical: Dimensions.height5,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to remove item from cart?'),
            actions: [
              TextButton(
                child: const Text(
                  'No',
                  style: TextStyle(
                    color: AppColors.secondryColor,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: const Text(
                  'Yes',
                  style: TextStyle(
                    color: AppColors.secondryColor,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: Dimensions.width15,
          vertical: Dimensions.height5,
        ),
        child: Padding(
          padding: EdgeInsets.all(Dimensions.height10),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.mainColor,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.height5),
                child: FittedBox(
                  child: MyText(
                    text: "$price",
                    size: Dimensions.font18,
                    color: Colors.white,
                    isBold: true,
                  ),
                ),
              ),
            ),
            title: MyText(
              text: title,
              size: Dimensions.font18,
              isBold: true,
            ),
            subtitle: MyText(
              text: 'Total: \$${quantity * price}',
              size: Dimensions.font18,
            ),
            trailing: MyText(
              text: '$quantity x',
              size: Dimensions.font15,
            ),
          ),
        ),
      ),
    );
  }
}
