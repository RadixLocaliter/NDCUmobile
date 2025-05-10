import 'package:dengue/components/header.dart';
import 'package:dengue/components/miniMap.dart';
import 'package:dengue/constants/dbHelper.dart';
import 'package:dengue/constants/dropdowns.dart';
import 'package:dengue/forms/pupalPlaces.dart';
import 'package:dengue/models/survey_premise_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dengue/components/textRow.dart';
import 'package:dengue/components/spinnerRow.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sqflite/sql.dart';

class PupalPremises extends StatefulWidget {
  final int survey_id;
  final dynamic gn;
  final String locality;
  const PupalPremises({
    Key? key,
    required this.survey_id,
    required this.gn,
    required this.locality,
  }) : super(key: key);

  @override
  State<PupalPremises> createState() => _PupalPremisesState();
}

class _PupalPremisesState extends State<PupalPremises> {
  int selectedSection = 0;

  String address = "";
  dynamic premiseType = null;
  String other_premise_type = "";
  dynamic location = null;
  dynamic selectedPremise = null;

  TextEditingController searchController = new TextEditingController();

  List<dynamic> premises = [];

  Future<void> loadPremises() async {
    final db = await DBHelper.db();
    print(widget.locality);
    List<SurveyPremiseModel> premiseList = [];
    (await db.query('ndcu_survey_premises',
            where: 'survey_id = ? AND locality = ?',
            whereArgs: [widget.survey_id,widget.locality]))
        .forEach((lo) => premiseList.add(SurveyPremiseModel.fromJson(lo)));
    print(premiseList.toString());
    setState(() {
      premises = premiseList;
    });
  }

  @override
  void initState() {
    loadPremises();
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
                  Header(pageName: "Premises"),
                  Expanded(
                    child: Column(children: [
                      Container(
                        color: Colors.white54,
                        padding: EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Column(
                          children: [
                            TextRow(
                                label: 'GN Division',
                                val: widget.gn,
                                bordered: true,
                                enabled: false,
                                onChange: (e) {
                                  setState(() {});
                                }),
                            TextRow(
                                label: 'Locality',
                                val: widget.locality,
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
                                Text('Premises'),
                                Spacer(),
                                IconButton(
                                  onPressed: () {
                                    showCupertinoDialog<void>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          CupertinoAlertDialog(
                                        title: selectedPremise == null
                                            ? const Text('Add new Premise')
                                            : const Text('Update Premise'),
                                        content: selectedPremise == null
                                            ? const Text(
                                                'Do you want to add a new premise?')
                                            : const Text(
                                                'Do you want to update premise?'),
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
                                              if (selectedPremise == null) {
                                                var database =
                                                    await DBHelper.db();
                                                SurveyPremiseModel premise =
                                                    new SurveyPremiseModel(
                                                        widget.survey_id,
                                                        widget.locality,
                                                        address,
                                                        premiseType['id'],
                                                        location['lat'],
                                                        location['lng'],
                                                        new DateTime.now()
                                                            .toString(),
                                                        new DateTime.now()
                                                            .toString());
                                                await database.insert(
                                                  'ndcu_survey_premises',
                                                  premise.toMap(),
                                                  conflictAlgorithm:
                                                      ConflictAlgorithm.abort,
                                                );
                                                setState(() {
                                                  location = null;
                                                });
                                                loadPremises();
                                              }
                                              Navigator.pop(context);
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    selectedPremise == null
                                        ? Icons.add
                                        : Icons.save_outlined,
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
                          left: 25.0,
                          right: 25.0,
                        ),
                        child: Column(children: [
                          TextRow(
                              label: 'Address',
                              val: address,
                              onChange: (e) {
                                setState(() {
                                  address = e;
                                });
                              }),
                          SpinnerRow(
                              label: 'Premise Type',
                              options: larvalPremises,
                              bordered: false,
                              onSelect: (option) {
                                setState(() {
                                  premiseType = option;
                                });
                              },
                              selected: premiseType),
                          premiseType != null && premiseType['id'] == "Ot"
                              ? TextRow(
                                  label: "Other",
                                  val: other_premise_type,
                                  onChange: (e) {
                                    setState(() {
                                      other_premise_type = e;
                                    });
                                  })
                              : Container(),
                          Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        color: Colors.black38, width: 0.0))),
                            child: SizedBox(
                              height:
                                  (MediaQuery.of(context).size.height * 0.07),
                              child: Row(
                                children: [
                                  Container(
                                    width: 2 *
                                        MediaQuery.of(context).size.width /
                                        5,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Location",
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: location == null
                                        ? ElevatedButton(
                                            child: Text("Locate"),
                                            onPressed: () {
                                              showCupertinoDialog<void>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        CupertinoAlertDialog(
                                                  content: Container(
                                                    child: MiniMap(
                                                      onLocationChange: (loc) {
                                                        setState(() {
                                                          location = loc;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  actions: <
                                                      CupertinoDialogAction>[
                                                    CupertinoDialogAction(
                                                      child:
                                                          const Text('Dismiss'),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    CupertinoDialogAction(
                                                      child:
                                                          const Text('Confirm'),
                                                      onPressed: () {
                                                        setState(() {});
                                                        final snackBar =
                                                            SnackBar(
                                                          backgroundColor:
                                                              Colors
                                                                  .greenAccent,
                                                          content: const Text(
                                                              'Location confirmed'),
                                                          action:
                                                              SnackBarAction(
                                                            label: 'OK',
                                                            onPressed: () {},
                                                          ),
                                                        );

                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                snackBar);
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          )
                                        : Text(
                                            "${location['lat']} , ${location['lng']}",
                                            textAlign: TextAlign.end,
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ]),
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
                                premises.length,
                                (index) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (selectedPremise != null) {
                                        selectedPremise = null;
                                      } else {
                                        selectedPremise = premises[index];
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
                                              '${premises[index].address}',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                PageTransition(
                                                  type: PageTransitionType
                                                      .rightToLeft,
                                                  duration: Duration(
                                                      milliseconds: 300),
                                                  reverseDuration: Duration(
                                                      milliseconds: 300),
                                                  child: PupalPlaces(
                                                    address: premises[index].address,
                                                    survey_id: widget.survey_id,
                                                  ),
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
