import { ApiPromise } from "@polkadot/api";
import type { AnyJson } from "@polkadot/types/types/codec";
import { u8aToHex } from "@polkadot/util";

export function createNativeTokenId(api: ApiPromise) {
    return api.createType("PalletAssetConversionNativeOrAssetId", { native: true }).toU8a();
}
  
export function createAssetTokenId(api: ApiPromise, assetTokenId: string | null) {
    return api.createType("PalletAssetConversionNativeOrAssetId", { asset: assetTokenId }).toU8a();
}

export const getAssetTokenFromNativeToken = async (
    api: ApiPromise,
    assetTokenId: string | null,
    nativeTokenValue: string
  ) => {
    const multiLocation = createAssetTokenId(api, assetTokenId);
    const multiLocation2 = createNativeTokenId(api);
  
    const amount = api.createType("u128", nativeTokenValue).toU8a();
    const bool = api.createType("bool", false).toU8a();
  
    const encodedInput = new Uint8Array(multiLocation.length + multiLocation2.length + amount.length + bool.length);
    encodedInput.set(multiLocation, 0);
    encodedInput.set(multiLocation2, multiLocation.length);
    encodedInput.set(amount, multiLocation.length + multiLocation2.length);
    encodedInput.set(bool, multiLocation.length + multiLocation2.length + amount.length);
  
    const encodedInputHex = u8aToHex(encodedInput);
  
    const response = await api.rpc.state.call("AssetConversionApi_quote_price_tokens_for_exact_tokens", encodedInputHex);
  
    const decodedPrice = api.createType("Option<u128>", response);
  
    return decodedPrice.toHuman();
  };
  
  export const getNativeTokenFromAssetToken = async (
    api: ApiPromise,
    assetTokenId: string | null,
    assetTokenValue: string
  ) => {
    const multiLocation = createAssetTokenId(api, assetTokenId);
    const multiLocation2 = createNativeTokenId(api);
  
    const amount = api.createType("u128", assetTokenValue).toU8a();
    const bool = api.createType("bool", false).toU8a();
  
    const encodedInput = new Uint8Array(multiLocation.length + multiLocation2.length + amount.length + bool.length);
    encodedInput.set(multiLocation, 0);
    encodedInput.set(multiLocation2, multiLocation.length);
    encodedInput.set(amount, multiLocation.length + multiLocation2.length);
    encodedInput.set(bool, multiLocation.length + multiLocation2.length + amount.length);
  
    const encodedInputHex = u8aToHex(encodedInput);
  
    const response = await api.rpc.state.call("AssetConversionApi_quote_price_exact_tokens_for_tokens", encodedInputHex);
  
    const decodedPrice = api.createType("Option<u128>", response);
  
    return decodedPrice.toHuman();
  };
  
  const concatAndHexEncodeU8A = (array1: Uint8Array, array2: Uint8Array, array3: Uint8Array, array4: Uint8Array) => {
    const encodedInput3 = new Uint8Array(array1.length + array2.length + array3.length + array4.length);
  
    encodedInput3.set(array1, 0);
    encodedInput3.set(array2, array1.length);
    encodedInput3.set(array3, array1.length + array2.length);
    encodedInput3.set(array4, array1.length + array2.length + array3.length);
    const encodedInputHex3 = u8aToHex(encodedInput3);
  
    return encodedInputHex3;
  };
  
  export const getAssetTokenAFromAssetTokenB = async (
    api: ApiPromise,
    assetToken2Value: string,
    assetToken1Id: string,
    assetToken2Id: string
  ) => {
    const multiLocation1 = createAssetTokenId(api, assetToken1Id);
    const multiLocation2 = createAssetTokenId(api, assetToken2Id);
  
    const token2Amount = api.createType("u128", assetToken2Value).toU8a();
  
    const bool = api.createType("bool", false).toU8a();
  
    const encodedInputHex = concatAndHexEncodeU8A(multiLocation1, multiLocation2, token2Amount, bool);
  
    const response = await api.rpc.state.call("AssetConversionApi_quote_price_tokens_for_exact_tokens", encodedInputHex);
  
    const decodedAmount2 = api.createType("Option<u128>", response);
  
    return decodedAmount2.toHuman();
  };
  
  export const getAssetTokenBFromAssetTokenA = async (
    api: ApiPromise,
    assetToken1Value: string,
    assetToken1Id: string,
    assetToken2Id: string
  ) => {
    const multiLocation1 = createAssetTokenId(api, assetToken1Id);
    const multiLocation2 = createAssetTokenId(api, assetToken2Id);
  
    const token2Amount = api.createType("u128", assetToken1Value).toU8a();
  
    const bool = api.createType("bool", false).toU8a();
  
    const encodedInputHex = concatAndHexEncodeU8A(multiLocation1, multiLocation2, token2Amount, bool);
  
    const response = await api.rpc.state.call("AssetConversionApi_quote_price_exact_tokens_for_tokens", encodedInputHex);
  
    const decodedAmount2 = api.createType("Option<u128>", response);
  
    return decodedAmount2.toHuman();
  };

export default {
    getAssetTokenBFromAssetTokenA,
    getAssetTokenAFromAssetTokenB,
    concatAndHexEncodeU8A,
    getAssetTokenFromNativeToken,
    getNativeTokenFromAssetToken,
    createNativeTokenId,
    createAssetTokenId
}