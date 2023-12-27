import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_lyg_test/components/icon_btn.dart';
import 'package:flutter_lyg_test/components/section_title.dart';
import 'package:flutter_lyg_test/models/Product_Model.dart';
import 'package:flutter_lyg_test/size_config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert' as convert;
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unicons/unicons.dart';

import 'constant.dart';

class DetailsScreen extends StatefulWidget {
  final title,
      description,
      price,
      discountPercentage,
      rating,
      stock,
      brand,
      category,
      thumbnail,
      images;

  const DetailsScreen(
      {Key? key,
      this.title,
      this.description,
      this.discountPercentage,
      this.rating,
      this.stock,
      this.brand,
      this.category,
        this.images,
      this.thumbnail,
      this.price})
      : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final oCcy = new NumberFormat("#,##0", "en_US");

  List _get = [];
  List _images = [];
  Future<void> readJson() async {
    setState(() {
      _images = widget.images;
    });
  }

  TextEditingController _controllerKeyword = TextEditingController();

  var list;

  Future<bool> getProducts() async {
    String url = "https://dummyjson.com/products?limit=10";
    EasyLoading.show(status: 'loading...');
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      final data = convert.jsonDecode(response.body);
      setState(() {
        _get = data['products'];
      });
    }
    return false;
  }

  @override
  void initState() {
    getProducts();
    readJson();
    SizeConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
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
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(UniconsLine.arrow_left)),
                      Text('Detail Product', style: GoogleFonts.poppins(fontSize: 15),),
                      SizedBox(width: 50,),
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
                SizedBox(height: getProportionateScreenWidth(10)),
                ImageSlideshow(
                  /// Width of the [ImageSlideshow].
                  width: double.infinity,

                  /// Height of the [ImageSlideshow].
                  height: getProportionateScreenHeight(250),

                  /// The page to show when first creating the [ImageSlideshow].
                  initialPage: 0,

                  /// The color to paint the indicator.
                  indicatorColor: Colors.blue,

                  /// The color to paint behind th indicator.
                  indicatorBackgroundColor: Colors.grey,

                  /// The widgets to display in the [ImageSlideshow].
                  /// Add the sample image file into the images folder

                  children: [
                    // for (int i=0; i<= _images.length; i++)
                    //   Image.network(
                    //     '${_images[i++]}',
                    //     fit: BoxFit.cover,
                    //   )
                    for (int i=0; i<_images.length; i++)
                      Image.network(
                        '${_images[i]}',
                        fit: BoxFit.cover,
                      )
                  ],

                  /// Called whenever the page in the center of the viewport changes.
                  onPageChanged: (value) {
                    // print('Page changed: $value');
                  },

                  /// Auto scroll interval.
                  /// Do not auto scroll with null or 0.
                  autoPlayInterval: 5000,
                ),
                SizedBox(height: getProportionateScreenWidth(15)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(20)),
                        child: Row(
                          children: [
                            widget.discountPercentage == "0"
                                ? Row(
                                    children: [
                                      widget.discountPercentage == null
                                          ? SizedBox(
                                              width: 50.0,
                                              height:
                                                  getProportionateScreenHeight(
                                                      25),
                                              child: Shimmer.fromColors(
                                                baseColor: Colors.white24,
                                                highlightColor: Colors.grey,
                                                child: Container(
                                                  margin: EdgeInsets.all(3),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white24,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Text(
                                              '\$ ${oCcy.format(double.parse(widget.price))}',
                                              style: GoogleFonts.roboto(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      widget.price == null
                                          ? SizedBox(
                                              width: 50.0,
                                              height:
                                                  getProportionateScreenHeight(
                                                      25),
                                              child: Shimmer.fromColors(
                                                baseColor: Colors.white24,
                                                highlightColor: Colors.grey,
                                                child: Container(
                                                  margin: EdgeInsets.all(3),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white24,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Text(
                                              '\$ ${oCcy.format(double.parse(widget.price))}',
                                              style: GoogleFonts.roboto(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                      SizedBox(
                                        width: getProportionateScreenWidth(10),
                                      ),
                                      widget.discountPercentage == null
                                          ? SizedBox(
                                              width: 20.0,
                                              height:
                                                  getProportionateScreenHeight(
                                                      25),
                                              child: Shimmer.fromColors(
                                                baseColor: Colors.white24,
                                                highlightColor: Colors.grey,
                                                child: Container(
                                                  margin: EdgeInsets.all(3),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white24,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container(
                                              color:
                                                  Colors.green.withOpacity(0.2),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(3),
                                                child: Text(
                                                  "${widget.discountPercentage} %",
                                                  style: GoogleFonts.roboto(
                                                      color: Colors.green,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            )
                                    ],
                                  ),
                          ],
                        )),
                    SizedBox(
                      height: getProportionateScreenHeight(10),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(20)),
                      child: widget.title != null
                          ? Text(
                              "${widget.title} | ${widget.brand}",
                              style: GoogleFonts.lato(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            )
                          : SizedBox(
                              width: 200.0,
                              height: getProportionateScreenHeight(25),
                              child: Shimmer.fromColors(
                                baseColor: Colors.white24,
                                highlightColor: Colors.grey,
                                child: Container(
                                  margin: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: Colors.white24,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                              ),
                            ),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(10),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // count_toko_produk_terjual == null
                            //     ? SizedBox(
                            //         width: getProportionateScreenWidth(100),
                            //         height: getProportionateScreenHeight(25),
                            //         child: Shimmer.fromColors(
                            //           baseColor: Colors.white24,
                            //           highlightColor: Colors.grey,
                            //           child: Container(
                            //             margin: EdgeInsets.all(3),
                            //             decoration: BoxDecoration(
                            //               color: Colors.white24,
                            //               borderRadius:
                            //                   BorderRadius.circular(50),
                            //             ),
                            //           ),
                            //         ),
                            //       )
                            //     : Text(
                            //         "$count_toko_produk_terjual sold",
                            //         style: GoogleFonts.lato(
                            //             fontSize: 12,
                            //             color: Colors.grey,
                            //             fontWeight: FontWeight.w500),
                            //       ),
                            Text(
                              "Available Stocks ${widget.stock}",
                              style: GoogleFonts.lato(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        )),
                    Divider(),
                    // nama_kategori == "Fashion"
                    // ? Padding(
                    //   padding: EdgeInsets.symmetric(
                    //     horizontal: getProportionateScreenWidth(20),
                    //     vertical: getProportionateScreenHeight(10),
                    //   ),
                    //   child: GestureDetector(
                    //     onTap: () {},
                    //     child: Column(
                    //       children: [
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             Text(
                    //               "Select options",
                    //               style: GoogleFonts.lato(
                    //                   fontWeight: FontWeight.bold,
                    //                   fontSize: 15),
                    //             ),
                    //             Text(
                    //               "Ukuran",
                    //               style: GoogleFonts.lato(
                    //                   color: Colors.grey, fontSize: 12),
                    //             ),
                    //           ],
                    //         ),
                    //         SizedBox(
                    //           height: getProportionateScreenHeight(10),
                    //         ),
                    //         Row(
                    //           children: [
                    //             Container(
                    //               width: getProportionateScreenWidth(25),
                    //               height: getProportionateScreenHeight(25),
                    //               color: Colors.grey.withOpacity(0.2),
                    //               child: Padding(
                    //                 padding: const EdgeInsets.all(3),
                    //                 child: Center(
                    //                     child: Text(
                    //                   "S",
                    //                   style: GoogleFonts.roboto(
                    //                       color: Colors.black54,
                    //                       fontSize: 15,
                    //                       fontWeight: FontWeight.bold),
                    //                 )),
                    //               ),
                    //             ),
                    //             SizedBox(
                    //               width: getProportionateScreenWidth(10),
                    //             ),
                    //             Container(
                    //               width: getProportionateScreenWidth(25),
                    //               height: getProportionateScreenHeight(25),
                    //               color: Colors.grey.withOpacity(0.2),
                    //               child: Padding(
                    //                 padding: const EdgeInsets.all(3),
                    //                 child: Center(
                    //                     child: Text(
                    //                   "M",
                    //                   style: GoogleFonts.roboto(
                    //                       color: Colors.black54,
                    //                       fontSize: 15,
                    //                       fontWeight: FontWeight.bold),
                    //                 )),
                    //               ),
                    //             ),
                    //             SizedBox(
                    //               width: getProportionateScreenWidth(10),
                    //             ),
                    //             Container(
                    //               width: getProportionateScreenWidth(25),
                    //               height: getProportionateScreenHeight(25),
                    //               color: Colors.grey.withOpacity(0.2),
                    //               child: Padding(
                    //                 padding: const EdgeInsets.all(3),
                    //                 child: Center(
                    //                     child: Text(
                    //                   "L",
                    //                   style: GoogleFonts.roboto(
                    //                       color: Colors.black54,
                    //                       fontSize: 15,
                    //                       fontWeight: FontWeight.bold),
                    //                 )),
                    //               ),
                    //             ),
                    //             SizedBox(
                    //               width: getProportionateScreenWidth(10),
                    //             ),
                    //             Container(
                    //               width: getProportionateScreenWidth(25),
                    //               height: getProportionateScreenHeight(25),
                    //               color: Colors.grey.withOpacity(0.2),
                    //               child: Padding(
                    //                 padding: const EdgeInsets.all(3),
                    //                 child: Center(
                    //                     child: Text(
                    //                   "XL",
                    //                   style: GoogleFonts.roboto(
                    //                       color: Colors.black54,
                    //                       fontSize: 15,
                    //                       fontWeight: FontWeight.bold),
                    //                 )),
                    //               ),
                    //             ),
                    //             SizedBox(
                    //               width: getProportionateScreenWidth(10),
                    //             ),
                    //             Container(
                    //               width: getProportionateScreenWidth(35),
                    //               height: getProportionateScreenHeight(25),
                    //               color: Colors.grey.withOpacity(0.2),
                    //               child: Padding(
                    //                 padding: const EdgeInsets.all(3),
                    //                 child: Center(
                    //                     child: Text(
                    //                   "XXL",
                    //                   style: GoogleFonts.roboto(
                    //                       color: Colors.black54,
                    //                       fontSize: 15,
                    //                       fontWeight: FontWeight.bold),
                    //                 )),
                    //               ),
                    //             ),
                    //           ],
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // )
                    // : SizedBox(width: 2,),
                    // Divider(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(20),
                        vertical: getProportionateScreenHeight(10),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => TokoProdukDetail(
                          //             ID_Toko: id_toko,
                          //             nama_toko: toko_nama,
                          //             file_path: toko_image)));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 23,
                                  backgroundColor: Colors.grey,
                                  backgroundImage:
                                      NetworkImage(widget.thumbnail),
                                ),
                                SizedBox(
                                  width: getProportionateScreenWidth(15),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    widget.brand == null
                                        ? SizedBox(
                                            width: getProportionateScreenWidth(
                                                100),
                                            height:
                                                getProportionateScreenHeight(
                                                    25),
                                            child: Shimmer.fromColors(
                                              baseColor: Colors.white24,
                                              highlightColor: Colors.grey,
                                              child: Container(
                                                margin: EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                  color: Colors.white24,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Text(
                                            "${widget.brand}",
                                            style: GoogleFonts.lato(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                    SizedBox(
                                      height: getProportionateScreenHeight(2),
                                    ),
                                    StarRating(
                                      rating: double.parse("${widget.rating}"),
                                      // onRatingChanged: (rating) => setState(() => this._get[index]['rating'] = _get[index]['rating']),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(width: getProportionateScreenWidth(5)),
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(20),
                        vertical: getProportionateScreenHeight(10),
                      ),
                      child: GestureDetector(
                        onTap: () {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Product description",
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(10),
                            ),
                            widget.description != null
                                ? Text(
                                    "${widget.description}",
                                    textAlign: TextAlign.justify,
                                    style: GoogleFonts.roboto(height: 1.5),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 300.0,
                                        height:
                                            getProportionateScreenHeight(25),
                                        child: Shimmer.fromColors(
                                          baseColor: Colors.white24,
                                          highlightColor: Colors.grey,
                                          child: Container(
                                            margin: EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                              color: Colors.white24,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 350.0,
                                        height:
                                            getProportionateScreenHeight(25),
                                        child: Shimmer.fromColors(
                                          baseColor: Colors.white24,
                                          highlightColor: Colors.grey,
                                          child: Container(
                                            margin: EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                              color: Colors.white24,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(20)),
                      child: SectionTitle(
                          title: "You may also like", press: () {}),
                    ),
                    SizedBox(height: getProportionateScreenWidth(20)),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: GridList(get: _get),
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

class ProductDetailsArguments {
  final Product product;

  ProductDetailsArguments({required this.product});
}

class GridList extends StatelessWidget {
  const GridList({
    Key? key,
    required List get,
  })  : _get = get,
        super(key: key);

  final List _get;

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
        mainAxisExtent: 320, // here set custom Height You Want
      ),
      itemBuilder: (_, index) => GestureDetector(
        // onTap: () => Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) =>
        //           DetailsScreen(ID_BrgVarian: _get[index]['ID_BrgVarian'])),
        // ),
        child: Card(
          child: Column(
            children: [
              _get[index]['thumbnail'] == null
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
                                  NetworkImage("${_get[index]['thumbnail']}"),
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
                                      "${_get[index]['thumbnail']}"),
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
                                  "Stock ${_get[index]['stock']}",
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
                      "${_get[index]['title']} | ${_get[index]['brand']}",
                      style: GoogleFonts.lato(color: Colors.black),
                      maxLines: 2,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          '\$ ${oCcy.format(double.parse('${_get[index]['price']}'))}',
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '(${_get[index]['discountPercentage']} %)',
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
                      rating: double.parse("${_get[index]['rating']}"),
                      // onRatingChanged: (rating) => setState(() => this._get[index]['rating'] = _get[index]['rating']),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      itemCount: _get.length,
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
