# Linux Monitoring Scripts

A collection of Bash scripts for monitoring Linux system resources: CPU, memory, and disk usage. Each script logs results and returns exit codes for integration with cron jobs, monitoring tools, or CI/CD pipelines.

## Features

- **CPU monitoring** — checks CPU usage against a configurable threshold
- **Memory monitoring** — checks RAM usage against a configurable threshold
- **Disk monitoring** — checks all partitions against a configurable threshold
- **Combined report** — runs all checks with a single command
- **Logging** — each script writes to `logs/` directory
- **Exit codes** — `0` for OK, `1` for alert (useful for automation)
- **Configurable thresholds** — pass as argument or use default 80%

## Scripts

| Script | Description | Usage |
|--------|-------------|-------|
| `cpu_check.sh` | Monitor CPU usage | `./cpu_check.sh [threshold]` |
| `memory_check.sh` | Monitor RAM usage | `./memory_check.sh [threshold]` |
| `disk_check.sh` | Monitor disk partitions | `./disk_check.sh [threshold]` |
| `system_health.sh` | Run all checks | `./system_health.sh [threshold]` |

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/mihail-serban-udescu/linux-monitoring-scripts.git
cd linux-monitoring-scripts
2. Make scripts executable
bash
chmod +x *.sh
3. (Optional) Fix line endings if on Windows
If you cloned on Windows and run in WSL/Linux:

bash
sed -i 's/\r$//' *.sh
Usage
Individual scripts
bash
# Default threshold (80%)
./cpu_check.sh

# Custom threshold (90%)
./cpu_check.sh 90
Combined report
bash
./system_health.sh
./system_health.sh 85
Example output
text
==========================================
  System Health Report
  Time: 2026-10-15 11:03:00
  Hostname: DESKTOP-GA332B9
==========================================

--- CPU ---
✅ OK: CPU usage is 15% (threshold: 80%)

--- MEMORY ---
✅ OK: Memory usage is 45% (615MB / 13879MB, threshold: 80%)

--- DISK ---
✅ OK: Partition / is at 1%
⚠️  ALERT: Partition /mnt/c is at 99% (threshold: 80%)

==========================================
⚠️  OVERALL: Some checks FAILED
==========================================
Logs
Each script writes to its own log file in logs/:

logs/cpu_check.log

logs/memory_check.log

logs/disk_check.log

Format:

text
[2026-10-15 11:03:00] CPU usage: 15% (threshold: 80%)
Automation with cron
Add to crontab -e to run every 15 minutes:

cron
*/15 * * * * /path/to/linux-monitoring-scripts/system_health.sh >> /var/log/system_health.log 2>&1
Exit Codes
Code	Meaning
0	All checks OK
1	One or more checks exceeded threshold
Useful for integration with monitoring systems.

Requirements
Bash 4.0+

Linux or WSL

Standard utilities: top, free, df, awk, sed, grep

License
Personal portfolio project — Mihail Serban, 2026.

