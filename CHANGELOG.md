# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),  
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]
### Planned
- File Organizer — sort files into extension-based folders.
- Large File Hunter — find largest files recursively.
- Wi-Fi Profile Exporter — dump saved Wi-Fi profiles to XML.
- Hosts Toggle — swap between dev and default hosts file.
- Git Quick Helper — `git add + commit + push` shortcut.
- Ping Sweep — scan local subnet for alive hosts.
- Windows Update Check — list available updates (PowerShell required).

---

## [1.3.0] - 2026-07-14
### Added
- `scripts/smart_backup.bat` — incremental folder backups via `robocopy`; Incremental (copy new/updated only) and Mirror (exact copy) modes; remembers last-used source/destination in `smart_backup.ini`; validates paths and confirms before running; multi-threaded copy with timestamped logs under `scripts/logs/`.

### Changed
- `scripts/menu_launcher.bat` — redesigned layout: tools grouped by category (Diagnostics / Maintenance), short description per option, date/time and Administrator status in the header, `R` shortcut to open the reports folder, friendly invalid-input handling; suppressed `mode con` errors on terminals that do not support resizing.
- `README.md` — documented Smart Backup and the new menu; moved Smart Backup from Roadmap to Available Scripts; updated repo structure.
- `.gitignore` — exclude `scripts/logs/` and `scripts/smart_backup.ini`.

---

## [1.2.0] - 2026-07-13
### Added
- `scripts/temp_cleaner.bat` — cleans User Temp, Windows Temp (admin), and Chrome/Edge/Firefox caches; warns about running browsers; shows MB freed before and after.

### Changed
- `scripts/net_quickdiag.bat` — fixed gateway detection using PowerShell (was unreliable with multiple adapters); removed `| more` pagination; added Pass/Fail status indicators for gateway and internet pings; improved header formatting.
- `scripts/sysinfo_snapshot.bat` — replaced deprecated `wmic` commands with PowerShell equivalents; added three new report files (processes, startup programs, uptime); improved progress display; now Windows 11 compatible.
- `scripts/menu_launcher.bat` — added menu option 3 for Temp and Cache Cleaner.
- `README.md` — documented temp_cleaner.bat; updated sysinfo_snapshot feature list; updated repo structure.

---

## [1.1.0] - 2025-08-30
### Added
- `scripts/net_quickdiag.bat` — quick network health checks (gateway, DNS, internet, routes, netstat, DNS cache).

### Changed
- `scripts/menu_launcher.bat` — added menu option for Network Quick Diagnostic.
- `README.md` — moved Network Quick Diagnostic from Roadmap to Available Scripts.
- `CHANGELOG.md` — project history and version tracking.

---

## [1.0.0] - 2025-08-30
### Added
- `scripts/menu_launcher.bat` — main menu to access all tools.
- `scripts/sysinfo_snapshot.bat` — collect system, network, and disk info into timestamped reports.
- `README.md` — usage instructions, roadmap, and repo structure.
- `LICENSE` — MIT license.
- `.gitignore` — exclude reports/logs from version control.
- `.gitattributes` — enforce CRLF for batch files.
- `CHANGELOG.md` — project history and version tracking.

---

[Unreleased]: https://github.com/APonder-Dev/windows-batch-utilities/compare/v1.3.0...HEAD
[1.3.0]: https://github.com/APonder-Dev/windows-batch-utilities/compare/v1.2.0...v1.3.0
[1.2.0]: https://github.com/APonder-Dev/windows-batch-utilities/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/APonder-Dev/windows-batch-utilities/releases/tag/v1.1.0
[1.0.0]: https://github.com/APonder-Dev/windows-batch-utilities/releases/tag/v1.0.0
