import 'dart:convert';

import 'package:dengue/api/index.dart';
import 'package:dengue/components/labelRow.dart';
import 'package:dengue/constants/dbHelper.dart';
import 'package:dengue/models/survey_gns_model.dart';
import 'package:dengue/models/survey_model.dart';
import 'package:dengue/models/survey_surveyour_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sqflite/sqflite.dart';
import 'components/header.dart';
import 'package:dengue/components/spinnerRow.dart';
import 'package:dengue/constants/dropdowns.dart';

import 'components/textRow.dart';

class CreateSurvey extends StatefulWidget {
  final String title;
  CreateSurvey({Key? key, this.title = "Create Survey Page"}) : super(key: key);

  @override
  _CreateSurveyState createState() => _CreateSurveyState();
}

class _CreateSurveyState extends State<CreateSurvey> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Box<dynamic> surveyRef = Hive.box('surveys_pending');
  Box<dynamic> metaRef = Hive.box('meta');

  dynamic selectedContribution;

  dynamic selectedSurveyCategory;

  dynamic selectedDistrict;

  dynamic selectedMohArea;

  dynamic selectedRdhsArea;

  dynamic selectedPhiArea;

  List<dynamic> selectedSurveyors = [];

  List<dynamic> selectedGns = [];

  List<dynamic> surveysList = [];
  dynamic selectedSurveyTechnique;
  List<dynamic> selectedSurveysList = [];

  dynamic selectedSurveyType;

  Map<String, dynamic> surveyData = {
    "id": "",
    "name": "",
    "contribution": "",
    "description": "",
    "type": "",
    "category": "",
    "survey_technique": "",
    "completed": 0,
    "lat": "",
    "lng": "",
    "district": null,
    "rdhs": null,
    "moh": null,
    "phi": null,
    "gns": [],
    "surveyors": [],
    "lead_by": "",
    "created_by": null,
    "done": false,
    "created": "",
    "updated": "",
    "finished": 0,
    "last_sync": null
  };

  String surveyId = "";
  String username = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      username = metaRef.get("user");
      surveyId = DateTime.now().millisecondsSinceEpoch.toString();
      surveyData['id'] = surveyId;
      selectedSurveyors.add(username);
    });
  }

  Future<void> syncSurvey() async {
    var sur = await createNewSurvey({"survey": jsonEncode(surveyData)});
    print("###### SUR");
    print(sur);
  }

  Future<void> insertSurvey() async {
    final database = await DBHelper.db();
    SurveyModel surveyModel = SurveyModel.fromJson(surveyData);
    await database.insert(
      'ndcu_surveys',
      surveyModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
    selectedGns.forEach((gn) async {
      SurveyGnsModel surveyGnsModel = SurveyGnsModel(
          int.parse(surveyData['id']),
          gn,
          DateTime.now().toString(),
          DateTime.now().toString());
      await database.insert(
        'ndcu_survey_gns',
        surveyGnsModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    });
    selectedSurveyors.forEach((surveyor) async {
      SurveySurveyourModel surveySurveyourModel = SurveySurveyourModel(
          int.parse(surveyData['id']),
          surveyor,
          DateTime.now().toString(),
          DateTime.now().toString());
      await database.insert(
        'ndcu_survey_surveyors',
        surveySurveyourModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Align(
              alignment: Alignment(0, 0),
              child: Container(
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Header(
                          action: () => {
                                showCupertinoDialog<void>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        CupertinoAlertDialog(
                                          title: const Text('Save section'),
                                          content: Text(
                                              "Do you want to create this survey? (Internet connection required)"),
                                          actions: <CupertinoDialogAction>[
                                            CupertinoDialogAction(
                                              child: const Text('No'),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            CupertinoDialogAction(
                                              child: const Text('Yes'),
                                              onPressed: () {
                                                surveyData['surveyors'] =
                                                    selectedSurveyors;
                                                surveyData['gns'] = selectedGns;
                                                surveyData['created_by'] =
                                                    username;
                                                surveyData['lead_by'] =
                                                    username;
                                                surveyData['created'] =
                                                    DateTime.now().toString();
                                                surveyData['updated'] =
                                                    DateTime.now().toString();
                                                // surveyRef.put(
                                                //     surveyId, surveyData);
                                                syncSurvey().whenComplete(() {
                                                  final snackBar = SnackBar(
                                                    backgroundColor:
                                                        Colors.greenAccent,
                                                    content: const Text(
                                                        'Survey Created'),
                                                    action: SnackBarAction(
                                                      label: 'OK',
                                                      onPressed: () {},
                                                    ),
                                                  );

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                }).onError((error, stackTrace) => print(error));

                                                // Navigator.pop(context);
                                                // Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        ))
                              },
                          actionLabel: Text(
                            'Create',
                            style: Theme.of(context).textTheme.labelMedium,
                            textAlign: TextAlign.center,
                          ),
                          pageName: "Create Survey"),
                      Expanded(
                          child: Padding(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              LabelRow(
                                label: 'Survey ID',
                                onChange: (out) {},
                                val: surveyId,
                              ),
                              LabelRow(
                                label: 'Lead By',
                                onChange: (out) {},
                                val: username,
                              ),
                              TextRow(
                                  label: 'Survey Name',
                                  val: surveyData['name'],
                                  onChange: (e) {
                                    setState(() {
                                      surveyData['name'] = e;
                                    });
                                  }),
                              TextRow(
                                  label: 'Description',
                                  val: surveyData['description'],
                                  onChange: (e) {
                                    setState(() {
                                      surveyData['description'] = e;
                                    });
                                  }),
                              SpinnerRow(
                                  label: "Contribution",
                                  options: contributionTypes,
                                  onSelect: (option) {
                                    setState(() {
                                      surveyData["contribution"] =
                                          contributionTypes
                                              .where((element) =>
                                                  element["id"] == option["id"])
                                              .toList()[0]['id'];
                                      selectedContribution = option;
                                    });
                                  },
                                  selected: selectedContribution),
                              SpinnerRow(
                                  label: "Survey Category",
                                  options: surveyCategories,
                                  onSelect: (option) {
                                    setState(() {
                                      surveyData["category"] = surveyCategories
                                          .where((element) =>
                                              element["id"] == option["id"])
                                          .toList()[0]['id'];
                                      selectedSurveyCategory = option;
                                    });
                                  },
                                  selected: selectedSurveyCategory),
                              SpinnerRow(
                                  label: "Survey Technique",
                                  options: surveyTechniques,
                                  onSelect: (option) {
                                    setState(() {
                                      surveyData["survey_technique"] =
                                          surveyTechniques
                                              .where((element) =>
                                                  element["id"] == option["id"])
                                              .toList()[0]["id"];
                                      selectedSurveysList = surveysList
                                          .where((survey) =>
                                              survey['id'] == option['id'])
                                          .toList();
                                      selectedSurveyTechnique = option;
                                    });
                                  },
                                  selected: selectedSurveyTechnique),
                              SpinnerRow(
                                  label: "Survey Type",
                                  options: surveyTypes,
                                  onSelect: (option) {
                                    setState(() {
                                      surveyData["type"] = surveyTypes
                                          .where((element) =>
                                              element["id"] == option["id"])
                                          .toList()[0]["id"];
                                      selectedSurveyType = option;
                                    });
                                  },
                                  selected: selectedSurveyType),
                              SpinnerRow(
                                  label: "District",
                                  options: metaRef.get('district'),
                                  onSelect: (option) {
                                    setState(() {
                                      surveyData["district"] = option['id'];
                                      selectedDistrict = option;
                                      selectedRdhsArea = null;
                                      selectedMohArea = null;
                                      selectedPhiArea = null;
                                      selectedGns = [];
                                    });
                                  },
                                  selected: selectedDistrict),
                              SpinnerRow(
                                  label: "RDHS/Admin Area",
                                  options: selectedDistrict != null
                                      ? metaRef
                                          .get('rdhs')
                                          .where((rdhs) =>
                                              rdhs['district'] ==
                                              selectedDistrict['id'])
                                          .toList()
                                      : [],
                                  onSelect: (option) {
                                    setState(() {
                                      surveyData["rdhs"] = option['id'];
                                      selectedRdhsArea = option;
                                      selectedMohArea = null;
                                      selectedPhiArea = null;
                                      selectedGns = [];
                                    });
                                  },
                                  selected: selectedRdhsArea),
                              SpinnerRow(
                                  label: "MOH Area",
                                  options: selectedRdhsArea != null
                                      ? metaRef
                                          .get('moh')
                                          .where((moh) =>
                                              moh['district'] ==
                                                  selectedDistrict['id'] &&
                                              moh['rdhs'] ==
                                                  selectedRdhsArea['id'])
                                          .toList()
                                      : [],
                                  onSelect: (option) {
                                    setState(() {
                                      surveyData["moh"] = option['id'];
                                      selectedMohArea = option;
                                      selectedPhiArea = null;
                                      selectedGns = [];
                                    });
                                  },
                                  selected: selectedMohArea),
                              SpinnerRow(
                                  label: "PHI Area",
                                  options: selectedMohArea != null
                                      ? metaRef
                                          .get('phi')
                                          .where((phi) =>
                                              phi['district'] ==
                                                  selectedDistrict['id'] &&
                                              phi['rdhs'] ==
                                                  selectedRdhsArea['id'] &&
                                              phi['moh'] ==
                                                  selectedMohArea['id'])
                                          .toList()
                                      : [],
                                  onSelect: (option) {
                                    setState(() {
                                      surveyData["phi"] = option['id'];
                                      selectedPhiArea = option;
                                      selectedGns = [];
                                    });
                                  },
                                  selected: selectedPhiArea),
                              SpinnerRow(
                                  label: "GN Divisions",
                                  options: selectedPhiArea != null
                                      ? metaRef
                                          .get('gn')
                                          .where((gn) =>
                                              gn['district'] ==
                                                  selectedDistrict['id'] &&
                                              gn['rdhs'] ==
                                                  selectedRdhsArea['id'] &&
                                              gn['moh'] ==
                                                  selectedMohArea['id'] &&
                                              gn['phi'] ==
                                                  selectedPhiArea['id'])
                                          .toList()
                                      : [],
                                  onSelect: (option) {
                                    setState(() {
                                      if (selectedGns.contains(option)) {
                                        final snackBar = SnackBar(
                                          backgroundColor: Colors.redAccent,
                                          content: const Text(
                                              'GN Division already exist'),
                                          action: SnackBarAction(
                                            label: 'OK',
                                            onPressed: () {},
                                          ),
                                        );

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      } else {
                                        setState(() {
                                          selectedGns = [
                                            ...selectedGns,
                                            option['id']
                                          ];
                                        });
                                      }
                                    });
                                  },
                                  selected: null),
                              Row(
                                children: [
                                  Spacer(),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        2 /
                                        3,
                                    child: Wrap(
                                      spacing: 5.0,
                                      children: List.generate(
                                          selectedGns.length, (index) {
                                        return Chip(
                                          label: Text(metaRef
                                              .get('gn')
                                              .where((element) =>
                                                  element["district"] ==
                                                      selectedDistrict["id"] &&
                                                  element["rdhs"] ==
                                                      selectedRdhsArea["id"] &&
                                                  element["moh"] ==
                                                      selectedMohArea["id"] &&
                                                  element["phi"] ==
                                                      selectedPhiArea["id"] &&
                                                  element["id"] ==
                                                      selectedGns[index])
                                              .toList()[0]['name']),
                                          deleteIcon: Icon(Icons.remove_circle),
                                          onDeleted: () {
                                            setState(() {
                                              selectedGns.removeAt(index);
                                            });
                                          },
                                        );
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                              SpinnerRow(
                                  label: "Surveyors",
                                  options: metaRef.get('users').toList(),
                                  disabled: selectedContribution != null &&
                                      selectedContribution["id"] == "1",
                                  onSelect: (option) {
                                    print(option);
                                    if (selectedSurveyors
                                        .contains(option['username'])) {
                                      final snackBar = SnackBar(
                                        backgroundColor: Colors.redAccent,
                                        content:
                                            const Text('User already exist'),
                                        action: SnackBarAction(
                                          label: 'OK',
                                          onPressed: () {},
                                        ),
                                      );

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    } else {
                                      setState(() {
                                        selectedSurveyors = [
                                          ...selectedSurveyors,
                                          option['username']
                                        ];
                                      });
                                    }
                                  },
                                  selected: null),
                              Row(
                                children: [
                                  Spacer(),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Wrap(
                                      spacing: 5.0,
                                      children: List.generate(
                                          selectedSurveyors.length, (index) {
                                        return Chip(
                                          label: Text(selectedSurveyors[index]),
                                          deleteIcon: Icon(Icons.remove_circle),
                                          onDeleted: selectedSurveyors[index] ==
                                                  username
                                              ? null
                                              : () {
                                                  setState(() {
                                                    selectedSurveyors
                                                        .removeAt(index);
                                                  });
                                                },
                                        );
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      )),
                    ]),
              )),
        ));
  }
}
