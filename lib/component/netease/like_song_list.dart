import 'dart:async';

import 'package:flutter/material.dart';
import 'package:music/model/music.dart';
import 'package:music/pages/account/account.dart';
import 'package:music/repository/local_cache_data.dart';
import 'package:music/model/model.dart';
import 'package:music/part/part.dart';
import 'package:scoped_model/scoped_model.dart';

class LikedSongList extends Model {
  LikedSongList(UserAccount account) {
    int userId = 0;
    account.addListener(() {
      if (account.isLogin && account.userId != userId) {
        userId = account.userId;
        _loadUserLikedList(userId);
      } else if (!account.isLogin) {
        userId = 0;
        _ids = const [];
        notifyListeners();
      }
    });
  }

  void _loadUserLikedList(int userId) async {
    _ids =
        (await neteaseLocalData['likedSongList'] as List)?.cast() ?? const [];
    notifyListeners();
//    final result = await neteaseRepository.likedList(userId);
//    if (result.isValue) {
//      _ids = result.asValue.value;
//      notifyListeners();
//      neteaseLocalData['likedSongList'] = _ids;
//    }
  }

  List<int> _ids = const [];

  List<int> get ids => _ids;

  static LikedSongList of(BuildContext context,
      {bool rebuildOnChange = false}) {
    return ScopedModel.of<LikedSongList>(context,
        rebuildOnChange: rebuildOnChange);
  }

  static bool contain(BuildContext context, Music music) {
    final list = ScopedModel.of<LikedSongList>(context, rebuildOnChange: true);
    return list.ids?.contains(music.id) == true;
  }

  ///红心歌曲
  Future<void> likeMusic(Music music) async {
    final succeed = false;
//    final succeed = await neteaseRepository.like(music.id, true);
    if (succeed) {
      _ids = List.from(_ids)..add(music.id);
      notifyListeners();
    }
  }

  ///取消红心歌曲
  Future<void> dislikeMusic(Music music) async {
    final succeed = false;
//    final succeed = await neteaseRepository.like(music.id, false);
    if (succeed) {
      _ids = List.from(_ids)..remove(music.id);
      notifyListeners();
    }
  }
}
