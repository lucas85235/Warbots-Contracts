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

        assert.equal(supply.valueOf(), 3, "Incorrect Supply!");
    });

    it('Check Owner Balance', async () => {
        const instance = await Robot.deployed();
        const balance = await instance.balanceOf(accounts[0]);
        assert.equal(balance.valueOf(), 3, "Incorrect Supply!");
    });

    it('Check NFT Owner', async () => {
        const instance = await Robot.deployed();
        const balance = await instance.ownerOf(0);
        assert.equal(balance.valueOf(), accounts[0], "Incorrect Supply!");
    });

    it('Check Get Robots List', async () => {
        const instance = await Robot.deployed();
        const robotsArray = await instance.robotsList(accounts[0]);

        assert.equal(robotsArray.length, 3, "Incorrect List Length!");

        for (let i = 0; i < robotsArray.length; i++) {
            assert.equal(robotsArray[i], i, "Incorrect List " + i + " Element!");
        }
    });

    it('Check NFT Transfer', async () => {
        const instance = await Robot.deployed();
        await instance.transferFrom(accounts[0], accounts[1], 0);

        const balance = await instance.ownerOf(0);

        assert.equal(balance.valueOf(), accounts[1], "Incorrect Supply!");
    });

    it('Check Get Robots Account 0 List', async () => {
        const instance = await Robot.deployed();
        const robotsArray = await instance.robotsList(accounts[0]);

        assert.equal(robotsArray.length, 2, "Incorrect List Length!");
    });

    it('Check Get Robots Account 1 List', async () => {
        const instance = await Robot.deployed();
        const robotsArray = await instance.robotsList(accounts[1]);

        assert.equal(robotsArray.length, 1, "Incorrect List Length!");

        for (let i = 0; i < robotsArray.length; i++) {
            assert.equal(robotsArray[i], i, "Incorrect List " + i + " Element!");
        }
    });

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
        await instance.updateHead(0, 1, { from: accounts[1] });

        const robotAttr = await instance.getRobotParts(0);

        assert.equal(robotAttr[0], 1, "Incorrect Head Part!");
    });

})
