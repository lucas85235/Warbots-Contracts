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

        assert.equal(supply.valueOf(), 6, "Incorrect Total Supply!");
    });

    it('Check Account 0 Balance', async () => {
        const instance = await Part.deployed();
        const balance = await instance.balanceOf(accounts[0]);
        assert.equal(balance.valueOf(), 6, "Incorrect Account 0 Balance!");
    });

    it('Check NFT Owner', async () => {
        const instance = await Part.deployed();
        const owner = await instance.ownerOf(5);
        assert.equal(owner.valueOf(), accounts[0], "Incorrect Owner!");
    });

    it('Check NFT Transfer', async () => {
        const instance = await Part.deployed();
        await instance.transferFrom(accounts[0], accounts[1], 5);

        const owner = await instance.ownerOf(5);

        assert.equal(owner.valueOf(), accounts[1], "Incorrect Supply!");
    });

    it('Check Account 0 Balance After Transfer', async () => {
        const instance = await Part.deployed();
        const balance = await instance.balanceOf(accounts[0]);

        assert.equal(balance.valueOf(), 5, "Incorrect Account 0 Balance!");
    });

    it('Check Account 1 Balance After Transfer', async () => {
        const instance = await Part.deployed();
        const balance = await instance.balanceOf(accounts[1]);

        assert.equal(balance.valueOf(), 1, "Incorrect Account 1 Balance!");
    });

    it('Check Get Part Atributes', async () => {
        const instance = await Part.deployed();
        const partsAttr = await instance.getPart(0);

        assert.equal(partsAttr.length, 2, "Incorrect List Length!");
        assert.equal(partsAttr[0], 0, "Incorrect Part Serie!");
        assert.equal(partsAttr[1], 0, "Incorrect Part Type!");
    });

    it('Check Burn', async () => {
        const instance = await Part.deployed();
        await instance.burn(5, { from: accounts[1] });
        const balance = await instance.balanceOf(accounts[1]);

        assert.equal(balance.valueOf(), 0, "Incorrect Account 1 Balance!");
    });

    it('Check Total Supply After Burn', async () => {
        const instance = await Part.deployed();
        const supply = await instance.totalSupply.call();

        assert.equal(supply.valueOf(), 5, "Incorrect Total Supply!");
    });
})
