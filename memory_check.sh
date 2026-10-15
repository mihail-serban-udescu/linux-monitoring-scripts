#!/bin/bash
# ============================================
# memory_check.sh - Monitor RAM usage
# ============================================
# Usage: ./memory_check.sh [threshold]
# Default threshold: 80%
# ============================================

set -euo pipefail

# Configurare
THRESHOLD="${1:-80}"
LOG_DIR="logs"
LOG_FILE="${LOG_DIR}/memory_check.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Creează folderul de log-uri
mkdir -p "$LOG_DIR"

# Extrage statisticile de memorie cu 'free'
MEM_TOTAL=$(free -m | awk '/^Mem:/ {print $2}')
MEM_USED=$(free -m | awk '/^Mem:/ {print $3}')

# Calculează procentul de utilizare
MEM_USAGE=$((MEM_USED * 100 / MEM_TOTAL))

# Loghează rezultatul
echo "[$TIMESTAMP] Memory usage: ${MEM_USAGE}% (${MEM_USED}MB / ${MEM_TOTAL}MB)" >> "$LOG_FILE"

# Verifică pragul
if [ "$MEM_USAGE" -ge "$THRESHOLD" ]; then
    echo "⚠️  ALERT: Memory usage is ${MEM_USAGE}% (${MEM_USED}MB / ${MEM_TOTAL}MB, threshold: ${THRESHOLD}%)"
    echo "[$TIMESTAMP] ALERT: Memory ${MEM_USAGE}% exceeded threshold ${THRESHOLD}%" >> "$LOG_FILE"
    exit 1
else
    echo "✅ OK: Memory usage is ${MEM_USAGE}% (${MEM_USED}MB / ${MEM_TOTAL}MB, threshold: ${THRESHOLD}%)"
    exit 0
fi