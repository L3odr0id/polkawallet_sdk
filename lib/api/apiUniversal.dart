import 'package:polkawallet_sdk/api/api.dart';
import 'package:polkawallet_sdk/service/universal.dart';

class ApiUniversal {
  ApiUniversal(this.apiRoot, this.service);

  final PolkawalletApi apiRoot;
  final ServiceUniversal service;

  Future<dynamic> callNoSign({
    required List<String> calls,
    required List<String>? args,
  }) async {
    return service.callNoSign(
      calls: calls,
      args: args,
    );
  }

  Future<dynamic> callSign({
    required String pubKey,
    required String password,
    required List<String> calls,
    required String? args,
    required Function(String) onStatusChange,
    required Function(String) msgIdCallback,
  }) async {
    return service.callSign(
      pubKey: pubKey,
      password: password,
      calls: calls,
      args: args,
      msgIdCallback: msgIdCallback,
      onStatusChange: onStatusChange,
    );
  }
}
