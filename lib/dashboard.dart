import 'package:dengue/components/tileRow.dart';
import 'package:dengue/createSurvey.dart';
import 'package:dengue/login.dart';
import 'package:dengue/surveySearch.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Box<dynamic> metaRef = Hive.box('meta');
  Box<dynamic> surveyRef = Hive.box('surveys');

  Future<bool> loggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final String? user = prefs.getString('user');
    if (user != null) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    loggedIn().then((value) {
      print("USER");
      print(value);
      if (!value) {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            duration: Duration(milliseconds: 300),
            reverseDuration: Duration(milliseconds: 300),
            child: Login(),
          ),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Align(
          alignment: Alignment(0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Image.asset(
                            'assets/images/profile.png',
                            height: 40,
                          ),
                        ),
                        Text(
                          'Hello' + ' ' + metaRef.get("user"),
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 15, 0),
                    child: IconButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        prefs.remove('user');
                        Navigator.pushReplacement(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 300),
                            reverseDuration: Duration(milliseconds: 300),
                            child: Login(),
                          ),
                        );
                      },
                      icon: Icon(Icons.settings_power_outlined),
                      color: Color.fromARGB(255, 200, 122, 122),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Pending Surveys',
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    TileRow(
                      title: 'Larval Surveys',
                      destination: SurveySearch(
                        type: 1,
                      ),
                    ),
                    TileRow(
                      title: 'Adult Surveys',
                      destination: SurveySearch(
                        type: 2,
                      ),
                    ),
                    TileRow(
                      title: 'Ovitrap Surveilances',
                      destination: SurveySearch(
                        type: 3,
                      ),
                    ),
                    TileRow(
                      title: 'Pupal Surveys',
                      destination: SurveySearch(
                        type: 4,
                      ),
                    ),
                    Text(
                      'Create Surveys',
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    TileRow(
                      title: 'Create Survey',
                      destination: CreateSurvey(),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Image.asset(
                        'assets/images/logo_lk.png',
                        height: 50,
                      ),
                    ),
                    Expanded(
                        child: Column(
                      children: [
                        Text(
                          'National Dengue Control Unit',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          'Public Health Complex, 555/5, Elvitigala Mawatha, Narahenpita, Colombo 5',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          'Telephone' +
                              ': (0094) 011 2368416, 2368417  ' +
                              'Fax' +
                              ': (0094) 011 2369893',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          'Email' + ': ndcu2010@yahoo.com',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    )),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Image.asset(
                        'assets/images/logo_ndcu.png',
                        height: 50,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
