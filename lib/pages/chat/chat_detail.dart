import 'package:flutter/material.dart';
import 'package:music/component/global/color.dart';
import 'package:scoped_model/scoped_model.dart';

import 'chat_input.dart';

class ChatDetail extends StatelessWidget {
  final int targetUserId = 100;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LongColor.chat_app_bar,
      resizeToAvoidBottomInset: false,
      body: _BoxWithBottomChatController(
        _ChatDetailTitle(targetUserId: 1232)
      )
    );
  }
}

class _ChatDetailTitle extends StatelessWidget {
  final int targetUserId;
  const _ChatDetailTitle({Key key, @required this.targetUserId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: AppBar(
        elevation: 0,
        primary: false,
        leading: IconButton(
            tooltip: '返回上一层',
            icon: Icon(
              Icons.arrow_back,
              color: LongColor.chat_font_theme,
            ),
            onPressed: () => Navigator.pop(context)),
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '陈一发',
              style: TextStyle(fontSize: 18, color: LongColor.chat_font_theme),
            ),
          ]
        ),
        backgroundColor: LongColor.chat_app_bar,
      ),
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
    return Column(
      children: <Widget>[
        Expanded(child: child),
        _BottomChatControllerBar(),
        SizedBox(height: media.viewInsets.bottom)
      ],
    );
  }
}

///底部当前音乐播放控制栏
// class _BottomChatControllerBar extends StatelessWidget {
//   const _BottomChatControllerBar({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       child: Card(
//         margin: const EdgeInsets.all(0),
//         shape: const RoundedRectangleBorder(
//             borderRadius:
//                 const BorderRadius.only(topLeft: const Radius.circular(4.0), topRight: const Radius.circular(4.0))),
//         child: Container(
//           height: 56,
//           child: Row(
//             children: <Widget>[
//               Hero(
//                 tag: "album_cover",
//                 child: Container(
//                   padding: const EdgeInsets.all(8),
//                   child: AspectRatio(
//                     aspectRatio: 1,
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.all(Radius.circular(3)),
//                       child: Container(color: Colors.grey)
//                     ),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: DefaultTextStyle(
//                   style: TextStyle(),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Spacer(),
//                       Text(
//                         '你好',
//                         style: Theme.of(context).textTheme.body1,
//                       ),
//                       Padding(padding: const EdgeInsets.only(top: 2)),
//                       Spacer(),
//                     ],
//                   ),
//                 ),
//               ),
//               // _PauseButton(),
//               IconButton(
//                   tooltip: "当前播放列表",
//                   icon: Icon(Icons.menu),
//                   onPressed: () {
//                   }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class _BottomChatControllerBar extends StatelessWidget {
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
          Padding(padding: EdgeInsets.only(left: 16)),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              child: Container(
                height: 45,
                alignment: Alignment.centerLeft,
                // color: Colors.blue[600],
                decoration: BoxDecoration(
                  color: Colors.white,
                  // border: Border.all(color: Colors.black12, width: 1)///边框颜色、宽
                ),
                child: TextField(
                  // controller: _queryTextController,
                  // focusNode: _focusNode,
                  // style: theme.primaryTextTheme.title,
                  textInputAction: TextInputAction.search,
                  style: TextStyle(fontSize: 18),
                  // onSubmitted: (String _) => _search(query),
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    hintStyle: theme.primaryTextTheme.title,
                    hintText: MaterialLocalizations.of(context).searchFieldLabel
                  )
                ),
              )
            ),
            // child: Container(
            //   height: 45,
            //   alignment: Alignment.centerLeft,
            //   // color: Colors.blue[600],
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     // border: Border.all(color: Colors.black12, width: 1)///边框颜色、宽
            //   ),
            //   child: TextField(
            //     // controller: _queryTextController,
            //     // focusNode: _focusNode,
            //     // style: theme.primaryTextTheme.title,
            //     textInputAction: TextInputAction.search,
            //     // onSubmitted: (String _) => _search(query),
            //     decoration: InputDecoration(
            //       fillColor: Colors.white,
            //       border: InputBorder.none,
            //       hintStyle: theme.primaryTextTheme.title,
            //       hintText: MaterialLocalizations.of(context).searchFieldLabel
            //     )
            //   ),
            // )
          ),
          Padding(padding: EdgeInsets.only(left: 16)),
        ]
      )
    );
    
  }
}

class NeteaseSearchPage extends StatefulWidget {
  final Animation<double> animation;

  const NeteaseSearchPage({Key key, @required this.animation}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NeteaseSearchPageState();
  }
}

class _NeteaseSearchPageState extends State<NeteaseSearchPage> {
  final TextEditingController _queryTextController = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  String get query => _queryTextController.text;

  set query(String value) {
    assert(value != null);
    _queryTextController.text = value;
  }


  bool initialState = true;


  @override
  void initState() {
    super.initState();
    _queryTextController.addListener(_onQueryTextChanged);
    widget.animation.addStatusListener(_onAnimationStatusChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _queryTextController.removeListener(_onQueryTextChanged);
    widget.animation.removeStatusListener(_onAnimationStatusChanged);
    _focusNode.removeListener(_onFocusChanged);
    super.dispose();
  }

  ChatInput _searchHistory = ChatInput();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    Widget tabs;

    return ScopedModel<ChatInput>(
      model: _searchHistory,
      child: Stack(
        children: <Widget>[
          DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: theme.primaryColor,
                iconTheme: theme.primaryIconTheme,
                textTheme: theme.primaryTextTheme,
                brightness: theme.primaryColorBrightness,
                leading: BackButton(),
                title: TextField(
                  controller: _queryTextController,
                  focusNode: _focusNode,
                  style: theme.primaryTextTheme.title,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (String _) => _search(query),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: theme.primaryTextTheme.title,
                      hintText: MaterialLocalizations.of(context).searchFieldLabel),
                ),
                actions: buildActions(context),
                bottom: tabs,
              ),
              resizeToAvoidBottomInset: false,
              // body: _BoxWithBottomChatController(),
            ),
          ),
          SafeArea(child: Padding(padding: EdgeInsets.only(top: kToolbarHeight), ))
        ],
      ),
    );
  }

  ///start search for keyword
  void _search(String query) {
    if (query.isEmpty) {
      return;
    }
    _searchHistory.insertSearchHistory(query);
    _focusNode.unfocus();
    setState(() {
      initialState = false;
      // _searchedQuery = query;
      this.query = query;
    });
  }

  void _onQueryTextChanged() {
    setState(() {
      // rebuild ourselves because query changed.
    });
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status != AnimationStatus.completed) {
      return;
    }
    widget.animation.removeStatusListener(_onAnimationStatusChanged);
    //we need request focus on text field when first in
    FocusScope.of(context).requestFocus(_focusNode);
  }

  void _onFocusChanged() {
    setState(() {});
  }

  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      query.isEmpty
          ? null
          : IconButton(
              tooltip: '清除',
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
              },
            )
    ]..removeWhere((v) => v == null);
  }

  // Widget buildSuggestions(BuildContext context) {
  //   if (query.isEmpty || !isSoftKeyboardDisplay(MediaQuery.of(context)) || !_focusNode.hasFocus) {
  //     return Container(height: 0, width: 0);
  //   }
  //   return SuggestionOverflow(
  //     query: query,
  //     onSuggestionSelected: (keyword) {
  //       query = keyword;
  //       _search(query);
  //     },
  //   );
  // }
}