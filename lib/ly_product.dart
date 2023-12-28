import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_lyg_test/components/drawer.dart';
import 'package:flutter_lyg_test/constant.dart';
import 'package:flutter_lyg_test/ly_product_detail.dart';
import 'package:flutter_lyg_test/size_config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:unicons/unicons.dart';
import 'dart:async';
import 'dart:convert' as convert;

import 'models/Product_Model.dart';

class ProductPage extends StatefulWidget {
  final category;

  const ProductPage({Key? key, this.category}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  //defined variable and object
  Product? product;
  List<Map<String, dynamic>> _get = [];
  List _getCategories = [];
  List<Map<String, dynamic>> _found = [];

  TextEditingController _controllerKeyword = TextEditingController();

  final oCcy = new NumberFormat("#,##0", "en_US");

  //get list of category data
  Future<bool> getCategories() async {
    String url = "https://dummyjson.com/products/categories";
    EasyLoading.show(status: 'loading...');
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      final data = convert.jsonDecode(response.body);
      setState(() {
        _getCategories = data;
      });
    }
    return false;
  }
  //get list of product data
  Future<bool> getProducts() async {
    String url = "https://dummyjson.com/products";
    EasyLoading.show(status: 'loading...');
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      final data = convert.jsonDecode(response.body);
      setState(() {
        _get = List<Map<String, dynamic>>.from(data['products']);
        _found = _get;
      });
    }
    return false;
  }

  //get list of product by category data
  Future<bool> getProductsByCategory(String category) async {
    String url = "https://dummyjson.com/products/category/$category";
    EasyLoading.show(status: 'loading...');
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      final data = convert.jsonDecode(response.body);
      setState(() {
        _get = List<Map<String, dynamic>>.from(data['products']);
        _found = _get;
      });
    }
    return false;
  }
  //run search product
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _get;
    } else {
      results = _get
          .where((products) => products["title"]
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }
    // Refresh the UI
    setState(() {
      _found = results;
    });
  }
  //show category menu using modal popup
  showModalCategories() {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Products Filter',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
                  child: Container(
                    height: 450,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(),
                        Text(
                          'Plese choose 1 of the following categories.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Wrap(
                          children: [
                            for (int i=0; i<_getCategories.length; i++)
                              Container(
                                padding: EdgeInsets.only(left: 5),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    getProductsByCategory(_getCategories[i]);
                                  },
                                  child: Text('${_getCategories[i]}'),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12), // <-- Radius
                                    ),
                                  ),
                                )
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    getProducts();
    getCategories();
    super.initState();
  }
  //UI of the product page
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      drawer: DrawerSection(),
      body: Builder(
        builder: (context) => SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: getProportionateScreenHeight(10)),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: SizeConfig.screenWidth * 0.65,
                        decoration: BoxDecoration(
                          color: kSecondaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextField(
                          onChanged: (value) => _runFilter(value),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: getProportionateScreenWidth(20),
                                vertical: getProportionateScreenWidth(9)),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            hintText: "Find Products",
                          ),
                          // prefixIcon: Icon(Icons.search)),
                        ),
                      ),
                      InkWell(
                          onTap: () {
                            showModalCategories();
                          },
                          child: Icon(Icons.filter_alt)),
                      InkWell(
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                        },
                        child: Icon(
                          Icons.menu,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(10)),
                Divider(thickness: 2, color: Color(0xffFF9900),),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: GridList(get: _found),
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenWidth(30)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GridList extends StatelessWidget {
  const GridList({
    Key? key,
    required List get,
  })  : _found = get,
        super(key: key);

  final List _found;

  @override
  Widget build(BuildContext context) {
    final oCcy = new NumberFormat("#,##0", "en_US");
    return GridView.builder(
      //wajib menggunakan 2 baris script di bawah ini, agar dapat digabung dengan widget lain
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        mainAxisExtent: 300, // here set custom Height You Want
      ),
      itemBuilder: (_, index) => GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailsScreen(
                    images: _found[index]['images'],
                    discountPercentage:
                        _found[index]['discountPercentage'].toString(),
                    title: _found[index]['title'],
                    description: _found[index]['description'],
                    price: _found[index]['price'].toString(),
                    rating: _found[index]['rating'].toString(),
                    stock: _found[index]['stock'].toString(),
                    brand: _found[index]['brand'],
                    category: _found[index]['category'],
                    thumbnail: _found[index]['thumbnail']),
              ));
        },
        child: Card(
          child: Column(
            children: [
              _found[index]['thumbnail'] == null
                  ? AspectRatio(
                      aspectRatio: 1.00,
                      child: Container(
                        padding: EdgeInsets.all(getProportionateScreenWidth(5)),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: getProportionateScreenHeight(100),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image:
                                  NetworkImage("${_found[index]['thumbnail']}"),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: 1.00,
                          child: Container(
                            padding:
                                EdgeInsets.all(getProportionateScreenWidth(5)),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: getProportionateScreenHeight(100),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      "${_found[index]['thumbnail']}"),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 1,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                color: Colors.transparent,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  offset: new Offset(0.0, 0.0),
                                  blurRadius: 1.0,
                                  spreadRadius: 0.0,
                                ),
                              ],
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(0.5),
                                child: Text(
                                  "Stock ${_found[index]['stock']}",
                                  style: GoogleFonts.poppins(fontSize: 12),
                                )),
                          ),
                        ),
                      ],
                    ),
              Divider(),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${_found[index]['title']} | ${_found[index]['brand']}",
                      style: GoogleFonts.lato(color: Colors.black),
                      maxLines: 2,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          '\$ ${oCcy.format(double.parse('${_found[index]['price']}'))}',
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '(${_found[index]['discountPercentage']} %)',
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ],
                    ),
                    // Row(
                    //   children: [
                    //     Icon(
                    //       Icons.store,
                    //       color: kPrimaryColor,
                    //       size: 15,
                    //     ),
                    //     SizedBox(
                    //       width: 3,
                    //     ),
                    //     Text(
                    //       "${_get[index]['createdBy'].length > 25 ? _get[index]['createdBy'].substring(0, 25) + '...' : _get[index]['createdBy']}",
                    //       maxLines: 1,
                    //       style: GoogleFonts.lato(
                    //           fontWeight: FontWeight.w600,
                    //           color: kPrimaryColor,
                    //           fontSize: getProportionateScreenWidth(10)),
                    //     )
                    //   ],
                    // ),
                    Divider(),
                    StarRating(
                      rating: double.parse("${_found[index]['rating']}"),
                      // onRatingChanged: (rating) => setState(() => this._get[index]['rating'] = _get[index]['rating']),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      itemCount: _found.length,
    );
  }
}

typedef void RatingChangeCallback(double rating);

class StarRating extends StatelessWidget {
  final int? starCount;
  final double? rating;
  final RatingChangeCallback? onRatingChanged;
  final Color? color;

  StarRating(
      {this.starCount = 5, this.rating = .0, this.onRatingChanged, this.color});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating!) {
      icon = const Icon(
        Icons.star_border,
        size: 15,
        color: Colors.orangeAccent,
      );
    } else if (index > rating! - 1 && index < rating!) {
      icon = Icon(
        Icons.star_half,
        size: 15,
        color: color ?? Colors.orange,
      );
    } else {
      icon = Icon(
        Icons.star,
        size: 15,
        color: color ?? Colors.orange,
      );
    }
    return new InkResponse(
      onTap:
          onRatingChanged == null ? null : () => onRatingChanged!(index + 1.0),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
        children: new List.generate(
            starCount!, (index) => buildStar(context, index)));
  }
}
