part of '../module.dart';

// 歌单详情
Handler playlist_detail = (query, cookie) {
  return request(
      'POST',
      'http://192.168.1.75:8080/weapi/playlist/detail',
      {
        'id': query['id'],
        'n': query['n'] ?? '100000',
        's': query['s'] ?? '8',
      },
      crypto: Crypto.linuxapi,
      cookies: cookie);
};