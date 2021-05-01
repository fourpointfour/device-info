import 'package:flutter/material.dart';

class ReusableButton extends StatefulWidget {

  final IconData iconData;
  final Function torchFunc;

  ReusableButton({required this.iconData, required this.torchFunc});
  @override
  _ReusableButtonState createState() => _ReusableButtonState();
}

class _ReusableButtonState extends State<ReusableButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        onPressed: widget.torchFunc(),
        child: Expanded(
          child: FittedBox(
            fit: BoxFit.fill,
            child: Icon(
              widget.iconData,
            ),
          ),
        )
      ),
    );
  }
}
