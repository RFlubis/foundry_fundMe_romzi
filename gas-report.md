No files changed, compilation skipped

Ran 9 tests for test/FundMeTest.t.sol:FundMeTest
[PASS] testAddsFunderToArrayOfFunders() (gas: 130160)
[PASS] testFundFailsWithoutEnoughEth() (gas: 53045)
[PASS] testFundUpdatesFundedDataStructure() (gas: 125784)
[PASS] testMinimumUsdIsFive() (gas: 5801)
[PASS] testOnlyOwnerCanWithdraw() (gas: 144767)
[PASS] testOwnerIsMsgSender() (gas: 5897)
[PASS] testPriceFeedVersionIsAccurate() (gas: 11305)
[PASS] testWithdrawFromMultipleFunders() (gas: 1207881)
[PASS] testWithdrawWithASingleFunder() (gas: 175166)
Suite result: ok. 9 passed; 0 failed; 0 skipped; finished in 1.90ms (2.01ms CPU time)

| script/DeployFundMe.s.sol:DeployFundMe Contract |                 |         |         |         |         |
|-------------------------------------------------|-----------------|---------|---------|---------|---------|
| Deployment Cost                                 | Deployment Size |         |         |         |         |
|                                         3038809 |           13847 |         |         |         |         |
|                                                 |                 |         |         |         |         |
| Function Name                                   | Min             | Avg     | Median  | Max     | # Calls |
| run                                             |         2450626 | 2450626 | 2450626 | 2450626 |       9 |

| script/HelperConfig.s.sol:HelperConfig Contract |                 |     |        |     |         |
|-------------------------------------------------|-----------------|-----|--------|-----|---------|
| Deployment Cost                                 | Deployment Size |     |        |     |         |
|                                               0 |            8422 |     |        |     |         |
|                                                 |                 |     |        |     |         |
| Function Name                                   | Min             | Avg | Median | Max | # Calls |
| activeNetworkConfig                             |             550 | 550 |    550 | 550 |       9 |

| src/FundMe.sol:FundMe Contract |                 |       |        |        |         |
|--------------------------------|-----------------|-------|--------|--------|---------|
| Deployment Cost                | Deployment Size |       |        |        |         |
|                              0 |            4270 |       |        |        |         |
|                                |                 |       |        |        |         |
| Function Name                  | Min             | Avg   | Median | Max    | # Calls |
| MINIMUM_USD                    |             329 |   329 |    329 |    329 |       1 |
| fund                           |           38227 | 89878 |  87622 | 104722 |      16 |
| getAddressToAmountFunded       |            2842 |  2842 |   2842 |   2842 |       1 |
| getFunder                      |            5055 |  5055 |   5055 |   5055 |       1 |
| getOwner                       |             408 |   408 |    408 |    408 |       7 |
| getVersion                     |            5886 |  5886 |   5886 |   5886 |       1 |
| withdraw                       |           21344 | 59348 |  35655 | 121047 |       3 |

| test/mocks/MockV3Aggregator.sol:MockV3Aggregator Contract |                 |      |        |      |         |
|-----------------------------------------------------------|-----------------|------|--------|------|---------|
| Deployment Cost                                           | Deployment Size |      |        |      |         |
|                                                         0 |            2859 |      |        |      |         |
|                                                           |                 |      |        |      |         |
| Function Name                                             | Min             | Avg  | Median | Max  | # Calls |
| latestRoundData                                           |            9949 | 9949 |   9949 | 9949 |      16 |
| version                                                   |             396 |  396 |    396 |  396 |       1 |


Ran 1 test suite in 3.14ms (1.90ms CPU time): 9 tests passed, 0 failed, 0 skipped (9 total tests)
