#!/usr/bin/env bash
# bench.sh SPRING_BINARY LABEL [LIMIT_SECONDS]
# Runs BAR's 650-unit benchmark (bar-benchmark.tdf) in a window with an
# isolated data dir, kills it at the limit, and prints the result block.
set -u
BIN=${1:?spring binary}; LABEL=${2:?label}; LIMIT=${3:-240}
DATA=${BENCH_DATA:-$HOME/.spring-bench}
OUT=${BENCH_OUT:-$HOME/.spring-bench/results}
mkdir -p "$OUT"
LOG="$OUT/$(date +%Y%m%d-%H%M%S)-$LABEL.log"

cd "$(dirname "$BIN")" || exit 1
ENGDIR=$(pwd)
for x in base fonts AI cmdcolors.txt ctrlpanel.txt luaui.lua; do # engine content from the binary under test
	[[ -e "$ENGDIR/$x" ]] && ln -sfn "$ENGDIR/$x" "$DATA/$x"
done
mkdir -p "$DATA/LuaUI/Config" # engine LuaUI files linked one by one; BAR's Config stays in the data dir
for f in "$ENGDIR"/LuaUI/*; do [[ "$(basename "$f")" == Config ]] || ln -sfn "$f" "$DATA/LuaUI/$(basename "$f")"; done
"$BIN" --isolation-dir "$DATA" --window "$DATA/bar-benchmark.tdf" > "$LOG" 2>&1 &
PID=$!
PEAK=0; SECONDS=0
while kill -0 "$PID" 2>/dev/null; do
	F=$(footprint -p "$PID" 2>/dev/null | awk '/phys_footprint:/ {v=$2;u=$3; if(u~/^GB/)print int(v*1024); else if(u~/^MB/)print int(v); else print 0; exit}')
	[[ -n "$F" && "$F" -gt "$PEAK" ]] && PEAK=$F
	if grep -q "Benchmark Results" "$DATA/infolog.txt" 2>/dev/null && [[ $SECONDS -gt 20 ]]; then sleep 3; break; fi
	[[ $SECONDS -ge $LIMIT ]] && { echo "time limit hit"; break; }
	sleep 1
done
kill "$PID" 2>/dev/null; sleep 2; kill -9 "$PID" 2>/dev/null
cp "$DATA/infolog.txt" "${LOG%.log}.infolog.txt" 2>/dev/null
echo "== $LABEL  peak footprint ${PEAK} MB  wall ${SECONDS}s  log ${LOG%.log}.infolog.txt"
grep -A25 "Benchmark Results" "$DATA/infolog.txt" | cut -d']' -f3- | head -30
