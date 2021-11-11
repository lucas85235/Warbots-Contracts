const Part = artifacts.require("Part");

const ether = 1e18
const sendAmount = 10 * 1e15

contract('Part', (accounts) => {

    it('Check NFT name', async () => {
        const instance = await Part.deployed();
        const name = await instance.name.call();

        assert.equal(name.valueOf(), "Part", "Incorrect Name!");
    });

    it('Check Total Supply', async () => {
        const instance = await Part.deployed();
        const supply = await instance.totalSupply.call();

        assert.equal(supply.valueOf(), 6, "Incorrect Supply!");
    });

    it('Check Owner Balance', async () => {
        const instance = await Part.deployed();
        const balance = await instance.balanceOf(accounts[0]);
        assert.equal(balance.valueOf(), 6, "Incorrect Supply!");
    });

    it('Check NFT Owner', async () => {
        const instance = await Part.deployed();
        const owner = await instance.ownerOf(0);
        assert.equal(owner.valueOf(), accounts[0], "Incorrect Supply!");
    });

    it('Check Get Parts List', async () => {
        const instance = await Part.deployed();
        const partsArray = await instance.partsList(accounts[0]);

        assert.equal(partsArray.length, 6, "Incorrect List Length!");

        for (let i = 0; i < partsArray.length; i++) {
            assert.equal(partsArray[i], i, "Incorrect List " + i + " Element!");
        }
    });

    it('Check NFT Transfer', async () => {
        const instance = await Part.deployed();
        await instance.transferFrom(accounts[0], accounts[1], 0);

        const owner = await instance.ownerOf(0);

        assert.equal(owner.valueOf(), accounts[1], "Incorrect Supply!");
    });

    it('Check Get Parts Account 0 List', async () => {
        const instance = await Part.deployed();
        const partsArray = await instance.partsList(accounts[0]);

        assert.equal(partsArray.length, 5, "Incorrect List Length!");
    });

    it('Check Get Parts Account 1 List', async () => {
        const instance = await Part.deployed();
        const partsArray = await instance.partsList(accounts[1]);

        assert.equal(partsArray.length, 1, "Incorrect List Length!");

        for (let i = 0; i < partsArray.length; i++) {
            assert.equal(partsArray[i], i, "Incorrect List " + i + " Element!");
        }
    });

    it('Check Get Part Atributes', async () => {
        const instance = await Part.deployed();
        const partsAttr = await instance.getPart(0);

        assert.equal(partsAttr.length, 2, "Incorrect List Length!");
        assert.equal(partsAttr[0], 0, "Incorrect Part Serie!");
        assert.equal(partsAttr[1], 0, "Incorrect Part Type!");
    });
})
