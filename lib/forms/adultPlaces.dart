import 'package:dengue/components/header.dart';
import 'package:dengue/components/numberRow.dart';
import 'package:dengue/constants/dbHelper.dart';
import 'package:dengue/constants/dropdowns.dart';
import 'package:dengue/models/adult_model.dart';
import 'package:dengue/models/larval_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:dengue/components/textRow.dart';
import 'package:dengue/components/spinnerRow.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sqflite/sql.dart';

class AdultPlaces extends StatefulWidget {
  final int survey_id;
  final String address;
  const AdultPlaces({
    Key? key,
    required this.address,
    required this.survey_id,
  }) : super(key: key);

  @override
  State<AdultPlaces> createState() => _AdultPlacesState();
}

enum Response { Yes, No }

class _AdultPlacesState extends State<AdultPlaces> {
  int selectedSection = 0;

  Box<dynamic> surveyRef = Hive.box('surveys');
  Box<dynamic> metaRef = Hive.box('meta');

  String locality = "";
  String address = "";

  dynamic breedingType = null;
  TextEditingController aeFemale = TextEditingController();
  TextEditingController alboFemale = TextEditingController();
  TextEditingController nonFed = TextEditingController();
  TextEditingController bloodFed = TextEditingController();
  TextEditingController semiGravid = TextEditingController();
  TextEditingController gravid = TextEditingController();
  TextEditingController aeMale = TextEditingController();
  TextEditingController alboMale = TextEditingController();
  TextEditingController note = TextEditingController();
  TextEditingController other_area = TextEditingController();
  TextEditingController other_place = TextEditingController();
  TextEditingController other_wall_type = TextEditingController();

  Response environment = Response.No;

  dynamic restingArea = null;
  dynamic restingPlace = null;
  dynamic restingHeight = null;
  dynamic abdomenCondition = null;
  dynamic wallType = null;
  String? otherIdentification;

  dynamic selectedPlace = null;

  TextEditingController searchController = new TextEditingController();

  List<dynamic> places = [];

  Future<void> loadPlaces() async {
    final db = await DBHelper.db();
    List<AdultModel> adultList = [];
    (await db.query('ndcu_adult_surveys',
            where: 'survey_id = ? AND address = ?',
            whereArgs: [widget.survey_id, widget.address]))
        .forEach((lo) => adultList.add(AdultModel.fromJson(lo)));
    print(adultList);
    List<dynamic> placeDynamic = [];
    adultList.forEach((lv) {
      dynamic item = lv.toMap();
      placeDynamic.add(item);
    });
    setState(() {
      places = placeDynamic;
    });
  }

  Future<void> saveAdultContainer() async {
    var database = await DBHelper.db();
    AdultModel adult = new AdultModel(
        survey_id: widget.survey_id,
        address: widget.address,
        container_id: places.length + 1,
        environment: environment == Response.Yes ? 1 : 0,
        resting_area: restingArea != null ? int.parse(restingArea['id']) : 0,
        other_area: restingArea != null && restingArea['id'] == "6"
            ? other_area.text
            : null,
        resting_place: restingPlace != null ? int.parse(restingPlace['id']) : 0,
        other_place: restingPlace != null && restingPlace['id'] == "6"
            ? other_place.text
            : null,
        wall_type: restingPlace != null && restingPlace['id'] == "1"
            ? int.tryParse(wallType['id'])
            : null,
        wall_other: restingPlace != null &&
                restingPlace['id'] == "1" &&
                wallType['id'] == "1"
            ? other_wall_type.text
            : null,
        resting_height:
            restingHeight != null ? int.parse(restingHeight['id']) : 0,
        ae_female: int.tryParse(aeFemale.text) ?? 0,
        albo_female: int.tryParse(alboFemale.text) ?? 0,
        ae_male: int.tryParse(aeMale.text) ?? 0,
        albo_male: int.tryParse(alboMale.text) ?? 0,
        non_fed: int.tryParse(nonFed.text) ?? 0,
        blood_fed: int.tryParse(bloodFed.text) ?? 0,
        semi_gravid: int.tryParse(semiGravid.text) ?? 0,
        gravid: int.tryParse(gravid.text) ?? 0,
        note: note.text,
        created: new DateTime.now().toString(),
        updated: new DateTime.now().toString());
    await database.insert(
      'ndcu_adult_surveys',
      adult.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    resetFields();
  }

  Future<void> resetFields() async {
    setState(() {
      environment = Response.No;
      restingArea = null;
      other_area.text = "";
      restingPlace = null;
      other_place.text = "";
      wallType = null;
      other_wall_type.text = "";
      restingHeight = null;
      aeFemale.text = "";
      alboFemale.text = "";
      nonFed.text = "";
      bloodFed.text = "";
      semiGravid.text = "";
      gravid.text = "";
      aeMale.text = "";
      alboMale.text = "";
      note.text = "";
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
      setState(() {
        environment = (item['environment'] == 1) ? Response.Yes : Response.No;
        restingArea = item['resting_area'] != 0
            ? (((item['environment'] == 1 ? adultRestingAreaOutdoor : adultRestingAreaIndoor).where((obj) =>
                    obj['id'].toString() == item['resting_area'].toString()))
                .toList())[0]
            : null;
        other_area.text = item['other_area'] ?? "";
        restingPlace = item['resting_place'] != 0
            ? ((adultRestingPlace.where((obj) =>
                    obj['id'].toString() == item['resting_place'].toString()))
                .toList())[0]
            : null;
        other_place.text = item['other_place'] ?? "";
        wallType = item['wall_type'] != null && item['wall_type'] != 0
            ? ((adultRestingPlace.where((obj) =>
                    obj['id'].toString() == item['resting_place'].toString()))
                .toList())[0]
            : null;
        other_wall_type.text = item['wall_other'] ?? "";
        restingHeight = item['resting_height'] != 0
            ? ((adultRestingHeight.where((obj) =>
                    obj['id'].toString() == item['resting_height'].toString()))
                .toList())[0]
            : null;
        aeFemale.text = item['ae_female'].toString();
        alboFemale.text = item['albo_female'].toString();
        aeMale.text = item['ae_male'].toString();
        alboMale.text = item['albo_male'].toString();
        nonFed.text = item['non_fed'].toString();
        bloodFed.text = item['blood_fed'].toString();
        semiGravid.text = item['semi_gravid'].toString();
        gravid.text = item['gravid'].toString();
        note.text = item['note'];
      });
    }
  }

  String getName(obj) {
    var area = "";
    if(obj['environment'] == 1) {
      area = (adultRestingAreaOutdoor.where((item) => item['id'].toString() == obj['resting_area'].toString()).toList())[0]['name'].toString();
    } else {
      area = (adultRestingAreaIndoor.where((item) => item['id'].toString() == obj['resting_area'].toString()).toList())[0]['name'].toString();
    }
    return '${obj['container_id']}. ${area} - ${obj['note'] ?? ""}';
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
                                  SpinnerRow(
                                      label: 'Resting Area',
                                      options: environment == Response.Yes ? adultRestingAreaOutdoor : adultRestingAreaIndoor,
                                      onSelect: (option) {
                                        setState(() {
                                          restingArea = option;
                                        });
                                      },
                                      selected: restingArea),
                                  restingArea != null &&
                                          restingArea['id'] == "6"
                                      ? TextRow(
                                          label: "Area",
                                          controller: other_area,
                                          onChange: (val) {})
                                      : Container(),
                                  SpinnerRow(
                                      label: 'Resting Place',
                                      options: adultRestingPlace,
                                      onSelect: (option) {
                                        setState(() {
                                          restingPlace = option;
                                        });
                                      },
                                      selected: restingPlace),
                                  restingPlace != null &&
                                          restingPlace['id'] == "6"
                                      ? TextRow(
                                          label: "Place",
                                          controller: other_place,
                                          onChange: (val) {})
                                      : Container(),
                                  restingPlace != null &&
                                          restingPlace['id'] == "1"
                                      ? SpinnerRow(
                                          label: 'Wall Type',
                                          options: adultWallTypes,
                                          onSelect: (option) {
                                            setState(() {
                                              wallType = option;
                                            });
                                          },
                                          selected: wallType)
                                      : Container(),
                                  wallType != null && wallType['id'] == "4"
                                      ? TextRow(
                                          label: "Wall",
                                          controller: other_wall_type,
                                          onChange: (val) {})
                                      : Container(),
                                  SpinnerRow(
                                      label: 'Resting Height',
                                      options: adultRestingHeight,
                                      onSelect: (option) {
                                        setState(() {
                                          restingHeight = option;
                                        });
                                      },
                                      selected: restingHeight),
                                  TextRow(
                                      label: "Ae.aegypti Female",
                                      controller: aeFemale,
                                      number: true,
                                      customText: Wrap(children: [
                                        Text(
                                          "Ae.aegypti ",
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                        Text(
                                          "Female",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ]),
                                      onChange: (val) {}),
                                  TextRow(
                                      label: "Ae.albopictus Female",
                                      controller: alboFemale,
                                      number: true,
                                      customText: Wrap(children: [
                                        Text(
                                          "Ae.albopictus ",
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                        Text(
                                          "Female",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ]),
                                      onChange: (val) {}),
                                  TextRow(
                                      label: "Non fed",
                                      controller: nonFed,
                                      number: true,
                                      onChange: (val) {}),
                                  TextRow(
                                      label: "Blood Fed",
                                      controller: bloodFed,
                                      number: true,
                                      onChange: (val) {}),
                                  TextRow(
                                      label: "Semi Gravid",
                                      controller: semiGravid,
                                      number: true,
                                      onChange: (val) {}),
                                  TextRow(
                                      label: "Gravid",
                                      controller: gravid,
                                      number: true,
                                      onChange: (val) {}),
                                  TextRow(
                                      label: "Ae.aegypti Male",
                                      controller: aeMale,
                                      number: true,
                                      customText: Wrap(children: [
                                        Text(
                                          "Ae.aegypti ",
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                        Text(
                                          "Male",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ]),
                                      onChange: (val) {}),
                                  TextRow(
                                      label: "Ae.albopictus Male",
                                      controller: alboMale,
                                      number: true,
                                      customText: Wrap(children: [
                                        Text(
                                          "Ae.albopictus ",
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                        Text(
                                          "Male",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ]),
                                      onChange: (val) {}),
                                  TextRow(
                                      label: "Notes",
                                      controller: note,
                                      onChange: (val) {}),
                                  TextButton(
                                    onPressed: () async {
                                      saveAdultContainer();
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
                                                    getName(places[index]),
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
