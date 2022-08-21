// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product_provider.dart';
import 'package:shop_app/utils/dimensions.dart';
import 'package:shop_app/widgets/my_text.dart';
import '../utils/app_colors.dart';

class ProductDetailsScreen extends StatelessWidget {
  ProductDetailsScreen({Key? key, required this.id}) : super(key: key);

  final String id;
  @override
  Widget build(BuildContext context) {
    final loadedProduct =
        Provider.of<ProductProvider>(context, listen: false).searchById(id);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
          child: Column(
            children: [
              SizedBox(
                height: Dimensions.height100 * 3,
                width: double.infinity,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Align(
                alignment: Alignment.centerLeft,
                child: MyText(
                  text: 'Price: \$${loadedProduct.price}',
                  size: Dimensions.font20,
                  isBold: true,
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Align(
                alignment: Alignment.centerLeft,
                child: MyText(
                  text: loadedProduct.description,
                  size: Dimensions.font20,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
