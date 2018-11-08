import 'dart:convert';
import 'dart:io';
import 'package:flutter_app/model/feedsModel.dart';
import 'package:flutter/material.dart';
import 'articlePage.dart';
import 'package:loadmore/loadmore.dart';


void main() {
  runApp(new MaterialApp(home: new MyApp(), routes: <String, WidgetBuilder>{
    'ArticleScreen': (BuildContext context) => new ArticleScreen(fid: '1'),
  }));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  feedsModel model;
  final List<ArticalCell> _cell = <ArticalCell>[];
  var pageIndex = 1;
  @override
  void initState() {
    super.initState();
    _getArticleList(1);
  }

  _getArticleList(int page) async {
    var url =
        'https://tips.kangzubin.com/api/feed/list?page=${page}&filter=tips';
    var httpClient = new HttpClient();

    var result;
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        var json = await response.transform(utf8.decoder).join();
        var data = jsonDecode(json);
        result = data['data'];
        print(data);
      } else {
        result = 'Error\nHttp status ${response.statusCode}';
      }
    } catch (exception) {
      result = 'Failed';
    }

    // If the widget was removed from the tree while the message was in flight,
    // we want to discard the reply rather than calling setState to update our
    // non-existent appearance.
    if (!mounted) return;

    setState(() {
      model = feedsModel.fromJson(result);
      for (int i = 0; i < model.feeds.length; i++) {
        ArticalCell cell = new ArticalCell(
          articleModel: model.feeds[i],
        );
        setState(() {
          _cell.add(cell);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("知识"),
      ),
      body: new Column(
        children: <Widget>[
          new Flexible(
            child: RefreshIndicator(
              child: LoadMore(
                  child: new ListView.builder(
                    padding: new EdgeInsets.all(8.0),
                    reverse: false,
                    itemBuilder: (_, int index) => _cell[index],
                    itemCount: _cell.length,
                  ),
                  onLoadMore: _onLoadMore),
              onRefresh: _onRefresh,
            ),
          ),
          new Divider(
            height: 10.0,
            color: Color.fromRGBO(243, 243, 243, 0),
          ),
        ],
      ),
    );
  }

  //下拉刷新
  Future<Null> _onRefresh() async {
    pageIndex = 1;
    _cell.clear();
    await _getArticleList(1);
    return;
  }

  Future<Null> _onLoadMore() async {
    pageIndex = pageIndex + 1;
    await _getArticleList(pageIndex);
    return;
  }
}

class ArticalCell extends StatelessWidget {
  ArticalCell({this.articleModel});
  article articleModel;

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: Card(
        elevation: 5.0,
        margin: EdgeInsets.only(top: 5.0, bottom: 15.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          padding: EdgeInsets.only(bottom: 0.0, top: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                padding: EdgeInsets.only(top: 8.0, left: 10.0, right: 10.0),
                height: 60.0,
                child: new Text(articleModel.title,
                    maxLines: 2, textAlign: TextAlign.left),
              ),
              new Container(
                padding: EdgeInsets.all(0.0),
                height: 1.0,
                color: Colors.black12,
              ),
              new Container(
                decoration: new BoxDecoration(
                  color: Color.fromRGBO(234, 234, 234, 1),
                  borderRadius: new BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0)),
                ),
                padding: EdgeInsets.only(left: 10.0),
                height: 20.0,
                child: new Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(right: 5.0),
                      child: new Text(
                        articleModel.postdate,
                        maxLines: 1,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    new Text('@${articleModel.author}',
                        style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.push(context,
            new MaterialPageRoute(builder: (BuildContext context) {
          return new ArticleScreen(fid: articleModel.fid);
        }));
      },
    );
  }
}
