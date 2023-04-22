// ignore_for_file: unnecessary_null_comparison, prefer_void_to_null

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product.dart';
import 'package:shop_app/provider/product_provider.dart';
import 'package:shop_app/utils/dimensions.dart';

import '../utils/app_colors.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = '/edit-product-screen';

  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imgUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();

  var _editProduct = Product(
    id: '',
    title: '',
    description: '',
    imageUrl: '',
    price: 0,
  );

  bool _isInit = true;
  bool _isLoading = false;

  var _initVal = {
    'title': '',
    'description': '',
    'imageUrl': '',
    'price': '',
  };

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final String? prodId =
          ModalRoute.of(context)!.settings.arguments as String?;

      if (prodId != null) {
        // 34an lw prod new msh hikon lsa id fa msh lazm y5osh hna
        _editProduct = Provider.of<ProductProvider>(
          context,
          listen: false,
        ).searchById(prodId);

        _initVal = {
          'title': _editProduct.title,
          'price': _editProduct.price.toString(),
          'description': _editProduct.description,
          'imageUrl': _imgUrlController.text = _editProduct.imageUrl,
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    final _validate = _form.currentState!.validate();
    final provider = Provider.of<ProductProvider>(context, listen: false);
    if (!_validate) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    if (_editProduct.id.isEmpty) {
      try {
        await provider.addProduct(_editProduct);
      } catch (er) {
        await _showDialog();
      }
    } else {
      // lw mlyan e3ml update
      try {
        await provider.updateProduct(_editProduct.id, _editProduct);
      } catch (er) {
        await _showDialog();
      }
    }
    setState(() {
      _isLoading = false;
    });
    Get.back();
  }

  Future<dynamic> _showDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('An error occurred!'),
        content: const Text(
          'Something went wrong and will be solved soon.',
        ),
        actions: [
          TextButton(
            child: const Text(
              'Okay',
              style: TextStyle(
                color: AppColors.secondryColor,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop(); //wait answer from user is future
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editing Products'),
        actions: [
          IconButton(
            onPressed: () {
              _saveForm();
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(Dimensions.font15),
              child: Form(
                // autovalidateMode: search how it work,
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initVal['title'],
                      decoration: const InputDecoration(
                        labelText: 'Title',
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _editProduct = Product(
                          id: _editProduct.id,
                          isFavorites: _editProduct.isFavorites,
                          title: '$val',
                          description: _editProduct.description,
                          imageUrl: _editProduct.imageUrl,
                          price: _editProduct.price,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initVal['price'],
                      decoration: const InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please enter the price.';
                        }
                        if (double.tryParse(val) == null) {
                          return 'please enter a valid number.';
                        }
                        if (double.parse(val) <= 0) {
                          return 'enter a number greater than zero.';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _editProduct = Product(
                          id: _editProduct.id,
                          isFavorites: _editProduct.isFavorites,
                          title: _editProduct.title,
                          description: _editProduct.description,
                          imageUrl: _editProduct.imageUrl,
                          price: double.parse('$val'),
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initVal['description'],
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      maxLength: 150,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please enter product description.';
                        }
                        if (val.length < 10) {
                          return 'at least 10 characters';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _editProduct = Product(
                          id: _editProduct.id,
                          isFavorites: _editProduct.isFavorites,
                          title: _editProduct.title,
                          description: '$val',
                          imageUrl: _editProduct.imageUrl,
                          price: _editProduct.price,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: Dimensions.width100,
                          height: Dimensions.height100,
                          margin: EdgeInsets.only(
                            top: Dimensions.height5,
                            right: Dimensions.width10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imgUrlController.text.isEmpty
                              ? Container(
                                  padding: EdgeInsets.all(Dimensions.height10),
                                  child: const Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.grey,
                                  ),
                                )
                              : FittedBox(
                                  child: Image.network(
                                    _imgUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Image Url',
                                hintText: 'Enter image url'),
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.url,
                            controller: _imgUrlController,
                            onSaved: (val) {
                              _editProduct = Product(
                                id: _editProduct.id,
                                isFavorites: _editProduct.isFavorites,
                                title: _editProduct.title,
                                description: _editProduct.description,
                                imageUrl: '$val',
                                price: _editProduct.price,
                              );
                            },
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please provide a url.';
                              }
                              if (!val.startsWith('http') &&
                                  !val.startsWith('https')) {
                                return 'enter a valid url';
                              }
                              if (!val.endsWith('.jpeg') &&
                                  !val.endsWith('.jpg') &&
                                  !val.endsWith('.png')) {
                                return 'let image url ends with .jpeg or .png or .jpg';
                              }
                              return null;
                            },
                            onEditingComplete: () {
                              setState(() {});
                            },
                            onChanged: (_) {
                              setState(() {});
                            },
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
