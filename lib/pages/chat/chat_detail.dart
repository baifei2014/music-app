import 'package:flutter/material.dart';
import 'package:music/component/global/color.dart';
import 'package:music/part/part.dart';
import 'package:music/repository/cached_image.dart';
import 'package:music/repository/netease.dart';


class ChatDetail extends StatelessWidget {
  final int targetUserId = 100;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LongColor.chat_app_bar,
      resizeToAvoidBottomInset: false,
      body: _BoxWithBottomChatController(
        Loader(
          loadTask: () => neteaseRepository.playlistDetail(115392005),
          builder: (context, result) {
            return _MainChatDetailPage();
          },
        ),
      )
    );
  }
}

class _MainChatDetailPage extends StatefulWidget {
  @override
  _MainChatDetailPageState createState() {
     return new _MainChatDetailPageState();
  }
}

class _MainChatDetailPageState extends State {
  List msgList;

  @override
  void initState() {
    super.initState();
    msgList = new List();
    for (var i = 0; i < 8; i = i+2) {
      msgList.add({"color": LongColor.msg_background_color, "name": "还欧艾斯jhi我胡狗狗会有反弹固有反弹的态度与hihi一月份有覅", "msgAlign": Alignment.centerRight, "direct": TextDirection.rtl, "id": i, "avatarUrl": "https://oss.likecho.com/user_avatar/109951164462932601.jpg"});
      msgList.add({"color": Colors.white, "name": "陈一个IG与费用分摊联合会预付抚养费用过后会一分一分裕太妃突发故意法语翻译翻译和是交话费有覅一份发", "msgAlign": Alignment.centerLeft, "direct": TextDirection.ltr, "id": i+1, "avatarUrl": "http://p1.music.126.net/AlmamjLHkrppEmpP37N74g==/109951164770785633.jpg"});
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            tooltip: '返回上一层',
            icon: Icon(
              Icons.arrow_back,
              color: LongColor.chat_font_theme,
            ),
            onPressed: () => Navigator.pop(context)),
        titleSpacing: 0,
        title: Text(
          '陈一发',
          style: TextStyle(fontSize: 18, color: LongColor.chat_font_theme),
        ),
        backgroundColor: LongColor.chat_app_bar,
      ),
      backgroundColor: LongColor.chat_app_bar,
      body: CustomScrollView(
          reverse: true,
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) => ChatMsgTile(msgList[index]),
                  childCount: msgList.length),
            ),
          ]
        ),
    );
  }
}

class ChatMsgTile extends StatelessWidget {
  final Map msg;

  ChatMsgTile(this.msg, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(msg);
    Widget cover = Container(
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(2)),
        child: FadeInImage(
          placeholder: AssetImage("assets/playlist_playlist.9.png"),
          image: CachedImage(msg['avatarUrl']),
          fit: BoxFit.cover,
          height: 40,
          width: 40,
        ),
      ),
    );

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Row(
        textDirection: msg['direct'],
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left: 16)),
          cover,
          Padding(padding: EdgeInsets.only(left: 8)),
          
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              decoration: BoxDecoration(
                color: msg['color'],
                borderRadius: BorderRadius.all(Radius.circular(6))
              ),
              child: Text(
                msg['id'].toString() + msg['name'],
                // overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 15),
                softWrap: true,
                textAlign: TextAlign.justify
              )
            )
            
          ),
          SizedBox(width: 80,)
        ]
      )
    );
  }
}

class _BoxWithBottomChatController extends StatelessWidget {
  _BoxWithBottomChatController(this.child);

  final Widget child;

  @override
  Widget build(BuildContext context) {

    final media = MediaQuery.of(context);
    //hide bottom player controller when view inserts
    //bottom too height (such as typing with soft keyboard)
    print('box高度 :\n');
    print(media.viewInsets.bottom);
    return Column(
      children: <Widget>[
        Expanded(child: child),
        BottomChatBox(),
        
        SizedBox(height: media.viewInsets.bottom)
      ],
    );
  }
}


class BottomChatBox extends StatefulWidget {
  // final Animation<double> animation;

  const BottomChatBox({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BottomChatBoxState();
  }
}

// class _BottomChatControllerBar extends StatelessWidget {
class _BottomChatBoxState extends State {
  final TextEditingController _inputTextController = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  String get inputMsg => _inputTextController.text;

  set inputMsg(String value) {
    _inputTextController.text = value;
  }

  void _updateInputMsg(String msg) {
    if (msg.isEmpty) {
      return;
    }
    print('输入消息 :\n');
    print(msg);
    // _focusNode.unfocus();
    setState(() {
      this.inputMsg = msg;
    });
  }

  void flushInputMsg() {
    // _focusNode.unfocus();
    setState(() {
      this.inputMsg = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      height: 70,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12, width: 1)///边框颜色、宽
      ),
      child: Row(
        children: [
          Padding(padding: EdgeInsets.only(left: 12)),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              child: Container(
                height: 45,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: TextField(
                  controller: _inputTextController,
                  focusNode: _focusNode,
                  textInputAction: TextInputAction.search,
                  style: TextStyle(fontSize: 18),
                  // onSubmitted: (String _) => _search(query),
                  onChanged: (String _) => _updateInputMsg(inputMsg),
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    hintStyle: theme.primaryTextTheme.title,
                    hintText: MaterialLocalizations.of(context).searchFieldLabel,
                    contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0)
                  )
                ),
              )
            ),
          ),
          SizedBox(width: 16,),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            child: Container(
              height: 45,
              alignment: Alignment.center,
              child: RaisedButton(
                child: Text('发送', style: TextStyle(fontSize: 18),),
                onPressed: () {
                  flushInputMsg();
                },
                color: LongColor.button_primary_color,
                textColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 7, horizontal: 0)
              ),
            )
          ),
          Padding(padding: EdgeInsets.only(right: 12)),
        ]
      )
    );
  }
}