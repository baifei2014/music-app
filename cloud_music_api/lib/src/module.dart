import 'dart:async';
import 'dart:core';
import 'dart:io';


import 'answer.dart';
import 'util/request.dart';

part 'module/user.dart';
part 'module/playlist.dart';
part 'module/song.dart';
part 'module/chat.dart';

typedef Handler = Future<Answer> Function(Map query, List<Cookie> cookie);

final handles = <String, Handler>{
  "/user/playlist": user_playlist,
  "/playlist/detail": playlist_detail,
  "/song/url": song_url,
  "/chat/friendlist": chat_friendlist,
  "/chat/messagelist": chat_messagelist,
};
