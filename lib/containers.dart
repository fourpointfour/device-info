import 'package:flutter/material.dart';

class CardForData extends StatefulWidget {
  final String? dataForCard;
  CardForData({this.dataForCard});

  @override
  _CardForDataState createState() => _CardForDataState();
}

class _CardForDataState extends State<CardForData> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15, left: 10, right: 10),
      padding: EdgeInsets.all(10),
      height: 80,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            offset: Offset(2, 2),
            color: Theme.of(context).shadowColor,
            spreadRadius: 3,
            blurRadius: 2,
          ),
          BoxShadow(
            offset: Offset(-2, -2),
            color: Colors.white,
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Text(
          '${widget.dataForCard}',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
    );
  }
}
