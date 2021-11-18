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
  it('enter works', async function () {
    const {users, FungibleBondingCurve} = await setup();
    const amount = 100;
    const supply = await FungibleBondingCurve.supply();
    const linearCoefficientPer10Thousands = await FungibleBondingCurve.linearCoefficientPer10Thousands();
    const curveStart = await FungibleBondingCurve.curveStart();
    const contribution = curveStart.add(supply.mul(linearCoefficientPer10Thousands).div(10000)).mul(amount);
    await expect(users[0].FungibleBondingCurve.enter(amount))
      .to.emit(FungibleBondingCurve, 'Entered')
      .withArgs(users[0].address, amount, contribution);
  });
});
