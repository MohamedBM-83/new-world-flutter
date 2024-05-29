import 'package:flutter/material.dart';
import 'package:netflim/models/app_tab_controller.dart';
import 'package:netflim/screens/youtube_video_screen.dart';
import 'package:netflim/services/favourites_product.dart';
import 'package:netflim/services/list_to_buy.dart';
import 'package:netflim/services/netflim_theme.dart';

import 'screens/movie_list_screen.dart';

import 'services/api_service.dart';
import 'services/user_preferences.dart';

import 'models/product.dart';

import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences().init();
  await FavouritesProduct().init();
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
        screen = AppTabController(ProductList: _products!);
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
      theme: NetflimTheme.theme(),
      debugShowCheckedModeBanner: false,
    );
  }
}
