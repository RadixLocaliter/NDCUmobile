import 'package:dengue/constants/dbHelper.dart';
import 'package:dengue/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:dengue/api/index.dart' as api;
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Box<dynamic> metaRef = Hive.box('meta');

  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  bool loading = false;

  Future<bool> loggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final String? user = prefs.getString('user');
    print("USER LOGIN");
    print(user);
    if (user != null) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    loggedIn().then((value) => {
          if (value) {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 300),
                reverseDuration:
                    Duration(milliseconds: 300),
                child: Dashboard(),
              ),
            )
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
              Padding(
                padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: Text(
                  'Login',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              Spacer(),
              loading
                  ? CupertinoActivityIndicator()
                  : Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.black38, width: 0.0))),
                              child: SizedBox(
                                  height: (MediaQuery.of(context).size.height *
                                      0.07),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 2 *
                                            MediaQuery.of(context).size.width /
                                            5,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Username",
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: TextField(
                                            controller: usernameController,
                                            style: TextStyle(fontSize: 15.0),
                                            textAlign: TextAlign.right,
                                            decoration: InputDecoration(
                                                border: InputBorder.none),
                                            textInputAction:
                                                TextInputAction.next,
                                            cursorColor: Colors.redAccent),
                                      )
                                    ],
                                  )),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.black38, width: 0.0))),
                              child: SizedBox(
                                  height: (MediaQuery.of(context).size.height *
                                      0.07),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 2 *
                                            MediaQuery.of(context).size.width /
                                            5,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Password",
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          controller: passwordController,
                                          style: TextStyle(fontSize: 15.0),
                                          textAlign: TextAlign.right,
                                          decoration: InputDecoration(
                                              border: InputBorder.none),
                                          textInputAction: TextInputAction.next,
                                          cursorColor: Colors.redAccent,
                                          obscureText: true,
                                          autocorrect: false,
                                          enableSuggestions: false,
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: ElevatedButton(
                                child: Text("Login"),
                                onPressed: () async {
                                  setState(() {
                                    loading = true;
                                  });
                                  dynamic out;
                                  try {
                                    out = await api.loginUser(
                                        usernameController.text,
                                        passwordController.text);
                                    if (out.length > 0) {
                                      print(out);
                                      final snackBar = SnackBar(
                                        backgroundColor:
                                            Colors.greenAccent[300],
                                        content: const Text('Login Successful'),
                                        action: SnackBarAction(
                                          label: 'OK',
                                          onPressed: () {},
                                        ),
                                      );

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                      metaRef.put(
                                          "user", usernameController.text);
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setString(
                                          'user', usernameController.text);
                                      prefs.setString("token", out['token']);
                                      dynamic meta = await api.getMeta();
                                      metaRef.put("district", meta['district']);
                                      metaRef.put("rdhs", meta['rdhs']);
                                      metaRef.put("moh", meta['moh']);
                                      metaRef.put("phi", meta['phi']);
                                      metaRef.put("gn", meta['gn']);
                                      metaRef.put("users", meta['users']);
                                      await Navigator.pushReplacement(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType.rightToLeft,
                                          duration: Duration(milliseconds: 300),
                                          reverseDuration:
                                              Duration(milliseconds: 300),
                                          child: Dashboard(),
                                        ),
                                      );
                                    } else {
                                      final snackBar = SnackBar(
                                        backgroundColor: Colors.redAccent,
                                        content: const Text(
                                            'Please check your login credentials'),
                                        action: SnackBarAction(
                                          label: 'OK',
                                          onPressed: () {},
                                        ),
                                      );

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);

                                      setState(() {
                                        loading = false;
                                      });
                                    }
                                  } on Exception catch (e) {
                                    setState(() {
                                      loading = false;
                                    });
                                    print(e);
                                    final snackBar = SnackBar(
                                      backgroundColor: Colors.redAccent,
                                      content:
                                          const Text('Network error occured'),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.redAccent),
                              )),
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
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        Text(
                          'Public Health Complex, 555/5, Elvitigala Mawatha, Narahenpita, Colombo 5',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        Text(
                          'Telephone' +
                              ': (0094) 011 2368416, 2368417  ' +
                              'Fax' +
                              ': (0094) 011 2369893',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        Text(
                          'Email' + ': ndcu2010@yahoo.com',
                          style: Theme.of(context).textTheme.labelMedium,
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
