//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

//import 'package:http_certificate_pinning/http_certificate_pinning.dart';

import 'colors.dart';
import 'user_data.dart';

late MainColors colorsTheme;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'client.env');
  await Firebase.initializeApp();

// Elsewhere in your code
//  FirebaseCrashlytics.instance.crash();
  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  _setColorTheme();
  runApp(const MyApp());
}

_setColorTheme() {
  String? selectedTheme = dotenv.env['THEME'];
  if (selectedTheme == 'blue') {
    colorsTheme = BlueColors();
  } else if (selectedTheme == 'red') {
    colorsTheme = RedColors();
  } else if (selectedTheme == 'yellow') {
    colorsTheme = YellowColors();
  } else {
    colorsTheme = GreenColors();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String appTitle = dotenv.env['TITLE']!;
    return MaterialApp(
      title: appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: colorsTheme.backgroundColor,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  UserData? userData;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  void initState() {
    //  myRepositoryMethod();
    super.initState();
  }

  static const sha256 =
      '41:2E:B1:9A:63:A1:CD:CB:58:2C:AA:46:70:70:3E:24:6C:6E:A1:E7:61:E8:96:57:73:FB:25:9F:11:2F:87:C2';

  @override
  Widget build(BuildContext context) {
    ///test trigger on push
    return Scaffold(
      backgroundColor: colorsTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: colorsTheme.appBarColor,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/logo.png',
              height: 100,
              width: 100,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              'You have pushed the button this many times:',
              style: TextStyle(color: colorsTheme.descColor),
            ),
            Text(
              '$_counter',
              style: TextStyle(color: colorsTheme.textColor),
            ),
            const SizedBox(height: 16),
            if (userData != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Id: ',
                        style: TextStyle(color: colorsTheme.textColor),
                      ),
                      Text(
                        (userData?.id ?? 0).toString(),
                        style: TextStyle(color: colorsTheme.descColor),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Name: ',
                        style: TextStyle(color: colorsTheme.textColor),
                      ),
                      Text(
                        userData?.name ?? '',
                        style: TextStyle(color: colorsTheme.descColor),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Nationality: ',
                        style: TextStyle(color: colorsTheme.textColor),
                      ),
                      Text(
                        userData?.nationality ?? '',
                        style: TextStyle(color: colorsTheme.descColor),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'City: ',
                        style: TextStyle(color: colorsTheme.textColor),
                      ),
                      Text(
                        userData?.city ?? '',
                        style: TextStyle(color: colorsTheme.descColor),
                      ),
                    ],
                  ),
                ],
              )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorsTheme.fabColor,
        onPressed: FirebaseCrashlytics.instance.crash /*_incrementCounter*/,
        tooltip: 'Increment',
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

/*  Future<void> getData() async {
    try {
      String url = dotenv.env['BASE_URL']!;
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          userData = UserData.fromJson(jsonDecode(response.body));
        });
      } else {
        throw 'connection error';
      }
    } catch (e) {
      rethrow;
    }
  }*/
}
