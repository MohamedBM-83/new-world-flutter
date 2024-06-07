import 'package:flutter/material.dart';
import 'package:newworld/models/app_tab_controller.dart';
import 'package:newworld/services/cart.dart';
import 'package:newworld/services/list_to_buy.dart';
import 'package:newworld/services/newworld_theme.dart';


import 'services/api_service.dart';
import 'services/user_preferences.dart';

import 'models/product.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences().init();
  await Cart().init();
  await ListToBuy().init();

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  LoadingStatus _loadingStatus = LoadingStatus.loading;
  List<Product>? _products;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _loadingStatus = LoadingStatus.loading;
    });

    ApiService service = ApiService();

    try {
      await Future.delayed(const Duration(seconds: 2));

      _products = await service.getProducts(1);

      //Movie? movie = await service.getMovie(940721);

      _loadingStatus = LoadingStatus.success;
    } catch (e) {
      print(e);
      _loadingStatus = LoadingStatus.error;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget screen;

    switch (_loadingStatus) {
      case LoadingStatus.success:
        // screen = LoginScreen(products: _products!);
        screen = AppTabController(ProductList: _products);
        break;
      default:
        screen = HomeScreen(
          loadingStatus: _loadingStatus,
          onReload: _fetchProducts,
        );
        break;
    }

    // Test d'accès à Youtube
    // screen = const YoutubeVideoScreen(videoId: '-6lMRysFhrM');

    return MaterialApp(
      home: screen,
      theme: NetfilmTheme.theme(),
      debugShowCheckedModeBanner: false,
    );
  }
}
