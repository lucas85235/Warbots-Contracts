const Robot = artifacts.require("Robot");

const ether = 1e18
const sendAmount = 10 * 1e15

contract('Robot', (accounts) => {

    it('Check NFT name', async () => {
        const instance = await Robot.deployed();
        const name = await instance.name.call();

        assert.equal(name.valueOf(), "Robot", "Incorrect Name!");
    });

    it('Check Total Supply', async () => {
        const instance = await Robot.deployed();
        const supply = await instance.totalSupply.call();

        assert.equal(supply.valueOf(), 1, "Incorrect Supply!");
    });

    it('Check Account 0 Balance', async () => {
        const instance = await Robot.deployed();
        const balance = await instance.balanceOf(accounts[0]);

        assert.equal(balance.valueOf(), 1, "Incorrect Account 0 Balance!");
    });

    it('Check NFT Owner', async () => {
        const instance = await Robot.deployed();
        const owner = await instance.ownerOf(0);

        assert.equal(owner.valueOf(), accounts[0], "Incorrect Owner!");
    });

    // it('Check NFT Transfer', async () => {
    //     const instance = await Robot.deployed();
    //     await instance.transferFrom(accounts[0], accounts[1], 0);
    //     const owner = await instance.ownerOf(0);

    //     assert.equal(owner.valueOf(), accounts[1], "Incorrect Owner!");
    // });

    it('Check Get Robot Parts', async () => {
        const instance = await Robot.deployed();
        const robotAttr = await instance.getRobotParts(0);

        assert.equal(robotAttr.length, 5, "Incorrect List Length!");

        for (let i = 0; i < robotAttr.length; i++) {
            assert.equal(robotAttr[i], 0, "Incorrect Part " + i + " Element!");
        }
    });

    it('Check Change Robot Head Part', async () => {
        const instance = await Robot.deployed();
        await instance.updateHead(0, 5, { from: accounts[0] });
        const robotAttr = await instance.getRobotParts(0);

        assert.equal(robotAttr[0], 1, "Incorrect Head Part!");
    });
})
