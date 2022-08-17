import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:src/helpers/generate_routes.dart';
import 'package:src/models/DrinkAmount.dart';
import 'package:src/screens/navigation_controller.dart';
import 'package:src/screens/welcome_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(DrinkAmountAdapter());
  await Hive.openBox<DrinkAmount>('drink_amounts');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<int> intakeAmount;

  @override
  void initState() {
    intakeAmount = _prefs.then((SharedPreferences prefs) {
      return prefs.getInt('intake_amount') ?? 0;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Set color of systemnavigation
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(systemNavigationBarColor: Colors.white));

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.robotoFlexTextTheme(),
        splashFactory: InkRipple.splashFactory,
        primaryColor: const Color(0xff41C4FD),
        useMaterial3: true,
      ),
      home: FutureBuilder<int>(
          future: intakeAmount,
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              default:
                if (snapshot.data == 0) {
                  return const WelcomeScreen();
                } else {
                  return const NavigationController(
                    initIndex: 0,
                  );
                }
            }
          }),
      onGenerateRoute: generate_routes,
    );
  }
}
