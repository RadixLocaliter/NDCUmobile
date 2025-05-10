import 'package:dengue/components/header.dart';
import 'package:dengue/formPage.dart';
import 'package:dengue/forms/larvalLocalities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalityList extends StatefulWidget {
  final dynamic obj;
  LocalityList({Key? key, required this.obj}) : super(key: key);

  @override
  _LocalityListState createState() => _LocalityListState();
}

class _LocalityListState extends State<LocalityList> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late TextEditingController _textController;

  Box<dynamic> surveyRef = Hive.box('surveys');
  Box<dynamic> metaRef = Hive.box('meta');

  List<dynamic> statList = [];

  List<dynamic> localityList = [];
  List<dynamic> gnList = [];

  dynamic selectedGN;

  @override
  void initState() {
    super.initState();
    if (widget.obj['content'] != null) {
      statList = widget.obj['content'];
    } else {
      statList = [];
    }

    localityList = statList;
    _textController = TextEditingController(text: '');
    gnList = metaRef
        .get('gn')
        .where((element) =>
            element["district"] == widget.obj["district"] &&
            element["rdhs"] == widget.obj["rdhs"] &&
            element["moh"] == widget.obj["moh"] &&
            element["phi"] == widget.obj["phi"])
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    String getText(item) {
      var displayText = "";
      switch (widget.obj['survey_technique']['id'].toString()) {
        case "1":
          displayText = item["selected_address"];
          break;
        case "2":
          displayText = item["address"];
          break;
        case "3":
          displayText = item['premise'] != null ? item['premise'] : "";
          break;
        case "4":
          displayText = item['selected_locality'];
          break;
        case "5":
          displayText = item['selected_locality'];
          break;
        default:
          displayText = "";
          break;
      }
      return displayText;
    }

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
                  action: () async {
                    // await Navigator.push(
                    //   context,
                    //   PageTransition(
                    //     type: PageTransitionType.rightToLeft,
                    //     duration: Duration(milliseconds: 300),
                    //     reverseDuration: Duration(milliseconds: 300),
                    //     child: Larval(survey: widget.obj['id'],),
                    //   ),
                    // );
                  },
                  actionLabel: Icon(
                    Icons.add,
                    color: Colors.redAccent,
                  ),
                  pageName: widget.obj['name'],
                ),
                Container(
                    height: 50,
                    child: SingleChildScrollView(
                      child: Row(
                          children: List.generate(
                              widget.obj["gns"].length,
                              (index) => Padding(
                                    padding:
                                        EdgeInsets.only(left: 5.0, right: 5.0),
                                    child: GestureDetector(
                                      child: Chip(
                                        backgroundColor:
                                            widget.obj["gns"][index] != null &&
                                                    selectedGN ==
                                                        widget.obj["gns"][index]
                                                ? Colors.teal
                                                : Colors.grey,
                                        label: Text(
                                            widget.obj["gns"][index] != null
                                                ? gnList.where((gn) => gn["id"] == widget.obj["gns"][index]).toList()[0]['name']
                                                : ""),
                                      ),
                                      onTap: () {
                                        if (selectedGN ==
                                            widget.obj["gns"][index]) {
                                          setState(() {
                                            selectedGN = null;
                                          });
                                        } else {
                                          setState(() {
                                            selectedGN =
                                                widget.obj["gns"][index]["id"];
                                          });
                                        }
                                      },
                                    ),
                                  ))),
                    )),
                Container(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
                    child: CupertinoSearchTextField(
                      controller: _textController,
                      onChanged: (val) {
                        setState(() {
                          localityList = statList
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
                  onRefresh: () async {
                    setState(() {
                      dynamic obj = surveyRef.get(widget.obj['id']);
                      localityList = obj;
                    });
                  },
                  child: ListView.builder(
                      itemCount: localityList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(left: 15.0, right: 15.0),
                          child: GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  duration: Duration(milliseconds: 300),
                                  reverseDuration: Duration(milliseconds: 300),
                                  child: FormPage(
                                    locality: localityList[index],
                                    survey: widget.obj,
                                    content: localityList[index],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom:
                                          BorderSide(color: Colors.black26))),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: Text(getText(localityList[index])),
                                  )),
                            ),
                          ),
                        );
                      }),
                )),
              ]),
        )));
  }
}
