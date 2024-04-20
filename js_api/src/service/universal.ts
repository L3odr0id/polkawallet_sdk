import { ApiPromise, SubmittableResult } from "@polkadot/api";
import { SubmittableExtrinsic } from "@polkadot/api/types";
import { Keyring } from "@polkadot/keyring";
import { KeyringPair, KeyringPair$Json } from "@polkadot/keyring/types";
import { KeypairType } from "@polkadot/util-crypto/types";
import { hexToU8a, u8aToHex } from "@polkadot/util";
import { ITuple } from "@polkadot/types/types";
import { DispatchError } from "@polkadot/types/interfaces";
import { getKeyring } from "./keyring"

let caller = (args, obj) => {
    return args.reduce((acc, arg) => {
        return acc[arg]
    }, obj)
}

async function unversalNoSign(api: ApiPromise, calls: string[], args: any, sendNullAsArg: boolean) {
    return new Promise(async (resolve) => {

        let tx = caller(calls, api);
        var res: any

        try {
            if (sendNullAsArg){
                res = await tx(null);
            } else {
                if (args == null){
                    res = await tx();
                } else {
                    res = await tx(...args);
                }
            }
        } catch (err) {
            resolve({ error: JSON.stringify(err) });
        }

        try {
            resolve(res.toHuman())
        } catch (err) {
            resolve(res)
        }
    });
}

function fastLog(msgId: string, title: string, msg: string) {
    (<any>window).send('txUpdateEvent|msgId='+msgId, {
        title: title,
        message: msg,
    });
}

function fastLogError(msgId: string, msg: string) {
    (<any>window).send('txUpdateEvent|msgId='+msgId, {
        title: 'error',
        message: msg,
    });
}

export function _getDispatchError(dispatchError: DispatchError): string {
    let message: string = dispatchError.type;
  
    if (dispatchError.isModule) {
      try {
        const mod = dispatchError.asModule;
        const error = dispatchError.registry.findMetaError(mod);
  
        message = `${error.section}.${error.name}`;
      } catch (error) {
        // swallow
      }
    } else if (dispatchError.isToken) {
      message = `${dispatchError.type}.${dispatchError.asToken.type}`;
    }
  
    return message;
  }

function _extractEvents(api: ApiPromise, result: SubmittableResult, msgId: string) {
    if (!result || !result.events) {
      return {};
    }
  
    let success = false;
    let error: string;
    result.events
      .filter((event) => !!event.event)
      .map(({ event: { data, method, section } }) => {
        if (section === "system" && method === "ExtrinsicFailed") {
            const [dispatchError] = (data as unknown) as ITuple<[DispatchError]>;
            error = _getDispatchError(dispatchError);

            fastLog(msgId, `${section}.${method}`, error);
        } else {
            fastLog(msgId, `${section}.${method}`, 'ok');

          if (section == "system" && method == "ExtrinsicSuccess") {
            success = true;
          }
        }
      });
    return { success, error };
  }

async function unversalSign(api: ApiPromise, pubKey: string, password: string, msgId: string, calls: string[], args: any) {
    return new Promise(async (resolve) => {
        const onStatusChange = (result: SubmittableResult) => {
            if (result.status.isInBlock || result.status.isFinalized) {
                const { success, error } = _extractEvents(api, result, msgId);
                if (success) {
                    resolve({ hash: tx.hash.toString(), blockHash: (result.status.asInBlock || result.status.asFinalized).toHex() });
                }
                if (error) {
                    resolve({ error });
                }
            } else {
                (<any>window).send(msgId, result.status.type);
            }
        };

        let keyPair: KeyringPair;
        keyPair = getKeyring().getPair(hexToU8a(pubKey));

        try {
            keyPair.decodePkcs8(password);
        } catch (err) {
            fastLog(msgId, 'error', 'password check failed');
            resolve({ error: "password check failed" });
            return;
        }

        let tx = caller(calls, api)(...args);

        try {
            tx.signAndSend(keyPair, { tip: '0' }, onStatusChange)
            .then((res) => {
                (<any>window).send(msgId, 'goodFinish');
                resolve({'finish': 'ok'});
            })
            .catch((err) => {
                fastLogError(msgId, err.message);
                resolve({ error: err.message });
            });
        } catch (err) {
            fastLogError(msgId, JSON.stringify(err),);
            resolve({ error: JSON.stringify(err) });
        }
    });
}

export default {
    unversalNoSign,
    unversalSign,
}