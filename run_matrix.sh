#!/usr/bin/env bash

set -u

root="$(cd "$(dirname "$0")" && pwd)"
work="$(mktemp -d)"
anvil="${ANVIL_BIN:-anvil}"

trap 'rm -rf "$work"' EXIT

if [[ -n "${OSS_CAD_SUITE_ENV:-}" ]]; then
    source "$OSS_CAD_SUITE_ENV"
fi

run_sim() {
    local bug="$1"
    local variant="$2"
    local file_list="$3"
    local top="$4"
    local build="$work/sim_bug${bug}_${variant}"

    echo "Simulation: Bug $bug, $variant"
    (cd "$root/src/bug$bug" &&
        verilator --binary --timing --assert -Wno-fatal \
            --top-module "$top" --Mdir "$build" -f "$file_list" &&
        "$build/V$top") || true
}

run_anvil_sim() {
    local bug="$1"
    local variant="$2"
    local build="$work/sim_anvil_bug${bug}_${variant}"

    echo "Generated-Anvil simulation: Bug $bug, $variant"
    local define=()

    if [[ "$variant" == semantic_bug ]]; then
        define=(-DSEMANTIC)
    fi

    verilator --binary --timing --assert -Wno-fatal "${define[@]}" \
        --top-module anvil_tb --Mdir "$build" \
        "$root/src/bug$bug/rtl/generated/$variant.sv" \
        "$root/src/bug$bug/tb/anvil_tb.sv" &&
        "$build/Vanvil_tb" || true
}

generate_anvil() {
    local bug="$1"
    local variant="$2"
    local output="$work/bug${bug}_${variant}"

    "$anvil" -o "$output" "$root/src/bug$bug/rtl/$variant.anvil"
    mv "$output.anvil.sv" \
        "$root/src/bug$bug/rtl/generated/$variant.sv"
}

run_sby() {
    local bug="$1"
    local config="$2"
    local task="$3"

    echo "Formal: Bug $bug, $task"
    (cd "$root/src/bug$bug" &&
        sby -f -d "$work/bug${bug}_${task}" "$config" "$task") || true
}

mkdir -p "$root"/src/bug{1,2,3,4,5}/rtl/generated

for bug in 1 2 5; do
    for variant in buggy fixed; do
        generate_anvil "$bug" "$variant"
    done
done

for bug in 3 4; do
    "$anvil" -just-check "$root/src/bug$bug/rtl/buggy.anvil" || true
    for variant in semantic_bug fixed; do
        generate_anvil "$bug" "$variant"
    done
done

for bug in 1 2 3 4 5; do
    run_sim "$bug" buggy sim_buggy.f tb
    run_sim "$bug" fixed sim_fixed.f tb
done

for bug in 1 2 5; do
    run_anvil_sim "$bug" buggy
    run_anvil_sim "$bug" fixed
done

for bug in 3 4; do
    run_anvil_sim "$bug" semantic_bug
    run_anvil_sim "$bug" fixed
done

for bug in 1 2 3 4 5; do
    run_sby "$bug" formal.sby buggy
    run_sby "$bug" formal.sby fixed
done

run_sby 4 formal_live.sby buggy
run_sby 4 formal_live.sby fixed

for bug in 1 2 5; do
    run_sby "$bug" formal/anvil.sby buggy
    run_sby "$bug" formal/anvil.sby fixed
done

for bug in 3 4; do
    run_sby "$bug" formal/anvil.sby semantic_bug
    run_sby "$bug" formal/anvil.sby fixed
done

echo "Formal: Bug 4, Anvil fixed liveness"
(cd "$root/src/bug4" &&
    sby -f -d "$work/bug4_anvil_live" formal/anvil_live.sby) || true
