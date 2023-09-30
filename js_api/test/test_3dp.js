
function expect(actual, matcher) {
    if (actual !== matcher) {
      throw new Error(`expect ${matcher}, got ${actual}`);
    }
  }
  
async function runConnectTest() {
    console.log("test connect");
    const endpoint = "wss://rpc.3dpscan.io";
    const connected = await settings.connect([endpoint]);
    // expect(connected, endpoint);
    expect(!!api, true);

    console.log("test get consts");
    const constants = await settings.getNetworkConst(api);
    expect(constants.balances.existentialDeposit.toHuman(), api.consts.balances.existentialDeposit.toHuman());

    console.log("settings tests passed.");
}

async function run3dpTests() {
    await runConnectTest();
  
    console.log("all tests passed.");
  }
  window.runTests = runTests;
