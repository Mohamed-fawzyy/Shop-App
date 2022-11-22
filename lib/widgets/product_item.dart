// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/provider/product.dart';
import 'package:shop_app/provider/product_provider.dart';
import 'package:shop_app/utils/app_colors.dart';
import 'package:shop_app/screens/products_details_screen.dart';

import '../provider/auth.dart';

class ProductItem extends StatelessWidget {
  ProductItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authToken = Provider.of<Auth>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Get.height * 0.01),
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            color: Color.fromARGB(255, 160, 160, 160),
          ),
        ],
      ),
      child: ClipRRect(
        // sahla lel decoratoin
        borderRadius: BorderRadius.circular(Get.height * 0.01),
        child: GridTile(
          child: GestureDetector(
            onTap: () => Get.to(ProductDetailsScreen(id: product.id)),
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Color.fromARGB(167, 0, 0, 0),
            leading: Consumer<Product>(
              builder: (context, product, _) => IconButton(
                onPressed: () async {
                  try {
                    await product.favStatus(authToken.token, authToken.userId);
                    await Provider.of<ProductProvider>(
                      context,
                      listen: false,
                    ).updateProduct(
                      product.id,
                      Product(
                        id: product.id,
                        title: product.title,
                        description: product.description,
                        isFavorites: product.isFavorites,
                        imageUrl: product.imageUrl,
                        price: product.price,
                      ),
                    );
                  } catch (er) {
                    Get.snackbar(
                      'Faild to add at favorites!',
                      'Somthing went wrong in the server, will be solved soon.',
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 4),
                    );
                  }
                },
                icon: Icon(
                  product.isFavorites ? Icons.favorite : Icons.favorite_border,
                  color: AppColors.secondryColor,
                ),
              ),
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: Consumer<Product>(
              builder: (context, product, _) => IconButton(
                onPressed: () {
                  cart.addItems(
                    product.id,
                    product.title,
                    product.price,
                  );
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added Item to the cart!'),
                      duration: Duration(seconds: 2),
                      action: SnackBarAction(
                        label: 'UNDO',
                        textColor: AppColors.secondryColor,
                        onPressed: () {
                          cart.removeSingleItem(product.id);
                        },
                      ),
                    ),
                  );
                },
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  color: AppColors.secondryColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
