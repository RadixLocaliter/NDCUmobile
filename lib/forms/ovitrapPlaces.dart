import 'package:dengue/components/header.dart';
import 'package:dengue/constants/dbHelper.dart';
import 'package:dengue/models/larval_model.dart';
import 'package:dengue/models/ovitrap_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dengue/components/textRow.dart';
import 'package:sqflite/sql.dart';

class OvitrapPlaces extends StatefulWidget {
  final int survey_id;
  final String address;
  const OvitrapPlaces({
    Key? key,
    required this.address,
    required this.survey_id,
  }) : super(key: key);

  @override
  State<OvitrapPlaces> createState() => _OvitrapPlacesState();
}

enum Response { Yes, No }

class _OvitrapPlacesState extends State<OvitrapPlaces> {
  TextEditingController placeNote = TextEditingController();
  TextEditingController fecundity = TextEditingController();

  Response environment = Response.No;
  Response identification = Response.No;

  dynamic selectedPlace = null;

  TextEditingController searchController = new TextEditingController();

  List<dynamic> places = [];
  bool collection_day = false;

  Future<void> loadPlaces() async {
    final db = await DBHelper.db();
    List<OvitrapModel> ovitrapList = [];
    (await db.query('ndcu_ovitrap_surveys',
            where: 'survey_id = ? AND address = ?',
            whereArgs: [widget.survey_id, widget.address]))
        .forEach((lo) => ovitrapList.add(OvitrapModel.fromJson(lo)));
    print(ovitrapList);
    List<dynamic> placeDynamic = [];
    ovitrapList.forEach((lv) {
      dynamic item = lv.toMap();
      placeDynamic.add(item);
    });
    setState(() {
      places = placeDynamic;
    });
  }

  Future<void> saveOvitrapContainer() async {
    var database = await DBHelper.db();
    OvitrapModel ovitrap = new OvitrapModel(
        survey_id: widget.survey_id,
        address: widget.address,
        container_id: selectedPlace == null
            ? places.length + 1
            : selectedPlace['container_id'],
        environment: environment == Response.Yes ? 1 : 0,
        collected: collection_day ? 1 : 0,
        identification:
            collection_day ? (identification == Response.Yes ? 1 : 0) : null,
        fecundity: collection_day ? (int.tryParse(fecundity.text) ?? 0) : null,
        note: placeNote.text,
        created: selectedPlace == null
            ? new DateTime.now().toString()
            : selectedPlace['created'],
        updated: new DateTime.now().toString());
    await database.insert(
      'ndcu_ovitrap_surveys',
      ovitrap.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> resetFields() async {
    setState(() {
      environment = Response.No;
      placeNote.text = "";
      collection_day = false;
      identification = Response.No;
      fecundity.text = "";
    });
  }

  Future<void> selectContainer(item) async {
    if (item != null &&
        selectedPlace != null &&
        item['container_id'] == selectedPlace['container_id']) {
      selectedPlace = null;
      resetFields();
    } else {
      setState(() {
        selectedPlace = item;
        environment = (item['environment'] == 1) ? Response.Yes : Response.No;
        placeNote.text = item['note'] ?? "";
        collection_day = item['collected'] == 1 ? true : false;
        identification =
            (item['identification'] == 1) ? Response.Yes : Response.No;
        fecundity.text = (item['fecundity']).toString();
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
                                  TextRow(
                                      label: "Notes",
                                      controller: placeNote,
                                      onChange: (val) {}),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0,
                                        right: 25.0,
                                        top: 0,
                                        bottom: 0),
                                    child: SizedBox(
                                      height:
                                          (MediaQuery.of(context).size.height *
                                              0.07),
                                      child: Align(
                                        child: Row(
                                          children: [
                                            Text('Collection Day'),
                                            Spacer(),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  collection_day =
                                                      !collection_day;
                                                });
                                              },
                                              icon: Icon(
                                                !collection_day
                                                    ? Icons.check_circle_outline
                                                    : Icons.check_circle,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        alignment: Alignment.centerLeft,
                                      ),
                                    ),
                                  ),
                                  collection_day
                                      ? Container(
                                          decoration: environment ==
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
                                                      "Identification",
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
                                                          child:
                                                              Text('Negative'),
                                                        ),
                                                        Response.Yes: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      20),
                                                          child:
                                                              Text('Positive'),
                                                        ),
                                                      },
                                                      groupValue:
                                                          identification,
                                                      onValueChanged:
                                                          (Response result) {
                                                        setState(() {
                                                          identification =
                                                              result;
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
                                  Opacity(
                                    opacity: collection_day ? 1 : 0,
                                    child: TextRow(
                                        label: "Fecundity",
                                        controller: fecundity,
                                        onChange: (val) {}),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      saveOvitrapContainer();
                                      setState(() {});
                                      loadPlaces();
                                    },
                                    child: Text(
                                      selectedPlace == null
                                          ? "Create"
                                          : "Update",
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
                                                    '${places[index]['container_id']} - ${places[index]['note'] ?? ""}',
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Spacer(),
                                                selectedPlace != null &&
                                                        places[index][
                                                                'container_id'] ==
                                                            selectedPlace[
                                                                'container_id']
                                                    ? Icon(
                                                        Icons.adjust,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      )
                                                    : Container()
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
