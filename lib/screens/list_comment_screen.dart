import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_list_app/models/comment.dart';
import 'package:infinite_list_app/services/services.dart';

class ListCommentScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListCommentState();
  }
}

class ListCommentState extends State<ListCommentScreen> {
  List<Comment> _comments = [];
  ScrollController? _scrollController;
  int start = 0;
  bool _loadMore = false;

  @override
  void initState() {
    super.initState();
    getCommentsFromApi(start, 12).then((value) => {
          this.setState(() {
            start = start + 12;
            _comments.addAll(value);
          })
        });
    _scrollController = new ScrollController()..addListener(listenerScrollView);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController?.removeListener(listenerScrollView);
  }

  void listenerScrollView() {
    double? position = _scrollController?.position.extentAfter;
    if (position != null && position < 200 && !_loadMore) {
      this.setState(() {
        _loadMore = true;
      });
      handleLoadMore();
    }
  }

  void handleLoadMore() {
    getCommentsFromApi(start, 12).then((value) => {
          this.setState(() {
            start = start + 12;
            _comments.addAll(value);
            _loadMore = false;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: _comments.length + 1,
                  controller: _scrollController,
                  itemBuilder: (BuildContext context, int index) {
                    if (index > _comments.length - 1) {
                      if (_loadMore) {
                        return Container(
                          alignment: Alignment.center,
                          child: Center(
                            child: SizedBox(
                                width: 25,
                                height: 25,
                                child: CircularProgressIndicator()),
                          ),
                        );
                      } else {
                        return SizedBox(width: 0, height: 0);
                      }
                    }
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      margin: EdgeInsets.symmetric(vertical: 10),
                      color: index % 2 == 0 ? Colors.white : Colors.grey,
                      child: Row(
                        children: [
                          Text(_comments[index].id.toString()),
                          Expanded(
                              child: Container(
                                  child: Column(
                                    children: [
                                      Text(_comments[index].name ?? "",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Padding(
                                        child:
                                            Text(_comments[index].body ?? ""),
                                        padding: EdgeInsets.only(top: 10),
                                      )
                                    ],
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                  ),
                                  padding: EdgeInsets.only(left: 10)))
                        ],
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}
