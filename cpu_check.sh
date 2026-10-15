#!/bin/bash
# ============================================
# cpu_check.sh - Monitor CPU usage
# ============================================
# Usage: ./cpu_check.sh [threshold]
# Default threshold: 80%
# ============================================

set -euo pipefail

# Configurare
THRESHOLD="${1:-80}"
LOG_DIR="logs"
LOG_FILE="${LOG_DIR}/cpu_check.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Creează folderul de log-uri dacă nu există
mkdir -p "$LOG_DIR"

# Calculează CPU usage (media pe 1 secundă)
# Formula: 100 - idle_time
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}' | cut -d'.' -f1)

# Loghează rezultatul
echo "[$TIMESTAMP] CPU usage: ${CPU_USAGE}% (threshold: ${THRESHOLD}%)" >> "$LOG_FILE"

# Verifică pragul
if [ "$CPU_USAGE" -ge "$THRESHOLD" ]; then
    echo "⚠️  ALERT: CPU usage is ${CPU_USAGE}% (threshold: ${THRESHOLD}%)"
    echo "[$TIMESTAMP] ALERT: CPU usage ${CPU_USAGE}% exceeded threshold ${THRESHOLD}%" >> "$LOG_FILE"
    exit 1
else
    echo "✅ OK: CPU usage is ${CPU_USAGE}% (threshold: ${THRESHOLD}%)"
    exit 0
fi
