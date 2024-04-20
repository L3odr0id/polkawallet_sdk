import 'dart:convert';

import 'package:polkawallet_sdk/service/index.dart';

class ServiceUniversal {
  ServiceUniversal(this.serviceRoot);

  final SubstrateService serviceRoot;

  Future<dynamic> callAnything({
    required String codeJS,
  }) async {
    print(codeJS);
    final res = serviceRoot.webView!.evalJavascript(codeJS);
    return res;
  }

  Future<dynamic> callNoSign({
    required List<String> calls,
    required String? args,
    required bool sendNullAsArg,
  }) async {
    final callsEncoded = jsonEncode(calls);
    final codeJS =
        'universal.unversalNoSign(api, $callsEncoded, $args, $sendNullAsArg)';
    print(codeJS);
    final res = serviceRoot.webView!.evalJavascript(codeJS);
    return res;
  }

  Future<dynamic> callSign({
    required String pubKey,
    required String password,
    required List<String> calls,
    required String? args,
    required Function(String) onStatusChange,
    required Function(String) msgIdCallback,
  }) async {
    final msgId =
        "onStatusChange${serviceRoot.webView!.getEvalJavascriptUID()}";
    serviceRoot.webView!.addMsgHandler(msgId, onStatusChange);

    msgIdCallback(msgId);

    final callsEncoded = jsonEncode(calls);

    final res = serviceRoot.webView!.evalJavascript(
      'universal.unversalSign(api, "$pubKey", "$password", "$msgId", $callsEncoded, $args)',
    );
    return res;
  }
}
