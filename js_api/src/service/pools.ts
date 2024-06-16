import { ApiPromise } from "@polkadot/api";
import { u8aToHex } from "@polkadot/util";

async function getPoolReserves(api: ApiPromise, multiLocation: Uint8Array, multiLocation2: Uint8Array) {
  // const multiLocation = createAssetTokenId(api, assetTokenId);
  // const multiLocation2 = createNativeTokenId(api);

  const encodedInput = new Uint8Array(multiLocation.length + multiLocation2.length);
  encodedInput.set(multiLocation, 0);
  encodedInput.set(multiLocation2, multiLocation.length);

  const encodedInputHex = u8aToHex(encodedInput);

  const reservers = await api.rpc.state.call("AssetConversionApi_get_reserves", encodedInputHex);

  const decoded = api.createType("Option<(u128, u128)>", reservers);

  return decoded.toHuman();
};

function createNativeTokenId(api: ApiPromise) {
  return api.createType("PalletAssetConversionNativeOrAssetId", { native: true }).toU8a();
}

function createAssetTokenId(api: ApiPromise, assetTokenId: string | null) {
  return api.createType("PalletAssetConversionNativeOrAssetId", { asset: assetTokenId }).toU8a();
}

export default {
  getPoolReserves,
  createNativeTokenId,
  createAssetTokenId
}