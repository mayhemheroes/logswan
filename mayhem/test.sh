#!/usr/bin/env bash
#
# mayhem/test.sh — functional oracle for logswan. RUNS the NORMAL-flags binary that
# mayhem/build.sh produced (build-tests/logswan) against the repo's own test inputs
# (tests/logswan.log, tests/invalid.log, tests/logswan.mmdb) and asserts KNOWN-ANSWER
# values from the JSON report (line counts, bandwidth, hits/visits, per-country GeoIP
# hits, methods, status codes). A neutered/exit(0) binary emits no JSON and fails every
# assertion. Emits a CTRF summary.
set -uo pipefail
[ -n "${SOURCE_DATE_EPOCH:-}" ] || unset SOURCE_DATE_EPOCH
cd "$SRC"

emit_ctrf() {
  local tool="$1" passed="$2" failed="$3" skipped="${4:-0}" pending="${5:-0}" other="${6:-0}"
  local tests=$(( passed + failed + skipped + pending + other ))
  cat > "${CTRF_REPORT:-$SRC/ctrf-report.json}" <<JSON
{
  "results": {
    "tool": { "name": "$tool" },
    "summary": {
      "tests": $tests,
      "passed": $passed,
      "failed": $failed,
      "pending": $pending,
      "skipped": $skipped,
      "other": $other
    }
  }
}
JSON
  printf 'CTRF {"results":{"tool":{"name":"%s"},"summary":{"tests":%d,"passed":%d,"failed":%d,"pending":%d,"skipped":%d,"other":%d}}}\n' \
    "$tool" "$tests" "$passed" "$failed" "$pending" "$skipped" "$other"
  [ "$failed" -eq 0 ]
}

BIN="$SRC/build-tests/logswan"
if [ ! -x "$BIN" ]; then
  echo "FATAL: $BIN missing — mayhem/build.sh must build the test binary" >&2
  emit_ctrf "logswan-golden" 0 1
  exit 1
fi

counts="$(python3 - "$BIN" <<'PY'
import json, subprocess, sys
bin = sys.argv[1]
passed = failed = 0
def check(name, got, want):
    global passed, failed
    if got == want:
        passed += 1
    else:
        failed += 1
        print(f"FAIL {name}: got {got!r}, want {want!r}", file=sys.stderr)

def run(args):
    out = subprocess.run([bin, *args], capture_output=True, text=True)
    return json.loads(out.stdout)

d = run(["-g", "-d", "tests/logswan.mmdb", "tests/logswan.log"])
check("generator", d["generator"], "Logswan 2.1.17")
check("processed_lines", d["processed_lines"], 68)
check("invalid_lines", d["invalid_lines"], 0)
check("bandwidth", d["bandwidth"], 592748)
check("hits", d["hits"], {"ipv4": 34, "ipv6": 34, "total": 68})
check("visits", d["visits"], {"ipv4": 7, "ipv6": 7, "total": 14})
check("countries", sorted((c["data"], c["hits"]) for c in d["countries"]),
      [("AU", 12), ("DE", 2), ("FR", 26), ("US", 28)])
check("methods", sorted((m["data"], m["hits"]) for m in d["methods"]),
      [("GET", 66), ("HEAD", 2)])
check("status", sorted((s["data"], s["hits"]) for s in d["status"]),
      [(200, 44), (404, 24)])

i = run(["tests/invalid.log"])
check("invalid: processed_lines", i["processed_lines"], 3)
check("invalid: invalid_lines", i["invalid_lines"], 3)
check("invalid: bandwidth", i["bandwidth"], 0)

v = subprocess.run([bin, "-v"], capture_output=True, text=True)
check("version output", v.stdout.strip(), "Logswan 2.1.17")

print(f"{passed} {failed}")
PY
)" || true
read -r P F <<< "$(printf '%s\n' "$counts" | tail -1)"
P="${P:-0}"; F="${F:-1}"
[ "$P" -eq 0 ] 2>/dev/null && F=1
emit_ctrf "logswan-golden" "$P" "$F"
