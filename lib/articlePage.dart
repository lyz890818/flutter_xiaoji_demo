import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/articleModel.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class ArticleScreen extends StatefulWidget {
  final String fid;

  ArticleScreen({
    @required this.fid,
  });

  @override
  ArticleScreenState createState() {
    return ArticleScreenState();
  }
}

class ArticleScreenState extends State<ArticleScreen> {
  feed article;

  @override
  void initState() {
    super.initState();
    _getArticle();
  }

  _getArticle() async {
    var url = 'https://tips.kangzubin.com/api/feed/detail?fid=${widget.fid}';
    var httpClient = new HttpClient();

    var result;
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        var json = await response.transform(utf8.decoder).join();
        var data = jsonDecode(json);
        result = data['data']['feed'];
        print(result);
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
      article = feed.fromJson(result);

    });
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
//      appBar: new AppBar(
//        title: new Text(''),
//      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          // These are the slivers that show up in the "outer" scroll view.
          return <Widget>[
            SliverOverlapAbsorber(
              // This widget takes the overlapping behavior of the SliverAppBar,
              // and redirects it to the SliverOverlapInjector below. If it is
              // missing, then it is possible for the nested "inner" scroll view
              // below to end up under the SliverAppBar even when the inner
              // scroll view thinks it has not been scrolled.
              // This is not necessary if the "headerSliverBuilder" only builds
              // widgets that do not overlap the next sliver.
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              child: SliverAppBar(
                title: const Text('小集'), // This is the title in the app bar.
                pinned: false,
                expandedHeight: 0.0,
                // The "forceElevated" property causes the SliverAppBar to show
                // a shadow. The "innerBoxIsScrolled" parameter is true when the
                // inner scroll view is scrolled beyond its "zero" point, i.e.
                // when it appears to be scrolled below the SliverAppBar.
                // Without this, there are cases where the shadow would appear
                // or not appear inappropriately, because the SliverAppBar is
                // not actually aware of the precise position of the inner
                // scroll views.
                forceElevated: innerBoxIsScrolled,

              ),
            ),
          ];
        },
          body: new Column(
            children: <Widget>[
              new Container(
                padding: EdgeInsets.all(0.0),
                child: new Text(article == null ? '' : article.title,style: TextStyle(fontSize: 20),textAlign: TextAlign.left),
                alignment: AlignmentDirectional.center,
                height: 60.0,
              ),
              new Divider(height: 1, color: Colors.black38),
              new Expanded(child: new Markdown(
                  data: article == null ? '' : article.content,
                  onTapLink: _onClickUrl,
              )),
            ],
          ),
      ),
    );
  }

  void _onClickUrl(String url) {
    Navigator.push(context,
        new MaterialPageRoute(builder: (BuildContext context) {
          return new WebviewScaffold(
              url: url,
              appBar: new AppBar(
              title: const Text(''),
          ),
          withZoom: true,
          withLocalStorage: true,);
        }));
  }
}
//
//new Column(
//children: <Widget>[
//new Text(article == null ? '' : article.title,style: TextStyle(fontSize: 20)),
//new Divider(height: 1, color: Colors.black38),
//new Expanded(child: new Markdown(data: article == null ? '' : article.content)),
//
//],
//),