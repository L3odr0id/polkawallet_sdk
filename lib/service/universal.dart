import 'dart:convert';

import 'package:polkawallet_sdk/service/index.dart';

class ServiceUniversal {
  ServiceUniversal(this.serviceRoot);

  final SubstrateService serviceRoot;

  Future<dynamic> callNoSign({
    required String first,
    required String second,
    required String third,
    required List<String>? args,
  }) async {
    final argsEncoded = jsonEncode(args);
    final codeJS =
        'universal.unversalNoSign(api, "$first", "$second", "$third", $argsEncoded)';
    print(codeJS);
    final res = serviceRoot.webView!.evalJavascript(codeJS);
    return res;
  }

  Future<dynamic> callSign({
    required String pubKey,
    required String password,
    required String first,
    required String second,
    required String third,
    required List<String>? args,
  }) async {
    final msgId =
        "onStatusChange${serviceRoot.webView!.getEvalJavascriptUID()}";

    final argsEncoded = jsonEncode(args);

    final res = serviceRoot.webView!.evalJavascript(
      'universal.unversalSign(api, "$pubKey", "$password", "$msgId", "$first", "$second", "$third", $argsEncoded)',
    );
    return res;
  }
}
