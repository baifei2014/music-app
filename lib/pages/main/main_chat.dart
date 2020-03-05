import 'package:flutter/material.dart';
import 'package:music/component/route.dart';
import 'package:music/material/my_icons.dart';
import 'package:music/part/part.dart';
import 'package:music/repository/cached_image.dart';
import 'package:overlay_support/overlay_support.dart';

class MainChatPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChatPageState();
}

class User {
  String name;
  String avatarUrl;

  User({this.name, this.avatarUrl});
}

class ChatPageState extends State<MainChatPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<Map> menuList;
  List<Map> friendList;

  void initState() {
    super.initState();
    menuList = new List();
    menuList.add({"title": '新的朋友', "icon": MyIcons.icon_morenzhuangtai_xindepengyou, "color": Color(0xFFffa400)});
    menuList.add({"title": '群聊', "icon": MyIcons.icon_qunliao, "color": Color(0xFF00e079)});
    menuList.add({"title": '标签', "icon": MyIcons.icon_biaoqian, "color": Color(0xFF4b5cc4)});
    friendList = new List();
    friendList.add({"name": "龙豪", "avatarUrl": "https://oss.likecho.com/user_avatar/109951164462932601.jpg"});
    friendList.add({"name": "陈一发", "avatarUrl": "http://p1.music.126.net/AlmamjLHkrppEmpP37N74g==/109951164770785633.jpg"});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      children: <Widget>[
        _MenulistGroup.serializeFriendlist(menuList),
        Container(height: 16, color: Theme.of(context).dividerColor),
        _FriendlistGroup.serializeFriendlist(friendList),
      ]
    );


        // _NavigationLine(),
        // _Header("推荐歌单", () {}),
//        _SectionPlaylist(),
        // _Header("最新音乐", () {}),
//        _SectionNewSongs(),
  }
}

class _FriendlistGroup extends StatefulWidget {
  List<Widget> children;
  _FriendlistGroup(this.children) : assert(children != null);
  _FriendlistGroup.serializeFriendlist(List<Map> list) : this(list.map((p) => _FriendItemTileDivider(p)).toList());

  @override
  _FriendListGroupState createState() => _FriendListGroupState();
}

class _FriendListGroupState extends State<_FriendlistGroup> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Column(children: widget.children);
  }
}

class _FriendItemTileDivider extends StatelessWidget{
  final Map data;

  _FriendItemTileDivider(this.data);

  @override
  Widget build(BuildContext context) {
    Widget cover = Container(
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        child: FadeInImage(
          placeholder: AssetImage("assets/playlist_playlist.9.png"),
          image: CachedImage(data['avatarUrl']),
          fit: BoxFit.cover,
          height: 40,
          width: 40,
        ),
      ),
    );

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatDetail()
            ));
      },
      child: Container(
        height: 60,
        child: Row(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(left: 16)),
            cover,
            Padding(padding: EdgeInsets.only(left: 16)),
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black12, width: 1))///边框颜色、宽
                ),
                child: Row(children: <Widget>[
                  Text(
                    data['name'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 15),
                  ),
                ],)
              ),
            ),
          ]
        )
      )
    );
  }
}

class _MenulistGroup extends StatefulWidget {
  List<Widget> children;
  _MenulistGroup(this.children) : assert(children != null);
  _MenulistGroup.serializeFriendlist(List<Map> list) : this(list.map((p) => _MenuItemTileDivider(p)).toList());

  @override
  _MenulistGroupState createState() => _MenulistGroupState();
}

class _MenulistGroupState extends State<_MenulistGroup> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Column(children: widget.children);
  }
}

class _MenuItemTileDivider extends StatelessWidget {
  final Map menu;

  _MenuItemTileDivider(this.menu);

  @override
  Widget build(BuildContext context) {
    Widget cover = Container(
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        child: Container(
          width: 40,
          height: 40,
          color: menu['color'],
          child: Icon(
            menu['icon'],
            color: Theme.of(context).primaryIconTheme.color,
          ),
        ),
      ),
    );
    return InkWell(
      child: Container(
        height: 60,
        child: Row(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(left: 16)),
            cover,
            Padding(padding: EdgeInsets.only(left: 16)),
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black12, width: 1))///边框颜色、宽
                ),
                child: Row(children: <Widget>[
                  Text(
                    menu['title'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 15),
                  ),
                ],)
              ),
            ),
          ]
        )
      )
    );
  }
}

class _MenuItemLine extends StatelessWidget {
  final String title;

  final IconData icon;

  final Color color;

  _MenuItemLine({this.title, this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    Widget cover = Container(
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        child: Container(
          width: 40,
          height: 40,
          color: color,
          child: Icon(
            icon,
            color: Theme.of(context).primaryIconTheme.color,
          ),
        ),
      ),
    );

    return InkWell(
      child: Container(
        height: 60,
        child: Row(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(left: 16)),
            cover,
            Padding(padding: EdgeInsets.only(left: 16)),
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black12, width: 1))///边框颜色、宽
                ),
                child: Row(children: <Widget>[
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 15),
                  ),
                ],)
              ),
            ),
          ]
        ),
      ),
    );
  }
}

class _NavigationLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _ItemNavigator(Icons.radio, "私人FM", () {
            toast('页面未完成');
          }),
          _ItemNavigator(Icons.today, "每日推荐", () {
            Navigator.pushNamed(context, ROUTE_DAILY);
          }),
          _ItemNavigator(Icons.show_chart, "排行榜", () {
            Navigator.pushNamed(context, ROUTE_LEADERBOARD);
          }),
        ],
      ),
    );
  }
}

///common header for section
class _Header extends StatelessWidget {
  final String text;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left: 8)),
          Text(
            text,
            style: Theme.of(context)
                .textTheme
                .subhead
                .copyWith(fontWeight: FontWeight.w800),
          ),
          Icon(Icons.chevron_right),
        ],
      ),
    );
  }

  _Header(this.text, this.onTap);
}

class _ItemNavigator extends StatelessWidget {
  final IconData icon;

  final String text;

  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            children: <Widget>[
              Material(
                shape: CircleBorder(),
                elevation: 5,
                child: ClipOval(
                  child: Container(
                    width: 40,
                    height: 40,
                    color: Theme.of(context).primaryColor,
                    child: Icon(
                      icon,
                      color: Theme.of(context).primaryIconTheme.color,
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 8)),
              Text(text),
            ],
          ),
        ));
  }

  _ItemNavigator(this.icon, this.text, this.onTap);
}
