# CapsuleerScripts

A collection of PowerShell scripts designed for EVE Online players and developers. These tools focus on interacting with the [EVE Swagger Interface (ESI)](https://esi.evetech.net/ui/) and supporting capsuleers with useful automation, diagnostics, and data extraction.

## 🔧 Features

- ✅ OAuth2 authentication via EVE Online's SSO
- 🚀 Character asset fetching from ESI
- 📡 Network diagnostics for EVE connectivity
- 📊 Loot sheet templating (for corp or personal usage)
- 📁 Local JSON data storage for ship/type info

---

## 🧰 Requirements

- **PowerShell 5.1+** (Windows) or **PowerShell 7+** (Cross-platform)
- Internet access to authenticate and query the ESI API

---

## 🧪 Scripts Overview

| Script | Purpose |
|--------|---------|
| `eve-auth-module.ps1` | OAuth2 flow for acquiring access and refresh tokens |
| `eve-online-loot-sheet v1.ps1` | Loot tallying and formatting tool |
| `eve-online-network-diagnostics v6.ps1` | EVE-specific connection and port testing |
| `eve_ships.json` | Data reference file (types, IDs, etc.) used for offline lookups |

---

## 🔑 OAuth2 Auth Flow (CLI)

1. Open a terminal and run:

```powershell
.\eve-auth-module.ps1 -ClientID "your-client-id" -ClientSecret "your-secret" -RedirectUri "https://yourapp.com/callback"
