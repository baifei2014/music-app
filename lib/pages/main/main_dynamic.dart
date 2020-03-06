import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:music/component/global/color.dart';
import 'package:music/repository/cached_image.dart';

class MainDynamicPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DynamicPageState();
}

class DynamicPageState extends State<MainDynamicPage> with AutomaticKeepAliveClientMixin {

  List dynamicList;

  void initState() {
    super.initState();
    dynamicList = new List();
    for (var i = 0; i < 10; i = i+2) {
      dynamicList.add({
        "name": "龙豪",
        "id": i,
        "avatarUrl": "https://oss.likecho.com/user_avatar/109951164462932601.jpg",
        "msgType": "text",
        'content': '你好，我是小沈阳',
      });
      dynamicList.add({
        "name": "陈一发",
        "id": i+1,
        "avatarUrl": "http://p1.music.126.net/AlmamjLHkrppEmpP37N74g==/109951164770785633.jpg",
        "msgType": "text_image",
        'content': {
          'text': '肖申呀昂',
          'imageList': [
            "http://p1.music.126.net/AlmamjLHkrppEmpP37N74g==/109951164770785633.jpg",
            "https://oss.likecho.com/user_avatar/109951164462932601.jpg"
            "http://p1.music.126.net/AlmamjLHkrppEmpP37N74g==/109951164770785633.jpg",
            "https://oss.likecho.com/user_avatar/109951164462932601.jpg"
            "http://p1.music.126.net/AlmamjLHkrppEmpP37N74g==/109951164770785633.jpg",
            "https://oss.likecho.com/user_avatar/109951164462932601.jpg"
            "http://p1.music.126.net/AlmamjLHkrppEmpP37N74g==/109951164770785633.jpg",
            "https://oss.likecho.com/user_avatar/109951164462932601.jpg"
          ]
        },
      });
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) => DynamicTile(dynamicList[index]),
                childCount: dynamicList.length),
          ),
        ]
      ),
    );
  }
}


class DynamicTile extends StatelessWidget {

  DynamicTile(this.dynamicInfo) : assert(dynamicInfo != null);

  final Map dynamicInfo;

  Widget build(BuildContext context) {

    Widget cover = Container(
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(2)),
        child: FadeInImage(
          placeholder: AssetImage("assets/playlist_playlist.9.png"),
          image: CachedImage(dynamicInfo['avatarUrl']),
          fit: BoxFit.cover,
          height: 40,
          width: 40,
        ),
      ),
    );
    
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 2),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: LongColor.under_line_color, width: 0.8))///边框颜色、宽
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left: 8)),
          cover,
          Padding(padding: EdgeInsets.only(left: 8)),
          
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6))
              ),
              // child: Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: <Widget>[
              //     DynamicContentPage(dynamicInfo),
              //   ]
              // )
              child: DynamicContentPage(dynamicInfo),
            )
            
          ),
        ]
      )
    );
  }
}


class DynamicContentPage extends StatelessWidget {

  final Map contentInfo;

  DynamicContentPage(this.contentInfo);

  @override
  Widget build(BuildContext context) {
    print(contentInfo);
    if (contentInfo['type'] == 'text') {
      Widget text = Text(contentInfo['content']);
      Widget viewCongent = Container(child: text,);
    }
    if (contentInfo['type'] == 'text_image') {
      Widget text = Text(contentInfo['content']['text']);
      List<Widget> imageList = new List();
      Widget image;
      Widget imageViewCongent;
      for (var i = 0; i < contentInfo['imageList'].length; i++) {
        image = ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          child: FadeInImage(
            placeholder: AssetImage("assets/playlist_playlist.9.png"),
            image: CachedImage(contentInfo['imageList'][i]),
            fit: BoxFit.cover,
            height: 40,
            width: 40,
          ),
        );
        imageList.add(image);
      }
      if (contentInfo['imageList'].length == 4) {
        imageViewCongent = GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, //横轴三个子widget
            childAspectRatio: 1.0 //宽高比为1时，子widget
          ),
          children: imageList
        );
      } else {
        imageViewCongent = GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, //横轴三个子widget
            childAspectRatio: 1.0 //宽高比为1时，子widget
          ),
          children: imageList
        );
      }
      Widget viewCongent = Wrap(
        children: <Widget>[
          text,
          imageViewCongent
        ],
      );
    }
    // print(viewCongent);
    // return Container(
    //   child: viewCongent,
    // );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        
        Text('年后'),
        Text('年年年年年后后后后年年年年后后后后年年年年年年后后后后年年年年年后后后后后后后后'),
        Container(
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, //横轴三个子widget
                childAspectRatio: 1.0 //宽高比为1时，子widget
            ),
            children:<Widget>[
              Icon(Icons.ac_unit),
              Icon(Icons.airport_shuttle),
              Icon(Icons.all_inclusive),
              Icon(Icons.beach_access),
              Icon(Icons.cake),
              Icon(Icons.free_breakfast)
            ]
          ),
        )
      ],
    );
  }
}