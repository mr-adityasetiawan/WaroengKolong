const test = require('node:test');
const assert = require('node:assert/strict');
const { menu } = require('../src/server');

test('menu seed contains operational prices', () => {
  assert.ok(menu.length >= 5);
  assert.equal(menu[0].name, 'Nasi Ayam Kolong');
  assert.equal(menu[0].price, 18000);
});
