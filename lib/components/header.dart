import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final VoidCallback? action;
  final String pageName;
  final Widget? actionLabel;
  const Header({
    Key? key,
    this.action,
    required this.pageName,
    this.actionLabel
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white54,
        boxShadow: [
          BoxShadow(color: Colors.black26.withOpacity(0.05),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 2)
          ),
        ],
      ),
      child: Padding(
          padding: EdgeInsets.all(10),
          child: SizedBox(
            height: (MediaQuery.of(context).size.height * 0.05),
            child: Align(
              alignment: Alignment.center,
              child: Row(
                children: [
                  SizedBox(
                    width: (MediaQuery.of(context).size.width * 0.2) ,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        children: [
                          Icon(Icons.arrow_back_ios_rounded, color: Theme.of(context).primaryColor),
                          Text('Back',style: Theme.of(context).textTheme.bodyMedium,),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(pageName,style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center,),
                  ),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width * 0.2),
                    child: InkWell(
                      onTap: action,
                      child: actionLabel,
                    ),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }

}