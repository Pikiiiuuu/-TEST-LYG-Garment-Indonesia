import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lyg_test/infinite_pagination/model.dart';
import 'package:flutter_lyg_test/ly_product_detail.dart';
import 'package:flutter_lyg_test/size_config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
//files of infinite_scroll of app version
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //initiate the amount of data per page
  static const int _perPage = 10;

  final oCcy = new NumberFormat("#,##0", "en_US");

  //initiate the first of page
  final PagingController<int, Product> _pagingController = PagingController(
    firstPageKey: 0,
  );

  //fetching data
  Future<void> _getProducts(int page) async {
    print(page);
    final client = http.Client();
    try {
      final result = await client.get(
        Uri.parse(
          "https://dummyjson.com/products?limit=$_perPage&skip=$page",
        ),
      );
      if (result.statusCode == 200) {
        final model = ResponseModel.fromJson(result.body);
        final isLastPage = model.products.length == 100;
        if (isLastPage) {
          _pagingController.appendLastPage(model.products);
        } else {
          _pagingController.appendPage(model.products, page + 10);
        }
      }
    } catch (e) {
      _pagingController.error = "Annother Error : $e";
    } finally {
      client.close();
    }
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) => _getProducts(pageKey));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => _pagingController.refresh(),
        child: Builder(
          builder: (context) => SafeArea(
              child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  title: Text(widget.title),
                  floating: true,
                  snap: true,
                ),
                PagedSliverList(
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<Product>(
                    transitionDuration: const Duration(seconds: 2),
                    itemBuilder: (_, item, __) => InkWell(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsScreen(
                                  images: item.images,
                                  discountPercentage:
                                  item.discountPercentage.toString(),
                                  title: item.discountPercentage,
                                  description: item.description,
                                  price: item.price.toString(),
                                  rating: '5',
                                  stock: item.stock.toString(),
                                  brand: item.brand,
                                  category: item.category,
                                  thumbnail: item.thumbnail),
                            ));
                      },
                      child: Card(
                        child: Column(
                          children: [
                            item.thumbnail == null
                                ? AspectRatio(
                              aspectRatio: 3,
                              child: Container(
                                padding: EdgeInsets.all(getProportionateScreenWidth(5)),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: getProportionateScreenHeight(100),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          "${item.thumbnail}"),
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
                                    padding: EdgeInsets.all(getProportionateScreenWidth(5)),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: getProportionateScreenHeight(100),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              "${item.thumbnail}"),
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
                                        child: Text("Stock ${item.stock}", style: GoogleFonts.poppins(fontSize: 12),)
                                    ),
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
                                    "${item.title} | ${item.brand}",
                                    style: GoogleFonts.lato(color: Colors.black),
                                    maxLines: 2,
                                  ),
                                  SizedBox(height: 5,),
                                  Row(
                                    children: [
                                      Text(
                                        '\$ ${oCcy.format(double.parse('${item.price}'))}',
                                        style: GoogleFonts.lato(
                                            fontWeight:
                                            FontWeight
                                                .bold,
                                            fontSize: 18),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '(${item.discountPercentage} %)',
                                        style: TextStyle(
                                            color: Colors
                                                .green,
                                            fontWeight:
                                            FontWeight
                                                .bold,
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
                                  // StarRating(
                                  //   rating: double.parse("${_found[index]['rating']}"),
                                  //   // onRatingChanged: (rating) => setState(() => this._get[index]['rating'] = _get[index]['rating']),
                                  // ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    firstPageErrorIndicatorBuilder: (context) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_pagingController.error),
                        IconButton(
                          onPressed: () => _pagingController.refresh(),
                          icon: const Icon(Icons.refresh),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          )
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

