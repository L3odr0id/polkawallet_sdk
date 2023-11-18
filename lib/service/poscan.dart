import 'dart:convert';
import 'dart:typed_data';

import 'package:polkawallet_sdk/service/index.dart';

class ServicePoScan {
  ServicePoScan(this.serviceRoot);

  final SubstrateService serviceRoot;

  Future<dynamic> putObject({
    required Map<String, String> category,
    required Uint8List file,
    required int nApprovals,
    required List<String>? hashes,
  }) async {
    final argCat = jsonEncode(category);
    final argFile = file.toList().join('');
    final argHashes = jsonEncode(hashes);
    final res = serviceRoot.webView!.evalJavascript(
      'poScan.txPutObject(api, $argCat, 0x$argFile, $nApprovals, $argHashes)',
    );
    return res;
  }
}
