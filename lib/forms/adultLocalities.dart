import 'package:dengue/components/header.dart';
import 'package:dengue/constants/dbHelper.dart';
import 'package:dengue/forms/adultPremises.dart';
import 'package:dengue/forms/larvalPremises.dart';
import 'package:dengue/models/survey_gns_model.dart';
import 'package:dengue/models/survey_locality_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:dengue/components/textRow.dart';
import 'package:dengue/components/spinnerRow.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sqflite/sql.dart';

class AdultLocalities extends StatefulWidget {
  final int survey;
  final String surveyName;
  const AdultLocalities(
      {Key? key, required this.survey, required this.surveyName})
      : super(key: key);

  @override
  State<AdultLocalities> createState() => _AdultLocalitiesState();
}

class _AdultLocalitiesState extends State<AdultLocalities> {
  int selectedSection = 0;

  Box<dynamic> metaRef = Hive.box('meta');

  dynamic selectedGn = null;
  String locality = "";

  dynamic selectedLocality = null;
  TextEditingController searchController = new TextEditingController();

  List<dynamic> localities = [];
  late Box<dynamic> localityBox;

  List<int> gnList = [];

  Future<void> loadGns() async {
    final db = await DBHelper.db();
    List<int> gns = [];
    (await db.query('ndcu_survey_gns',
            where: 'survey_id = ?', whereArgs: [widget.survey]))
        .forEach((gn) => gns.add(SurveyGnsModel.fromJson(gn).gn));
    print(gns);
    setState(() {
      gnList = gns;
    });
  }

  Future<void> loadLocalities() async {
    final db = await DBHelper.db();
    List<SurveyLocalityModel> localityList = [];
    (await db.query('ndcu_survey_localities',
            where: 'survey_id = ?', whereArgs: [widget.survey]))
        .forEach((lo) => localityList.add(SurveyLocalityModel.fromJson(lo)));
    print(localityList.toString());
    setState(() {
      localities = localityList;
    });
  }

  @override
  void initState() {
    loadGns();
    loadLocalities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Align(
          alignment: Alignment(0, 0),
          child: Container(
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Header(pageName: "Localities"),
                  Expanded(
                    child: Column(children: [
                      Container(
                        color: Colors.white54,
                        padding: EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 10.0, bottom: 10.0),
                        child: Column(
                          children: [
                            TextRow(
                                label: 'Survey ID',
                                val: widget.survey.toString(),
                                enabled: false,
                                onChange: (e) {}),
                            TextRow(
                                label: 'Survey Name',
                                val: widget.surveyName,
                                bordered: false,
                                enabled: false,
                                onChange: (e) {
                                  setState(() {});
                                }),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 0, bottom: 0),
                        child: SizedBox(
                          height: (MediaQuery.of(context).size.height * 0.07),
                          child: Align(
                            child: Row(
                              children: [
                                Text('Localities'),
                                Spacer(),
                                IconButton(
                                  onPressed: () {
                                    showCupertinoDialog<void>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          CupertinoAlertDialog(
                                        title: const Text('Add new Locality'),
                                        content: const Text(
                                            'Do you want to add a new locality?'),
                                        actions: <CupertinoDialogAction>[
                                          CupertinoDialogAction(
                                            child: const Text('No'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          CupertinoDialogAction(
                                            child: const Text('Yes'),
                                            isDestructiveAction: true,
                                            onPressed: () async {
                                              if (selectedLocality == null) {
                                                final database =
                                                    await DBHelper.db();
                                                SurveyLocalityModel
                                                    localityModel =
                                                    new SurveyLocalityModel(
                                                        widget.survey,
                                                        selectedGn['id'],
                                                        new DateTime.now()
                                                            .toString(),
                                                        new DateTime.now()
                                                            .toString(),
                                                        locality);
                                                await database.insert(
                                                  'ndcu_survey_localities',
                                                  localityModel.toMap(),
                                                  conflictAlgorithm:
                                                      ConflictAlgorithm.abort,
                                                );
                                                loadLocalities();
                                                setState(() {
                                                  locality = "";
                                                  selectedGn = null;
                                                });
                                              }
                                              Navigator.pop(context);
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.white54,
                        padding: EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 10.0, bottom: 10.0),
                        child: Column(
                          children: [
                            SpinnerRow(
                                label: 'GN Division',
                                options: metaRef
                                    .get('gn')
                                    .where((g) => gnList.contains(g['id']))
                                    .toList(),
                                onSelect: (option) {
                                  setState(() {
                                    selectedGn = option;
                                  });
                                },
                                selected: selectedGn),
                            TextRow(
                                label: 'Locality',
                                val: locality,
                                bordered: false,
                                onChange: (e) {
                                  setState(() {
                                    locality = e;
                                  });
                                }),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white54,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 25.0,
                            right: 25.0,
                            top: 10.0,
                            bottom: 10.0,
                          ),
                          child: CupertinoSearchTextField(
                            controller: searchController,
                            onChanged: (val) {
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                            child: Column(
                              children: List.generate(
                                localities.length,
                                (index) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (selectedLocality != null) {
                                        selectedLocality = null;
                                      } else {
                                        selectedLocality = localities[index];
                                      }
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white70,
                                      border: Border.all(color: Colors.black26),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '${localities[index].locality}',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              print(localities[index].locality);
                                              Navigator.push(
                                                context,
                                                PageTransition(
                                                  type: PageTransitionType
                                                      .rightToLeft,
                                                  duration: Duration(
                                                      milliseconds: 300),
                                                  reverseDuration: Duration(
                                                      milliseconds: 300),
                                                  child: AdultPremises(
                                                      survey_id: widget.survey,
                                                      gn: (metaRef
                                                          .get('gn')
                                                          .where((g) =>
                                                              gnList.contains(
                                                                  g['id']))
                                                          .toList())[0]['name'],
                                                      locality:
                                                          localities[index].locality),
                                                ),
                                              );
                                            },
                                            icon: Icon(
                                                Icons.remove_red_eye_outlined,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
