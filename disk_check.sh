#!/bin/bash
# ============================================
# disk_check.sh - Monitor disk usage
# ============================================
# Usage: ./disk_check.sh [threshold]
# Default threshold: 80%
# ============================================

set -euo pipefail

THRESHOLD="${1:-80}"
LOG_DIR="logs"
LOG_FILE="${LOG_DIR}/disk_check.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

mkdir -p "$LOG_DIR"

echo "[$TIMESTAMP] Checking disk usage (threshold: ${THRESHOLD}%)" >> "$LOG_FILE"

# Verifică fiecare partiție
ALERT=0
while read -r line; do
    USAGE=$(echo "$line" | awk '{print $5}' | sed 's/%//')
    MOUNT=$(echo "$line" | awk '{print $6}')

    if [ "$USAGE" -ge "$THRESHOLD" ]; then
        echo "⚠️  ALERT: Partition $MOUNT is at ${USAGE}% (threshold: ${THRESHOLD}%)"
        echo "[$TIMESTAMP] ALERT: $MOUNT at ${USAGE}%" >> "$LOG_FILE"
        ALERT=1
    else
        echo "✅ OK: Partition $MOUNT is at ${USAGE}%"
    fi
done < <(df -h | grep -vE '^Filesystem|tmpfs|cdrom|udev')

if [ "$ALERT" -eq 1 ]; then
    exit 1
else
    echo "[$TIMESTAMP] All partitions OK" >> "$LOG_FILE"
    exit 0
fi