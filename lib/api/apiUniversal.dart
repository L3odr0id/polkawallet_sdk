import 'package:polkawallet_sdk/api/api.dart';
import 'package:polkawallet_sdk/service/universal.dart';

class ApiUniversal {
  ApiUniversal(this.apiRoot, this.service);

  final PolkawalletApi apiRoot;
  final ServiceUniversal service;

  Future<dynamic> callNoSign({
    String first = 'query',
    required String second,
    required String third,
    required List<String>? args,
  }) async {
    return service.callNoSign(
      first: first,
      second: second,
      third: third,
      args: args,
    );
  }

  Future<dynamic> callSign({
    required String pubKey,
    required String password,
    String first = 'query',
    required String second,
    required String third,
    required List<String>? args,
  }) async {
    return service.callSign(
      pubKey: pubKey,
      password: password,
      first: first,
      second: second,
      third: third,
      args: args,
    );
  }
}
