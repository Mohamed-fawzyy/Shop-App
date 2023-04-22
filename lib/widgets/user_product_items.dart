import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/utils/app_colors.dart';

class UserProductItems extends StatelessWidget {
  final String id;
  final String title;
  final String imgUrl;

  const UserProductItems({
    Key? key,
    required this.title,
    required this.imgUrl,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(imgUrl)),
      title: Text(title),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.edit,
                color: AppColors.mainColor,
              ),
              onPressed: () {
                // Get.toNamed(EditProductScreen.routeName,arguments: id);
                Navigator.of(context).pushNamed(
                  EditProductScreen.routeName,
                  arguments: id,
                );
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete immediately!'),
                    content: const Text('Do you want to remove this product?'),
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
                        onPressed: () async {
                          try {
                            Navigator.of(context).pop(true);
                            await Provider.of<ProductProvider>(
                              context,
                              listen: false,
                            ).deleteProduct(id);
                          } catch (er) {
                            Get.snackbar(
                              'Faild to delete!',
                              'Somthing went wrong in the server, will be solved soon.',
                              snackPosition: SnackPosition.BOTTOM,
                              duration: const Duration(seconds: 4),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
