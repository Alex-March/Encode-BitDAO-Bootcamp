//  Store string to IPFS

// Dependency
const IPFS = require('ipfs');

(async() => {
  // Initialise IPFS node
  const node = await IPFS.create();
  // Set some data to a variable
  const data = 'Hello, <YOUR NAME HERE>';
  // Submit data to the network
  const cid = await node.add(data);
  // Log CID to console
  console.log(cid.path);
})();

document.body.innerHTML = data

// Retrieve string from IPFS

// Dependencies
const IPFS = require('ipfs');

const all = require('it-all');

(async  () => {
  // Initialise IPFS node
  const node = await IPFS.create();

  // Store CID in a variable
  const cid ='QmPChd2hVbrJ6bfo3WBcTW4iZnpHm8TEzWkLHmLpXhF68A';

  // Retrieve data from CID
  const data = Buffer.concat(await all(node.cat(cid)));

  // Print data to console
  console.log(data.toString());
})();



// Store file to IPFS
// Client-side:
const reader = new FileReader();
reader.onloadend = function () {
  const buf = buffer.Buffer.from(reader.result);
  const route = 'addFile';
  const req = { data: buf };
  // ...
  // ...
}
const file = document.getElementById("file");
reader.readAsArrayBuffer(file.files[0]);

// For IPFS add:
let buf = Buffer.from(obj);

// To show retrieved data on screen

function toBase64(arr) {
  arr = new Uint8Array(arr)
  return btoa(
    arr.reduce((data, byte) => data + String.fromCharCode(byte),'')
    );
  }
$('#ipfs-image').attr('src',`data:image/png;base64,
  ${toBase64(response[0].data)}`);

  