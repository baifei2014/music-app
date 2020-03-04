part of '../module.dart';

// 歌曲链接
Handler song_url = (query, cookie) {
//  if (!cookie.any((cookie) => cookie.name == 'MUSIC_U')) {
//    String _createdSecretKey({int size = 16}) {
//      StringBuffer buffer = StringBuffer();
//      for (var i = 0; i < size; i++) {
//        final position = math.Random().nextInt(_keys.length);
//        buffer.write(_keys[position]);
//      }
//      return buffer.toString();
//    }
//
//    cookie = List.from(cookie)..add(Cookie('_ntes_nuid', _createdSecretKey()));
//  }

  return request(
      'POST',
      'http://192.168.1.75:8080/weapi/song/enhance/player/url',
      {
        'ids': [query['id']],
        'br': query['br'] ?? '999000',
      },
      crypto: Crypto.weapi,
      cookies: cookie);
};