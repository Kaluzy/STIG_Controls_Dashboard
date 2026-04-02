# Deployment Paths

## Goal

Support two clean deployment modes:

- GitHub Pages for a rendered static reviewable app
- Proxmox-hosted server for the working team version with shared state

## 1. GitHub Pages

### Purpose

Use GitHub Pages for:

- a live rendered page from the repo
- quick stakeholder review
- safe static preview

Use Pages when you want the app visible and easy to access from GitHub.

### What is deployed

The Pages workflow only publishes:

- `index.html`
- `app.js`
- `styles.css`
- `data/`
- `README.md`

It does **not** publish:

- `Harding_STIG/`
- local temp folders
- `server.js`
- mutable shared state

This is intentional. The raw evidence archive is too heavy and too sensitive to treat as a public static Pages payload.

### Expected Pages URL

For the current repo:

```text
https://kaluzy.github.io/STIG_Controls_Dashboard/
```

### Important limitation

GitHub Pages runs the app in static mode only.

That means:

- the HTML renders
- filters and local interactions work
- shared save does not use `server.js`
- note persistence falls back to browser storage

### Required repo setting

If GitHub does not auto-publish after the workflow runs, set:

- Repository Settings
- Pages
- Build and deployment
- Source: `GitHub Actions`

## 2. Proxmox-hosted server

### Purpose

Use Proxmox hosting for the real working version of the app when you want:

- shared notes
- shared priorities
- shared status changes
- internal team collaboration

### Recommended runtime

- small Ubuntu or Windows VM/container
- Node.js installed
- reverse proxy optional through Nginx or Caddy
- TrueNAS for backup if desired

### Run model

```powershell
node server.js
```

This keeps the static UI while enabling shared file-backed state.

### Recommended internal layout

```text
/opt/stig-pilot-control-center/
  index.html
  app.js
  styles.css
  server.js
  data/
  docs/
  backups/
```

### Suggested production notes

- keep source-controlled data in git
- keep mutable shared state outside the repo or in a backed-up data path
- add scheduled backup of shared state to TrueNAS
- use HTTPS internally if exposed beyond a lab network

## 3. Workflow split

### GitHub Pages

Best for:

- review
- demos
- leadership link sharing

### Proxmox server

Best for:

- actual team operations
- shared state
- internal execution

## 4. Recommended combined strategy

Use both:

- GitHub Pages as the static published view
- Proxmox as the real operations environment

That gives you:

- a clean live page from git
- a proper internal working app

## 5. GitHub Actions workflow

Workflow file:

- `.github/workflows/deploy-pages.yml`

What it does:

1. runs on push to `main`
2. builds a small `_site` folder
3. copies only the static app files
4. uploads the Pages artifact
5. deploys it to GitHub Pages

## 6. Review checklist

Before treating the deployment as final, verify:

- the GitHub Pages workflow succeeds
- the site loads from the expected Pages URL
- the app can load `data/baseline-data.js`
- no raw scan archive is accidentally published
- the Proxmox-hosted copy still supports shared state through `server.js`
