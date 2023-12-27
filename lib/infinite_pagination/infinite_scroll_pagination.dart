import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_lyg_test/infinite_pagination/post.dart';
import 'package:flutter_lyg_test/infinite_pagination/post_item.dart';
import 'package:http/http.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';


class InfiniteScrollPaginatorDemo extends StatefulWidget {
  @override
  _InfiniteScrollPaginatorDemoState createState() => _InfiniteScrollPaginatorDemoState();
}

class _InfiniteScrollPaginatorDemoState extends State<InfiniteScrollPaginatorDemo> {
  final _numberOfPostsPerRequest = 10;

  final PagingController<int, Post> _pagingController =
  PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    final response = await get(Uri.parse(
        "https://dummyjson.com/products?limit=$_numberOfPostsPerRequest&skip=$pageKey"));
    List responseList = json.decode(response.body);
    List<Post> postList = responseList.map((data) =>
        Post(data['products']['title'], data['products']['description'])).toList();
    final isLastPage = postList.length < _numberOfPostsPerRequest;
    if (isLastPage) {
      _pagingController.appendLastPage(postList);
    } else {
      final nextPageKey = pageKey + 1;
      _pagingController.appendPage(postList, nextPageKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(title: const Text("Blog App"), centerTitle: true,),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(() => _pagingController.refresh()),
        child: PagedListView<int, Post>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Post>(
            itemBuilder: (context, item, index) =>
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: PostItem(
                      item.title, item.body
                  ),
                ),

          ),

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