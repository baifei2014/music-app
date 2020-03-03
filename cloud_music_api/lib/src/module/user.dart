part of '../module.dart';

// 用户歌单
Handler user_playlist = (query, cookie) {
  return request(
      'POST',
      'http://192.168.1.75:8080/weapi/user/playlist',
      {
        'uid': query['uid'],
        'limit': query['limit'] ?? 30,
        'page': query['page'] ?? 0,
      },
      crypto: Crypto.weapi,
      cookies: const []);
};