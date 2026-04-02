# Git And Deploy

## Recommended model

Use:

- GitHub for source control
- Proxmox-hosted Node server for the working shared app
- optional GitHub Pages only for a static preview

## Why

The app has two modes:

- static HTML mode
  - renders fine anywhere
  - shared state falls back to browser local storage

- server mode
  - renders the same UI
  - keeps shared note and priority state through `server.js`

If you want team collaboration, use server mode on an internal VM or container.

## Repository layout

Keep in git:

- `index.html`
- `server.js`
- `app.js`
- `styles.css`
- `data/baseline-data.js`
- docs
- source JSON and static assets

Do not keep in git by default:

- `data/shared-infosec-state.json`
- temp workbook extraction folders
- exported local report bundles unless intentionally versioned

## Initialize git locally

From the project root:

```powershell
Set-Location "C:\Users\kaluz\OneDrive\Documents\AI Playground\STIG-Pilot-Dashboard"
git init
git add .
git commit -m "Initial STIG Pilot Control Center"
```

## Connect to GitHub

```powershell
git branch -M main
git remote add origin <YOUR_GITHUB_REPO_URL>
git push -u origin main
```

## Static preview option

If you only want the app to render as a static page:

1. push to GitHub
2. enable GitHub Pages
3. publish from the root or `/docs` branch/folder depending on your repo setup

Result:

- the HTML renders
- local shared save does not use `server.js`

## Team-ready hosted option

Use your Proxmox environment for the real app:

1. create a small Linux or Windows VM/container
2. clone the repo
3. install Node.js
4. run:

```powershell
node server.js
```

5. optionally put Nginx or Caddy in front
6. store backups on TrueNAS if desired

Result:

- rendered app
- shared state via local JSON file
- simple internal collaboration

## Suggested next deployment improvement

Once the app moves to structured multi-file JSON and lifecycle records:

- keep source-controlled data files in git
- keep mutable shared-state and exports out of git
- add periodic backup of mutable state to TrueNAS

## If git still fails from OneDrive path

If PowerShell keeps truncating the path in your current shell, run:

```powershell
Set-Location "C:\Users\kaluz\OneDrive\Documents\AI Playground\STIG-Pilot-Dashboard"
git status
```

If that still fails, move or clone the project to a shorter local path such as:

```text
C:\Projects\STIG-Pilot-Control-Center
```

That avoids OneDrive path issues and is usually the better long-term developer path.
