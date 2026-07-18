# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),  
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]
### Planned
- Large File Hunter — find largest files recursively.
- Wi-Fi Profile Exporter — dump saved Wi-Fi profiles to XML.
- Hosts Toggle — swap between dev and default hosts file.
- Git Quick Helper — `git add + commit + push` shortcut.
- Ping Sweep — scan local subnet for alive hosts.
- Windows Update Check — list available updates (PowerShell required).

---

## [1.9.0] - 2026-07-17
### Added
- `scripts/ping_sweep.bat` — parallel ping sweep of a /24 subnet (~10 seconds for all 254 addresses via async .NET pings); auto-detects the local subnet with a custom-subnet option; shows round-trip time and resolved hostnames; tags this PC and the gateway; optional report saved to `scripts/reports/ping_sweep_<timestamp>.txt`.

### Changed
- `scripts/menu_launcher.bat` — Ping Sweep added as option 6 under NETWORK; FILES renumbered to 7-9 and DEV to 10; version bumped in header; taller window.
- `README.md` — documented Ping Sweep; moved it from Roadmap to Available Scripts; updated repo structure.

---

## [1.8.0] - 2026-07-17
### Added
- `scripts/git_quick_helper.bat` — stage + commit + push any repo in one go; shows branch and `git status --short` preview before prompting; requires a commit message and confirmation; sets upstream automatically on first push; offers push-only when the tree is clean but commits are unpushed; guards for missing git, non-repos, detached HEAD, and failed pushes; remembers the last repo in `git_quick_helper.ini`.

### Changed
- `scripts/menu_launcher.bat` — new DEV category with Git Quick Helper as option 9; version bumped in header; taller window.
- `README.md` — documented Git Quick Helper; moved it from Roadmap to Available Scripts; updated repo structure.
- `.gitignore` — exclude `scripts/git_quick_helper.ini`.

---

## [1.7.0] - 2026-07-16
### Added
- `scripts/hosts_toggle.bat` — swap the Windows hosts file between DEV and DEFAULT profiles; header shows the currently active profile via a marker comment; save either profile from the live hosts file; edit the DEV profile in Notepad; switching backs up the old hosts to `hosts.previous` and flushes the DNS cache; first run offers to snapshot the current hosts as DEFAULT; switching requires Administrator (gated with a clear message).

### Changed
- `scripts/menu_launcher.bat` — added Hosts Toggle as option 5 under NETWORK; FILES renumbered to 6-8; version bumped in header; taller window.
- `README.md` — documented Hosts Toggle; moved it from Roadmap to Available Scripts; updated repo structure.
- `.gitignore` — exclude `scripts/hosts_profiles/`.

---

## [1.6.0] - 2026-07-15
### Added
- `scripts/wifi_profile_exporter.bat` — backs up all saved Wi-Fi profiles to XML via `netsh wlan export profile`; lists profiles with a count first; passwordless export by default with optional plain-text password export as Administrator; timestamped output folder under `scripts/reports/`; verifies the exported file count; exports from inside the destination folder (`folder=.`) to work around netsh path mis-parsing.

### Changed
- `scripts/menu_launcher.bat` — regrouped the menu into SYSTEM / NETWORK / FILES categories with logical renumbering (1 Sysinfo, 2 Temp Cleaner, 3 Net Diag, 4 Wi-Fi Exporter, 5 Backup, 6 Organizer, 7 Hunter); version bumped in header.
- `README.md` — documented Wi-Fi Profile Exporter; moved it from Roadmap to Available Scripts; updated menu categories and repo structure.

---

## [1.5.0] - 2026-07-15
### Added
- `scripts/large_file_hunter.bat` — recursively finds the biggest files under a folder; Top N mode (default 25) or minimum-size mode (default 100 MB); MB/GB sizes with full paths and a total-scanned summary; optional report saved to `scripts/reports/large_files_<timestamp>.txt`; remembers the last-used folder in `large_file_hunter.ini`.

### Changed
- `scripts/menu_launcher.bat` — added menu option 6 for Large File Hunter; version number now shown in the header; taller window to fit the new layout.
- `README.md` — documented Large File Hunter; moved it from Roadmap to Available Scripts; updated repo structure.
- `.gitignore` — exclude `scripts/large_file_hunter.ini`.

---

## [1.4.0] - 2026-07-14
### Added
- `scripts/file_organizer.bat` — sorts the files in a folder into tidy subfolders; By-type mode (Images, Documents, Videos, Music, Archives, Programs, Other) or By-extension mode (one folder per extension); previews the full plan and confirms before moving; resolves name clashes with `_1`, `_2`, ... suffixes; remembers the last-used folder in `file_organizer.ini`; only touches top-level files.

### Changed
- `scripts/menu_launcher.bat` — new FILES category groups Smart Backup and File Organizer; added `L` shortcut to open the backup logs folder alongside `R` for reports; taller window to fit the new layout.
- `scripts/sysinfo_snapshot.bat` — header now shows date and time, matching the other tools.
- `README.md` — documented File Organizer; moved it from Roadmap to Available Scripts; updated menu features and repo structure.
- `.gitignore` — exclude `scripts/file_organizer.ini`.

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

[Unreleased]: https://github.com/APonder-Dev/windows-batch-utilities/compare/v1.9.0...HEAD
[1.9.0]: https://github.com/APonder-Dev/windows-batch-utilities/compare/v1.8.0...v1.9.0
[1.8.0]: https://github.com/APonder-Dev/windows-batch-utilities/compare/v1.7.0...v1.8.0
[1.7.0]: https://github.com/APonder-Dev/windows-batch-utilities/compare/v1.6.0...v1.7.0
[1.6.0]: https://github.com/APonder-Dev/windows-batch-utilities/compare/v1.5.0...v1.6.0
[1.5.0]: https://github.com/APonder-Dev/windows-batch-utilities/compare/v1.4.0...v1.5.0
[1.4.0]: https://github.com/APonder-Dev/windows-batch-utilities/compare/v1.3.0...v1.4.0
[1.3.0]: https://github.com/APonder-Dev/windows-batch-utilities/compare/v1.2.0...v1.3.0
[1.2.0]: https://github.com/APonder-Dev/windows-batch-utilities/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/APonder-Dev/windows-batch-utilities/releases/tag/v1.1.0
[1.0.0]: https://github.com/APonder-Dev/windows-batch-utilities/releases/tag/v1.0.0
