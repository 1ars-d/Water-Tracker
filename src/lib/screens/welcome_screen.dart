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
      style: GoogleFonts.robotoSlab(
        color: const Color(0xff43AAD7),
        fontSize: 24,
        fontWeight: FontWeight.w400,
      ),
    );

    const welcomeText = Text(
      "Enter what and how much you drank every day and track your progress improving your drinking habits",
      textAlign: TextAlign.start,
      style: TextStyle(color: Color.fromARGB(255, 110, 110, 110), fontSize: 16),
    );

    final nextButton = ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, SetupScreen.routeName);
        },
        style: ElevatedButton.styleFrom(
            elevation: 10,
            shadowColor: const Color.fromARGB(255, 4, 217, 255).withOpacity(.5),
            primary: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Get Started",
              style: TextStyle(
                  fontSize: 19,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 13,
            ),
            Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
            )
          ],
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Container(
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/IMG/welcome_screen.svg",
                      height: 220,
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
              Container(
                  margin: const EdgeInsets.only(top: 20),
                  height: 55,
                  width: double.infinity,
                  child: nextButton),
            ],
          )),
    );
  }
}
