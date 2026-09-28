#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$script_dir"

input_tex="${1:-report.tex}"
output_pdf="${2:-}"

if [[ ! -f "$input_tex" ]]; then
    echo "error: input file not found: $input_tex" >&2
    exit 1
fi

base_name="$(basename "$input_tex" .tex)"

if command -v latexmk >/dev/null 2>&1; then
    latexmk -pdf -interaction=nonstopmode -halt-on-error "$input_tex"
elif command -v pdflatex >/dev/null 2>&1; then
    pdflatex -interaction=nonstopmode -halt-on-error "$input_tex"
    pdflatex -interaction=nonstopmode -halt-on-error "$input_tex"
else
    echo "error: install latexmk or pdflatex to compile $input_tex" >&2
    exit 1
fi

built_pdf="${base_name}.pdf"

if [[ -n "$output_pdf" ]]; then
    mv "$built_pdf" "$output_pdf"
    built_pdf="$output_pdf"
fi

echo "built $script_dir/$built_pdf"