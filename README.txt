Tools and Versions
---

OSS CAD Suite  20260724
Verilator      5.051 devel, v5.050-92-g7d3021c34
SymbiYosys     v0.67-4-gfea6e46
Yosys          0.67+92, git 30fe16c7f
Z3             4.15.5, 64 bit
suprove        hwmcc20-2
Anvil          SHA-256
               0d59e68d03a05e5edd6f5785c6554ee8c9876f6b634b6b8577d3158c5270aeab
rtl-buddy-cdc  0.5.0, commit df996d55af0e8b824183d03d531426b8601af429





Run the test matrix
---
(run from the project root)
export OSS_CAD_SUITE_ENV=/path/to/oss-cad-suite/environment
export ANVIL_BIN=/path/to/anvil
export CDC_BIN=/path/to/rtl-buddy-cdc/.venv/bin/rtl-buddy-cdc
./run_matrix.sh
