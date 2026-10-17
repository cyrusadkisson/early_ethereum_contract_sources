// Checks every contract in manifest.json against the code deployed on Ethereum mainnet.
//
// usage: node check.cjs <rpc-url> [--download] [--compilers=<dir>] [address ...]
//
// Compilers are read from ./compilers/, or from the folder given with --compilers. With --download, missing ones are fetched from
// https://binaries.soliditylang.org/bin/ and checked against the SHA-256 that list.json publishes.
// Each file is compiled in a fresh process, because compilers this old can give different output
// after compiling something else. Give addresses to check only those contracts.
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const { execFileSync } = require('child_process');

const HERE = __dirname;
const dirArg = process.argv.find(a => a.startsWith('--compilers='));
const COMPILERS = dirArg ? path.resolve(dirArg.slice(12)) : path.join(HERE, 'compilers');
const BIN = 'https://binaries.soliditylang.org/bin/';

// --- worker: compile one manifest entry and print {creation, runtime} ---
if (process.argv[2] === '--worker') {
  const e = JSON.parse(process.argv[3]);
  const solc = require(path.join(COMPILERS, e.compiler));
  let creation, runtime;
  if (e.mode === 'legacy') {
    const compile = solc.cwrap('compileJSON', 'string', ['string', 'number']);
    const out = JSON.parse(compile(fs.readFileSync(path.join(HERE, e.file), 'utf8'), e.optimize ? 1 : 0));
    const c = out.contracts && (out.contracts[e.contract] || out.contracts[':' + e.contract]);
    if (!c) { console.log(JSON.stringify({ error: String(out.errors || 'contract not found') })); process.exit(0); }
    creation = c.bytecode;
    runtime = c.runtimeBytecode || sliceRuntime(creation);
  } else {
    const sources = {};
    if (e.root) {
      for (const f of walk(path.join(HERE, e.root))) sources[path.relative(path.join(HERE, e.root), f).split(path.sep).join('/')] = { content: fs.readFileSync(f, 'utf8') };
    } else {
      sources[e.path] = { content: fs.readFileSync(path.join(HERE, e.file), 'utf8') };
    }
    const input = { language: 'Solidity', sources, settings: {
      optimizer: { enabled: e.optimize, runs: e.runs }, evmVersion: e.evmVersion,
      outputSelection: { '*': { '*': ['evm.bytecode.object', 'evm.deployedBytecode.object'] } } } };
    const compile = solc.cwrap('solidity_compile', 'string', ['string', 'number', 'number']);
    const out = JSON.parse(compile(JSON.stringify(input), 0, 0));
    const key = e.root ? path.relative(e.root, e.file).split(path.sep).join('/') : e.path;
    const c = out.contracts && out.contracts[key] && out.contracts[key][e.contract];
    if (!c) { console.log(JSON.stringify({ error: JSON.stringify(out.errors || 'contract not found').slice(0, 500) })); process.exit(0); }
    creation = c.evm.bytecode.object;
    runtime = c.evm.deployedBytecode.object;
  }
  console.log(JSON.stringify({ creation, runtime }));
  process.exit(0);
}

function walk(dir) {
  return fs.readdirSync(dir, { withFileTypes: true }).flatMap(d => d.isDirectory() ? walk(path.join(dir, d.name)) : [path.join(dir, d.name)]);
}

// Solidity 0.1.x-0.4.x constructors end with: PUSH2 <len> DUP1 PUSH2 <offset> PUSH1 0 CODECOPY PUSH1 0 RETURN
function sliceRuntime(creation) {
  const m = creation.match(/61([0-9a-f]{4})8061([0-9a-f]{4})6000396000f3/);
  if (!m) return null;
  const len = parseInt(m[1], 16), offset = parseInt(m[2], 16);
  return creation.slice(offset * 2, (offset + len) * 2);
}

// The hash of the compiler's metadata, which covers the exact source text and file name, is appended to the code.
const METADATA = /a165627a7a72305820[0-9a-f]{64}0029|a265627a7a72315820[0-9a-f]{64}64736f6c6343[0-9a-f]{6}0032|a2646970667358221220[0-9a-f]{64}64736f6c6343[0-9a-f]{6}0033/g;
function compare(mine, chain, allowArgs) {
  mine = (mine || '').toLowerCase().replace(/^0x/, ''); chain = chain.toLowerCase().replace(/^0x/, '');
  if (!mine) return 'NOT COMPILED';
  if (mine === chain) return 'IDENTICAL';
  if (allowArgs && chain.startsWith(mine)) return 'IDENTICAL + constructor arguments';
  const a = mine.replace(METADATA, 'm'), b = chain.replace(METADATA, 'm');
  if (a === b) return 'IDENTICAL except metadata hash';
  if (allowArgs && b.startsWith(a)) return 'IDENTICAL except metadata hash, + constructor arguments';
  return 'DIFFERENT';
}

// Public endpoints rate-limit, so a failed call is retried a few times with a growing pause.
async function rpc(url, method, params) {
  for (let attempt = 0; attempt < 5; attempt++) {
    try {
      const r = await fetch(url, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ jsonrpc: '2.0', id: 1, method, params }) });
      const j = await r.json();
      if (j.result !== undefined && !(method === 'eth_getCode' && j.result === null)) return j.result;
    } catch (err) { /* retry */ }
    await new Promise(res => setTimeout(res, 2000 * (attempt + 1)));
  }
  return undefined;
}

async function ensureCompilers(entries, download) {
  fs.mkdirSync(COMPILERS, { recursive: true });
  const needed = [...new Set(entries.filter(e => e.compiler).map(e => e.compiler))];
  const missing = needed.filter(c => !fs.existsSync(path.join(COMPILERS, c)));
  if (!missing.length) return true;
  if (!download) {
    console.log('Missing compilers (run again with --download, or save them in ./compilers/ yourself):');
    for (const c of missing) console.log('  ' + BIN + c);
    return false;
  }
  const list = await (await fetch(BIN + 'list.json')).json();
  for (const c of missing) {
    const entry = list.builds.find(b => b.path === c);
    const data = Buffer.from(await (await fetch(BIN + c)).arrayBuffer());
    const sha = '0x' + crypto.createHash('sha256').update(data).digest('hex');
    if (!entry || sha !== entry.sha256) { console.log(`${c}: SHA-256 does not match list.json; not saved`); return false; }
    fs.writeFileSync(path.join(COMPILERS, c), data);
    console.log(`downloaded ${c} (SHA-256 matches list.json)`);
  }
  return true;
}

(async () => {
  const args = process.argv.slice(2);
  const url = args.find(a => /^https?:/.test(a));
  if (!url) { console.error('usage: node check.cjs <rpc-url> [--download] [--compilers=<dir>] [address ...]'); process.exit(2); }
  const only = args.filter(a => /^0x[0-9a-fA-F]{40}$/.test(a)).map(a => a.toLowerCase());
  const entries = JSON.parse(fs.readFileSync(path.join(HERE, 'manifest.json'), 'utf8')).filter(e => !only.length || only.includes(e.address.toLowerCase()));
  if (!(await ensureCompilers(entries, args.includes('--download')))) process.exit(1);
  let bad = 0;
  for (const e of entries) {
    let built;
    if (e.mode === 'binary') {
      const creation = fs.readFileSync(path.join(HERE, e.file), 'utf8').trim().replace(/^0x/, '');
      built = { creation, runtime: sliceRuntime(creation) };
    } else {
      const out = execFileSync(process.execPath, [__filename, '--worker', JSON.stringify(e)].concat(dirArg ? [dirArg] : []), { stdio: ['ignore', 'pipe', 'ignore'], maxBuffer: 1 << 26 }).toString();
      built = JSON.parse(out.trim().split('\n').pop());
      if (built.error) { console.log(`${e.label} ${e.address}: compile error: ${built.error}`); bad++; continue; }
    }
    const code = await rpc(url, 'eth_getCode', [e.address, 'latest']);
    if (code === undefined) { console.log(`${e.label} ${e.address}: the node did not return its code`); bad++; continue; }
    const rt = compare(built.runtime, code, false);
    let cr = 'no deployment transaction (created by another contract)';
    if (e.deployment_tx) {
      const tx = await rpc(url, 'eth_getTransactionByHash', [e.deployment_tx]);
      cr = tx ? compare(built.creation, tx.input, true) : 'deployment transaction not served by this node';
      await new Promise(res => setTimeout(res, 300));
    }
    if (rt === 'DIFFERENT' || rt === 'NOT COMPILED' || cr === 'DIFFERENT') bad++;
    console.log(`${e.label} ${e.address}\n    runtime:  ${rt}\n    creation: ${cr}`);
  }
  console.log(bad ? `${bad} DIFFERENT` : 'All checked contracts match.');
  process.exit(bad ? 1 : 0);
})();
