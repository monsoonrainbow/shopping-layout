import 'dart:convert';
import 'package:flutter/material.dart';

class SelectedItemView extends StatelessWidget {
  var item;

  SelectedItemView(this.item);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Column(
          children: <Widget>[
            Container(
              height: 360,
              width: double.infinity,
              child: Image.network(item.image),
            ),
            Expanded(
              flex: 1,
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 20, 0, 0),
                    child: Text(
                      item.category,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 10, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(item.title,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 28)),
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Icon(Icons.favorite , color: Colors.deepPurple,),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 10, 0, 0),
                    child: Text(item.price,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 23,
                            color: Colors.deepPurple)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40.0, 15.0, 8.0, 8.0),
                    child: Row(
                      children: <Widget>[
                        RaisedButton(
                            child: Text(
                              "Add To Cart",
                              style: TextStyle(fontSize: 15),
                            ),
                            padding: EdgeInsets.fromLTRB(35, 12, 35, 12),
                            onPressed: () {},
                            color: Colors.deepPurple,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                side: BorderSide(color: Colors.white))),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18.0, 0, 0, 0),
                          child: RaisedButton(
                              child: Text(
                                "Buy Now",
                                style: TextStyle(fontSize: 15),
                              ),
                              padding: EdgeInsets.fromLTRB(40, 10.5, 40, 10.5),
                              onPressed: () {},
                              color: Colors.white,
                              textColor: Colors.deepPurple,
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(10.0),
                                  side: BorderSide(color: Colors.deepPurple))),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
