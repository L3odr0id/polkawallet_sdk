import 'package:json_annotation/json_annotation.dart';

part 'prop_value.g.dart';

@JsonSerializable()
class PropValue {
  @JsonKey(name: 'prop_idx')
  final int propIdx;
  @JsonKey(name: 'max_value')
  final BigInt maxValue;

  const PropValue({
    required this.maxValue,
    required this.propIdx,
  });

  Map<String, dynamic> toJson() => _$PropValueToJson(this);
}
