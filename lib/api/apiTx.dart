import 'dart:async';
import 'dart:convert';

import 'package:polkawallet_sdk/api/api.dart';
import 'package:polkawallet_sdk/api/types/txInfoData.dart';
import 'package:polkawallet_sdk/p3d/tx_info.dart';
import 'package:polkawallet_sdk/service/tx.dart';

class ApiTx {
  ApiTx(this.apiRoot, this.service);

  final PolkawalletApi apiRoot;
  final ServiceTx service;

  /// Estimate tx fees, [params] will be ignored if we have [rawParam].
  Future<TxFeeEstimateResult> estimateFees(TxInfoData txInfo, List params,
      {String? rawParam, String? jsApi}) async {
    final String param = rawParam != null ? rawParam : jsonEncode(params);
    final Map tx = txInfo.toJson();
    final res = (await (service.estimateFees(tx, param, jsApi: jsApi))) ?? {};

    final Map<String, dynamic> resTyped =
        res.map((key, value) => MapEntry(key.toString(), value));

    return TxFeeEstimateResult.fromJson(resTyped);
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

  /// Send tx, [params] will be ignored if we have [rawParam].
  /// [onStatusChange] is a callback when tx status change.
  /// @return txHash [string] if tx finalized success.
  Future<Map> signAndSend({
    required TransferTxInfoI txInfo,
    required String password,
    required Function(String) onStatusChange,
    required MsgCallback msgIdCallback,
  }) async {
    // final param = rawParam != null ? rawParam : jsonEncode(params);
    // final Map tx = txInfo.toJson();
    // print(tx);
    // print(param);
    final res = await service.signAndSend(
      txInfoMeta: txInfo,
      password: password,
      onStatusChange: onStatusChange,
      msgIdCallback: msgIdCallback,
    );
    if (res?['error'] != null) {
      throw Exception(res?['error']);
    }
    return res ?? {};
  }

  /// Send batch
  Future<Map> sendMultiTxSingleSender({
    required List<TransferTxInfoI> txInfoMetas,
    required String password,
    required Function(String) onStatusChange,
    required MsgCallback msgIdCallback,
  }) async {
    // final Map tx = txInfo.toJson();

    final res = await service.sendMultiTxSingleSender(
      txInfoMetas: txInfoMetas,
      password: password,
      onStatusChange: onStatusChange,
      msgIdCallback: msgIdCallback,
    );
    if (res?['error'] != null) {
      throw Exception(res?['error']);
    }
    return res ?? {};
  }

  /// Send multiple transactions
  Future<Map> sendMultiTxMultiSender({
    required List<TransferTxInfoI> txInfoMetas,
    required List<String> passwords,
    required Function(String) onStatusChange,
    required MsgCallback msgIdCallback,
  }) async {
    // final List<Map<dynamic, dynamic>> txInfosMap =
    //     txInfos.map((e) => e.toJson()).toList();
    final res = await service.sendMultiTxMultiSender(
      txInfoMetas: txInfoMetas,
      passwords: passwords,
      onStatusChange: onStatusChange,
      msgIdCallback: msgIdCallback,
    );
    if (res?['error'] != null) {
      throw Exception(res?['error']);
    }
    return res ?? {};
  }
}
