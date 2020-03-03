import 'package:flutter/material.dart';
import 'package:music/component/player/bottom_player_bar.dart';
import 'package:music/component/route.dart';
import 'package:music/pages/main/main_playlist.dart';
import 'package:overlay_support/overlay_support.dart';

import 'main_cloud.dart';

part 'drawer.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  TabController _tabController;
  TextStyle _labelStyle;
  TextStyle _unselectedLabelStyle;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ProxyAnimation transitionAnimation = ProxyAnimation(kAlwaysDismissedAnimation);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _labelStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
    _unselectedLabelStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.normal);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
            icon: AnimatedIcon(
                icon: AnimatedIcons.menu_arrow,
                color: Theme.of(context).primaryIconTheme.color,
                progress: transitionAnimation),
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            }),
        title: Container(
          height: kToolbarHeight,
          width: 128,
          child: TabBar(
            controller: _tabController,
            labelStyle: _labelStyle,
            unselectedLabelStyle: _unselectedLabelStyle,
            indicator: UnderlineTabIndicator(),
            tabs: <Widget>[
//              Tab(child: Icon(Icons.music_note)),
//              Tab(child: Icon(Icons.cloud)),
              Tab(text: "我的"),
              Tab(text: '发现'),
            ],
          ),
        ),
        titleSpacing: 0,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
              onPressed: () {
                toast('年后');
              }
          )
        ],
      ),
      body: BoxWithBottomPlayerController(TabBarView(
        controller: _tabController,
        children: <Widget>[MainPlaylistPage(), MainCloudPage()],
      )),
    );
  }
}

