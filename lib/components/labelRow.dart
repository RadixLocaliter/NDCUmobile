import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LabelRow extends StatefulWidget {
  final String label;
  final void Function(dynamic) onChange;
  final String val;
  final bool bordered;
  LabelRow(
      {Key? key,
      required this.label,
      required this.onChange,
      this.bordered = true,
      this.val = ''})
      : super(key: key);

  @override
  _LabelRowState createState() => _LabelRowState();
}

class _LabelRowState extends State<LabelRow> {
  TextEditingController _widgetController = new TextEditingController();

  @override
  void initState() {
    _widgetController.text = widget.val;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widget.bordered
          ? BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: Colors.black38, width: 0.0)))
          : null,
      child: SizedBox(
          height: (MediaQuery.of(context).size.height * 0.07),
          child: Row(
            children: [
              Container(
                width: 2 * MediaQuery.of(context).size.width/5,
                child: Align(
                alignment: Alignment.centerLeft,
                child: Text(widget.label,
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),),
              ),
              ),
              Expanded(
                child: Text(
                  widget.val,
                  textAlign: TextAlign.right,
                ),
              )
            ],
          )),
    );
  }
}
