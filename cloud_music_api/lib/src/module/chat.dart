part of '../module.dart';

Handler chat_friendlist = (query, cookie) {
  return request(
    'POST',
    'http://192.168.1.75:8080/weapi/friend/list',
    {
      'uid': query['uid']
    },
    crypto: Crypto.linuxapi,
    cookies: cookie
  );
};