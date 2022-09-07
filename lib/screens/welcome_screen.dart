import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:src/screens/setup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  static const routeName = "/welcome";

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget title = Text(
      "Track your water intake & improve your health",
      textAlign: TextAlign.start,
      style: GoogleFonts.robotoFlex(
        color: const Color(0xff43AAD7),
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
    );

    const welcomeText = Text(
      "Enter what and how much you drank every day and track your progress improving your drinking habits",
      textAlign: TextAlign.start,
      style: TextStyle(color: Color.fromARGB(255, 110, 110, 110), fontSize: 16),
    );

    return Scaffold(
      backgroundColor: Colors.white,
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
        toolbarHeight: 10,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, SetupScreen.routeName);
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
          )),
      body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Welcome",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff3F3D56),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        "assets/images/others/welcome_screen.svg",
                        height: 240,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    title,
                    const SizedBox(
                      height: 15,
                    ),
                    welcomeText,
                  ],
                ),
              ),
              const SizedBox(),
            ],
          )),
    );
  }
}
