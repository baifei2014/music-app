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
        'publish_time': '3小时前',
        'content': '春天来了，还没有褪去冬天的冷，还没有百花争奇斗艳，有的还只是秋天的萧瑟，还在等，等春天的雨水，等春天的嫩芽',
        "id": i,
        "avatarUrl": "https://oss.likecho.com/user_avatar/109951164462932601.jpg",
        "msgType": "text",
        // 'content': '你好，我是小沈阳',
      });
      dynamicList.add({
        "name": "陈一发",
        'publish_time': '刚刚',
        'content': '节日快乐',
        "id": i+1,
        "avatarUrl": "http://p1.music.126.net/AlmamjLHkrppEmpP37N74g==/109951164770785633.jpg",
        "msgType": "text_image",
        // 'content': {
        //   'text': '肖申呀昂',
        //   'imageList': [
        //     "http://p1.music.126.net/AlmamjLHkrppEmpP37N74g==/109951164770785633.jpg",
        //     "https://oss.likecho.com/user_avatar/109951164462932601.jpg"
        //     "http://p1.music.126.net/AlmamjLHkrppEmpP37N74g==/109951164770785633.jpg",
        //     "https://oss.likecho.com/user_avatar/109951164462932601.jpg"
        //     "http://p1.music.126.net/AlmamjLHkrppEmpP37N74g==/109951164770785633.jpg",
        //     "https://oss.likecho.com/user_avatar/109951164462932601.jpg"
        //     "http://p1.music.126.net/AlmamjLHkrppEmpP37N74g==/109951164770785633.jpg",
        //     "https://oss.likecho.com/user_avatar/109951164462932601.jpg"
        //   ]
        // },
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
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6))
              ),
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
    List imageItems = [
      {
        'url': 'https://oss.likecho.com/user_avatar/109951164462932601.jpg'
      },
      {
        'url': 'https://oss.likecho.com/user_avatar/109951164462932601.jpg'
      },
      {
        'url': 'https://oss.likecho.com/user_avatar/109951164462932601.jpg'
      },
      {
        'url': 'https://oss.likecho.com/user_avatar/109951164462932601.jpg'
      },
      {
        'url': 'https://oss.likecho.com/user_avatar/109951164462932601.jpg'
      },
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        
        Text(
          contentInfo['name'],
          style: TextStyle(
            color: Color(0xff2C3E50),
            fontSize: 16,
            fontWeight: FontWeight.w500
          ),
        ),
        Text(
          contentInfo['publish_time'],
          style: TextStyle(
            color: Colors.black26,
            fontSize: 12,
            // fontWeight: FontWeight.w500
          ),
        ),
        SizedBox(height: 4,),
        Text(
          contentInfo['content'],
          style: TextStyle(
            fontSize: 14,
            // fontWeight: FontWeight.w500
          ),
        ),
        SizedBox(height: 10,),
        Container(
          child: Flow(
            delegate: ImageFlowDelegate(
              count: imageItems.length,
            ),
            children: imageItems.map<Widget>((image) => flowImageItem(image)).toList(),
          ),
        )
      ],
    );
  }

  Widget flowImageItem(Map image) {
    return ClipRRect(
      // borderRadius: BorderRadius.all(Radius.circular(2)),
      child: FadeInImage(
        placeholder: AssetImage("assets/playlist_playlist.9.png"),
        image: CachedImage(image['url']),
        fit: BoxFit.cover,
      ),
    );
  }

  // flowImageItem() {

  // }
}

class ImageFlowDelegate extends FlowDelegate {
  final int count;
  final double gap;
  ImageFlowDelegate({
    @required this.count,
    this.gap = 5.0,
  });

  var columns = 3;
  var rows = 3;
  double itemW = 0;
  double itemH = 0;
  double totalW = 0;

  @override
  void paintChildren(FlowPaintingContext context) {
    var x = 0.0;
    var y = 0.0;

    /// 需要重新计算,解决刷新值为0的问题
    getItemSize();
    getColumnsNumber(count);
    totalW = (itemW * rows) + (gap * (rows + 1));

    //计算每一个子widget的位置 
    for (var i = 0; i < count; i++) {
      var w = context.getChildSize(i).width + x;
      if (w < totalW) {
        context.paintChild(i,
            transform: new Matrix4.translationValues(
                x, y, 0.0));
        x += context.getChildSize(i).width + gap;
      } else {
        x = 0.0;
        y += context.getChildSize(i).height + gap;
        context.paintChild(i,
            transform: new Matrix4.translationValues(
                x, y, 0.0));
        x += context.getChildSize(i).width + gap;
      }
    }
  }
  
  getColumnsNumber(int length) {
    if (length == 4) {
      columns = 2;
      rows = 2;
    } else {
      rows = 3;
      if (length % 3 == 0) {
        columns = length ~/ 3;
      } else {
        columns = (length ~/ 3 + 1);
      }
    }
  }

  getItemSize() {
    if (count == 1) {
      itemW = 120;
      itemH = 120;
    }else if (count <= 3){
      itemW = 80;
      itemH = 80;
    }else if (count <= 6) {
      itemW = 70;
      itemH = 70;
      if (count == 4) {
        itemW = 80;
        itemH = 80;
      }
    } else {
      itemW = 60;
      itemH = 60;
    }
  }

  /// 设置每个子view的size
  getConstraintsForChild(int i, BoxConstraints constraints) {
    getItemSize();
    return BoxConstraints(
      minWidth: itemW,
      minHeight: itemH,
      maxWidth: itemW,
      maxHeight: itemH
    );

  }

  /// 设置flow的size
  getSize(BoxConstraints constraints){ 
    getColumnsNumber(count);
    getItemSize();
    double h = (columns * itemH) + ((columns - 1) * gap);
    totalW = (itemW * rows) + (gap * (rows + 1));
    return Size(totalW, h);
  }
  
  @override
  bool shouldRepaint(FlowDelegate oldDelegate) {
    return oldDelegate != this;
  }
}