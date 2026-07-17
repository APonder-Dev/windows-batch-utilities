# Windows Batch Utilities

A collection of **Windows Command Prompt (Batch) scripts** developed and maintained by me.  
Each script provides quick automation, diagnostics, or quality-of-life features for Windows systems.

---

## Available Scripts

### Menu Launcher
- **File:** [`menu_launcher.bat`](./scripts/menu_launcher.bat)
- **Description:** A text-based launcher that allows you to easily run any of the available batch utilities.
- **Features:**
  - Clean console menu with tools grouped by category (System / Network / Files).
  - Shows current date, time, and whether you are running as Administrator.
  - Short description next to every option.
  - `R` opens the `reports/` folder, `L` opens the backup `logs/` folder in Explorer.
  - Friendly handling of invalid selections.
  - Designed to scale as more utilities are added.

### System Info Snapshot
- **File:** [`sysinfo_snapshot.bat`](./scripts/sysinfo_snapshot.bat)
- **Description:** Collects system, network, disk, process, and startup information into a timestamped report folder.
- **Features:**
  - Saves `systeminfo`, `ipconfig /all`, installed hotfixes, disk usage, running processes, startup programs, and system uptime.
  - Uses PowerShell for hotfixes and disk info (WMIC-free, Windows 11 compatible).
  - Reports stored under:
    ```
    scripts/reports/<yyyy-MM-dd_HH-mm-ss>/
    ```

### Network Quick Diagnostic
- **File:** [`net_quickdiag.bat`](./scripts/net_quickdiag.bat)
- **Description:** Quickly checks IP config, pings your default gateway and public DNS, verifies DNS resolution, prints route table, active connections, and DNS cache.
- **Features:**
  - Shows IPv4/Subnet/Default Gateway/DNS servers.
  - Reliable gateway detection via PowerShell.
  - Pass/Fail status for gateway and internet reachability pings.
  - Verifies DNS resolution with `nslookup`.
  - Tests internet reachability (1.1.1.1 & 8.8.8.8).
  - Prints route table and active connections.
  - Displays DNS cache entries.

### Temp and Cache Cleaner
- **File:** [`temp_cleaner.bat`](./scripts/temp_cleaner.bat)
- **Description:** Safely wipes temporary files and browser caches, then reports how much disk space was freed.
- **Features:**
  - Cleans User Temp (`%TEMP%`).
  - Cleans Windows Temp (`C:\Windows\Temp`) when run as Administrator.
  - Cleans Chrome, Edge, and Firefox caches (Firefox profiles auto-detected).
  - Warns if targeted browsers are currently running.
  - Shows MB freed on `C:` before and after cleanup.
  - Requires confirmation before deleting anything.

### Smart Backup
- **File:** [`smart_backup.bat`](./scripts/smart_backup.bat)
- **Description:** Incremental folder backups powered by `robocopy`, with remembered paths and timestamped logs.
- **Features:**
  - **Incremental mode** (default): copies only new and updated files — nothing is ever deleted.
  - **Mirror mode**: makes the destination an exact copy of the source (with an explicit warning, since extra files in the destination are deleted).
  - Remembers your last source/destination — just press Enter to reuse them.
  - Validates paths, offers to create the destination, and asks for confirmation before running.
  - Multi-threaded copy (`/MT:8`) with retry handling for locked files.
  - Clear Pass/Fail summary based on robocopy exit codes.
  - Full logs saved to:
    ```
    scripts/logs/backup_<yyyy-MM-dd_HH-mm-ss>.log
    ```

### File Organizer
- **File:** [`file_organizer.bat`](./scripts/file_organizer.bat)
- **Description:** Sorts the files in a folder (e.g. Downloads) into tidy subfolders, with a preview before anything moves.
- **Features:**
  - **By type** (default): groups files into Images, Documents, Videos, Music, Archives, Programs, and Other.
  - **By extension**: one folder per extension (`jpg/`, `pdf/`, ...).
  - Shows a full plan (how many files go where) and asks for confirmation before moving anything.
  - Only touches top-level files — existing subfolders are left alone.
  - Name clashes are resolved safely with `_1`, `_2`, ... suffixes; nothing is ever overwritten.
  - Remembers your last folder — just press Enter to reuse it.

### Large File Hunter
- **File:** [`large_file_hunter.bat`](./scripts/large_file_hunter.bat)
- **Description:** Recursively finds the biggest files under a folder so you can see what is eating your disk.
- **Features:**
  - **Top N mode** (default): lists the N largest files (you pick N, default 25).
  - **Size limit mode**: lists every file over a minimum size in MB.
  - Scans all subfolders; access-denied files are skipped silently.
  - Sizes shown in MB/GB with full file paths, plus a total scanned summary.
  - Optionally saves the results to `scripts/reports/large_files_<yyyy-MM-dd_HH-mm-ss>.txt`.
  - Remembers your last folder — just press Enter to reuse it.

### Wi-Fi Profile Exporter
- **File:** [`wifi_profile_exporter.bat`](./scripts/wifi_profile_exporter.bat)
- **Description:** Backs up every saved Wi-Fi profile to XML files you can restore on any PC with `netsh wlan add profile`.
- **Features:**
  - Lists all saved profiles with a count before doing anything.
  - Exports **without passwords** by default; optional **plain-text password** export when run as Administrator (with a clear warning).
  - Exports to a timestamped folder:
    ```
    scripts/reports/wifi_profiles_<yyyy-MM-dd_HH-mm-ss>/
    ```
  - Verifies and reports how many profiles were actually exported.
  - Friendly messages when there is no wireless adapter or no saved profiles.

---

## Installation

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

## Usage

### Run via Menu
1. Open `menu_launcher.bat`.
2. Choose a number from the list.
3. Outputs are displayed in the console or saved to the `reports/` folder.

### Run a Script Directly
Example:
```bat
scripts\sysinfo_snapshot.bat
scripts\temp_cleaner.bat
scripts\smart_backup.bat
scripts\file_organizer.bat
scripts\large_file_hunter.bat
scripts\wifi_profile_exporter.bat
```

> **Tip:** Run `temp_cleaner.bat` as Administrator to also clean `C:\Windows\Temp`.

---

## Roadmap

Planned future scripts include:

- **Hosts Toggle** — swap between dev and default hosts file.
- **Git Quick Helper** — `git add + commit + push` shortcut.
- **Ping Sweep** — scan local subnet for alive hosts.
- **Windows Update Check** — list available updates (PowerShell required).

---

## Continuous Integration (CI)

This repo can be extended with **GitHub Actions**:

- **Every tag push** (e.g. `v1.2.0`) → package scripts into a `.zip` and attach to a GitHub Release.
- Keeps releases clean and ready to download.

Workflow file: `.github/workflows/release.yml`

---

## Repo Structure

```
.
├─ scripts/                  # All batch scripts live here
│  ├─ file_organizer.bat
│  ├─ large_file_hunter.bat
│  ├─ menu_launcher.bat
│  ├─ net_quickdiag.bat
│  ├─ smart_backup.bat
│  ├─ sysinfo_snapshot.bat
│  ├─ temp_cleaner.bat
│  ├─ wifi_profile_exporter.bat
│  ├─ logs/                  # Auto-created by smart_backup (gitignored)
│  │  └─ backup_<yyyy-MM-dd_HH-mm-ss>.log
│  └─ reports/               # Auto-created by report-producing tools
│     ├─ large_files_<yyyy-MM-dd_HH-mm-ss>.txt
│     ├─ wifi_profiles_<yyyy-MM-dd_HH-mm-ss>/
│     └─ <yyyy-MM-dd_HH-mm-ss>/
│        ├─ systeminfo.txt
│        ├─ ipconfig_all.txt
│        ├─ hotfixes.txt
│        ├─ disks.txt
│        ├─ processes.txt
│        ├─ startup.txt
│        └─ uptime.txt
├─ .github/workflows/        # GitHub Actions configs (optional)
├─ .gitignore
├─ .gitattributes
├─ LICENSE
└─ README.md
```

---

## License

This project is licensed under the [MIT License](./LICENSE).

---

## Support

- Found a bug? → Open an [Issue](../../issues).
- Want to contribute? → Pull Requests are welcome.
- If you find these utilities useful, please consider **starring the repo**!

---

## Donation

If you find these tools helpful, you can support my development:

[Buy Me a Coffee](https://buymeacoffee.com/aponder.dev)
