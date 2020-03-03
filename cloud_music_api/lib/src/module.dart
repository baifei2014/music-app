import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:math' as math;


import 'answer.dart';
import 'util/request.dart';

part 'module/user.dart';
part 'module/playlist.dart';

typedef Handler = Future<Answer> Function(Map query, List<Cookie> cookie);

final handles = <String, Handler>{
  "/user/playlist": user_playlist,
  "/playlist/detail": playlist_detail,
};
