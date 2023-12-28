import 'package:flutter/material.dart';
import 'package:flutter_lyg_test/constant.dart';
import 'package:flutter_lyg_test/infinite_pagination/post_home.dart';
import 'package:flutter_lyg_test/ly_product.dart';
import 'package:flutter_lyg_test/size_config.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';

class DrawerSection extends StatefulWidget {
  @override
  _DrawerSectionState createState() => _DrawerSectionState();
}


class _DrawerSectionState extends State<DrawerSection> {
  
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xff112639), Color(0xff144EA2)])),
                width: double.infinity,
                height: 100,
                padding: EdgeInsets.only(top: 20.0),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'LYG Dev Test Prototype',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                )),
          ),
          Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Navigation",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    InkWell(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 10, 5),
                        child: Row(
                          children: [
                            Expanded(
                                child: Icon(
                                  Icons.home_filled,
                                  size: 20,
                                  color: Colors.black45,
                                )),
                            Expanded(
                                flex: 4,
                                child: Text(
                                  'Standard',
                                  style: TextStyle(
                                      color: Colors.black45, fontSize: 15),
                                ))
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => ProductPage()));
                      },
                    ),
                    Divider(),
                    InkWell(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0,10,10,5),
                        child: Row(
                          children: [
                            Expanded(
                                child: Icon(
                                  Icons.shopping_cart,
                                  size: 20,
                                  color: Colors.black45,
                                )),
                            Expanded(
                                flex: 4,
                                child: Text(
                                  'Infinite Scroll',
                                  style: TextStyle(
                                      color: Colors.black45, fontSize: 15),
                                ))
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => MyHomePage(title: "Product List")));
                      },
                    ),
                    Divider(),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
