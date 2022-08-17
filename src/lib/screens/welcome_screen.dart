import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:src/screens/setup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  static const routeName = "/welcome";

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const welcomeTitle = Text(
      "Welcome",
      style: TextStyle(
          color: Color(0xFF3B3B3B), fontSize: 48, fontWeight: FontWeight.bold),
    );

    const welcomeText = Text(
      "To get started we need to setup your daily water intake",
      style: TextStyle(color: Color(0xff5C5C5C), fontSize: 16),
    );

    final nextButton = ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, SetupScreen.routeName);
        },
        style:
            ElevatedButton.styleFrom(primary: Theme.of(context).primaryColor),
        child: const Text(
          "NEXT",
          style: TextStyle(
              fontSize: 19, color: Colors.white, fontWeight: FontWeight.w600),
        ));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: Colors.transparent,

          // Status bar brightness (optional)
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        elevation: 0,
      ),
      body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    welcomeTitle,
                    welcomeText,
                  ],
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 20),
                  height: 60,
                  width: double.infinity,
                  child: nextButton),
            ],
          )),
    );
  }
}
