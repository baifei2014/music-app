import 'package:loader/loader.dart';
import 'package:music/model/model.dart';
import 'package:music/model/music.dart';
import 'package:music/model/playlist_detail.dart';

import 'package:netease_music_api/netease_cloud_music.dart' as api;

import 'local_cache_data.dart';

enum PlaylistOperation { add, remove }

const _CODE_SUCCESS = 200;

const _CODE_NEED_LOGIN = 301;

NeteaseRepository neteaseRepository;

///map a result to any other
Result<R> _map<T, R>(Result<T> source, R f(T t)) {
  if (source.isError) return source.asError;
  try {
    return Result.value(f(source.asValue.value));
  } catch (e, s) {
    return Result.error(e, s);
  }
}

class NeteaseRepository {

  ///获取用户详情
  Future<Result<Map>> getUserDetail(int uid) {
    assert(uid != null);
    return doRequest('/user/detail', {'uid': uid});
  }

  ///edit playlist tracks
  ///true : succeed
  Future<bool> playlistTracksEdit(PlaylistOperation operation, int playlistId, List<int> musicIds) async {
    assert(operation != null);
    assert(playlistId != null);
    assert(musicIds != null && musicIds.isNotEmpty);

    var result = await doRequest("https://music.163.com/weapi/playlist/manipulate/tracks", {
      "op": operation == PlaylistOperation.add ? "add" : "del",
      "pid": playlistId,
      "trackIds": "[${musicIds.join(",")}]"
    });
    return result.isValue;
  }

  ///获取歌手的专辑列表
  Future<Result<Map>> artistAlbums(int artistId, {int limit = 10, int offset = 0}) async {
    return doRequest("/artist/album", {
      'id': artistId,
      "limit": limit,
      "offset": offset,
      "total": true,
    });
  }

  ///获取歌手信息和单曲
  Future<Result<Map>> artistDetail(int artistId) async {
    return doRequest("/artists", {'id': artistId});
  }

  ///create new playlist by [name]
  Future<Result<PlaylistDetail>> createPlaylist(String name, {bool privacy = false}) async {
    final response = await doRequest("/playlist/create", {"name": name, 'privacy': privacy ? 10 : null});
    return _map(response, (result) {
      return PlaylistDetail.fromJson(result["playlist"]);
    });
  }

  ///根据音乐id获取歌词
  Future<String> lyric(int id) async {
//    final lyricCache = await _lyricCache();
//    final key = _LyricCacheKey(id);
    //check cache first
//    String cached = await lyricCache.get(key);
    String cached = null;
    if (cached != null) {
      return cached;
    }
    var result = await doRequest('/lyric', {"id": id});
    if (result.isError) {
      return Future.error(result.asError.error);
    }
    Map lyc = result.asValue.value["lrc"];
    if (lyc == null) {
      return null;
    }
    final content = lyc["lyric"];
    //update cache
//    await lyricCache.update(key, content);
    return content;
  }

  /// 获取音乐播放地址
  /// id 歌曲id
  Future<Result<String>> getPlayUrl(int id, [int br = 320000]) async {
    final result = await doRequest("/song/url", {"id": id, "br": br});
    return _map(result, (result) {
      final data = result['data'] as List;
      if (data.isEmpty) {
        throw "无法获取播放地址";
      }
      return data.first['url'];
    });
  }

  ///获取用户播放记录
  ///type : 0 all , 1 this week
  Future<Result<Map>> getRecord(int uid, int type) {
    assert(type == 0 || type == 1);
    return doRequest('/user/record', {'uid': uid, 'type': type});
  }


  ///使用手机号码登录
  Future<Result<Map>> login(String phone, String password) async {
    return await doRequest("/login/cellphone", {"phone": phone, "password": password});
  }

  ///刷新登陆状态
  ///返回结果：true 正常登陆状态
  ///         false 需要重新登陆
  Future<bool> refreshLogin() async {
    final result = await doRequest('/login/refresh');
    return result.isValue;
  }

  ///根据歌单id获取歌单详情，包括歌曲
  ///
  /// [s] 歌单最近的 s 个收藏者
  Future<Result<PlaylistDetail>> playlistDetail(int id, {int s = 5}) async {
    final response = await doRequest("/playlist/detail", {"id": "$id", "s": s});
    return _map(response, (t) {
      final result = PlaylistDetail.fromJson(t["playlist"]);
//      neteaseLocalData.updatePlaylistDetail(result);
      return result;
    });
  }

  ///根据用户ID获取歌单
  ///PlayListDetail 中的 tracks 都是空数据
  Future<Result<List<PlaylistDetail>>> userPlaylist(int userId, [int page = 1, int limit = 1000]) async {
    print("当前分页 : \n $page");
    final response = await doRequest("/user/playlist", {"page": page, "uid": userId, "limit": limit});

    print("用户歌单列表 : \n");
    print(response);
    return _map(response, (Map result) {
      final list = (result["playlist"] as List).cast<Map>().map((e) => PlaylistDetail.fromJson(e)).toList();
//      neteaseLocalData.updateUserPlaylist(userId, list);
      return list;
    });
  }

  ///获取好友列表
  Future<Result<List<Map>>> userFriendlist(int uid) async {
    final response = await doRequest("/chat/friendlist", {"uid": uid});
    return _map(response, (Map result) {
      final list = (result["data"] as List).cast<Map>().map((e) => e).toList();
      return list;
    });
  }

  ///[path] request path
  ///[data] parameter
  Future<Result<Map<String, dynamic>>> doRequest(String path, [Map param = const {}]) async {
    api.Answer result;
    try {
      // convert all params to string
      final Map<String, String> convertedParams = param.map((k, v) => MapEntry(k.toString(), v.toString()));
      result = await api.cloudMusicApi(path, parameter: convertedParams, cookie: const []);
    } catch (e, stacktrace) {
      print("request error : $e \n $stacktrace");
      return Result.error(e, stacktrace);
    }
    result.body.forEach((key, value) {
      print("结果循环打印 : $key \n");
      print(value);
    });
    final map = result.body;
    
    if (map == null) {
      return Result.error('请求失败了');
    } else if (map['code'] == _CODE_NEED_LOGIN) {
      return Result.error('需要登陆才能访问哦~');
    } else if (map['code'] != _CODE_SUCCESS) {
      return Result.error(map['msg'] ?? '请求失败了~');
    }
    return Result.value(map);
  }
}

Music mapJsonToMusic(Map song, {String artistKey = "artists", String albumKey = "album"}) {
  Map album = song[albumKey] as Map;

  List<Artist> artists = (song[artistKey] as List).cast<Map>().map((e) {
    return Artist(
      name: e["name"],
      id: e["id"],
    );
  }).toList();

  return Music(
      id: song["id"],
      title: song["name"],
      mvId: song['mv'] ?? 0,
      url: song["url"],
      album: Album(id: album["id"], name: album["name"], coverImageUrl: album["picUrl"]),
      artist: artists);
}

List<Music> mapJsonListToMusicList(List tracks, {String artistKey = "artists", String albumKey = "album"}) {
  if (tracks == null) {
    return null;
  }
  var list = tracks.cast<Map>().map((e) => mapJsonToMusic(e, artistKey: "ar", albumKey: "al"));
  return list.toList();
}