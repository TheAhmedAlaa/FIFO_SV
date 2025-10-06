vlib work
vlog -sv +define+SIM FIFO.sv FIFO_IF.sv FIFO_Trans.sv shared_pkg.sv FIFO_cvg.sv FIFO_sb.sv FIFO_mon.sv FIFO_tb.sv FIFO_TOP.sv +cover -covercells
vsim -voptargs=+acc work.FIFO_TOP -cover
add wave sim:/FIFO_TOP/FIFO_IF_obj/*
coverage save FIFO_TOP.ucdb -onexit
run -all