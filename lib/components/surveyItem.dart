import 'dart:convert';

import 'package:dengue/api/index.dart';
import 'package:dengue/constants/dbHelper.dart';
import 'package:dengue/forms/adultLocalities.dart';
import 'package:dengue/forms/ovitrapLocalities.dart';
import 'package:dengue/forms/pupalLocalities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/dropdowns.dart';
import 'package:dengue/forms/larvalLocalities.dart';

class SurveyItem extends StatefulWidget {
  final dynamic obj;
  SurveyItem({Key? key, required this.obj}) : super(key: key);

  @override
  _SurveyItemState createState() => _SurveyItemState();
}

class _SurveyItemState extends State<SurveyItem> {
  bool selected = false;
  double _height = 50;

  Future<bool> syncSurvey() async {
    var db = await DBHelper.db();
    var last_sync = DateTime.parse(widget.obj['last_sync'].toString());

    var locality_sync = [];
    var localities = await db.query('ndcu_survey_localities',
        where: 'survey_id = ?', whereArgs: [widget.obj['id']]);
    localities.forEach((item) async {
      var upd_time = DateTime.parse(item['updated'].toString());
      if (upd_time.compareTo(last_sync) > 0) {
        locality_sync.add(item);
      }
    });

    var premise_sync = [];
    var premises = await db.query('ndcu_survey_premises',
        where: 'survey_id = ?', whereArgs: [widget.obj['id']]);
    premises.forEach((item) async {
      var upd_time = DateTime.parse(item['updated'].toString());
      if (upd_time.compareTo(last_sync) > 0) {
        premise_sync.add(item);
      }
    });

    var containers = [];
    var containers_sync = [];
    if (widget.obj['survey_technique'] == 1) {
      containers = await db.query('ndcu_larval_surveys',
          where: 'survey_id = ?', whereArgs: [widget.obj['id']]);
    }
    if (widget.obj['survey_technique'] == 2) {
      containers = await db.query('ndcu_adult_surveys',
          where: 'survey_id = ?', whereArgs: [widget.obj['id']]);
    }
    if (widget.obj['survey_technique'] == 3) {
      containers = await db.query('ndcu_ovitrap_surveys',
          where: 'survey_id = ?', whereArgs: [widget.obj['id']]);
    }
    if (widget.obj['survey_technique'] == 4) {
      containers = await db.query('ndcu_pupal_surveys',
          where: 'survey_id = ?', whereArgs: [widget.obj['id']]);
    }
    containers.forEach((container) async {
      var upd_time = DateTime.parse(container['updated']);
      if (upd_time.compareTo(last_sync) > 0) {
        containers_sync.add(container);
      }
    });

    var out = await upsyncSurvey({
      "survey": widget.obj['id'].toString(),
      "localities": jsonEncode(locality_sync),
      "premises": jsonEncode(premise_sync),
      "containers": jsonEncode(containers_sync),
      "technique": widget.obj['survey_technique'].toString()
    });
    final snackBar = SnackBar(
      backgroundColor: Colors.redAccent,
      content: const Text('Sync successful'),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(widget.obj['id']);
      },
      child: Card(
        child: AnimatedContainer(
          height: _height,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
          child: Column(children: [
            Container(
              height: 50,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.obj['name'],
                        style: Theme.of(context).textTheme.headlineMedium),
                    Wrap(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (_height == 50) {
                                _height = 250;
                              } else {
                                _height = 50;
                              }
                            });
                            if (!selected) {
                              Future.delayed(const Duration(milliseconds: 500),
                                  () {
                                setState(() {
                                  selected = !selected;
                                });
                              });
                            } else {
                              setState(() {
                                selected = !selected;
                              });
                            }
                          },
                          icon: Icon(
                            selected ? Icons.info : Icons.info_outline,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (widget.obj['survey_technique'] == 1) {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  duration: Duration(milliseconds: 300),
                                  reverseDuration: Duration(milliseconds: 300),
                                  child: LarvalLocalities(
                                    survey: widget.obj['id'],
                                    surveyName: widget.obj['name'],
                                  ),
                                ),
                              );
                            } else if (widget.obj['survey_technique'] == 2) {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  duration: Duration(milliseconds: 300),
                                  reverseDuration: Duration(milliseconds: 300),
                                  child: AdultLocalities(
                                    survey: widget.obj['id'],
                                    surveyName: widget.obj['name'],
                                  ),
                                ),
                              );
                            } else if (widget.obj['survey_technique'] == 3) {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  duration: Duration(milliseconds: 300),
                                  reverseDuration: Duration(milliseconds: 300),
                                  child: OvitrapLocalities(
                                    survey: widget.obj['id'],
                                    surveyName: widget.obj['name'],
                                  ),
                                ),
                              );
                            } else if (widget.obj['survey_technique'] == 4) {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  duration: Duration(milliseconds: 300),
                                  reverseDuration: Duration(milliseconds: 300),
                                  child: PupalLocalities(
                                    survey: widget.obj['id'],
                                    surveyName: widget.obj['name'],
                                  ),
                                ),
                              );
                            }
                          },
                          icon: Icon(
                            Icons.add_box_outlined,
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                        // widget.obj['sync_state'] == 0 ?
                        // IconButton(
                        //   onPressed: () {

                        //   },
                        //   icon: Icon(
                        //     Icons.cloud_off,
                        //     color: Theme.of(context).dividerColor,
                        //   ),
                        // ) : Container(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            selected
                ? Container(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Survey ID : ${widget.obj['id']}'),
                            Text('Description : ${widget.obj['description']}'),
                            Text('Lead By : ${widget.obj['lead_by']}'),
                            Text('Created : ${widget.obj['created']}'),
                            Text(
                                'Category : ${(surveyCategories.where((item) => item['id'].toString() == widget.obj['category'].toString()).toList())[0]['name']}'),
                            Text(
                                'Technique : ${(surveyTechniques.where((item) => item['id'].toString() == widget.obj['survey_technique'].toString()).toList())[0]['name']}'),
                          ]),
                    ))
                : Container(),
            selected
                ? ElevatedButton(
                    onPressed: () {
                      showCupertinoDialog<void>(
                        context: context,
                        builder: (BuildContext context) => CupertinoAlertDialog(
                          title: Text(widget.obj['name']),
                          content: const Text('Do you want to sync survey?'),
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
                                syncSurvey();
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      );
                    },
                    child: Text("Sync survey"))
                : Container()
          ]),
        ),
      ),
    );
  }
}
