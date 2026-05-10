`timescale 1ns / 1ps

module fifo_memory #(
    parameter M = 32,
    parameter N = 16
)
(
    input rst, clk,
    input WriteEnable, ReadEnable,
    input [N-1:0] WriteData,
    
    // Hme read and write pointers input me dene ki zrurt nhi h.
    // We will consider them as internal registers in module itself.
    // Verilog will then itself update them.
    
    output full, empty, half_full,
    output [N-1:0] ReadData
);

// Now it internally needs memory array, read and write pointers.
// N bit word length and M memory places.
// read / write ptr should be log2(M) bits wide so that it can give access to any of M places.
// M-1 islie lia qki hme 0 to M-1 tk locations access krni h reverse nhi.

reg [N-1:0] fifo [0:M-1];
reg [$clog2(M)-1:0] read_ptr, write_ptr;

/*
Ab hme ek esa count variable bnana chie joki track krega ki kitne elements filled h 
hmare memory array me. 
Now, its size should not be till log2(M)-1. It should be one more than that because 
count should go till 32 and not stop till 31. (Empty -> count = 0, Full -> count = 32 = M)
*/
reg [$clog2(M):0] count;

assign empty = (count == 0);
assign full = (count == M);
assign half_full = (count >= M/2);
// ye sb outputs to combinatinoal hi aa skte, no need of clk here.

always @(posedge clk or posedge rst) begin

if (rst) begin
    write_ptr <= 0;
    read_ptr <= 0;
    count <= 0;
end 

else begin
    if (WriteEnable && !full) begin
        fifo[write_ptr] <= WriteData;
        write_ptr <= write_ptr + 1;
    end
    if (ReadEnable && !empty) begin
        read_ptr <= read_ptr + 1;
    end
    // Hm read to combinational me hi krte h to abi alag se assign dal denge.
    
    /* 
    agar hm write kr rhe to ek nya element ayga so count increases by 1.
    read kr rhe to one element leaves fifo.
    */
    
    case ({WriteEnable && !full, ReadEnable && !empty}) 
        2'b00: count <= count;
        2'b01: count <= count - 1;
        2'b10: count <= count + 1;
        2'b11: count <= count;
    endcase

end

end
// Asynchronours read: 
assign ReadData = fifo[read_ptr];

endmodule

