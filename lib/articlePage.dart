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
  String content;

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
      content = '## **${article.title}** \n##### *作者：${article.author}*\n--- \n--- \n' + article.content;
    });
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text("小集"),),
      body: new Markdown(
        data: article == null ? '' : content,
        onTapLink: _onClickUrl,
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
