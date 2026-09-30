#!/usr/bin/env bash

set -u

root="$(cd "$(dirname "$0")" && pwd)"
work="$(mktemp -d)"
anvil="${ANVIL_BIN:-anvil}"
errors=0

trap 'rm -rf "$work"' EXIT

if [[ -n "${OSS_CAD_SUITE_ENV:-}" ]]; then
    source "$OSS_CAD_SUITE_ENV"
fi

mark_error() {
    echo "[ERROR] $1"
    errors=$((errors + 1))
}

run_sim() {
    local bug="$1"
    local variant="$2"
    local file_list="$3"
    local top="$4"
    local expected="$5"
    local build="$work/sim_bug${bug}_${variant}"
    local log="$work/sim_bug${bug}_${variant}.log"
    local status

    echo "Simulation: Bug $bug, $variant"
    if ! (cd "$root/src/bug$bug" &&
        verilator --binary --timing --assert -Wno-fatal --timescale 1ns/1ps \
            --top-module "$top" --Mdir "$build" -f "$file_list") \
            > "$log" 2>&1; then
        cat "$log"
        mark_error "Bug $bug $variant simulation did not build"
        return
    fi

    if "$build/V$top" >> "$log" 2>&1; then
        status=0
    else
        status=$?
    fi
    cat "$log"

    if [[ "$expected" == pass && "$status" -eq 0 ]]; then
        echo "[PASS] Bug $bug $variant simulation"
    elif [[ "$expected" == fail && "$status" -ne 0 ]] &&
            grep -q '%Fatal:.*Assertion failed' "$log"; then
        echo "[EXPECTED FAIL] Bug $bug $variant simulation assertion"
    else
        mark_error "Bug $bug $variant simulation expected $expected, exit $status"
    fi
}

run_anvil_sim() {
    local bug="$1"
    local variant="$2"
    local expected="$3"
    local build="$work/sim_anvil_bug${bug}_${variant}"
    local log="$work/sim_anvil_bug${bug}_${variant}.log"
    local status

    echo "Generated-Anvil simulation: Bug $bug, $variant"
    local define=()

    if [[ "$variant" == semantic_bug ]]; then
        define=(-DSEMANTIC)
    fi

    if ! verilator --binary --timing --assert -Wno-fatal --timescale 1ns/1ps \
        "${define[@]}" \
        --top-module anvil_tb --Mdir "$build" \
        "$root/src/bug$bug/rtl/generated/$variant.sv" \
        "$root/src/bug$bug/tb/anvil_tb.sv" > "$log" 2>&1; then
        cat "$log"
        mark_error "Bug $bug $variant generated-Anvil simulation did not build"
        return
    fi

    if "$build/Vanvil_tb" >> "$log" 2>&1; then
        status=0
    else
        status=$?
    fi
    cat "$log"

    if [[ "$expected" == pass && "$status" -eq 0 ]]; then
        echo "[PASS] Bug $bug $variant generated-Anvil simulation"
    elif [[ "$expected" == fail && "$status" -ne 0 ]] &&
            grep -q '%Fatal:.*Assertion failed' "$log"; then
        echo "[EXPECTED FAIL] Bug $bug $variant generated-Anvil assertion"
    else
        mark_error "Bug $bug $variant generated-Anvil simulation expected $expected, exit $status"
    fi
}

run_cdc() {
    local variant="$1"
    local expected="$2"
    local cdc="${CDC_BIN:-rtl-buddy-cdc}"
    local output="$root/src/bug3/cdc/results/$variant.log"
    local error_log="$work/cdc_${variant}.err"
    local status

    echo "CDC: Bug 3, $variant"
    if (cd "$root" &&
        "$cdc" lint --frontend slang --top cdc_check_top \
            --sdc src/bug3/cdc.sdc \
            src/bug3/rtl/"$variant".sv \
            src/bug3/cdc/top.sv > "$output" 2> "$error_log"); then
        status=0
    else
        status=$?
    fi
    cat "$output"
    cat "$error_log"

    if [[ "$expected" == pass && "$status" -eq 0 ]] &&
            grep -q 'PASS$' "$output"; then
        echo "[PASS] Bug 3 $variant CDC"
    elif [[ "$expected" == fail && "$status" -ne 0 ]] &&
            grep -q 'FAIL$' "$output"; then
        echo "[EXPECTED FAIL] Bug 3 $variant CDC violation"
    else
        mark_error "Bug 3 $variant CDC expected $expected, exit $status"
    fi
}

generate_anvil() {
    local bug="$1"
    local variant="$2"
    local output="$work/bug${bug}_${variant}"

    if "$anvil" -o "$output" "$root/src/bug$bug/rtl/$variant.anvil" &&
            mv "$output.anvil.sv" \
                "$root/src/bug$bug/rtl/generated/$variant.sv"; then
        echo "[PASS] Bug $bug $variant Anvil compilation"
    else
        mark_error "Bug $bug $variant Anvil compilation"
    fi
}

check_anvil_rejection() {
    local bug="$1"
    local log="$work/anvil_bug${bug}_rejection.log"
    local status

    echo "Anvil compilation: Bug $bug, buggy"
    if "$anvil" -just-check "$root/src/bug$bug/rtl/buggy.anvil" \
            > "$log" 2>&1; then
        status=0
    else
        status=$?
    fi
    cat "$log"

    if [[ "$status" -ne 0 ]] && grep -q 'Borrow checking failed' "$log"; then
        echo "[EXPECTED FAIL] Bug $bug buggy Anvil borrow check"
    else
        mark_error "Bug $bug buggy Anvil borrow check unexpectedly exited $status"
    fi
}

run_sby() {
    local bug="$1"
    local config="$2"
    local task="$3"
    local expected="$4"
    local tag="${config//\//_}"
    local log="$work/bug${bug}_${tag}_${task}.log"
    local status
    local task_args=()
    local task_name="${task:-default}"

    if [[ -n "$task" ]]; then
        task_args=("$task")
    fi

    echo "Formal: Bug $bug, $task_name"
    if (cd "$root/src/bug$bug" &&
        sby -f -d "$work/bug${bug}_${tag}_${task_name}" \
            "$config" "${task_args[@]}") \
            > "$log" 2>&1; then
        status=0
    else
        status=$?
    fi
    cat "$log"

    if [[ "$expected" == pass && "$status" -eq 0 ]] &&
            grep -q 'DONE (PASS' "$log"; then
        echo "[PASS] Bug $bug $task_name formal ($config)"
    elif [[ "$expected" == fail && "$status" -ne 0 ]] &&
            grep -q 'DONE (FAIL' "$log"; then
        echo "[EXPECTED FAIL] Bug $bug $task_name formal counterexample ($config)"
    else
        mark_error "Bug $bug $task_name formal expected $expected, exit $status ($config)"
    fi
}

mkdir -p "$root"/src/bug{1,2,3,4,5}/rtl/generated

for bug in 1 2 5; do
    for variant in buggy fixed; do
        generate_anvil "$bug" "$variant"
    done
done

for bug in 3 4; do
    check_anvil_rejection "$bug"
    for variant in semantic_bug fixed; do
        generate_anvil "$bug" "$variant"
    done
done

for bug in 1 2 3 4 5; do
    if [[ "$bug" -eq 1 ]]; then
        run_sim "$bug" buggy sim_buggy.f tb pass
    else
        run_sim "$bug" buggy sim_buggy.f tb fail
    fi
    run_sim "$bug" fixed sim_fixed.f tb pass
done

run_cdc buggy fail
run_cdc fixed pass

for bug in 1 2 5; do
    if [[ "$bug" -eq 1 ]]; then
        run_anvil_sim "$bug" buggy pass
    else
        run_anvil_sim "$bug" buggy fail
    fi
    run_anvil_sim "$bug" fixed pass
done

for bug in 3 4; do
    run_anvil_sim "$bug" semantic_bug fail
    run_anvil_sim "$bug" fixed pass
done

for bug in 1 2 3 4 5; do
    run_sby "$bug" formal.sby buggy fail
    run_sby "$bug" formal.sby fixed pass
done

run_sby 4 formal_live.sby buggy pass
run_sby 4 formal_live.sby fixed pass

for bug in 1 2 5; do
    if [[ "$bug" -eq 1 ]]; then
        run_sby "$bug" formal/anvil.sby buggy pass
    else
        run_sby "$bug" formal/anvil.sby buggy fail
    fi
    run_sby "$bug" formal/anvil.sby fixed pass
done

for bug in 3 4; do
    run_sby "$bug" formal/anvil.sby semantic_bug fail
    run_sby "$bug" formal/anvil.sby fixed pass
done

run_sby 4 formal/anvil_live.sby "" pass

if [[ "$errors" -ne 0 ]]; then
    echo "Matrix completed with $errors unexpected result(s)."
    exit 1
fi

echo "Matrix completed with all results as expected."
