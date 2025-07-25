# ===================================================================
# Coverage Waiver and Exclusion File
# ===================================================================
# This script applies all necessary coverage waivers and exclusions.
# Waivers are grouped by module/file and then by coverage type.

puts ">>> Applying waivers for cfs_synch_fifo.v and toggle exclusions"

#-------------------------------------------------------------------
## Waivers for Synchronous FIFO (cfs_synch_fifo.v)
#-------------------------------------------------------------------
# Condition Coverage (C) for tx_fifo and rx_fifo instances

coverage exclude \
    -scope      /testbench/dut/core/tx_fifo \
    -srcfile    "/home/user/Dhan_workspace/aligner_repo/rtl/cfs_synch_fifo.v" \
    -linerange  128 \
    -code       c \
    -comment    "Waiving uncovered condition at line 128 (tx_fifo)"

coverage exclude \
    -scope      /testbench/dut/core/tx_fifo \
    -srcfile    "/home/user/Dhan_workspace/aligner_repo/rtl/cfs_synch_fifo.v" \
    -linerange  154 \
    -code       c \
    -comment    "Waiving uncovered condition at line 154 (tx_fifo)"

coverage exclude \
    -scope      /testbench/dut/core/rx_fifo \
    -srcfile    "/home/user/Dhan_workspace/aligner_repo/rtl/cfs_synch_fifo.v" \
    -linerange  128 \
    -code       c \
    -comment    "Waiving uncovered condition at line 128 (rx_fifo)"

#-------------------------------------------------------------------
## Waivers for Control Logic (cfs_ctrl.v)
#-------------------------------------------------------------------
# All waivers below target the same scope and source file:
# Scope: /testbench/dut/core/ctrl
# File:  ../../rtl/cfs_ctrl.v

# Statement Coverage (S) Waivers
# Lines: 94, 152, 153, 154, 155, 244, 257, 258, 259, 260, 262, 266, 269, 275, 276, 277, 279, 282
foreach line {94 152 153 154 155 244 257 258 259 260 262 266 269 275 276 277 279 282} {
    coverage exclude \
        -scope      /testbench/dut/core/ctrl \
        -srcfile    "../../rtl/cfs_ctrl.v" \
        -linerange  $line \
        -code       s \
        -comment    "Waiving uncovered statement at line $line (cfs_ctrl)"
}

# Branch Coverage (B) Waivers
# Lines: 80, 115, 201, 204, 254, 264, 268, 272
foreach line {91 149 251 242 254 264 268 272} {
    coverage exclude \
        -scope      /testbench/dut/core/ctrl \
        -srcfile    "../../rtl/cfs_ctrl.v" \
        -linerange  $line \
        -code       b \
        -comment    "Waiving uncovered branch at line $line (cfs_ctrl)"
}

# Condition Coverage (C) Waivers
# Lines: 91, 109, 149, 201, 242, 254, 264
foreach line {91 109 149 201 242 254 264} {
    coverage exclude \
        -scope      /testbench/dut/core/ctrl \
        -srcfile    "../../rtl/cfs_ctrl.v" \
        -linerange  $line \
        -code       c \
        -comment    "Waiving uncovered condition at line $line (cfs_ctrl)"
}

# FEC (Finite State Machine Condition) Coverage Waivers
coverage exclude -src ../../rtl/cfs_ctrl.v -scope merged:/testbench/dut/core/ctrl -feccondrow 80 3
coverage exclude -src ../../rtl/cfs_ctrl.v -scope merged:/testbench/dut/core/ctrl -feccondrow 115 3
coverage exclude -src ../../rtl/cfs_ctrl.v -scope merged:/testbench/dut/core/ctrl -feccondrow 204 3

#-------------------------------------------------------------------
## Toggle Coverage Exclusions
#-------------------------------------------------------------------

# Exclude toggle for a specific bit in ctrl
coverage exclude \
    -scope      /testbench/dut/core/ctrl \
    -togglenode {aligned_bytes_processed[2]} \
    -comment    "Excluding toggle coverage for aligned_bytes_processed[2] in ctrl"

# Exclude toggle on unused register bits at various hierarchy levels
coverage exclude -scope /testbench/dut           -togglenode {prdata[31:20]} {prdata[15:12]}
coverage exclude -scope /testbench/dut/core      -togglenode {prdata[31:20]} {prdata[15:12]}
coverage exclude -scope /testbench/dut/core/regs -togglenode {addr_aligned[1:0]} {prdata[31:20]} {prdata[15:12]}

# Exclude toggle on unused bits within the register file logic
coverage exclude \
    -scope      /testbench/dut/core/regs \
    -togglenode {status_rd_val[31:20]} {status_rd_val[15:12]} \
    -comment    "Unused STATUS register bits"

coverage exclude \
    -scope      /testbench/dut/core/regs \
    -togglenode {ctrl_rd_val[31:20]} {ctrl_rd_val[19:10]} {ctrl_rd_val[7:3]} \
    -comment    "Unused CTRL register bits"

coverage exclude \
    -scope      /testbench/dut/core/regs \
    -togglenode {irq_rd_val[31:20]} {irq_rd_val[19:10]} {irq_rd_val[9:8]} {irq_rd_val[7:5]} \
    -comment    "Unused IRQ_STATUS register bits"

coverage exclude \
    -scope      /testbench/dut/core/regs \
    -togglenode {irqen_rd_val[31:20]} {irqen_rd_val[19:10]} {irqen_rd_val[9:8]} {irqen_rd_val[7:5]} \
    -comment    "Unused IRQ_ENABLE register bits"

#-------------------------------------------------------------------
## Finalization
#-------------------------------------------------------------------
puts ">>> Saving coverage database..."
coverage save ucdb/merged.ucdb

quit
