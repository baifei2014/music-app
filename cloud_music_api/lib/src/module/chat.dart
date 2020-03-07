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

Handler chat_messagelist = (query, cookie) {
  return request(
    'POST',
    'http://192.168.1.75:8080/weapi/chat_message/list',
    {
      'group_id': query['group_id'],
      'page': query['page'] ?? '1',
      'page_size': query['page_size'] ?? '50'
    },
    crypto: Crypto.linuxapi,
    cookies: cookie
  );
};