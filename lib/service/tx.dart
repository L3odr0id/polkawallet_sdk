import 'dart:async';
import 'dart:convert';

import 'package:polkawallet_sdk/p3d/tx_info.dart';
import 'package:polkawallet_sdk/service/index.dart';

/// Map of FROMaddr, TOaddr -> msgId
typedef MsgCallback = Function(Map<List<String>, String>)?;

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

  Map<List<String>, String> responseMap(List<TransferTxInfoI> txInfoMetas) {
    final res = <List<String>, String>{};

    for (int i = 0; i < txInfoMetas.length; ++i) {
      final m = txInfoMetas[i];
      final msgId =
          "onStatusChange${serviceRoot.webView!.getEvalJavascriptUID()}";
      final arr = <String>[m.senderData.address!, m.toAddress];
      res[arr] = msgId;
    }

    return res;
  }

  Future<Map?> signAndSend({
    required TransferTxInfoI txInfoMeta,
    required String password,
    required Function(String) onStatusChange,
    required MsgCallback? msgIdCallback,
  }) async {
    final msgIdMap = responseMap([txInfoMeta]);
    msgIdCallback?.call(msgIdMap);

    final msgId = msgIdMap.values.first;
    serviceRoot.webView!.addMsgHandler(msgId, onStatusChange);

    final txInfo = txInfoMeta.txInfo();
    final params = txInfoMeta.params().paramsToSend();

    final code =
        'keyring.sendTx(api, ${jsonEncode(txInfo)}, ${jsonEncode(params)}, "$password", "$msgId")';
    // print(code);
    final dynamic res = await serviceRoot.webView!.evalJavascript(code);
    // serviceRoot.webView!.removeMsgHandler(msgId);

    return res;
  }

  Future<Map?> sendMultiTxSingleSender({
    required List<TransferTxInfoI> txInfoMetas,
    required String password,
    required Function(String) onStatusChange,
    required MsgCallback msgIdCallback,
  }) async {
    final msgIdMap = responseMap(txInfoMetas);
    msgIdCallback?.call(msgIdMap);

    final msgId = msgIdMap.values.first;
    serviceRoot.webView!.addMsgHandler(msgId, onStatusChange);

    final txInfo = txInfoMetas.first.txInfo().toJson();
    final params = txInfoMetas.map((e) => e.params().paramsToSend()).toList();
    final encodedTx = jsonEncode(txInfo);
    final encodedParams = jsonEncode(params);
    final code =
        'keyring.sendMultiTxSingleSender(api, $encodedTx, $encodedParams, "$password", "$msgId")';

    final dynamic res = await serviceRoot.webView!.evalJavascript(code);
    serviceRoot.webView!.removeMsgHandler(msgId);

    return res;
  }

  Future<Map?> sendMultiTxMultiSender({
    required List<TransferTxInfoI> txInfoMetas,
    required List<String> passwords,
    required Function(String) onStatusChange,
    required MsgCallback msgIdCallback,
  }) async {
    final msgIdMap = responseMap(txInfoMetas);
    msgIdCallback?.call(msgIdMap);

    final msgId = msgIdMap.values.first;
    serviceRoot.webView!.addMsgHandler(msgId, onStatusChange);

    final txInfos = txInfoMetas.map((e) => e.txInfo().toJson()).toList();
    final params = txInfoMetas.map((e) => e.params().paramsToSend()).toList();
    final encodedTx = jsonEncode(txInfos);
    final encodedParams = jsonEncode(params);
    final encodedPasswords = jsonEncode(passwords);
    final msgIds = jsonEncode(msgIdMap.values.toList());
    final code =
        'keyring.sendMultiTxMultiSender(api, $encodedTx, $encodedParams, $encodedPasswords, $msgIds)';

    final dynamic res = await serviceRoot.webView!.evalJavascript(code);
    serviceRoot.webView!.removeMsgHandler(msgId);

    return res;
  }
}
