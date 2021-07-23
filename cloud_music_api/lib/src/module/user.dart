part of '../module.dart';

// 用户歌单
Handler user_playlist = (query, cookie) {
  return request(
      'POST',
      'https://music.likecho.com/weapi/user/playlist',
      {
        'uid': query['uid'],
        'limit': query['limit'] ?? '30',
        'page': query['page'] ?? '1',
      },
      crypto: Crypto.weapi,
      cookies: const []);
};