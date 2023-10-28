import 'dart:async';
import 'dart:convert';

import 'package:polkawallet_sdk/service/index.dart';

class ServiceTx {
  ServiceTx(this.serviceRoot);

  final SubstrateService serviceRoot;

  Future<Map?> estimateFees(Map txInfo, String params, {String? jsApi}) async {
    dynamic res = await serviceRoot.webView!.evalJavascript(
      'keyring.txFeeEstimate(${jsApi ?? 'api'}, ${jsonEncode(txInfo)}, $params)',
    );
    return res;
  }

//  Future<dynamic> _testSendTx() async {
//    Completer c = new Completer();
//    void onComplete(res) {
//      c.complete(res);
//    }
//
//    Timer(Duration(seconds: 6), () => onComplete({'hash': '0x79867'}));
//    return c.future;
//  }

  Future<Map?> signAndSend(
      Map txInfo, String params, password, Function(String) onStatusChange,
      {Function(String)? msgIdCallback}) async {
    final msgId =
        "onStatusChange${serviceRoot.webView!.getEvalJavascriptUID()}";
    msgIdCallback?.call(msgId);
    serviceRoot.webView!.addMsgHandler(msgId, onStatusChange);
    final code =
        'keyring.sendTx(api, ${jsonEncode(txInfo)}, $params, "$password", "$msgId")';
    // print(code);
    final dynamic res = await serviceRoot.webView!.evalJavascript(code);
    serviceRoot.webView!.removeMsgHandler(msgId);

    return res;
  }

  Future<Map?> sendMultiTxSingleSender({
    required Map<dynamic, dynamic> txInfo,
    required List<List<String>> params,
    required String password,
    required Function(String) onStatusChange,
    required Function(String) msgIdCallback,
  }) async {
    final msgId =
        "onStatusChange${serviceRoot.webView!.getEvalJavascriptUID()}";
    msgIdCallback.call(msgId);
    serviceRoot.webView!.addMsgHandler(msgId, onStatusChange);
    final encodedTx = jsonEncode(txInfo);
    final encodedParams = jsonEncode(params);
    final code =
        'keyring.sendMultiTxSingleSender(api, $encodedTx, $encodedParams, "$password", "$msgId")';

    final dynamic res = await serviceRoot.webView!.evalJavascript(code);
    serviceRoot.webView!.removeMsgHandler(msgId);

    return res;
  }

  Future<Map?> sendMultiTxMultiSender({
    required List<Map<dynamic, dynamic>> txInfos,
    required List<List<String>> params,
    required List<String> passwords,
    required Function(String) onStatusChange,
    required Function(String) msgIdCallback,
  }) async {
    final msgId =
        "onStatusChange${serviceRoot.webView!.getEvalJavascriptUID()}";
    msgIdCallback.call(msgId);
    serviceRoot.webView!.addMsgHandler(msgId, onStatusChange);
    final encodedTx = jsonEncode(txInfos);
    final encodedParams = jsonEncode(params);
    final encodedPasswords = jsonEncode(passwords);
    final code =
        'keyring.sendMultiTxMultiSender(api, $encodedTx, $encodedParams, $encodedPasswords, "$msgId")';

    final dynamic res = await serviceRoot.webView!.evalJavascript(code);
    serviceRoot.webView!.removeMsgHandler(msgId);

    return res;
  }
}
