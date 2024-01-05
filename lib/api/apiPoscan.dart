import 'dart:typed_data';

import 'package:polkawallet_sdk/api/api.dart';
import 'package:polkawallet_sdk/p3d/prop_value.dart';
import 'package:polkawallet_sdk/service/poscan.dart';

class ApiPoScan {
  ApiPoScan(this.apiRoot, this.service);

  final PolkawalletApi apiRoot;
  final ServicePoScan service;

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
    return service.putObject(
      pubKey: pubKey,
      password: password,
      category: category,
      file: file,
      nApprovals: nApprovals,
      hashes: hashes,
      propValue: propValue,
      onStatusChange: onStatusChange,
      msgIdCallback: msgIdCallback,
    );
  }
}
