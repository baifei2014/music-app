import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

///
/// 提供各种数目,比如收藏数目,我的电台数目
///
class Counter extends Model {
  static final key = 'netease_sub_count';

  int _djRadioCount = 0;

  int get djRadioCount => _djRadioCount;

  int _artistCount = 0;

  int get artistCount => _artistCount;

  int _mvCount = 0;

  int get mvCount => _mvCount;

  int _createDjRadioCount = 0;

  int get createDjRadioCount => _createDjRadioCount;

  int _createdPlaylistCount = 0;

  int get createdPlaylistCount => _createdPlaylistCount;

  int _subPlaylistCount = 0;

  int get subPlaylistCount => _subPlaylistCount;

  void _handleData(Map data) {
    _artistCount = data['artistCount'] ?? 0;
    _djRadioCount = data['djRadioCount'] ?? 0;
    _mvCount = data['mvCount'] ?? 0;
    _createDjRadioCount = data['createDjRadioCount'] ?? 0;
    _createdPlaylistCount = data['createdPlaylistCount'] ?? 0;
    _subPlaylistCount = data['subPlaylistCount'] ?? 0;
    notifyListeners();
  }

  static Counter of(BuildContext context) {
    return ScopedModel.of<Counter>(context, rebuildOnChange: true);
  }

}
