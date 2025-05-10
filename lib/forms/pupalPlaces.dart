import 'package:dengue/components/header.dart';
import 'package:dengue/components/numberRow.dart';
import 'package:dengue/constants/dbHelper.dart';
import 'package:dengue/constants/dropdowns.dart';
import 'package:dengue/models/larval_model.dart';
import 'package:dengue/models/pupal_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:dengue/components/textRow.dart';
import 'package:dengue/components/spinnerRow.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sqflite/sql.dart';

class PupalPlaces extends StatefulWidget {
  final int survey_id;
  final String address;
  const PupalPlaces({
    Key? key,
    required this.address,
    required this.survey_id,
  }) : super(key: key);

  @override
  State<PupalPlaces> createState() => _PupalPlacesState();
}

enum Response { Yes, No, Pending }

enum Identified { A, B, C, Other }

class _PupalPlacesState extends State<PupalPlaces> {
  int selectedSection = 0;

  Box<dynamic> surveyRef = Hive.box('surveys');
  Box<dynamic> metaRef = Hive.box('meta');

  String locality = "";
  String address = "";

  dynamic breedingType = null;
  TextEditingController placeNote = TextEditingController();
  TextEditingController samples = TextEditingController();
  TextEditingController heavy = TextEditingController();

  Identified identification = Identified.Other;

  Response observation = Response.No;
  Response environment = Response.No;
  Response isIdentified = Response.No;

  String? otherIdentification;

  dynamic selectedPlace = null;

  TextEditingController searchController = new TextEditingController();

  List<dynamic> places = [];

  Future<void> loadPlaces() async {
    final db = await DBHelper.db();
    List<PupalModel> pupalList = [];
    (await db.query('ndcu_pupal_surveys',
            where: 'survey_id = ? AND address = ?',
            whereArgs: [widget.survey_id, widget.address]))
        .forEach((lo) => pupalList.add(PupalModel.fromJson(lo)));
    print(pupalList);
    List<dynamic> placeDynamic = [];
    pupalList.forEach((lv) {
      dynamic item = lv.toMap();
      placeDynamic.add(item);
    });
    setState(() {
      places = placeDynamic;
    });
  }

  Future<void> savePupalContainer() async {
    var database = await DBHelper.db();
    var identified_type = null;
    if (observation == Response.Yes && isIdentified == Response.Yes) {
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
    PupalModel adult = new PupalModel(
        survey_id: widget.survey_id,
        address: widget.address,
        container_id: places.length + 1,
        breeding_type: breedingType != null ? breedingType['id'] : 0,
        environment: environment == Response.Yes ? 1 : 0,
        observation: observation == Response.Yes ? 1 : 0,
        samples: samples.text,
        identified: observation == Response.Yes
            ? (isIdentified == Response.Yes ? 1 : 0)
            : null,
        identified_type: identified_type,
        identified_other: identified_type == 4 ? otherIdentification : null,
        note: placeNote.text,
        created: new DateTime.now().toString(),
        updated: new DateTime.now().toString());
    await database.insert(
      'ndcu_pupal_surveys',
      adult.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    resetFields();
  }

  Future<void> resetFields() async {
    setState(() {
      environment = Response.No;
      observation = Response.No;
      placeNote.text = "";
      breedingType = null;
      samples.text = "";
      isIdentified = Response.No;
      identification = Identified.Other;
      otherIdentification = null;
    });
  }

  Future<void> selectContainer(item) async {
    print(item);
    if (item != null &&
        selectedPlace != null &&
        item['container_id'] == selectedPlace['container_id']) {
      selectedPlace = null;
      resetFields();
    } else {
      Identified idt = Identified.Other;
      switch (item['identified_type']) {
        case 0:
          idt = Identified.A;
          break;
        case 1:
          idt = Identified.B;
          break;
        case 2:
          idt = Identified.C;
          break;
        case 3:
          idt = Identified.Other;
          break;
        default:
          break;
      }

      setState(() {
        selectedPlace = item;
        environment = (item['environment'] == 1) ? Response.Yes : Response.No;
        observation = (item['observation'] == 1) ? Response.Yes : Response.No;
        placeNote.text = item['note'];
        breedingType = item['breeding_type'] != 0
            ? ((larvalBreedings.where(
                (obj) => obj['id'].toString() == item['breeding_type'].toString())).toList())[0]
            : null;
        samples.text = item['samples'];
        isIdentified = (item['identified'] == 1) ? Response.Yes : Response.No;
        identification = idt;
        otherIdentification = item['identified_other'];
      });
    }
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
                                  Container(
                                    decoration: environment == Response.Yes
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
                                                children: const <Response,
                                                    Widget>{
                                                  Response.No: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20),
                                                    child: Text('Indoor'),
                                                  ),
                                                  Response.Yes: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20),
                                                    child: Text('Outdoor'),
                                                  ),
                                                },
                                                groupValue: environment,
                                                onValueChanged:
                                                    (Response result) {
                                                  setState(() {
                                                    environment = result;
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
                                      savePupalContainer();
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
                              SingleChildScrollView(
                                child: Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                                  child: Column(
                                    children: List.generate(
                                      places.length,
                                      (index) => GestureDetector(
                                        onTap: () {
                                          selectContainer(places[index]);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: 10.0),
                                          decoration: BoxDecoration(
                                            color: Colors.white70,
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
                                                        color: Theme.of(context)
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
