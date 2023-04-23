import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/utils/dimensions.dart';
import 'package:shop_app/widgets/drawer.dart';
import 'package:shop_app/widgets/my_text.dart';
import 'package:shop_app/widgets/user_product_items.dart';

class UserProductScreen extends StatelessWidget {
  const UserProductScreen({Key? key}) : super(key: key);

  Future<void> _refreshProducts(BuildContext ctx) async {
    await Provider.of<ProductProvider>(ctx, listen: false)
        .fetchAndSetProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Get.to(() => const EditProductScreen());
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () => _refreshProducts(context),
                child: Consumer<ProductProvider>(
                  builder: (context, productData, _) => Padding(
                    padding: EdgeInsets.all(Dimensions.height10),
                    child: productData.items.isEmpty
                        ? Center(
                            child: MyText(
                              text: 'Start your journy and add some products',
                              size: 20,
                              isBold: true,
                            ),
                          )
                        : ListView.builder(
                            itemCount: productData.items.length,
                            itemBuilder: (_, i) => UserProductItems(
                              id: productData.items[i].id,
                              title: productData.items[i].title,
                              imgUrl: productData.items[i].imageUrl,
                            ),
                          ),
                  ),
                ),
              ),
      ),
    );
  }
}
