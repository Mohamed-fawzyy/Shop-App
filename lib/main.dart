import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/auth.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/provider/orders.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/provider/product_provider.dart';
import 'package:shop_app/screens/products_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(), //do this for init for 1st time only
        ),
        // proxy mean this provider depends on other provider and the <second>for returning type
        ChangeNotifierProxyProvider<Auth, ProductProvider>(
          update: (context, auth, previousData) => ProductProvider(
            auth.token,
            auth.userId,
            previousData == null ? [] : previousData.items,
          ),
          create: (_) => ProductProvider('', '', []),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (context, auth, prevData) => Orders(
            auth.token,
            auth.userId,
            prevData == null ? [] : prevData.orders,
          ),
          create: (context) => Orders('', '', []),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Shop App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple),
            fontFamily: 'Lato',
          ),
          home: auth.isAuth
              ? ProductsScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogIn(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthScreen(),
                ),
          routes: {
            '/edit-product-screen': (context) => const EditProductScreen(),
          },
        ),
      ),
    );
  }
}
