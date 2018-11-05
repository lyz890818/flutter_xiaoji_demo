import 'dart:convert' show json;

class feed {

  int favor;
  String author;
  String content;
  String fid;
  String platform;
  String postdate;
  String title;
  String type;
  String url;

  feed.fromParams({this.favor, this.author, this.content, this.fid, this.platform, this.postdate, this.title, this.type, this.url});

  factory feed(jsonStr) => jsonStr == null ? null : jsonStr is String ? new feed.fromJson(json.decode(jsonStr)) : new feed.fromJson(jsonStr);

  feed.fromJson(jsonRes) {
    favor = jsonRes['favor'];
    author = jsonRes['author'];
    content = jsonRes['content'];
    fid = jsonRes['fid'];
    platform = jsonRes['platform'];
    postdate = jsonRes['postdate'];
    title = jsonRes['title'];
    type = jsonRes['type'];
    url = jsonRes['url'];
  }

  @override
  String toString() {
    return '{"favor": $favor,"author": ${author != null?'${json.encode(author)}':'null'},"content": ${content != null?'${json.encode(content)}':'null'},"fid": ${fid != null?'${json.encode(fid)}':'null'},"platform": ${platform != null?'${json.encode(platform)}':'null'},"postdate": ${postdate != null?'${json.encode(postdate)}':'null'},"title": ${title != null?'${json.encode(title)}':'null'},"type": ${type != null?'${json.encode(type)}':'null'},"url": ${url != null?'${json.encode(url)}':'null'}}';
  }
}

