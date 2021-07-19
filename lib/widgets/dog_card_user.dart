import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class DogCardUser extends StatelessWidget {
  final DocumentSnapshot document;

  const DogCardUser({
    this.document,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[300]),
      child: Card(
        child: Column(
          children: <Widget>[
            document['image_path'] != ''
                ? Image.network(document['image_path'])
                : Container(
                    width: 100,
                    height: 100,
                  ),
            Padding(
              padding: EdgeInsets.all(7.0),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Text(
                      "Name: ${document['title']}",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'K2D',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(7.0),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Text(
                      "Description: ${document['description']}",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'K2D',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(7.0),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Text(
                      "Time: ${DateTime.parse(document['created_at'].toDate().toString())}",
                      // document['created_at']
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'K2D',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(7.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Status :",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'K2D',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Transform.scale(
                    scale: 0.6,
                    child: LiteRollingSwitch(
                      value: false,
                      textOn: " พบเจอ  :${document['found']}",
                      textOff: " สูญหาย ${document['found']}",
                      colorOn: Colors.lightGreenAccent,
                      colorOff: Colors.redAccent,
                      iconOn: Icons.notifications,
                      iconOff: Icons.notifications,
                      textSize: 22.0,
                      onChanged: (bool position) {
                        print("The button is $position");
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
