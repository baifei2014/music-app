import 'package:flutter/material.dart';
import 'package:music/pages/chat/chat_detail.dart';
import 'package:music/pages/main/page_main.dart';
import 'package:music/pages/player/page_playing.dart';

export 'package:music/pages/chat/chat_detail.dart';

const pageMain = Navigator.defaultRouteName;

///popup with [true] if login succeed
const pageLogin = "/login";

const ROUTE_PLAYLIST_DETAIL = "/playlist/detail";

const ROUTE_PAYING = "/playing";

const ROUTE_LEADERBOARD = "/leaderboard";

const ROUTE_DAILY = "/daily";

const ROUTE_MY_DJ = '/mydj';

const ROUTE_MY_COLLECTION = '/my_collection';

const ROUTE_SETTING = '/setting';

const ROUTE_SETTING_THEME = '/setting/theme';

const ROUTE_CHAT_DETAIL = '/chat/detail';

const pageWelcome = 'welcome';

///app routers
final Map<String, WidgetBuilder> routes = {
  pageMain: (context) => MainPage(),
//  pageLogin: (context) => LoginNavigator(),
  ROUTE_PAYING: (context) => PlayingPage(),
  ROUTE_CHAT_DETAIL: (context) => ChatDetail(),
//  ROUTE_LEADERBOARD: (context) => LeaderboardPage(),
//  ROUTE_DAILY: (context) => DailyPlaylistPage(),
//  ROUTE_MY_DJ: (context) => MyDjPage(),
//  ROUTE_MY_COLLECTION: (context) => MyCollectionPage(),
//  ROUTE_SETTING: (context) => SettingPage(),
//  ROUTE_SETTING_THEME: (context) => SettingThemePage(),
//  pageWelcome: (context) => PageWelcome(),
};

Route<dynamic> routeFactory(RouteSettings settings) {
  WidgetBuilder builder;

  if (builder != null) return MaterialPageRoute(builder: builder, settings: settings);

  assert(false, 'ERROR: can not generate Route for ${settings.name}');
  return null;
}
