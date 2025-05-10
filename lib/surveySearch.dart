import 'package:dengue/components/header.dart';
import 'package:dengue/components/surveyItem.dart';
import 'package:dengue/constants/dbHelper.dart';
import 'package:dengue/models/survey_gns_model.dart';
import 'package:dengue/models/survey_locality_model.dart';
import 'package:dengue/models/survey_model.dart';
import 'package:dengue/models/survey_premise_model.dart';
import 'package:dengue/models/survey_surveyour_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dengue/api/index.dart' as api;
import 'package:sqflite/sql.dart';

class SurveySearch extends StatefulWidget {
  final int type;
  SurveySearch({Key? key, required this.type}) : super(key: key);

  @override
  _SurveySearchState createState() => _SurveySearchState();
}

class _SurveySearchState extends State<SurveySearch> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  dynamic selectedSurveyTechnique;

  Box<dynamic> surveyRef = Hive.box('surveys');
  Box<dynamic> surveyPendingRef = Hive.box('surveys_pending');

  List<String> titles = [
    "Larval Surveys",
    "Adult Surveys",
    "Ovitrap Surveilances",
    "Pupal Surveys"
  ];

  List<dynamic> surveysList = [];

  List<dynamic> selectedSurveysList = [];

  TextEditingController searchController = new TextEditingController();

  void manageServerSync() async {
    var surveys = await api.getSurveys('admin');

    for (var survey in surveys) {
      surveyRef.put(survey['id'], survey);
    }

    setState(() {
      selectedSurveysList = surveys;
    });
  }

  Future<void> loadSurveys() async {
    surveysList = [];
    final db = await DBHelper.db();
    surveysList = await db.query('ndcu_surveys',
        where: 'survey_technique = ?', whereArgs: [widget.type]);
    setState(() {
      selectedSurveysList = surveysList;
    });
  }

  @override
  void initState() {
    // manageServerSync();
    super.initState();
    loadSurveys();
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
                Header(
                  pageName: titles[widget.type - 1],
                  actionLabel: IconButton(
                      onPressed: () {
                        showCupertinoDialog<void>(
                          context: context,
                          builder: (BuildContext context) =>
                              CupertinoAlertDialog(
                            title: const Text('Fetch new surveys'),
                            content:
                                const Text('Do you want to fetch new surveys?'),
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
                                  var records =
                                      await api.fetchSurveys(widget.type);
                                  if (records != null) {
                                    print(records);
                                    final db = await DBHelper.db();
                                    for (var i = 0;
                                        i < records['surveys'].length;
                                        i++) {
                                      if (records['surveys'][i]['finished'] ==
                                          null) {
                                        records['surveys'][i]['finished'] = 0;
                                      }
                                      records['surveys'][i]['last_sync'] =
                                          new DateTime.now().toString();
                                      SurveyModel surveyModel =
                                          SurveyModel.fromJson(
                                              records['surveys'][i]);
                                      await db.insert(
                                        'ndcu_surveys',
                                        surveyModel.toMap(),
                                        conflictAlgorithm:
                                            ConflictAlgorithm.ignore,
                                      );
                                    }

                                    for (var i = 0;
                                        i < records['survey_gns'].length;
                                        i++) {
                                      SurveyGnsModel surveyModel =
                                          SurveyGnsModel.fromJson(
                                              records['survey_gns'][i]);
                                      await db.insert(
                                        'ndcu_survey_gns',
                                        surveyModel.toMap(),
                                        conflictAlgorithm:
                                            ConflictAlgorithm.ignore,
                                      );
                                    }

                                    for (var i = 0;
                                        i < records['survey_surveyors'].length;
                                        i++) {
                                      SurveySurveyourModel surveyModel =
                                          SurveySurveyourModel.fromJson(
                                              records['survey_surveyors'][i]);
                                      await db.insert(
                                        'ndcu_survey_surveyors',
                                        surveyModel.toMap(),
                                        conflictAlgorithm:
                                            ConflictAlgorithm.ignore,
                                      );
                                    }

                                    for (var i = 0;
                                        i < records['survey_localities'].length;
                                        i++) {
                                      SurveyLocalityModel surveyModel =
                                          SurveyLocalityModel.fromJson(
                                              records['survey_localities'][i]);
                                      await db.insert(
                                        'ndcu_survey_localities',
                                        surveyModel.toMap(),
                                        conflictAlgorithm:
                                            ConflictAlgorithm.ignore,
                                      );
                                    }

                                    for (var i = 0;
                                        i < records['survey_premises'].length;
                                        i++) {
                                      SurveyPremiseModel surveyModel =
                                          SurveyPremiseModel.fromJson(
                                              records['survey_premises'][i]);
                                      await db.insert(
                                        'ndcu_survey_premises',
                                        surveyModel.toMap(),
                                        conflictAlgorithm:
                                            ConflictAlgorithm.ignore,
                                      );
                                    }

                                    switch (widget.type) {
                                      case 1:
                                        for (var i = 0;
                                            i < records['containers'].length;
                                            i++) {
                                          SurveyPremiseModel surveyModel =
                                              SurveyPremiseModel.fromJson(
                                                  records['containers'][i]);
                                          await db.insert(
                                            'ndcu_larval_surveys',
                                            surveyModel.toMap(),
                                            conflictAlgorithm:
                                                ConflictAlgorithm.ignore,
                                          );
                                        }
                                        break;
                                      case 2:
                                        for (var i = 0;
                                            i < records['containers'].length;
                                            i++) {
                                          SurveyPremiseModel surveyModel =
                                              SurveyPremiseModel.fromJson(
                                                  records['containers'][i]);
                                          await db.insert(
                                            'ndcu_adult_surveys',
                                            surveyModel.toMap(),
                                            conflictAlgorithm:
                                                ConflictAlgorithm.ignore,
                                          );
                                        }
                                        break;
                                      case 3:
                                        for (var i = 0;
                                            i < records['containers'].length;
                                            i++) {
                                          SurveyPremiseModel surveyModel =
                                              SurveyPremiseModel.fromJson(
                                                  records['containers'][i]);
                                          await db.insert(
                                            'ndcu_ovitrap_surveys',
                                            surveyModel.toMap(),
                                            conflictAlgorithm:
                                                ConflictAlgorithm.ignore,
                                          );
                                        }
                                        break;
                                      case 4:
                                        for (var i = 0;
                                            i < records['containers'].length;
                                            i++) {
                                          SurveyPremiseModel surveyModel =
                                              SurveyPremiseModel.fromJson(
                                                  records['containers'][i]);
                                          await db.insert(
                                            'ndcu_pupal_surveys',
                                            surveyModel.toMap(),
                                            conflictAlgorithm:
                                                ConflictAlgorithm.ignore,
                                          );
                                        }
                                        break;
                                      default:
                                        break;
                                    }
                                    final snackBar = SnackBar(
                                      backgroundColor: Colors.redAccent,
                                      content: const Text('Sync successful'),
                                      action: SnackBarAction(
                                        label: 'OK',
                                        onPressed: () {},
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } else {
                                    print("Nothing's available to sync");
                                    final snackBar = SnackBar(
                                      backgroundColor: Colors.redAccent,
                                      content: const Text('Already synced'),
                                      action: SnackBarAction(
                                        label: 'OK',
                                        onPressed: () {},
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }

                                  Navigator.pop(context);
                                },
                              )
                            ],
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.downloading_sharp,
                        color: Colors.blueGrey,
                      )),
                ),
                SizedBox(
                  height: (MediaQuery.of(context).size.height * 0.01),
                ),
                Container(
                  color: Colors.white54,
                  child: Padding(
                    padding: EdgeInsets.all(25.0),
                    child: CupertinoSearchTextField(
                      controller: searchController,
                      onChanged: (val) {
                        setState(() {
                          selectedSurveysList = surveysList
                              .where((item) =>
                                  item['name'].toString().contains(val))
                              .toList();
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                    child: RefreshIndicator(
                  onRefresh: () => loadSurveys(),
                  child: ListView.builder(
                      itemCount: selectedSurveysList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(left: 15.0, right: 15.0),
                          child: SurveyItem(obj: selectedSurveysList[index]),
                        );
                      }),
                ))
              ]),
        )));
  }
}
