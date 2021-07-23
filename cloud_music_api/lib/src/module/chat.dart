part of '../module.dart';

Handler chat_friendlist = (query, cookie) {
  return request(
    'POST',
    'https://music.likecho.com/weapi/friend/list',
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
    'https://music.likecho.com/weapi/chat_message/list',
    {
      'group_id': query['group_id'],
      'page': query['page'] ?? '1',
      'page_size': query['page_size'] ?? '50'
    },
    crypto: Crypto.linuxapi,
    cookies: cookie
  );
};