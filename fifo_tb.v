`timescale 1ns / 1ps

module fifo_tb #(
parameter M = 32,
parameter N = 16)();

reg clk, rst, WriteEnable, ReadEnable;
reg [N-1:0] WriteData;

wire full, empty, half_full;
wire [N-1:0] ReadData;

fifo_memory #(.M(M), .N(N))
uut (
    .rst(rst),
    .clk(clk),
    .WriteEnable(WriteEnable),
    .ReadEnable(ReadEnable),
    .WriteData(WriteData),
    .full(full),
    .empty(empty),
    .half_full(half_full),
    .ReadData(ReadData)
);

// Generate clk (period of clk = 10ns): 
initial clk = 0;
always #5 clk = ~clk;

initial begin

rst = 1;
WriteEnable = 0;
ReadEnable = 0;
WriteData = 0;

#10;
rst = 0;
WriteEnable = 1;
ReadEnable = 0;
WriteData = 55;

// We dont need to repeat the inputs because they remain the same unless changed.
#10;
WriteData = 74;

#10;
WriteData = 29;

#10;
WriteEnable = 0;
ReadEnable = 1;
WriteData = 0;

#20;
$finish;

end

endmodule

