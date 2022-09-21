import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:src/helpers/generate_routes.dart';
import 'package:src/models/DrinkAmount.dart';
import 'package:src/screens/navigation_controller.dart';
import 'package:src/screens/setup_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //* Initialize Hive Database
  await Hive.initFlutter();
  Hive.registerAdapter(DrinkAmountAdapter());
  await Hive.openBox<DrinkAmount>('drink_amounts');

  //* Lock screen in portrait-mode
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _intakeAmount = 0;

  void loadIntakeAmount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _intakeAmount = (prefs.getInt('intake_amount') ?? -1);
    });
  }

  @override
  void initState() {
    super.initState();
    loadIntakeAmount();
  }

  @override
  Widget build(BuildContext context) {
    // Set color of systemnavigation
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarContrastEnforced: true,
        systemNavigationBarIconBrightness: Brightness.dark));

    return MaterialApp(
      color: Colors.white,
      debugShowCheckedModeBanner: false,
      title: 'Minimal Water Tracker',
      theme: ThemeData(
        textTheme: GoogleFonts.robotoFlexTextTheme(),
        splashFactory: InkRipple.splashFactory,
        primaryColor: const Color(0xff41C4FD),
        useMaterial3: true,
      ),
      home: _intakeAmount == -1
          ? const SetupScreen()
          : const NavigationController(
              initIndex: 0,
            ),
      onGenerateRoute: generateRoutes,
    );
  }
}
