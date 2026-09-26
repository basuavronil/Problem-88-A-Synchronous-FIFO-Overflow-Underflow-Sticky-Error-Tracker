module fifo_error_tracker (
    input  wire clk,
    input  wire rst_n,
    input  wire full,
    input  wire empty,
    input  wire wr_en,
    input  wire rd_en,
    input  wire sw_clr_err,
    output wire overflow_err,
    output wire underflow_err,
    output reg  sticky_error
);

    // Immediate error condition detection
    assign overflow_err  = wr_en & full;
    assign underflow_err = rd_en & empty;

    // Sticky Error Latching Logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sticky_error <= 1'b0;
        end else if (sw_clr_err) begin
            // Software clear takes priority or resets error state
            sticky_error <= 1'b0;
        end else if (overflow_err || underflow_err) begin
            // Latch error on illegal operation
            sticky_error <= 1'b1;
        end
    end

endmodule
