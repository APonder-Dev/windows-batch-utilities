# Windows Batch Utilities

A collection of **Windows Command Prompt (Batch) scripts** developed and maintained by me.  
Each script provides quick automation, diagnostics, or quality-of-life features for Windows systems.

---

## 📦 Available Scripts

### 📋 Menu Launcher
- **File:** [`menu_launcher.bat`](./scripts/menu_launcher.bat)  
- **Description:** A text-based launcher that allows you to easily run any of the available batch utilities.  
- **Features:**
  - Clean console menu.
  - Calls other scripts automatically.
  - Designed to scale as more utilities are added.

### 🖥️ System Info Snapshot
- **File:** [`sysinfo_snapshot.bat`](./scripts/sysinfo_snapshot.bat)  
- **Description:** Collects system, network, and disk information into a timestamped report folder.  
- **Features:**
  - Saves output of `systeminfo`, `ipconfig /all`, installed hotfixes, and disk usage.  
  - Reports stored under:  
    ```
    scripts/reports/<yyyy-MM-dd_HH-mm-ss>/
    ```
  - Great for troubleshooting or documentation snapshots.

### 🌐 Network Quick Diagnostic
- **File:** [`net_quickdiag.bat`](./scripts/net_quickdiag.bat)  
- **Description:** Quickly checks IP config, pings your default gateway and public DNS, verifies DNS resolution, prints route table, active connections, and DNS cache.
- **Features:**
  - Shows IPv4/Subnet/Default Gateway.
  - Pings your default gateway.
  - Verifies DNS resolution with `nslookup`.
  - Tests internet reachability (1.1.1.1 & 8.8.8.8).
  - Prints route table and active connections.
  - Displays DNS cache entries.

---

## 🛠 Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/APonder-Dev/windows-batch-utilities.git
   cd windows-batch-utilities
   ```

2. Navigate into the `scripts` folder:
   ```bat
   cd scripts
   ```

3. Run the menu launcher:
   ```bat
   menu_launcher.bat
   ```

---

## 🔧 Usage

### Run via Menu
1. Open `menu_launcher.bat`.  
2. Choose a number from the list.  
3. Outputs are displayed in the console or saved to the `reports/` folder.  

### Run a Script Directly
Example:  
```bat
scripts\sysinfo_snapshot.bat
```

---

## 📌 Roadmap

Planned future scripts include:

- 🧹 **Temp & Cache Cleaner** — wipe safe temp folders and browser caches.  
- 💾 **Smart Backup** — incremental backups via `robocopy`.  
- 🗂️ **File Organizer** — sort files into extension-based folders.  
- 🔍 **Large File Hunter** — find largest files recursively.  
- 📡 **Wi-Fi Profile Exporter** — dump saved Wi-Fi profiles to XML.  
- 📝 **Hosts Toggle** — swap between dev and default hosts file.  
- 🔧 **Git Quick Helper** — `git add + commit + push` shortcut.  
- 📶 **Ping Sweep** — scan local subnet for alive hosts.  
- 🔄 **Windows Update Check** — list available updates (PowerShell required).  

---

## 🤖 Continuous Integration (CI)

This repo can be extended with **GitHub Actions**:

- **Every tag push** (e.g. `v1.0.0`) → package scripts into a `.zip` and attach to a GitHub Release.  
- Keeps releases clean and ready to download.  

Workflow file: `.github/workflows/release.yml`

---

## 📂 Repo Structure

```
.
├─ scripts/                  # All batch scripts live here
│  ├─ menu_launcher.bat
│  ├─ net_quickdiag.bat
│  ├─ sysinfo_snapshot.bat
│  └─ reports/               # Auto-created by sysinfo_snapshot (Will not see this yet.)
│     └─ <yyyy-MM-dd_HH-mm-ss>/
│        ├─ systeminfo.txt
│        ├─ ipconfig_all.txt
│        ├─ hotfixes.txt
│        └─ disks.txt
├─ .github/workflows/        # GitHub Actions configs (optional)
├─ .gitignore
├─ .gitattributes
├─ LICENSE
└─ README.md
```

---

## 📜 License

This project is licensed under the [MIT License](./LICENSE).

---

## ⭐ Support

- Found a bug? → Open an [Issue](../../issues).  
- Want to contribute? → Pull Requests are welcome.  
- If you find these utilities useful, please consider **starring ⭐ the repo**!

---

## 💖 Donation

If you find these tools helpful, you can support my development:  

[💸 Donate via PayPal](https://www.paypal.com/donate/?business=6TUCF33LPY9K2&no_recurring=0&item_name=Development+and+Coding+Features&currency_code=USD)
