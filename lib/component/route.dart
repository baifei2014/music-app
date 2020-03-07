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


const pageWelcome = 'welcome';

///app routers
final Map<String, WidgetBuilder> routes = {
  pageMain: (context) => MainPage(),
  ROUTE_PAYING: (context) => PlayingPage(),
};

Route<dynamic> routeFactory(RouteSettings settings) {
  WidgetBuilder builder;

  if (builder != null) return MaterialPageRoute(builder: builder, settings: settings);

  assert(false, 'ERROR: can not generate Route for ${settings.name}');
  return null;
}
