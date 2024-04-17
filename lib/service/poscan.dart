import 'dart:convert';

import 'package:polkawallet_sdk/service/index.dart';

class ServicePoScan {
  ServicePoScan(this.serviceRoot);

  final SubstrateService serviceRoot;

  Future<dynamic> putObject({
    required String pubKey,
    required String password,
    required Map<String, String> category,
    required Function(String) onStatusChange,
    required String file,
    required int nApprovals,
    required List<String> hashes,
    required String? propValue,
    required Function(String) msgIdCallback,
  }) async {
    final msgId =
        "onStatusChange${serviceRoot.webView!.getEvalJavascriptUID()}";
    serviceRoot.webView!.addMsgHandler(msgId, onStatusChange);

    msgIdCallback(msgId);

    final argCat = jsonEncode(category);
    // final argFile = file.toList().map((e) => e.toRadixString(16)).join(''); // 0x$argFile

    // final hashesToHex = hashes.map((e) => '0x' + e);
    // final hexHashesStr = hashesToHex.join(',');
    // final argHashes = '[$hexHashesStr]';

    final pseudoHex = hashes.map((e) => '0x' + e).toList();
    final argHashes = jsonEncode(pseudoHex);

    final res = serviceRoot.webView!.evalJavascript(
      'poScan.txPutObject(api, "$pubKey", "$password", "$msgId", $argCat, $file, $nApprovals, $argHashes, $propValue)',
    );
    return res;
  }
}
