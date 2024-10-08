import ClientApp from "./v1/client";

const wc = new ClientApp();

async function initConnect(uri: string, address: string, chainId: number) {
  wc.onURIReceive(uri, address, chainId);
}

async function reConnectSession(session: any) {
  wc.reConnectSession(session);
}

/**
 * User will see a confirm dialog while wc client received 'session_request' from DApp.
 * Then user will confirm approve or reject the connection.
 */
async function confirmConnect(approve: boolean) {
  if (approve) {
    wc.approveSession();
  } else {
    wc.rejectSession();
  }
}

async function disconnect() {
  wc.killSession();
}

async function confirmCallRequest(id: number, approve: boolean, pass: string, gasOptions: any) {
  return new Promise((resolve) => {
    if (approve) {
      wc.approveRequest(id, pass, gasOptions, (res: any) => {
        resolve(res);
      });
    } else {
      wc.rejectRequest(id);
      resolve({});
    }
  });
}

async function updateSession(sessionParams: { chainId?: number; address?: string }) {
  wc.updateSession(sessionParams);
}

export default {
  initConnect,
  reConnectSession,
  confirmConnect,
  updateSession,
  disconnect,
  confirmCallRequest,
};
