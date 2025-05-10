import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonRow extends StatefulWidget {
  final String label;
  final String btnLabel;
  final String value;
  final String message;
  final void Function(dynamic) onConfirm;
  ButtonRow(
      {Key? key,
      required this.label,
      required this.btnLabel,
      required this.onConfirm,
      required this.message,
      required this.value})
      : super(key: key);

  @override
  _ButtonRowState createState() => _ButtonRowState();
}

class _ButtonRowState extends State<ButtonRow> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: Colors.black38, width: 0.0))),
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
                child: widget.value == "" ? ElevatedButton(child: Text(widget.btnLabel), style: ElevatedButton.styleFrom(foregroundColor: Colors.redAccent), onPressed: (){
                  showCupertinoDialog<void>(
                            context: context,
                            builder: (BuildContext context) =>
                                CupertinoAlertDialog(
                              title: const Text('Confirmation'),
                              content: Text(widget.message),
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
                                    Navigator.pop(context);
                                    widget.onConfirm(new DateTime.now().toLocal().toString());
                                  },
                                )
                              ],
                            ),
                          );
                },) : Text(widget.value, textAlign: TextAlign.right,),
              )
            ],
          )),
    );
  }
}
