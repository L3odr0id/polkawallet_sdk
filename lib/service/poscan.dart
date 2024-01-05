import 'dart:convert';
import 'dart:typed_data';

import 'package:polkawallet_sdk/p3d/prop_value.dart';
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
    required List<PropValue>? propValue,
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

    final argPropValue = jsonEncode(propValue);
    final res = serviceRoot.webView!.evalJavascript(
      'poScan.txPutObject(api, "$pubKey", "$password", "$msgId", $argCat, $file, $nApprovals, $argHashes, $argPropValue)',
    );
    return res;
  }
}
