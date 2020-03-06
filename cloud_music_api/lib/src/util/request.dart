import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import '../../netease_cloud_music.dart';

enum Crypto { linuxapi, weapi, eapi }

String _chooseUserAgent({String ua}) {
  const userAgentList = [
    'Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1',
    'Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1',
    'Mozilla/5.0 (Linux; Android 5.0; SM-G900P Build/LRX21T) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Mobile Safari/537.36',
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Mobile Safari/537.36',
    'Mozilla/5.0 (Linux; Android 5.1.1; Nexus 6 Build/LYZ28E) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Mobile Safari/537.36',
    'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_2 like Mac OS X) AppleWebKit/603.2.4 (KHTML, like Gecko) Mobile/14F89;GameHelper',
    'Mozilla/5.0 (iPhone; CPU iPhone OS 10_0 like Mac OS X) AppleWebKit/602.1.38 (KHTML, like Gecko) Version/10.0 Mobile/14A300 Safari/602.1',
    'Mozilla/5.0 (iPad; CPU OS 10_0 like Mac OS X) AppleWebKit/602.1.38 (KHTML, like Gecko) Version/10.0 Mobile/14A300 Safari/602.1',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:46.0) Gecko/20100101 Firefox/46.0',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/603.2.4 (KHTML, like Gecko) Version/10.1.1 Safari/603.2.4',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:46.0) Gecko/20100101 Firefox/46.0',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/13.10586'
  ];

  var r = Random();
  int index;
  if (ua == 'mobile') {
    index = (r.nextDouble() * 7).floor();
  } else if (ua == "pc") {
    index = (r.nextDouble() * 5).floor() + 8;
  } else {
    index = (r.nextDouble() * (userAgentList.length - 1)).floor();
  }
  return userAgentList[index];
}

Map<String, String> _buildHeader(String url, String ua, String method, List<Cookie> cookies) {
  final headers = {'User-Agent': _chooseUserAgent(ua: ua)};
  if (method.toUpperCase() == 'POST') headers['Content-Type'] = 'application/x-www-form-urlencoded';
  if (url.contains('music.163.com')) headers['Referer'] = 'https://music.163.com';
  headers['Cookie'] = cookies.join("; ");
  return headers;
}

///[crypto] 只支持 [Crypto.linuxapi] 和 [Crypto.weapi]
Future<Answer> request(
    String method,
    String url,
    Map data, {
      List<Cookie> cookies = const [],
      String ua,
      Crypto crypto = Crypto.weapi,
    }) async {
  print('刚传入的链接 : \n');
  print(url);
  final headers = _buildHeader(url, ua, method, cookies);
  if (crypto == Crypto.weapi) {
    var csrfToken = cookies.firstWhere((c) => c.name == "__csrf", orElse: () => null);
    data["csrf_token"] = csrfToken?.value ?? "";
    url = url.replaceAll(RegExp(r"\w*api"), 'weapi');
  }
  print("请求链接 : \n $url");
  print("请求参数: \n $data");
  return _doRequest(url, headers, data, method).then((response) async {
    var ans = Answer(cookie: response.cookies);

    final content = await response.cast<List<int>>().transform(utf8.decoder).join();
    final body = json.decode(content);
    print("请求路由 : \n $url");
    print("返回数据内容 : \n $body");
    ans = ans.copy(status: int.parse(body['code'].toString()) ?? response.statusCode, body: body);

    ans = ans.copy(status: ans.status > 100 && ans.status < 600 ? ans.status : 400);
    return ans;
  }).catchError((e, s) {
    print(e.toString());
    print(s.toString());
    return Answer(status: 502, body: {'code': 502, 'msg': e.toString()});
  });
}

Future<HttpClientResponse> _doRequest(String url, Map<String, String> headers, Map data, String method) {
  return HttpClient().openUrl(method, Uri.parse(url)).then((request) {
    headers.forEach(request.headers.add);
    request.write(Uri(queryParameters: data.cast()).query);
    return request.close();
  });
}