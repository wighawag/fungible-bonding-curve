import {expect} from './chai-setup';
import {ethers, deployments, getUnnamedAccounts} from 'hardhat';
import {FungibleBondingCurve} from '../typechain';
import {setupUsers} from './utils';

const setup = deployments.createFixture(async () => {
  await deployments.fixture('FungibleBondingCurve');
  const contracts = {
    FungibleBondingCurve: <FungibleBondingCurve>await ethers.getContract('FungibleBondingCurve'),
  };
  const users = await setupUsers(await getUnnamedAccounts(), contracts);
  return {
    ...contracts,
    users,
  };
});
describe('FungibleBondingCurve', function () {
  it('setMessage works', async function () {
    const {users, FungibleBondingCurve} = await setup();
    const amount = 100;
    await expect(users[0].FungibleBondingCurve.enter(amount))
      .to.emit(FungibleBondingCurve, 'Entered')
      .withArgs(users[0].address, amount);
  });
});
