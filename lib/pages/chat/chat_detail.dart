import 'package:flutter/material.dart';
import 'package:music/component/global/color.dart';
import 'package:music/part/part.dart';
import 'package:music/repository/cached_image.dart';
import 'package:music/repository/netease.dart';

class ChatDetailPage extends StatefulWidget {
  final String name;
  final String groupId;

  ChatDetailPage(this.name, this.groupId) : assert(name != null, groupId != null);

  State<StatefulWidget> createState() => ChatDetailPageState();
}

class ChatDetailPageState extends State<ChatDetailPage> {
  @override
  Widget build(BuildContext context) {
    print('聊天详情页内容 : \n');
    print(context);
    return Scaffold(
      backgroundColor: LongColor.chat_app_bar,
      resizeToAvoidBottomInset: false,
      body: _BoxWithBottomChatController(
        Loader(
          loadTask: () => neteaseRepository.chatMessagelist(widget.groupId),
          builder: (context, result) {
            return _MainChatDetailPage(widget.name, result);
          },
        ),
      )
    );
  }
}

class _MainChatDetailPage extends StatefulWidget {
  final String name;
  final List<Map> messagelist;
  _MainChatDetailPage(this.name, this.messagelist) : assert(name != null, messagelist != null);
  @override
  _MainChatDetailPageState createState() {
     return new _MainChatDetailPageState();
  }
}

class _MainChatDetailPageState extends State<_MainChatDetailPage> {
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
          widget.name,
          style: TextStyle(fontSize: 18, color: LongColor.chat_font_theme),
        ),
        backgroundColor: LongColor.chat_app_bar,
      ),
      backgroundColor: LongColor.chat_app_bar,
      body: CustomScrollView(
          reverse: true,
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) => ChatMsgTile(widget.messagelist[index]),
                  childCount: widget.messagelist.length),
            ),
          ]
        ),
    );
  }
}

class ChatMsgTile extends StatelessWidget {
  final Map msg;

  final msgStyle = {
    'self': {
      'color': LongColor.msg_background_color,
      'textDirection': TextDirection.rtl
    },
    'other': {
      'color': Colors.white,
      'textDirection': TextDirection.ltr
    }
  };

  ChatMsgTile(this.msg, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        textDirection: msg['is_self'] ? msgStyle['self']['textDirection'] : msgStyle['other']['textDirection'],
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left: 16)),
          cover,
          Padding(padding: EdgeInsets.only(left: 8)),
          
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              decoration: BoxDecoration(
                color: msg['is_self'] ? msgStyle['self']['color'] : msgStyle['other']['color'],
                borderRadius: BorderRadius.all(Radius.circular(6))
              ),
              child: Text(
                msg['content'],
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