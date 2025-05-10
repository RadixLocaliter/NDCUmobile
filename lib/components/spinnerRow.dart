import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SpinnerRow extends StatefulWidget {
  final String label;
  final List<dynamic> options;
  final void Function(dynamic) onSelect;
  final dynamic selected;
  final bool bordered;
  final bool disabled;
  SpinnerRow(
      {Key? key,
      required this.label,
      required this.options,
      required this.onSelect,
      required this.selected,
      this.disabled = false,
      this.bordered = true})
      : super(key: key);

  @override
  _SpinnerRowState createState() => _SpinnerRowState();
}

class _SpinnerRowState extends State<SpinnerRow> {
  void selectItem(item) {
    widget.onSelect(item);
  }

  void openDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          List<dynamic> items = widget.options;
          return StatefulBuilder(
              builder: (dialogContext, StateSetter addState) {
            return CupertinoAlertDialog(
                content: ConstrainedBox(
              constraints: new BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.5,
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                  minWidth: double.infinity),
              child: SingleChildScrollView(
                child: Column(children: [
                  CupertinoTextField.borderless(
                    onChanged: (txt) {
                      addState(() {
                        items = widget.options
                            .where((obj) => obj["name"]
                                .toLowerCase()
                                .contains(txt.toLowerCase()))
                            .toList();
                      });
                    },
                    placeholder: 'Search',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                  Column(
                      children: List.generate(
                    items.length,
                    (index) => GestureDetector(
                      child: Container(
                        child: ConstrainedBox(
                            constraints: new BoxConstraints(
                                minHeight:
                                    MediaQuery.of(context).size.height * 0.07,
                                minWidth: double.infinity),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(items[index]["name"],
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyMedium),
                            )),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.black12))),
                      ),
                      onTap: () {
                        selectItem(items[index]);
                        Navigator.of(dialogContext).pop();
                      },
                    ),
                  )),
                ]),
              ),
            ));
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    String text = widget.selected == null
        ? "--None--"
        : widget.options
            .where((option) => option["id"] == widget.selected["id"])
            .toList()[0]["name"];
    return Container(
        decoration: widget.bordered
            ? BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.black38, width: 0.0)))
            : null,
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: SizedBox(
              height: (MediaQuery.of(context).size.height * 0.07),
              child: Row(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.label,
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                      )),
                  Spacer(),
                  Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () => {widget.disabled ? null : openDialog()},
                        child: Row(
                          children: [
                            Container(
                              width: 130,
                              child: Text(
                                text,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 15.0,
                            ),
                          ],
                        ),
                      ))
                ],
              )),
        ));
  }
}
