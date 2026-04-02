const http = require('http');
const fs = require('fs');
const path = require('path');

const root = __dirname;
const port = process.env.PORT || 3085;
const statePath = path.join(root, 'data', 'shared-infosec-state.json');

const mimeTypes = {
  '.html': 'text/html; charset=utf-8',
  '.js': 'application/javascript; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.md': 'text/markdown; charset=utf-8',
  '.xml': 'application/xml; charset=utf-8'
};

function send(res, status, body, type = 'text/plain; charset=utf-8') {
  res.writeHead(status, {
    'Content-Type': type,
    'Cache-Control': 'no-store'
  });
  res.end(body);
}

function readState() {
  try {
    return JSON.parse(fs.readFileSync(statePath, 'utf8'));
  } catch {
    return {};
  }
}

function writeState(data) {
  fs.mkdirSync(path.dirname(statePath), { recursive: true });
  fs.writeFileSync(statePath, JSON.stringify(data, null, 2));
}

function serveFile(res, relPath) {
  const fullPath = path.join(root, relPath);
  const normalized = path.normalize(fullPath);
  if (!normalized.startsWith(path.normalize(root))) {
    send(res, 403, 'Forbidden');
    return;
  }

  if (!fs.existsSync(normalized) || fs.statSync(normalized).isDirectory()) {
    send(res, 404, 'Not found');
    return;
  }

  const ext = path.extname(normalized).toLowerCase();
  send(res, 200, fs.readFileSync(normalized), mimeTypes[ext] || 'application/octet-stream');
}

const server = http.createServer((req, res) => {
  const url = new URL(req.url, `http://${req.headers.host}`);

  if (url.pathname === '/api/infosec-state' && req.method === 'GET') {
    send(res, 200, JSON.stringify(readState(), null, 2), mimeTypes['.json']);
    return;
  }

  if (url.pathname === '/api/infosec-state' && req.method === 'POST') {
    let body = '';
    req.on('data', chunk => {
      body += chunk;
      if (body.length > 2_000_000) req.destroy();
    });
    req.on('end', () => {
      try {
        const parsed = JSON.parse(body || '{}');
        writeState(parsed);
        send(res, 200, JSON.stringify({ ok: true }), mimeTypes['.json']);
      } catch {
        send(res, 400, JSON.stringify({ ok: false, error: 'Invalid JSON payload' }), mimeTypes['.json']);
      }
    });
    return;
  }

  if (url.pathname === '/' || url.pathname === '/index.html') {
    serveFile(res, 'index.html');
    return;
  }

  serveFile(res, decodeURIComponent(url.pathname).replace(/^\/+/, ''));
});

server.listen(port, () => {
  console.log(`STIG tracker available at http://localhost:${port}`);
});
