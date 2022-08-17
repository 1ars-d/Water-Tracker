import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StatisticsScreen extends StatelessWidget {
  static const routeName = "/statistics";

  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Statistics"),
        elevation: 10,
        systemOverlayStyle: const SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: Colors.transparent,

          // Status bar brightness (optional)
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: const Center(
        child: Text("Statistics"),
      ),
    );
  }
}
