// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/provider/product_provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
// import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/drawer.dart';
import '../widgets/product_grid_view.dart';
import 'package:shop_app/utils/app_colors.dart';

enum FilterOptions {
  all,
  favorite,
}

class ProductsScreen extends StatefulWidget {
  ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  bool _showOnlyFav = false;
  bool _isLoading = false;
  bool _isInit = true;

// use this instead of init cuz it rebuilt manytime not once like the init at
//begenning so her for each rebuild to notify chage we call this method to
//reload another time as init
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductProvider>(context).fetchAndSetProduct().then(
            (_) => setState(
              () {
                _isLoading = false;
              },
            ),
          );
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        centerTitle: true,
        backgroundColor: AppColors.mainColor,
        actions: [
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              label: Text(
                  99 <= cart.itemsCount ? '99+' : cart.itemsCount.toString()),
              textColor: Color.fromRGBO(255, 87, 34, 1),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Get.to(CartScreen());
              },
            ),
          ),
          PopupMenuButton(
            onSelected: ((FilterOptions selectedVal) {
              setState(() {
                if (selectedVal == FilterOptions.favorite) {
                  _showOnlyFav = true;
                } else {
                  _showOnlyFav = false;
                }
              });
            }),
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.favorite,
              ),
              PopupMenuItem(
                child: Text('Show all'),
                value: FilterOptions.all,
              ),
            ],
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ProductGridView(_showOnlyFav),
    );
  }
}
