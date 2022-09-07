import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:src/screens/about_screen.dart';
import 'package:src/screens/settings_screen.dart';
import 'package:src/screens/setup_screen.dart';
import 'package:src/screens/welcome_screen.dart';

import '../screens/home_screen.dart';
import '../screens/navigation_controller.dart';
import '../screens/statistics_screen.dart';

Route<dynamic> generateRoutes(settings) {
  switch (settings.name) {
    case AboutScreen.routeName:
      return PageTransition(
        child: const AboutScreen(),
        type: PageTransitionType.rightToLeftWithFade,
        settings: settings,
      );
    case SettingsScreen.routeName:
      return PageTransition(
        child: const SettingsScreen(),
        type: PageTransitionType.rightToLeftWithFade,
        settings: settings,
      );
    case WelcomeScreen.routeName:
      return PageTransition(
        child: const WelcomeScreen(),
        type: PageTransitionType.leftToRightWithFade,
        settings: settings,
      );
    case SetupScreen.routeName:
      return PageTransition(
        child: const SetupScreen(),
        type: PageTransitionType.rightToLeftWithFade,
        settings: settings,
      );
    case HomeScreen.routeName:
      return PageTransition(
        child: const NavigationController(
          initIndex: 0,
        ),
        type: PageTransitionType.rightToLeftWithFade,
        settings: settings,
      );
    case StatisticsScreen.routeName:
      return PageTransition(
        child: const NavigationController(
          initIndex: 1,
        ),
        type: PageTransitionType.rightToLeftWithFade,
        settings: settings,
      );
    default:
      return PageTransition(
        child: const WelcomeScreen(),
        type: PageTransitionType.leftToRightWithFade,
        settings: settings,
      );
  }
}
