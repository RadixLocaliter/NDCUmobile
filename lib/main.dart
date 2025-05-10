import 'package:dengue/login.dart';
import 'package:dengue/theme/app_theme.dart';
import 'package:dengue/theme/config.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('surveys');
  await Hive.openBox('surveys_pending');
  await Hive.openBox('localities');
  await Hive.openBox('localities_pending');
  await Hive.openBox('premises');
  await Hive.openBox('premises_pending');
  await Hive.openBox('containers');
  await Hive.openBox('containers_pending');
  await Hive.openBox('meta');
  runApp(NDCUApp());
}

class NDCUApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainWidget(title: "Test");
  }
}

class MainWidget extends StatefulWidget {
  MainWidget({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    appTheme.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "National Dengue Control Unit",
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: appTheme.appTheme,
      home: Login(),
    );
  }
}
