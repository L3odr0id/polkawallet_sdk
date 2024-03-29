import 'dart:convert';

import 'package:polkawallet_sdk/service/index.dart';

class ServiceUniversal {
  ServiceUniversal(this.serviceRoot);

  final SubstrateService serviceRoot;

  Future<dynamic> callNoSign({
    required List<String> calls,
    required List<String>? args,
  }) async {
    final argsEncoded = jsonEncode(args);
    final callsEncoded = jsonEncode(calls);
    final codeJS = 'universal.unversalNoSign(api, $callsEncoded, $argsEncoded)';
    print(codeJS);
    final res = serviceRoot.webView!.evalJavascript(codeJS);
    return res;
  }

  Future<dynamic> callSign({
    required String pubKey,
    required String password,
    required List<String> calls,
    required List<String>? args,
  }) async {
    final msgId =
        "onStatusChange${serviceRoot.webView!.getEvalJavascriptUID()}";

    final argsEncoded = jsonEncode(args);
    final callsEncoded = jsonEncode(calls);

    final res = serviceRoot.webView!.evalJavascript(
      'universal.unversalSign(api, "$pubKey", "$password", "$msgId", $callsEncoded, $argsEncoded)',
    );
    return res;
  }
}
