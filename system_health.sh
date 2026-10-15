#!/bin/bash
# ============================================
# system_health.sh - Run all checks
# ============================================
# Usage: ./system_health.sh [threshold]
# Runs: cpu_check, memory_check, disk_check
# ============================================

set -euo pipefail

THRESHOLD="${1:-80}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

echo "=========================================="
echo "  System Health Report"
echo "  $TIMESTAMP"
echo "  Threshold: ${THRESHOLD}%"
echo "=========================================="
echo ""

FAILED=0

# 1. CPU check
echo "--- CPU ---"
if "$SCRIPT_DIR/cpu_check.sh" "$THRESHOLD"; then
    :
else
    FAILED=1
fi
echo ""

# 2. Memory check
echo "--- MEMORY ---"
if "$SCRIPT_DIR/memory_check.sh" "$THRESHOLD"; then
    :
else
    FAILED=1
fi
echo ""

# 3. Disk check
echo "--- DISK ---"
if "$SCRIPT_DIR/disk_check.sh" "$THRESHOLD"; then
    :
else
    FAILED=1
fi
echo ""

echo "=========================================="
if [ "$FAILED" -eq 1 ]; then
    echo "⚠️  OVERALL: Some checks FAILED"
    exit 1
else
    echo "✅ OVERALL: All checks OK"
    exit 0
fi