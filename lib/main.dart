import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps/changes/onboarding.dart';
import 'package:google_maps/deep_link_handler.dart';
import 'package:google_maps/google_maps.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:app_links/app_links.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await Hive.openBox('mapTiles');
  await Hive.openBox('sharePlaces');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final appLinks = AppLinks();

  void _handleDeepLink() async {
    final initialLink = await appLinks.getInitialLink();
    if (initialLink != null) {
      final uri = initialLink;
      DeepLinkHandler.handleDeepLink(context, uri);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _handleDeepLink();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.data != null) {
            return GoogleMapsFlutter();
          }
          return Onboarding();
        },
      ),
    );
  }
}
