import { ApiPromise, SubmittableResult } from "@polkadot/api";
import { Bytes } from "ethers";

async function txPutObject(api: ApiPromise, category: any, file: Bytes, nApprovals: number, hashes: any) {
    api.tx.poScan.putObject(category, file, nApprovals, hashes);
}

export default {
    txPutObject,
}