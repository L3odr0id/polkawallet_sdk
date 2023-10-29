
import 'package:polkawallet_sdk/api/types/txInfoData.dart';
import 'package:polkawallet_sdk/p3d/balance_transaction_type.dart';
import 'package:polkawallet_sdk/p3d/tx_params.dart';
import 'package:polkawallet_sdk/plugin/store/balances.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';

abstract class TransferTxInfoI {
  final KeyPairData senderData;
  final int decimals;
  final BalanceTransactionType transferType;
  final String toAddress;
  final double amount;

  const TransferTxInfoI({
    required this.decimals,
    required this.senderData,
    required this.amount,
    required this.toAddress,
    required this.transferType,
  });

  TxInfoData txInfo();
  TxParams params();
}

class AssetsTransferTx extends TransferTxInfoI {
  final TokenBalanceData tokenBalanceData;

  const AssetsTransferTx({
    required super.decimals,
    required super.senderData,
    required super.amount,
    required super.toAddress,
    required super.transferType,
    required this.tokenBalanceData,
  });

  @override
  TxInfoData txInfo() => TxInfoData(
        'assets',
        BalanceTransactionTypeValue(transferType).toString(),
        TxSenderData(senderData.address, senderData.pubKey),
      );

  @override
  TxParams params() {
    return AssetsTxParams(
      amount: amount,
      toAddress: toAddress,
      tokenBalanceData: tokenBalanceData,
    );
  }
}

class CoinsTransferTx extends TransferTxInfoI {
  const CoinsTransferTx({
    required super.decimals,
    required super.senderData,
    required super.amount,
    required super.toAddress,
    required super.transferType,
  });

  @override
  TxInfoData txInfo() => TxInfoData(
        'balances',
        BalanceTransactionTypeValue(transferType).toString(),
        TxSenderData(
          senderData.address,
          senderData.pubKey,
        ),
      );

  @override
  TxParams params() {
    return CoinsTxParams(
      amount: amount,
      decimals: decimals,
      toAddress: toAddress,
    );
  }
}
