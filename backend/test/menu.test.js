const test = require('node:test');
const assert = require('node:assert/strict');
const { menu, minimumPortionPerMenu, orderLeadDays } = require('../src/server');

test('menu seed follows Waroeng Kolong web order page', () => {
  assert.equal(menu.length, 2);
  assert.deepEqual(
    menu.map((item) => [item.id, item.name, item.price]),
    [
      ['mie-rebus-medan', 'Mie Rebus Medan', 17000],
      ['lontong-medan', 'Lontong Medan', 15000],
    ],
  );
});

test('online order rules match the web page', () => {
  assert.equal(minimumPortionPerMenu, 20);
  assert.equal(orderLeadDays, 3);
});
