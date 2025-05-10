import 'package:dengue/components/header.dart';
import 'package:dengue/constants/dbHelper.dart';
import 'package:dengue/constants/dropdowns.dart';
import 'package:dengue/models/larval_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:dengue/components/textRow.dart';
import 'package:dengue/components/spinnerRow.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sqflite/sql.dart';
import 'dart:developer';

class LarvalPlaces extends StatefulWidget {
  final int survey_id;
  final String address;
  const LarvalPlaces({
    Key? key,
    required this.address,
    required this.survey_id,
  }) : super(key: key);

  @override
  State<LarvalPlaces> createState() => _LarvalPlacesState();
}

enum Containers { Wet, Dry }

enum Environment { Indoor, Outdoor }

enum Response { Yes, No, Pending }

enum Identified { A, B, C, Other }

class _LarvalPlacesState extends State<LarvalPlaces> {
  int selectedSection = 0;

  Box<dynamic> surveyRef = Hive.box('surveys');
  Box<dynamic> metaRef = Hive.box('meta');

  String locality = "";
  String address = "";

  dynamic breedingType = null;
  TextEditingController placeNote = TextEditingController();
  TextEditingController samples = TextEditingController();
  TextEditingController heavy = TextEditingController();

  Containers selectedContainer = Containers.Wet;
  Environment selectedEnv = Environment.Indoor;
  Response observation = Response.No;
  Response isIdentified = Response.No;
  Response isHeavy = Response.No;
  Identified identification = Identified.Other;
  dynamic breedingPlace = null;
  String? otherIdentification;

  dynamic selectedPlace = null;

  TextEditingController searchController = new TextEditingController();

  List<dynamic> places = [];

  Future<void> loadPlaces() async {
    final db = await DBHelper.db();
    List<LarvalModel> larvalList = [];
    (await db.query('ndcu_larval_surveys',
            orderBy: 'identified DESC',
            where: 'survey_id = ? AND address = ?',
            whereArgs: [widget.survey_id, widget.address]))
        .forEach((lo) => larvalList.add(LarvalModel.fromJson(lo)));
    List<dynamic> placeDynamic = [];
    larvalList.forEach((lv) {
      dynamic item = lv.toMap();
      item['type'] = (lv.type == 0 ? Containers.Wet : Containers.Dry);
      item['environment'] =
          (lv.environment == 0 ? Environment.Indoor : Environment.Outdoor);
      item['observation'] = (lv.observation == 0 ? Response.No : Response.Yes);
      item['breeding'] = (lv.breeding == 0 ? Response.No : Response.Yes);
      print("IDENTIFICATION");
      print(lv.identified);
      item['identified'] = (lv.identified == 2
          ? Response.Yes
          : (lv.identified == 1 ? Response.No : Response.Pending));
      item['identified_type'] = (lv.identified_type == 0
          ? Identified.A
          : (lv.identified_type == 1
              ? Identified.B
              : (lv.identified_type == 2 ? Identified.C : Identified.Other)));
      placeDynamic.add(item);
    });
    setState(() {
      places = placeDynamic;
    });
  }

  Future<void> saveLarvalContainer() async {
    var database = await DBHelper.db();
    var identified_type = null;
    if (isIdentified == Response.Yes) {
      switch (identification) {
        case Identified.A:
          identified_type = 0;
          break;
        case Identified.B:
          identified_type = 1;
          break;
        case Identified.C:
          identified_type = 2;
          break;
        case Identified.Other:
          identified_type = 3;
          break;
        default:
          break;
      }
    }
    LarvalModel larval = new LarvalModel(
        survey_id: widget.survey_id,
        address: widget.address,
        container_id: selectedPlace == null ? places.length + 1 : selectedPlace['container_id'],
        breeding_type: breedingType['id'],
        type: selectedContainer == Containers.Wet ? 0 : 1,
        environment: selectedEnv == Environment.Indoor ? 0 : 1,
        observation: observation == Response.No ? 0 : 1,
        samples: samples.text == "" ? null : samples.text,
        breeding: observation == Response.Yes
            ? (isHeavy == Response.No ? 0 : 1)
            : null,
        identified: observation == Response.Yes
            ? (isIdentified == Response.Pending
                ? 0
                : (isIdentified == Response.No ? 1 : 2))
            : null,
        identified_type: identified_type,
        identified_other: identified_type == 3 ? otherIdentification : null,
        note: placeNote.text == "" ? null : placeNote.text,
        created: selectedPlace == null ? new DateTime.now().toString() : selectedPlace['created'],
        updated: new DateTime.now().toString());
    await database.insert(
      'ndcu_larval_surveys',
      larval.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
    resetFields();
  }

  Future<void> selectLarvalContainer(item) async {
    print(item);
    if (item != null &&
        selectedPlace != null &&
        item['container_id'] == selectedPlace['container_id']) {
      selectedPlace = null;
      resetFields();
    } else {
      setState(() {
        selectedPlace = item;
        breedingType = item['breeding_type'] != 0
            ? ((larvalBreedings.where((obj) =>
                    obj['id'].toString() == item['breeding_type'].toString()))
                .toList())[0]
            : null;
        selectedContainer = item['type'];
        selectedEnv = item['environment'];
        observation = item['observation'];
        samples.text = item['samples'] ?? "";
        isHeavy = item['breeding'];
        isIdentified = item['identified'];
        identification = item['identified_type'];
        otherIdentification = item['identified_other'];
        placeNote.text = item['note'] ?? "";
      });
    }
  }

  Future<void> resetFields() async {
    setState(() {
      breedingType = null;
      selectedContainer = Containers.Wet;
      selectedEnv = Environment.Indoor;
      observation = Response.No;
      samples.text = "";
      isHeavy = Response.No;
      isIdentified = Response.No;
      identification = Identified.Other;
      otherIdentification = "";
      placeNote.text = "";
    });
  }

  @override
  void initState() {
    loadPlaces();
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
                  Header(pageName: widget.address),
                  Expanded(
                    flex: 1,
                    child: Column(children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            child: Column(children: [
                              Container(
                                color: Colors.white54,
                                padding: EdgeInsets.only(
                                    left: 25.0,
                                    right: 25.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                child: Column(children: [
                                  SpinnerRow(
                                      label: 'Breeding Type',
                                      options: larvalBreedings,
                                      onSelect: (option) {
                                        setState(() {
                                          breedingType = option;
                                        });
                                      },
                                      selected: breedingType),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0,
                                        right: 25.0,
                                        top: 0,
                                        bottom: 0),
                                    child: SizedBox(
                                      height:
                                          (MediaQuery.of(context).size.height *
                                              0.02),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.black38,
                                                width: 0.0))),
                                    child: SizedBox(
                                      height:
                                          (MediaQuery.of(context).size.height *
                                              0.07),
                                      child: Row(
                                        children: [
                                          Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Type",
                                                style: TextStyle(
                                                    fontSize: 15.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                          Spacer(),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Container(
                                              width: (MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6),
                                              child: CupertinoSegmentedControl(
                                                children: const <Containers,
                                                    Widget>{
                                                  Containers.Wet: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20),
                                                    child: Text('Wet'),
                                                  ),
                                                  Containers.Dry: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20),
                                                    child: Text('Dry'),
                                                  ),
                                                },
                                                groupValue: selectedContainer,
                                                onValueChanged:
                                                    (Containers container) {
                                                  setState(() {
                                                    selectedContainer =
                                                        container;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.black38,
                                                width: 0.0))),
                                    child: SizedBox(
                                      height:
                                          (MediaQuery.of(context).size.height *
                                              0.07),
                                      child: Row(
                                        children: [
                                          Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Environment",
                                                style: TextStyle(
                                                    fontSize: 15.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                          Spacer(),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Container(
                                              width: (MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6),
                                              child: CupertinoSegmentedControl(
                                                children: const <Environment,
                                                    Widget>{
                                                  Environment.Indoor: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20),
                                                    child: Text('Indoor'),
                                                  ),
                                                  Environment.Outdoor: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20),
                                                    child: Text('Outdoor'),
                                                  ),
                                                },
                                                groupValue: selectedEnv,
                                                onValueChanged:
                                                    (Environment environment) {
                                                  setState(() {
                                                    selectedEnv = environment;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: observation == Response.Yes
                                        ? null
                                        : BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.black38,
                                                    width: 0.0)),
                                          ),
                                    child: SizedBox(
                                      height:
                                          (MediaQuery.of(context).size.height *
                                              0.07),
                                      child: Row(
                                        children: [
                                          Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Observation",
                                                style: TextStyle(
                                                    fontSize: 15.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                          Spacer(),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Container(
                                              width: (MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6),
                                              child: CupertinoSegmentedControl(
                                                children: const <Response,
                                                    Widget>{
                                                  Response.No: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20),
                                                    child: Text('Negative'),
                                                  ),
                                                  Response.Yes: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20),
                                                    child: Text('Positive'),
                                                  ),
                                                },
                                                groupValue: observation,
                                                onValueChanged:
                                                    (Response result) {
                                                  setState(() {
                                                    observation = result;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  observation == Response.Yes
                                      ? TextRow(
                                          controller: samples,
                                          label: "Samples",
                                          onChange: (val) {})
                                      : Container(),
                                  observation == Response.Yes
                                      ? Container(
                                          decoration: isIdentified ==
                                                  Response.Yes
                                              ? null
                                              : BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: Colors.black38,
                                                          width: 0.0)),
                                                ),
                                          child: SizedBox(
                                            height: (MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.07),
                                            child: Row(
                                              children: [
                                                Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "Breeding",
                                                      style: TextStyle(
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                Spacer(),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Container(
                                                    width:
                                                        (MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.6),
                                                    child:
                                                        CupertinoSegmentedControl(
                                                      children: const <Response,
                                                          Widget>{
                                                        Response.No: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      20),
                                                          child: Text('Normal'),
                                                        ),
                                                        Response.Yes: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      20),
                                                          child: Text('Heavy'),
                                                        ),
                                                      },
                                                      groupValue: isHeavy,
                                                      onValueChanged:
                                                          (Response heavy) {
                                                        setState(() {
                                                          isHeavy = heavy;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  observation == Response.Yes
                                      ? Container(
                                          decoration: isIdentified ==
                                                  Response.Yes
                                              ? null
                                              : BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: Colors.black38,
                                                          width: 0.0)),
                                                ),
                                          child: SizedBox(
                                            height: (MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.07),
                                            child: Row(
                                              children: [
                                                Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "Identified",
                                                      style: TextStyle(
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                Spacer(),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Container(
                                                    width:
                                                        (MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.6),
                                                    child:
                                                        CupertinoSegmentedControl(
                                                      children: const <Response,
                                                          Widget>{
                                                        Response.Pending:
                                                            Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      20),
                                                          child: Icon(Icons
                                                              .watch_later_outlined),
                                                        ),
                                                        Response.No: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      20),
                                                          child: Text('No'),
                                                        ),
                                                        Response.Yes: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      20),
                                                          child: Text('Yes'),
                                                        ),
                                                      },
                                                      groupValue: isIdentified,
                                                      onValueChanged: (Response
                                                          identified) {
                                                        setState(() {
                                                          isIdentified =
                                                              identified;
                                                          if (identified ==
                                                              Response.No) {
                                                            identification =
                                                                Identified
                                                                    .Other;
                                                          }
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  isIdentified == Response.Yes &&
                                          observation == Response.Yes
                                      ? Container(
                                          decoration: identification ==
                                                  Identified.Other
                                              ? null
                                              : BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: Colors.black38,
                                                          width: 0.0))),
                                          child: SizedBox(
                                            height: (MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.07),
                                            child: CupertinoSegmentedControl(
                                              padding: EdgeInsets.only(
                                                  left: 0, right: 0),
                                              children: const <Identified,
                                                  Widget>{
                                                Identified.A: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20),
                                                  child: Text('A'),
                                                ),
                                                Identified.B: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20),
                                                  child: Text('B'),
                                                ),
                                                Identified.C: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20),
                                                  child: Text('C'),
                                                ),
                                                Identified.Other: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20),
                                                  child: Text('Other'),
                                                ),
                                              },
                                              groupValue: identification,
                                              onValueChanged:
                                                  (Identified identified) {
                                                setState(() {
                                                  identification = identified;
                                                });
                                              },
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  isIdentified == Response.Yes &&
                                          identification == Identified.Other
                                      ? TextRow(
                                          label: "Other",
                                          onChange: (val) {
                                            setState(() {
                                              otherIdentification = val;
                                            });
                                          })
                                      : Container(),
                                  TextRow(
                                      label: "Notes",
                                      controller: placeNote,
                                      onChange: (val) {}),
                                  TextButton(
                                    onPressed: () async {
                                      saveLarvalContainer();
                                      setState(() {});
                                      loadPlaces();
                                    },
                                    child: Text(
                                      "Save",
                                      style: TextStyle(color: Colors.redAccent),
                                    ),
                                  ),
                                ]),
                              ),
                            ]),
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Column(
                            children: [
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
                                    padding: EdgeInsets.fromLTRB(
                                        10.0, 5.0, 10.0, 5.0),
                                    child: Column(
                                      children: List.generate(
                                        places.length,
                                        (index) => GestureDetector(
                                          onTap: () {
                                            selectLarvalContainer(
                                                places[index]);
                                          },
                                          child: Container(
                                            margin:
                                                EdgeInsets.only(bottom: 10.0),
                                            decoration: BoxDecoration(
                                              color: places[index]
                                                          ['identified'] ==
                                                      Response.Yes
                                                  ? Color.fromARGB(
                                                      255, 245, 197, 197)
                                                  : (places[index]['identified'] == Response.No ? Colors.white70 : Color.fromARGB(255, 198, 245, 200)),
                                              border: Border.all(
                                                  color: Colors.black26),
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
                                                      '${places[index]['breeding_type']} ${places[index]['container_id']} - ${places[index]['note'] ?? ""}',
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
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
                            ],
                          )),
                    ]),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
