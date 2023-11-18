import 'dart:typed_data';

import 'package:polkawallet_sdk/api/api.dart';
import 'package:polkawallet_sdk/service/poscan.dart';

class ApiPoScan {
  ApiPoScan(this.apiRoot, this.service);

  final PolkawalletApi apiRoot;
  final ServicePoScan service;

  Future<dynamic> putObject({
    required Map<String, String> category,
    required Uint8List file,
    required int nApprovals,
    required List<String>? hashes,
  }) async {
    return service.putObject(
      category: category,
      file: file,
      nApprovals: nApprovals,
      hashes: hashes,
    );
  }
}
