// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product_provider.dart';
import 'package:shop_app/widgets/product_item.dart';

class ProductGridView extends StatelessWidget {
  final bool showFav;
  ProductGridView(this.showFav, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductProvider>(context);
    final products = showFav ? productsData.isFav : productsData.items;

    return GridView.builder(
      padding: EdgeInsets.all(Get.height * 0.01),
      itemCount: products.length,
      itemBuilder: (context, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: Get.height * 15 / 10000,
        crossAxisSpacing: Get.height * 0.01,
        mainAxisSpacing: Get.height * 0.01,
      ),
    );
  }
}
