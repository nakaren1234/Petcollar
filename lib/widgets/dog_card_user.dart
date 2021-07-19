import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class DogCard extends StatelessWidget {
  final DocumentSnapshot document;
  final bool userView;

  const DogCard({
    this.document,
    this.userView,
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
                  userView
                      ? Transform.scale(
                          scale: 0.6,
                          child: LiteRollingSwitch(
                            value: document['found'] ?? false,
                            textOn: "สูญหาย",
                            textOff: "พบเจอ",
                            colorOn: Colors.redAccent,
                            colorOff: Colors.lightGreenAccent,
                            iconOn: Icons.notifications,
                            iconOff: Icons.notifications,
                            textSize: 22.0,
                            onChanged: (bool position) async {
                              FirebaseFirestore.instance
                                  .collection('posts')
                                  .doc(document.id)
                                  .update({
                                "found": !document['found'],
                                "updated_at": DateTime.now(),
                              });
                            },
                          ),
                        )
                      : document['found'],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
