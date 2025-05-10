import 'package:dengue/components/numberRow.dart';
import 'package:dengue/forms/larvalLocalities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'components/header.dart';
import 'package:dengue/components/spinnerRow.dart';
import 'package:hive/hive.dart';
import 'package:dengue/constants/dropdowns.dart';

import 'components/textRow.dart';
import 'components/buttonRow.dart';

class FormPage extends StatefulWidget {
  final dynamic locality;
  final dynamic survey;
  final String title;
  final dynamic content;
  FormPage(
      {Key? key,
      required this.survey,
      required this.locality,
      this.content = null,
      this.title = "Form Page"})
      : super(key: key);

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Box<dynamic> surveyRef = Hive.box('surveys');

  Map<dynamic, dynamic> companyData = {
    "gn_divisions": [],
    "survey_id": '',
    "indie_id": null,
    "survey_name": '',
    "team_type": null,
    "team_name": '',
    "survey_gn": null,
    "premise": '',
    "location": null,
    "breeding": null,
    "wwi": 0,
    "wwo": 0,
    "wowi": 0,
    "wowo": 0,
    "moi": 0,
    "moo": 0,
    "noli": 0,
    "nolo": 0,
    "nopi": 0,
    "nopo": 0,
    "mi": 0,
    "mo": 0,
    "ia": 0,
    "ib": 0,
    "iab": 0,
    "remarks": null,
    "actions": null,
    "sections": []
  };

  Map<dynamic, dynamic> adultData = {
    "gn_divisions": [],
    "selected_survey_id": '',
    "indie_id": null,
    "selected_survey_name": '',
    "selected_gn": null,
    "selected_locality": '',
    "selected_weather": null,
    "started_at": "",
    "finished_at": "",
    "location": null,
    // Collection Details
    "address": "",
    "start_time": "",
    "end_time": "",
    "roof": null,
    "wall": null,
    "indoor": 0,
    "outdoor": 0,
    "rarea": null,
    "rplace": null,
    "aemale": 0,
    "aefemale": 0,
    "almale": 0,
    "alfemale": 0,
    "condition": null,
    "height": null,
    "sections": []
  };

  Map<dynamic, dynamic> ovitrapData = {
    "gn_divisions": [],
    "selected_survey_id": '',
    "indie_id": null,
    "selected_survey_name": '',
    "selected_gn": null,
    "selected_locality": '',
    "selected_climate": null,
    "selected_nature": null,
    "name": "",
    "premise_type": null,
    "iarea": null,
    "oarea": null,
    "iplace": null,
    "oplace": null,
    "niarea": 0,
    "noarea": 0,
    "niplace": 0,
    "noplace": 0,
    // Section Details
    "sections": []
  };

  Map<dynamic, dynamic> pupalData = {
    "gn_divisions": [],
    "selected_survey_id": '',
    "indie_id": null,
    "selected_survey_name": '',
    "selected_gn": null,
    "selected_locality": '',
    "location": null,
    "selected_breeding": null,
    "wet": 0,
    "positive": 0,
    "aegypti": 0,
    "albopictus": 0,
    // Section Details
    "sections": []
  };

  Map<dynamic, dynamic> selectedData = Map<dynamic, dynamic>();
  late dynamic tempLocation;

  dynamic selectedSection;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Widget renderCompany() {
    return Column(
      children: [
        SizedBox(
            height: (MediaQuery.of(context).size.height * 0.07),
            child: Padding(
              padding: EdgeInsets.only(left: 25.0),
              child: Align(
                child: Text(
                  'forms.company.sub_survey',
                ),
                alignment: Alignment.centerLeft,
              ),
            )),
        Container(
          color: Colors.white54,
          padding:
              EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0, bottom: 10.0),
          child: Column(
            children: [
              TextRow(
                  label: 'forms.company.survey_id',
                  val: selectedData['selected_survey_id'],
                  onChange: (e) {
                    setState(() {
                      selectedData['selected_survey_id'] = e;
                    });
                  }),
              TextRow(
                  label: 'forms.company.survey_name',
                  val: selectedData['selected_survey_name'],
                  onChange: (e) {
                    setState(() {
                      selectedData['selected_survey_name'] = e;
                    });
                  }),
              SpinnerRow(
                  label: 'forms.company.team_type',
                  options: companyTeamTypes,
                  onSelect: (option) {
                    setState(() {
                      selectedData['team_type'] = option;
                    });
                  },
                  selected: selectedData['team_type']),
              TextRow(
                  label: 'forms.company.team_name',
                  val: "",
                  onChange: (e) {
                    setState(() {
                      selectedData['team_name'] = e;
                    });
                  }),
              SpinnerRow(
                  label: 'forms.company.gn_division',
                  options: selectedData['gn_divisions'],
                  onSelect: (option) {
                    setState(() {
                      selectedData['survey_gn'] = option;
                    });
                  },
                  selected: selectedData['survey_gn']),
              TextRow(
                  label: 'forms.company.premise_name',
                  val: selectedData['premise'],
                  bordered: false,
                  onChange: (e) {
                    setState(() {
                      selectedData['premise'] = e;
                    });
                  }),
            ],
          ),
        ),
        SizedBox(
            height: (MediaQuery.of(context).size.height * 0.07),
            child: Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0),
              child: Align(
                child: Row(
                  children: [
                    Text(
                      'forms.company.sub_section',
                    ),
                    Spacer(),
                    IconButton(
                        onPressed: () {
                          showCupertinoDialog<void>(
                            context: context,
                            builder: (BuildContext context) =>
                                CupertinoAlertDialog(
                              title: const Text('New section'),
                              content: const Text(
                                  'Do you want to reset fields & and start a new record?'),
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
                                  onPressed: () {
                                    setState(() {
                                      selectedData['breeding'] = null;
                                      selectedData['wwi'] = 0;
                                      selectedData['wwo'] = 0;
                                      selectedData['wowi'] = 0;
                                      selectedData['wowo'] = 0;
                                      selectedData['moi'] = 0;
                                      selectedData['moo'] = 0;
                                      selectedData['noli'] = 0;
                                      selectedData['nolo'] = 0;
                                      selectedData['nopi'] = 0;
                                      selectedData['nopo'] = 0;
                                      selectedData['mi'] = 0;
                                      selectedData['mo'] = 0;
                                      selectedData['ia'] = 0;
                                      selectedData['ib'] = 0;
                                      selectedData['iab'] = 0;
                                      selectedSection = null;
                                    });
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.add,
                          color: Colors.redAccent,
                        ))
                  ],
                ),
                alignment: Alignment.centerLeft,
              ),
            )),
        Container(
          color: Colors.white54,
          padding:
              EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0, bottom: 10.0),
          child: Column(children: [
            SpinnerRow(
                label: 'forms.company.breeding',
                options: companyBreedings,
                onSelect: (option) {
                  setState(() {
                    selectedData['breeding'] = option;
                  });
                },
                selected: selectedData['breeding']),

            SizedBox(
                height: (MediaQuery.of(context).size.height * 0.07),
                child: Padding(
                  padding: EdgeInsets.only(left: 0.0),
                  child: Align(
                    child: Text(
                      'forms.company.sub_containers',
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                )),
            NumberRow(
                label: 'forms.company.wwi',
                val: selectedData['wwi'],
                onChange: (e) {
                  setState(() {
                    selectedData['wwi'] = e;
                  });
                }),
            NumberRow(
                label: 'forms.company.wwo',
                val: selectedData['wwo'],
                onChange: (e) {
                  setState(() {
                    selectedData['wwo'] = e;
                  });
                }),
            NumberRow(
                label: 'forms.company.wowi',
                val: selectedData['wowi'],
                onChange: (e) {
                  setState(() {
                    selectedData['wowi'] = e;
                  });
                }),
            NumberRow(
                label: 'forms.company.wowo',
                val: selectedData['wowo'],
                onChange: (e) {
                  setState(() {
                    selectedData['wowo'] = e;
                  });
                }),
            NumberRow(
                label: 'forms.company.moi',
                val: selectedData['moi'],
                onChange: (e) {
                  setState(() {
                    selectedData['moi'] = e;
                  });
                }),
            NumberRow(
                label: 'forms.company.moo',
                val: selectedData['moo'],
                onChange: (e) {
                  setState(() {
                    selectedData['moo'] = e;
                  });
                }),

            SizedBox(
                height: (MediaQuery.of(context).size.height * 0.07),
                child: Padding(
                  padding: EdgeInsets.only(left: 0.0),
                  child: Align(
                    child: Text(
                      'forms.company.sub_aedes',
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                )),
            NumberRow(
                label: 'forms.company.noli',
                val: selectedData['noli'],
                onChange: (e) {
                  setState(() {
                    selectedData['noli'] = e;
                  });
                }),
            NumberRow(
                label: 'forms.company.nolo',
                val: selectedData['nolo'],
                onChange: (e) {
                  setState(() {
                    selectedData['nolo'] = e;
                  });
                }),
            NumberRow(
                label: 'forms.company.nopi',
                val: selectedData['nopi'],
                onChange: (e) {
                  setState(() {
                    selectedData['nopi'] = e;
                  });
                }),
            NumberRow(
                label: 'forms.company.nopo',
                val: selectedData['nopo'],
                onChange: (e) {
                  setState(() {
                    selectedData['nopo'] = e;
                  });
                }),

            SizedBox(
                height: (MediaQuery.of(context).size.height * 0.07),
                child: Padding(
                  padding: EdgeInsets.only(left: 0.0),
                  child: Align(
                    child: Text(
                      'forms.company.sub_mosquito',
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                )),

            NumberRow(
                label: 'forms.company.mi',
                val: selectedData['mi'],
                onChange: (e) {
                  setState(() {
                    selectedData['mi'] = e;
                  });
                }),

            NumberRow(
                label: 'forms.company.mo',
                val: selectedData['mo'],
                onChange: (e) {
                  setState(() {
                    selectedData['mo'] = e;
                  });
                }),

            SizedBox(
                height: (MediaQuery.of(context).size.height * 0.07),
                child: Padding(
                  padding: EdgeInsets.only(left: 0.0),
                  child: Align(
                    child: Text(
                      'forms.company.sub_aedes',
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                )),

            NumberRow(
                label: 'forms.company.ia',
                val: selectedData['ia'],
                onChange: (e) {
                  setState(() {
                    selectedData['ia'] = e;
                  });
                }),

            NumberRow(
                label: 'forms.company.ib',
                val: selectedData['ib'],
                onChange: (e) {
                  setState(() {
                    selectedData['ib'] = e;
                  });
                }),

            NumberRow(
                label: 'forms.company.iab',
                val: selectedData['iab'],
                onChange: (e) {
                  setState(() {
                    selectedData['iab'] = e;
                  });
                }),

            SizedBox(
              height: 10.0,
            ),

            // TextRow(
            //       label: 'forms.company.remarks',
            //       val: selectedData['remarks'],
            //       onChange: (e) {
            //         setState(() {
            //           selectedData['remarks'] = e;
            //         });
            //       }),

            //       TextRow(
            //       label: 'forms.company.actions',
            //       val: selectedData['actions'],
            //       onChange: (e) {
            //         setState(() {
            //           selectedData['actions'] = e;
            //         });
            //       }),

            SizedBox(
              height: 10.0,
            ),
            TextButton(
              onPressed: () {
                if (selectedData['breeding'] == null) {
                  final snackBar = SnackBar(
                    backgroundColor: Colors.redAccent,
                    content: const Text('Type of breeding place is required'),
                    action: SnackBarAction(
                      label: 'OK',
                      onPressed: () {},
                    ),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  showCupertinoDialog<void>(
                    context: context,
                    builder: (BuildContext context) => CupertinoAlertDialog(
                      title: const Text('Save section'),
                      content: Text(selectedSection != null
                          ? 'Do you want to update the record $selectedSection'
                          : 'Do you want to create this record?'),
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
                          onPressed: () {
                            List<dynamic> sections = selectedData['sections'];
                            if (selectedSection != null) {
                              sections[selectedSection] = {
                                "breeding": selectedData['breeding'],
                                "wwi": selectedData['wwi'],
                                "wwo": selectedData['wwo'],
                                "wowi": selectedData['wowi'],
                                "wowo": selectedData['wowo'],
                                "moi": selectedData['moi'],
                                "moo": selectedData['moo'],
                                "noli": selectedData['noli'],
                                "nolo": selectedData['nolo'],
                                "nopi": selectedData['nopi'],
                                "nopo": selectedData['nopo'],
                                "mi": selectedData['mi'],
                                "mo": selectedData['mo'],
                                "ia": selectedData['ia'],
                                "ib": selectedData['ib'],
                                "iab": selectedData['iab'],
                              };
                            } else {
                              sections.add({
                                "breeding": selectedData['breeding'],
                                "wwi": selectedData['wwi'],
                                "wwo": selectedData['wwo'],
                                "wowi": selectedData['wowi'],
                                "wowo": selectedData['wowo'],
                                "moi": selectedData['moi'],
                                "moo": selectedData['moo'],
                                "noli": selectedData['noli'],
                                "nolo": selectedData['nolo'],
                                "nopi": selectedData['nopi'],
                                "nopo": selectedData['nopo'],
                                "mi": selectedData['mi'],
                                "mo": selectedData['mo'],
                                "ia": selectedData['ia'],
                                "ib": selectedData['ib'],
                                "iab": selectedData['iab'],
                              });
                            }
                            setState(() {
                              selectedData['sections'] = sections;
                              selectedData['breeding'] = null;
                              selectedData['wwi'] = 0;
                              selectedData['wwo'] = 0;
                              selectedData['wowi'] = 0;
                              selectedData['wowo'] = 0;
                              selectedData['moi'] = 0;
                              selectedData['moo'] = 0;
                              selectedData['noli'] = 0;
                              selectedData['nolo'] = 0;
                              selectedData['nopi'] = 0;
                              selectedData['nopo'] = 0;
                              selectedData['mi'] = 0;
                              selectedData['mo'] = 0;
                              selectedData['ia'] = 0;
                              selectedData['ib'] = 0;
                              selectedData['iab'] = 0;
                              selectedSection = null;
                            });
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  );
                }
              },
              child: Text(
                "Save",
                style: TextStyle(color: Colors.redAccent),
              ),
            )
          ]),
        ),
        SizedBox(
            height: (MediaQuery.of(context).size.height * 0.07),
            child: Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0),
              child: Align(
                child: Text(
                  'forms.adult.sub_sections',
                ),
                alignment: Alignment.centerLeft,
              ),
            )),
        Container(
          padding:
              EdgeInsets.only(left: 25.0, right: 15.0, top: 10.0, bottom: 10.0),
          child: Column(
              children: List.generate(
                  selectedData['sections'].length,
                  (index) => Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        border: Border.all(color: Colors.black26),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Map<dynamic, dynamic> tempData = selectedData;
                          tempData['breeding'] =
                              selectedData['sections'][index]['breeding'];
                          tempData['wwi'] =
                              selectedData['sections'][index]['wwi'];
                          tempData['wwo'] =
                              selectedData['sections'][index]['wwo'];
                          tempData['wowi'] =
                              selectedData['sections'][index]['wowi'];
                          tempData['wowo'] =
                              selectedData['sections'][index]['wowo'];
                          tempData['moi'] =
                              selectedData['sections'][index]['moi'];
                          tempData['moo'] =
                              selectedData['sections'][index]['moo'];
                          tempData['noli'] =
                              selectedData['sections'][index]['noli'];
                          tempData['nolo'] =
                              selectedData['sections'][index]['nolo'];
                          tempData['nopi'] =
                              selectedData['sections'][index]['nopi'];
                          tempData['nopo'] =
                              selectedData['sections'][index]['nopo'];
                          tempData['mi'] =
                              selectedData['sections'][index]['mi'];
                          tempData['mo'] =
                              selectedData['sections'][index]['mo'];
                          tempData['ia'] =
                              selectedData['sections'][index]['ia'];
                          tempData['ib'] =
                              selectedData['sections'][index]['ib'];
                          tempData['iab'] =
                              selectedData['sections'][index]['iab'];
                          setState(() {
                            selectedSection = index;
                            selectedData = tempData;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.all(25.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                "#${index + 1}",
                                style: TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              Text(selectedData['sections'][index]['breeding']
                                  ['name']),
                            ],
                          ),
                        ),
                      )))),
        )
      ],
    );
  }

  Widget renderAdult() {
    return Column(
      children: [
        SizedBox(
            height: (MediaQuery.of(context).size.height * 0.07),
            child: Padding(
              padding: EdgeInsets.only(left: 25.0),
              child: Align(
                child: Text(
                  'forms.adult.sub_survey',
                ),
                alignment: Alignment.centerLeft,
              ),
            )),
        Container(
          color: Colors.white54,
          padding:
              EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0, bottom: 10.0),
          child: Column(
            children: [
              TextRow(
                  label: 'forms.adult.survey_id',
                  val: selectedData['selected_survey_id'],
                  enabled: false,
                  onChange: (e) {
                    setState(() {
                      selectedData['selected_survey_id'] = e;
                    });
                  }),
              SpinnerRow(
                  label: 'forms.adult.gn_division',
                  options: selectedData['gn_divisions'],
                  onSelect: (option) {
                    setState(() {
                      selectedData['selected_gn'] = option;
                    });
                  },
                  selected: selectedData['selected_gn']),
              TextRow(
                  label: 'forms.adult.locality',
                  val: selectedData['selected_locality'],
                  onChange: (e) {
                    setState(() {
                      selectedData['selected_locality'] = e;
                    });
                  }),
              SpinnerRow(
                  label: 'forms.adult.weather',
                  options: adultWeather,
                  onSelect: (option) {
                    setState(() {
                      selectedData['selected_weather'] = option;
                    });
                  },
                  selected: selectedData['selected_weather']),
              ButtonRow(
                  label: "Started at",
                  btnLabel: "Start",
                  onConfirm: (out) {
                    setState(() {
                      selectedData['started_at'] = out;
                    });
                  },
                  message: "Are you sure you want to start?",
                  value: selectedData['started_at'] != null
                      ? selectedData['started_at']
                      : ""),
              ButtonRow(
                  label: "Finished at",
                  btnLabel: "Finish",
                  onConfirm: (out) {
                    setState(() {
                      selectedData['finished_at'] = out;
                    });
                  },
                  message: "Are you sure you want to finish?",
                  value: selectedData['finished_at'] != null
                      ? selectedData['finished_at']
                      : ""),
            ],
          ),
        ),
        SizedBox(
            height: (MediaQuery.of(context).size.height * 0.07),
            child: Padding(
              padding: EdgeInsets.only(left: 25.0),
              child: Align(
                child: Row(
                  children: [
                    Text(
                      'forms.adult.sub_collection',
                    ),
                    Spacer(),
                    IconButton(
                        onPressed: () {
                          showCupertinoDialog<void>(
                            context: context,
                            builder: (BuildContext context) =>
                                CupertinoAlertDialog(
                              title: const Text('New section'),
                              content: const Text(
                                  'Do you want to reset fields & and start a new record?'),
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
                                  onPressed: () {
                                    setState(() {
                                      selectedData['address'] = "";
                                      selectedData['start_time'] = "";
                                      selectedData['end_time'] = "";
                                      selectedData['roof'] = null;
                                      selectedData['wall'] = null;
                                      selectedData['indoor'] = 0;
                                      selectedData['outdoor'] = 0;
                                      selectedData['rarea'] = null;
                                      selectedData['rplace'] = null;
                                      selectedData['aemale'] = 0;
                                      selectedData['aefemale'] = 0;
                                      selectedData['almale'] = 0;
                                      selectedData['alfemale'] = 0;
                                      selectedData['condition'] = null;
                                      selectedData['height'] = null;
                                      selectedSection = null;
                                    });
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.add,
                          color: Colors.redAccent,
                        ))
                  ],
                ),
                alignment: Alignment.centerLeft,
              ),
            )),
        Container(
          color: Colors.white54,
          padding:
              EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0, bottom: 10.0),
          child: Column(children: [
            TextRow(
                label: 'forms.adult.addr',
                val: selectedData['address'],
                onChange: (e) {
                  setState(() {
                    setState(() {
                      selectedData['address'] = e;
                    });
                  });
                }),
            SpinnerRow(
                label: 'forms.adult.roof',
                options: adultRoofTypes,
                onSelect: (option) {
                  setState(() {
                    selectedData['roof'] = option;
                  });
                },
                selected: selectedData['roof']),
            SpinnerRow(
                label: 'forms.adult.wall',
                options: adultWallTypes,
                onSelect: (option) {
                  setState(() {
                    selectedData['wall'] = option;
                  });
                },
                selected: selectedData['wall']),
            NumberRow(
                label: 'forms.adult.in',
                val: selectedData['indoor'],
                onChange: (e) {
                  setState(() {
                    selectedData['indoor'] = e;
                  });
                }),
            NumberRow(
                label: 'forms.adult.ou',
                val: selectedData['outdoor'],
                onChange: (e) {
                  setState(() {
                    selectedData['outdoor'] = e;
                  });
                }),
            SizedBox(
                height: (MediaQuery.of(context).size.height * 0.07),
                child: Padding(
                  padding: EdgeInsets.only(left: 25.0),
                  child: Align(
                    child: Text(
                      'forms.adult.sub_resting',
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                )),
            SpinnerRow(
                label: 'forms.adult.rarea',
                options: adultRestingAreaOutdoor,
                onSelect: (option) {
                  setState(() {
                    selectedData['rarea'] = option;
                  });
                },
                selected: selectedData['rarea']),
            SpinnerRow(
                label: 'forms.adult.rplace',
                options: adultRestingPlace,
                onSelect: (option) {
                  setState(() {
                    selectedData['rplace'] = option;
                  });
                },
                selected: selectedData['rplace']),
            SpinnerRow(
                label: 'forms.adult.abdomen',
                options: adultAbdomenCondition,
                onSelect: (option) {
                  setState(() {
                    selectedData['condition'] = option;
                  });
                },
                selected: selectedData['condition']),
            SpinnerRow(
                label: 'forms.adult.resting',
                options: adultRestingHeight,
                onSelect: (option) {
                  setState(() {
                    selectedData['height'] = option;
                  });
                },
                selected: selectedData['height']),
            SizedBox(
                height: (MediaQuery.of(context).size.height * 0.07),
                child: Padding(
                  padding: EdgeInsets.only(left: 25.0),
                  child: Align(
                    child: Text(
                      'forms.adult.sub_collected',
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                )),
            NumberRow(
                label: 'forms.adult.amale',
                val: selectedData['aemale'],
                onChange: (e) {
                  setState(() {
                    selectedData['aemale'] = e;
                  });
                }),
            NumberRow(
                label: 'forms.adult.afemale',
                val: selectedData['aefemale'],
                onChange: (e) {
                  setState(() {
                    selectedData['aefemale'] = e;
                  });
                }),
            NumberRow(
                label: 'forms.adult.almale',
                val: selectedData['almale'],
                onChange: (e) {
                  setState(() {
                    selectedData['almale'] = e;
                  });
                }),
            NumberRow(
                label: 'forms.adult.alfemale',
                val: selectedData['alfemale'],
                onChange: (e) {
                  setState(() {
                    selectedData['alfemale'] = e;
                  });
                }),
            SizedBox(
              height: 10.0,
            ),
            TextButton(
              onPressed: () {
                showCupertinoDialog<void>(
                  context: context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                    title: const Text('Save section'),
                    content: Text(selectedSection != null
                        ? 'Do you want to update the record $selectedSection'
                        : 'Do you want to create this record?'),
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
                        onPressed: () {
                          List<dynamic> sections = selectedData['sections'];
                          if (selectedSection != null) {
                            sections[selectedSection] = {
                              "address": selectedData['address'],
                              "start_time": selectedData['start_time'],
                              "end_time": selectedData['end_time'],
                              "roof": selectedData['roof'],
                              "wall": selectedData['wall'],
                              "indoor": selectedData['indoor'],
                              "outdoor": selectedData['outdoor'],
                              "rarea": selectedData['rarea'],
                              "rplace": selectedData['rplace'],
                              "condition": selectedData['condition'],
                              "height": selectedData['height'],
                              "aemale": selectedData['aemale'],
                              "aefemale": selectedData['aefemale'],
                              "almale": selectedData['almale'],
                              "alfemale": selectedData['alfemale'],
                            };
                          } else {
                            sections.add({
                              "address": selectedData['address'],
                              "start_time": selectedData['start_time'],
                              "end_time": selectedData['end_time'],
                              "roof": selectedData['roof'],
                              "wall": selectedData['wall'],
                              "indoor": selectedData['indoor'],
                              "outdoor": selectedData['outdoor'],
                              "rarea": selectedData['rarea'],
                              "rplace": selectedData['rplace'],
                              "condition": selectedData['condition'],
                              "height": selectedData['height'],
                              "aemale": selectedData['aemale'],
                              "aefemale": selectedData['aefemale'],
                              "almale": selectedData['almale'],
                              "alfemale": selectedData['alfemale'],
                            });
                          }
                          setState(() {
                            selectedData['address'] = "";
                            selectedData['start_time'] = "";
                            selectedData['end_time'] = "";
                            selectedData['roof'] = null;
                            selectedData['wall'] = null;
                            selectedData['indoor'] = 0;
                            selectedData['outdoor'] = 0;
                            selectedData['rarea'] = null;
                            selectedData['rplace'] = null;
                            selectedData['aemale'] = 0;
                            selectedData['aefemale'] = 0;
                            selectedData['almale'] = 0;
                            selectedData['alfemale'] = 0;
                            selectedData['condition'] = null;
                            selectedData['height'] = null;
                            selectedSection = null;
                          });
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                );
              },
              child: Text(
                "Save",
                style: TextStyle(color: Colors.redAccent),
              ),
            )
          ]),
        ),
        SizedBox(
            height: (MediaQuery.of(context).size.height * 0.07),
            child: Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0),
              child: Align(
                child: Text(
                  'forms.adult.sub_sections',
                ),
                alignment: Alignment.centerLeft,
              ),
            )),
        Container(
          padding:
              EdgeInsets.only(left: 25.0, right: 15.0, top: 10.0, bottom: 10.0),
          child: Column(
              children: List.generate(
                  selectedData['sections'].length,
                  (index) => Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        border: Border.all(color: Colors.black26),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Map<dynamic, dynamic> tempData = selectedData;
                          tempData['address'] =
                              selectedData['sections'][index]['address'];
                          tempData['start_time'] =
                              selectedData['sections'][index]['start_time'];
                          tempData['end_time'] =
                              selectedData['sections'][index]['end_time'];
                          tempData['roof'] =
                              selectedData['sections'][index]['roof'];
                          tempData['wall'] =
                              selectedData['sections'][index]['wall'];
                          tempData['indoor'] =
                              selectedData['sections'][index]['indoor'];
                          tempData['outdoor'] =
                              selectedData['sections'][index]['outdoor'];
                          tempData['rarea'] =
                              selectedData['sections'][index]['rarea'];
                          tempData['rplace'] =
                              selectedData['sections'][index]['rplace'];
                          tempData['aemale'] =
                              selectedData['sections'][index]['aemale'];
                          tempData['aefemale'] =
                              selectedData['sections'][index]['aefemale'];
                          tempData['almale'] =
                              selectedData['sections'][index]['almale'];
                          tempData['alfemale'] =
                              selectedData['sections'][index]['alfemale'];
                          tempData['condition'] =
                              selectedData['sections'][index]['condition'];
                          tempData['height'] =
                              selectedData['sections'][index]['height'];
                          setState(() {
                            selectedSection = index;
                            selectedData = tempData;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.all(25.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                "#${index + 1}",
                                style: TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              Text(selectedData['sections'][index]['address']),
                            ],
                          ),
                        ),
                      )))),
        )
      ],
    );
  }

  Widget renderOvitrap() {
    return Column(
      children: [
        SizedBox(
            height: (MediaQuery.of(context).size.height * 0.07),
            child: Padding(
              padding: EdgeInsets.only(left: 25.0),
              child: Align(
                child: Text(
                  'forms.ovitrap.sub_survey',
                ),
                alignment: Alignment.centerLeft,
              ),
            )),
        Container(
          color: Colors.white54,
          padding:
              EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0, bottom: 10.0),
          child: Column(
            children: [
              TextRow(
                  label: 'forms.ovitrap.survey_id',
                  val: selectedData['selected_survey_id'],
                  onChange: (e) {
                    setState(() {
                      selectedData['selected_survey_id'] = e;
                    });
                  }),
              TextRow(
                  label: 'forms.ovitrap.survey_name',
                  val: selectedData['selected_survey_name'],
                  onChange: (e) {
                    setState(() {
                      selectedData['selected_survey_name'] = e;
                    });
                  }),
              SpinnerRow(
                  label: 'forms.ovitrap.gn_division',
                  options: selectedData['gn_divisions'],
                  onSelect: (option) {
                    setState(() {
                      selectedData['selected_gn'] = option;
                    });
                  },
                  selected: selectedData['selected_gn']),
              TextRow(
                  label: 'forms.ovitrap.locality',
                  val: selectedData['selected_locality'],
                  onChange: (e) {
                    setState(() {
                      selectedData['selected_locality'] = e;
                    });
                  }),
              SpinnerRow(
                  label: 'forms.ovitrap.climate',
                  options: ovitrapClimate,
                  onSelect: (option) {
                    setState(() {
                      selectedData['selected_climate'] = option;
                    });
                  },
                  selected: selectedData['selected_climate']),
              SpinnerRow(
                  label: 'forms.ovitrap.nature',
                  options: ovitrapNature,
                  onSelect: (option) {
                    setState(() {
                      selectedData['selected_nature'] = option;
                    });
                  },
                  selected: selectedData['selected_nature']),
            ],
          ),
        ),
        SizedBox(
            height: (MediaQuery.of(context).size.height * 0.07),
            child: Padding(
              padding: EdgeInsets.only(left: 25.0),
              child: Align(
                child: Row(
                  children: [
                    Text(
                      'forms.ovitrap.section',
                    ),
                    Spacer(),
                    IconButton(
                        onPressed: () {
                          showCupertinoDialog<void>(
                            context: context,
                            builder: (BuildContext context) =>
                                CupertinoAlertDialog(
                              title: const Text('New section'),
                              content: const Text(
                                  'Do you want to reset fields & and start a new record?'),
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
                                  onPressed: () {
                                    setState(() {
                                      selectedData['name'] = "";
                                      selectedData['premise'] = null;
                                      selectedData['iarea'] = null;
                                      selectedData['oarea'] = null;
                                      selectedData['iplace'] = null;
                                      selectedData['oplace'] = null;
                                      selectedData['niarea'] = 0;
                                      selectedData['noarea'] = 0;
                                      selectedData['niplace'] = 0;
                                      selectedData['noplace'] = 0;
                                      selectedSection = null;
                                    });
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.add,
                          color: Colors.redAccent,
                        ))
                  ],
                ),
                alignment: Alignment.centerLeft,
              ),
            )),
        Container(
            color: Colors.white54,
            padding: EdgeInsets.only(
                left: 25.0, right: 25.0, top: 10.0, bottom: 10.0),
            child: Column(children: [
              TextRow(
                  label: 'forms.ovitrap.name',
                  val: selectedData['name'],
                  onChange: (e) {
                    setState(() {
                      selectedData['name'] = e;
                    });
                  }),
              SpinnerRow(
                  label: 'forms.ovitrap.premise',
                  options: ovitrapPremises,
                  onSelect: (option) {
                    setState(() {
                      selectedData['premise_type'] = option;
                    });
                  },
                  selected: selectedData['premise_type']),
              SizedBox(
                  height: (MediaQuery.of(context).size.height * 0.07),
                  child: Padding(
                    padding: EdgeInsets.only(left: 25.0),
                    child: Align(
                      child: Text(
                        'forms.ovitrap.placement',
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                  )),
              SpinnerRow(
                  label: 'forms.ovitrap.placeIarea',
                  options: ovitrapIndoorAreas,
                  onSelect: (option) {
                    setState(() {
                      selectedData['iarea'] = option;
                    });
                  },
                  selected: selectedData['iarea']),
              SpinnerRow(
                  label: 'forms.ovitrap.placeOarea',
                  options: ovitrapOutdoorAreas,
                  onSelect: (option) {
                    setState(() {
                      selectedData['oarea'] = option;
                    });
                  },
                  selected: selectedData['oarea']),
              SpinnerRow(
                  label: 'forms.ovitrap.placeIplace',
                  options: ovitrapIndoorPlaces,
                  onSelect: (option) {
                    setState(() {
                      selectedData['iplace'] = option;
                    });
                  },
                  selected: selectedData['iplace']),
              SpinnerRow(
                  label: 'forms.ovitrap.placeOplace',
                  options: ovitrapOutdoorPlaces,
                  onSelect: (option) {
                    setState(() {
                      selectedData['oplace'] = option;
                    });
                  },
                  selected: selectedData['oplace']),
              SizedBox(
                  height: (MediaQuery.of(context).size.height * 0.07),
                  child: Padding(
                    padding: EdgeInsets.only(left: 25.0),
                    child: Align(
                      child: Text(
                        'forms.ovitrap.collection',
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                  )),
              NumberRow(
                  label: 'forms.ovitrap.collectionIarea',
                  val: selectedData["niarea"],
                  onChange: (e) {
                    setState(() {
                      selectedData["niarea"] = e;
                    });
                  }),
              NumberRow(
                  label: 'forms.ovitrap.collectionOarea',
                  val: selectedData["noarea"],
                  onChange: (e) {
                    setState(() {
                      selectedData["noarea"] = e;
                    });
                  }),
              NumberRow(
                  label: 'forms.ovitrap.collectionIplace',
                  val: selectedData["niplace"],
                  onChange: (e) {
                    setState(() {
                      selectedData["niplace"] = e;
                    });
                  }),
              NumberRow(
                  label: 'forms.ovitrap.collectionOplace',
                  val: selectedData["noplace"],
                  onChange: (e) {
                    setState(() {
                      selectedData["noplace"] = e;
                    });
                  }),
              TextButton(
                onPressed: () {
                  showCupertinoDialog<void>(
                    context: context,
                    builder: (BuildContext context) => CupertinoAlertDialog(
                      title: const Text('Save section'),
                      content: Text(selectedSection != null
                          ? 'Do you want to update the record $selectedSection'
                          : 'Do you want to create this record?'),
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
                          onPressed: () {
                            List<dynamic> sections = selectedData['sections'];
                            if (selectedSection != null) {
                              sections[selectedSection] = {
                                "name": selectedData['name'],
                                "premise": selectedData['premise'],
                                "iarea": selectedData['iarea'],
                                "oarea": selectedData['oarea'],
                                "iplace": selectedData['iplace'],
                                "oplace": selectedData['oplace'],
                                "niarea": selectedData['niarea'],
                                "noarea": selectedData['noarea'],
                                "niplace": selectedData['niplace'],
                                "noplace": selectedData['noplace'],
                              };
                            } else {
                              sections.add({
                                "name": selectedData['name'],
                                "premise": selectedData['premise'],
                                "iarea": selectedData['iarea'],
                                "oarea": selectedData['oarea'],
                                "iplace": selectedData['iplace'],
                                "oplace": selectedData['oplace'],
                                "niarea": selectedData['niarea'],
                                "noarea": selectedData['noarea'],
                                "niplace": selectedData['niplace'],
                                "noplace": selectedData['noplace'],
                              });
                            }
                            setState(() {
                              selectedData['name'] = "";
                              selectedData['premise'] = null;
                              selectedData['iarea'] = null;
                              selectedData['oarea'] = null;
                              selectedData['iplace'] = null;
                              selectedData['oplace'] = null;
                              selectedData['niarea'] = 0;
                              selectedData['noarea'] = 0;
                              selectedData['niplace'] = 0;
                              selectedData['noplace'] = 0;
                              selectedSection = null;
                            });
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  );
                },
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.redAccent),
                ),
              )
            ])),
        SizedBox(
            height: (MediaQuery.of(context).size.height * 0.07),
            child: Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0),
              child: Align(
                child: Text(
                  'forms.ovitrap.sub_sections',
                ),
                alignment: Alignment.centerLeft,
              ),
            )),
        Container(
          padding:
              EdgeInsets.only(left: 25.0, right: 15.0, top: 10.0, bottom: 10.0),
          child: Column(
              children: List.generate(
                  selectedData['sections'].length,
                  (index) => GestureDetector(
                      onTap: () {
                        Map<dynamic, dynamic> tempData = selectedData;
                        tempData['name'] =
                            selectedData['sections'][index]['name'];
                        tempData['premise'] =
                            selectedData['sections'][index]['premise'];
                        tempData['iarea'] =
                            selectedData['sections'][index]['iarea'];
                        tempData['oarea'] =
                            selectedData['sections'][index]['oarea'];
                        tempData['iplace'] =
                            selectedData['sections'][index]['iplace'];
                        tempData['oplace'] =
                            selectedData['sections'][index]['oplace'];
                        tempData['niarea'] =
                            selectedData['sections'][index]['niarea'];
                        tempData['noarea'] =
                            selectedData['sections'][index]['noarea'];
                        tempData['niplace'] =
                            selectedData['sections'][index]['niplace'];
                        tempData['noplace'] =
                            selectedData['sections'][index]['noplace'];
                        setState(() {
                          selectedSection = index;
                          selectedData = tempData;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          border: Border.all(color: Colors.black26),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(25.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                "#${index + 1}",
                                style: TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              Text(selectedData['sections'][index]['name']),
                            ],
                          ),
                        ),
                      )))),
        )
      ],
    );
  }

  Widget renderPupal() {
    return Column(
      children: [
        SizedBox(
            height: (MediaQuery.of(context).size.height * 0.07),
            child: Padding(
              padding: EdgeInsets.only(left: 25.0),
              child: Align(
                child: Text(
                  'forms.pupal.sub_survey',
                ),
                alignment: Alignment.centerLeft,
              ),
            )),
        Container(
          color: Colors.white54,
          padding:
              EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0, bottom: 10.0),
          child: Column(
            children: [
              TextRow(
                  label: 'forms.pupal.survey_id',
                  val: selectedData['selected_survey_id'],
                  onChange: (e) {
                    setState(() {
                      selectedData['selected_survey_id'] = e;
                    });
                  }),
              TextRow(
                  label: 'forms.pupal.survey_name',
                  val: selectedData['selected_survey_name'],
                  onChange: (e) {
                    setState(() {
                      selectedData['selected_survey_name'] = e;
                    });
                  }),
              SpinnerRow(
                  label: 'forms.pupal.gn_division',
                  options: selectedData['gn_divisions'],
                  onSelect: (option) {
                    setState(() {
                      selectedData['selected_gn'] = option;
                    });
                  },
                  selected: selectedData['selected_gn']),
              TextRow(
                  label: 'forms.pupal.locality',
                  val: selectedData['selected_locality'],
                  onChange: (e) {
                    setState(() {
                      selectedData['selected_locality'] = e;
                    });
                  }),
            ],
          ),
        ),
        SizedBox(
            height: (MediaQuery.of(context).size.height * 0.07),
            child: Padding(
              padding: EdgeInsets.only(left: 25.0),
              child: Align(
                child: Row(
                  children: [
                    Text(
                      'forms.ovitrap.section',
                    ),
                    Spacer(),
                    IconButton(
                        onPressed: () {
                          showCupertinoDialog<void>(
                            context: context,
                            builder: (BuildContext context) =>
                                CupertinoAlertDialog(
                              title: const Text('New section'),
                              content: const Text(
                                  'Do you want to reset fields & and start a new record?'),
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
                                  onPressed: () {
                                    setState(() {
                                      selectedData['selected_breeding'] = null;
                                      selectedData['wet'] = 0;
                                      selectedData['positive'] = 0;
                                      selectedData['aegypti'] = 0;
                                      selectedData['albopictus'] = 0;
                                      selectedSection = null;
                                    });
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.add,
                          color: Colors.redAccent,
                        ))
                  ],
                ),
                alignment: Alignment.centerLeft,
              ),
            )),
        Container(
            color: Colors.white54,
            padding: EdgeInsets.only(
                left: 25.0, right: 25.0, top: 10.0, bottom: 10.0),
            child: Column(children: [
              SpinnerRow(
                  label: 'forms.pupal.breeding',
                  options: pupalBreeding,
                  onSelect: (option) {
                    setState(() {
                      selectedData['selected_breeding'] = option;
                    });
                  },
                  selected: selectedData['selected_breeding']),
              NumberRow(
                  label: 'forms.pupal.wet',
                  val: selectedData['wet'],
                  onChange: (e) {
                    setState(() {
                      selectedData['wet'] = e;
                    });
                  }),
              NumberRow(
                  label: 'forms.pupal.positive',
                  val: selectedData['positive'],
                  onChange: (e) {
                    setState(() {
                      selectedData['positive'] = e;
                    });
                  }),
              NumberRow(
                  label: 'forms.pupal.aegypti',
                  val: selectedData['aegypti'],
                  onChange: (e) {
                    setState(() {
                      selectedData['aegypti'] = e;
                    });
                  }),
              NumberRow(
                  label: 'forms.pupal.albopictus',
                  val: selectedData['albopictus'],
                  onChange: (e) {
                    setState(() {
                      selectedData['albopictus'] = e;
                    });
                  }),
              TextButton(
                onPressed: () {
                  showCupertinoDialog<void>(
                    context: context,
                    builder: (BuildContext context) => CupertinoAlertDialog(
                      title: const Text('Save section'),
                      content: Text(selectedSection != null
                          ? 'Do you want to update the record $selectedSection'
                          : 'Do you want to create this record?'),
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
                          onPressed: () {
                            List<dynamic> sections = selectedData['sections'];
                            if (selectedSection != null) {
                              sections[selectedSection] = {
                                "selected_breeding":
                                    selectedData['selected_breeding'],
                                "wet": selectedData['wet'],
                                "positive": selectedData['positive'],
                                "aegypti": selectedData['aegypti'],
                                "albopictus": selectedData['albopictus'],
                              };
                            } else {
                              sections.add({
                                "selected_breeding":
                                    selectedData['selected_breeding'],
                                "wet": selectedData['wet'],
                                "positive": selectedData['positive'],
                                "aegypti": selectedData['aegypti'],
                                "albopictus": selectedData['albopictus'],
                              });
                            }
                            setState(() {
                              selectedData['selected_breeding'] = null;
                              selectedData['wet'] = 0;
                              selectedData['positive'] = 0;
                              selectedData['aegypti'] = 0;
                              selectedData['albopictus'] = 0;
                              selectedSection = null;
                            });
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  );
                },
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.redAccent),
                ),
              )
            ])),
        SizedBox(
            height: (MediaQuery.of(context).size.height * 0.07),
            child: Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0),
              child: Align(
                child: Text(
                  'forms.ovitrap.sub_sections',
                ),
                alignment: Alignment.centerLeft,
              ),
            )),
        Container(
          padding:
              EdgeInsets.only(left: 25.0, right: 15.0, top: 10.0, bottom: 10.0),
          child: Column(
              children: List.generate(
                  selectedData['sections'].length,
                  (index) => GestureDetector(
                      onTap: () {
                        Map<dynamic, dynamic> tempData = selectedData;
                        tempData['selected_breeding'] = selectedData['sections']
                            [index]['selected_breeding'];
                        tempData['wet'] =
                            selectedData['sections'][index]['wet'];
                        tempData['positive'] =
                            selectedData['sections'][index]['positive'];
                        tempData['aegypti'] =
                            selectedData['sections'][index]['aegypti'];
                        tempData['albopictus'] =
                            selectedData['sections'][index]['albopictus'];
                        setState(() {
                          selectedSection = index;
                          selectedData = tempData;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          border: Border.all(color: Colors.black26),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(25.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                "#${index + 1}",
                                style: TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              Text(selectedData['sections'][index]
                                  ['selected_breeding']['name']),
                            ],
                          ),
                        ),
                      )))),
        )
      ],
    );
  }
}
