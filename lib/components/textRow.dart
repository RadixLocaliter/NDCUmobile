import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextRow extends StatefulWidget {
  final String label;
  final void Function(dynamic) onChange;
  final String? val;
  final bool bordered;
  final bool enabled;
  final bool number;
  final TextEditingController? controller;
  final Widget? customText;
  TextRow(
      {Key? key,
      required this.label,
      required this.onChange,
      this.bordered = true,
      this.enabled = true,
      this.number = false,
      this.val = '',
      this.controller, 
      this.customText = null})
      : super(key: key);

  @override
  _TextRowState createState() => _TextRowState();
}

class _TextRowState extends State<TextRow> {
  late TextEditingController _widgetController;

  @override
  void initState() {
    _widgetController = widget.controller ??  new TextEditingController();
    _widgetController.text = widget.val != null ? widget.val.toString() : "";
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
                child: widget.customText ?? Text(widget.label,
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),),
              ),
              ),
              Expanded(
                child: TextField(
                  enabled: widget.enabled,
                  controller: _widgetController,
                  style: TextStyle(fontSize: 15.0),
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(border: InputBorder.none),
                  textInputAction: TextInputAction.next,
                  keyboardType: widget.number ? TextInputType.number : TextInputType.text,
                  cursorColor: Colors.redAccent,
                  onChanged: (e){ widget.onChange(e);},
                ),
              )
            ],
          )),
    );
  }
}
