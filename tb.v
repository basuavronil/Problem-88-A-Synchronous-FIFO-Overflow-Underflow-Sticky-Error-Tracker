`timescale 1ns / 1ps

module tb_fifo_error_tracker;

    // Inputs
    reg clk;
    reg rst_n;
    reg full;
    reg empty;
    reg wr_en;
    reg rd_en;
    reg sw_clr_err;

    // Outputs
    wire overflow_err;
    wire underflow_err;
    wire sticky_error;

    // Unit Under Test (UUT)
    fifo_error_tracker uut (
        .clk(clk),
        .rst_n(rst_n),
        .full(full),
        .empty(empty),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .sw_clr_err(sw_clr_err),
        .overflow_err(overflow_err),
        .underflow_err(underflow_err),
        .sticky_error(sticky_error)
    );

    // Clock generation (100MHz -> 10ns period)
    always #5 clk = ~clk;

    initial begin
        // Waveform dumping setup for GTKWave / ModelSim
        $dumpfile("fifo_error_tracker.vcd");
        $dumpvars(0, tb_fifo_error_tracker);

        // Real-time console monitor
        $monitor("Time=%0tns | rst_n=%b | wr_en=%b full=%b ovf=%b | rd_en=%b empty=%b unf=%b | sw_clr=%b | sticky_err=%b",
                 $time, rst_n, wr_en, full, overflow_err, rd_en, empty, underflow_err, sw_clr_err, sticky_error);

        // Initialize Inputs
        clk        = 0;
        rst_n      = 0;
        full       = 0;
        empty      = 0;
        wr_en      = 0;
        rd_en      = 0;
        sw_clr_err = 0;

        // Apply Reset
        #15;
        rst_n = 1;
        #10;

        // Scenario 1: Normal Write operation (No Error)
        full = 0; wr_en = 1;
        #10;
        wr_en = 0;
        #10;

        // Scenario 2: Trigger Overflow Error (Write when full)
        full = 1; wr_en = 1;
        #10;
        // Stop writing and return to normal full state
        wr_en = 0; full = 0;
        #20; // Verify sticky_error remains 1 even when overflow_err drops to 0

        // Scenario 3: Software Clear Sticky Error
        sw_clr_err = 1;
        #10;
        sw_clr_err = 0;
        #20;

        // Scenario 4: Trigger Underflow Error (Read when empty)
        empty = 1; rd_en = 1;
        #10;
        rd_en = 0; empty = 0;
        #20; // Verify sticky_error latches again

        // Scenario 5: Clear error again
        sw_clr_err = 1;
        #10;
        sw_clr_err = 0;
        #20;

        $finish;
    end

endmodule
