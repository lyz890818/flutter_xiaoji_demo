import 'dart:convert' show json;

class feedsModel {

  List<article> feeds;
  topButtonContent topButton;

  feedsModel.fromParams({this.feeds, this.topButton});

  factory feedsModel(jsonStr) => jsonStr == null ? null : jsonStr is String ? new feedsModel.fromJson(json.decode(jsonStr)) : new feedsModel.fromJson(jsonStr);

  feedsModel.fromJson(jsonRes) {
    feeds = jsonRes['feeds'] == null ? null : [];

    for (var feedsItem in feeds == null ? [] : jsonRes['feeds']){
      feeds.add(feedsItem == null ? null : new article.fromJson(feedsItem));
    }

    topButton = jsonRes['topButton'] == null ? null : new topButtonContent.fromJson(jsonRes['topButton']);
  }

  @override
  String toString() {
    return '{"feeds": $feeds,"topButton": $topButton}';
  }
}

class topButtonContent {

  String appid;
  String target;
  String title;

  topButtonContent.fromParams({this.appid, this.target, this.title});

  topButtonContent.fromJson(jsonRes) {
    appid = jsonRes['appid'];
    target = jsonRes['target'];
    title = jsonRes['title'];
  }

  @override
  String toString() {
    return '{"appid": ${appid != null?'${json.encode(appid)}':'null'},"target": ${target != null?'${json.encode(target)}':'null'},"title": ${title != null?'${json.encode(title)}':'null'}}';
  }
}

class article {

  String author;
  String fid;
  String platform;
  String postdate;
  String title;
  String url;

  article.fromParams({this.author, this.fid, this.platform, this.postdate, this.title, this.url});

  article.fromJson(jsonRes) {
    author = jsonRes['author'];
    fid = jsonRes['fid'];
    platform = jsonRes['platform'];
    postdate = jsonRes['postdate'];
    title = jsonRes['title'];
    url = jsonRes['url'];
  }

  @override
  String toString() {
    return '{"author": ${author != null?'${json.encode(author)}':'null'},"fid": ${fid != null?'${json.encode(fid)}':'null'},"platform": ${platform != null?'${json.encode(platform)}':'null'},"postdate": ${postdate != null?'${json.encode(postdate)}':'null'},"title": ${title != null?'${json.encode(title)}':'null'},"url": ${url != null?'${json.encode(url)}':'null'}}';
  }
}

