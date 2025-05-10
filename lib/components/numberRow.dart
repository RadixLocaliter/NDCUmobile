import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NumberRow extends StatefulWidget {
  final String label;
  final void Function(dynamic) onChange;
  final bool bordered;
  final int? val;
  NumberRow(
      {Key? key,
      required this.label,
      required this.onChange,
      this.bordered = true,
      this.val = 0})
      : super(key: key);

  @override
  _NumberRowState createState() => _NumberRowState();
}

class _NumberRowState extends State<NumberRow> {
  @override
  Widget build(BuildContext context) {
    int count = widget.val != null ? widget.val!.toInt() : 0;
    return Container(
      decoration: widget.bordered ? BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black38, width: 0.0))) : null,
      child: SizedBox(
          height: (MediaQuery.of(context).size.height * 0.07),
          child: Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(widget.label,
                    style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),)
              ),
              Spacer(),
              Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                      width: (MediaQuery.of(context).size.width * 0.4),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (count > 0) {
                                  count = count - 1;
                                  widget.onChange(count);
                                }
                              });
                            },
                            child: Container(
                                width: 30,
                                height: 30,
                                color: Colors.redAccent,
                                child: Center(
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                          Expanded(
                              child: Center(
                            child: Text(count.toString(), style: TextStyle(fontSize: 15.0),),
                          )),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                count = count + 1;
                                widget.onChange(count);
                              });
                            },
                            child: Container(
                                width: 30,
                                height: 30,
                                color: Colors.redAccent,
                                child: Center(
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                        ],
                      )))
            ],
          )),
    );
  }
}
