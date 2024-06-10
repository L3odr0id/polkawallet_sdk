import { WsProvider, ApiPromise } from "@polkadot/api";
import { subscribeMessage, getNetworkConst, getNetworkProperties } from "./service/setting";
import keyring from "./service/keyring";
import account from "./service/account";
import staking from "./service/staking";
import poScan from "./service/poScan";
import universal from "./service/universal";
import pools from "./service/pools";
import wc from "./service/walletconnect";
import { renderEthereumRequests, signEthPayload } from "./service/walletconnect/v1/engines/ethereum";
import gov from "./service/gov";
import gov2 from "./service/gov2";
import parachain from "./service/parachain";
import assets from "./service/assets";
import { genLinks } from "./utils/config/config";

// ethers APIs:
import keyringETH from "./service/eth/keyring";
import accountETH from "./service/eth/account";
import { connect as connectEVM } from "./service/eth/settings";

// console.log will send message to MsgChannel to App
function send(path: string, data: any) {
  console.log(JSON.stringify({ path, data }));
}
send("log", "main js loaded");
(<any>window).send = send;

async function connectAll(nodes: string[]) {
  return Promise.race(nodes.map((node) => connect([node])));
}

/**
 * connect to a specific node.
 *
 * @param {string} nodeEndpoint
 */
async function connect(nodes: string[]) {
  (<any>window).api = undefined;

  return new Promise(async (resolve, reject) => {
    const wsProvider = new WsProvider(nodes);
    try {
      const res = await ApiPromise.create({
        provider: wsProvider,
        types: {
          AccountInfo: "AccountInfoWithTripleRefCount",
          Address: "AccountId",
          LookupSource: "AccountId",
          Keys: "SessionKeys2",
          Weight: "u32",
          Difficulty: "u256",
          DifficultyAndTimestamp: {
            difficulty: "Difficulty",
            timestamp: "u64",
          },
          LockParameters: {
            period: "u16",
            divide: "u16",
          },
          StorageVersion: {
            _enum: ["V0", "V1"],
            V0: "u8",
            V1: "u8",
          },
        },
      });
      if (!(<any>window).api) {
        (<any>window).api = res;
        // console.log(res);
        const url = nodes[(<any>res)._options.provider.__private_44_endpointIndex];
        send("log", `${url} wss connected success`);
        resolve(url);
      } else {
        res.disconnect();
        const url = nodes[(<any>res)._options.provider.__private_44_endpointIndex];
        send("log", `${url} wss success and disconnected`);
        resolve(url);
      }
    } catch (err) {
      send("log", `connect failed`);
      wsProvider.disconnect();
      resolve(null);
    }
  });
}

const test = async () => {
  // const props = await api.rpc.system.properties();
  // send("log", props);
};

const settings = {
  test,
  connect,
  connectAll,
  subscribeMessage,
  getNetworkConst,
  getNetworkProperties,
  // generate external links to polkascan/subscan/polkassembly...
  genLinks,
};

(<any>window).settings = settings;
(<any>window).keyring = keyring;
(<any>window).account = account;
(<any>window).staking = staking;
(<any>window).gov = gov;
(<any>window).gov2 = gov2;
(<any>window).parachain = parachain;
(<any>window).assets = assets;
(<any>window).poScan = poScan;
(<any>window).universal = universal;
(<any>window).pools = pools;
(<any>window).eth = {
  settings: { connect: connectEVM },
  keyring: { ...keyringETH, signEthRequest: signEthPayload, renderEthRequest: renderEthereumRequests },
  account: accountETH,
};

// walletConnect supporting is not ready.
(<any>window).walletConnect = wc;

export default settings;
