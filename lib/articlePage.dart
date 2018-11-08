import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/articleModel.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:dio/dio.dart';

class ArticleScreen extends StatefulWidget {
  final String fid;
  final String articleTitle;

  ArticleScreen({
    @required this.fid,
    this.articleTitle,
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
    Response apiResponse;
    Dio dio = new Dio();
    apiResponse = await dio.get('https://tips.kangzubin.com/api/feed/detail?fid=${widget.fid}');
    var art = apiResponse.data['data']['feed'];

    setState(() {
      article = feed.fromJson(art);
      content = '## **${article.title}** \n##### *作者：${article.author}*\n--- \n--- \n' + article.content;
    });
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text("${widget.articleTitle}"),),
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
