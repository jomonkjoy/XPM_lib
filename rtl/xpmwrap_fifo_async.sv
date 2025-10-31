//    Setting USE_ADV_FEATURES[0] to 1 enables overflow flag; Default value of this bit is 1
//    Setting USE_ADV_FEATURES[1] to 1 enables prog_full flag; Default value of this bit is 1
//    Setting USE_ADV_FEATURES[2] to 1 enables wr_data_count; Default value of this bit is 1
//    Setting USE_ADV_FEATURES[3] to 1 enables almost_full flag; Default value of this bit is 0
//    Setting USE_ADV_FEATURES[4] to 1 enables wr_ack flag; Default value of this bit is 0
//    Setting USE_ADV_FEATURES[8] to 1 enables underflow flag; Default value of this bit is 1
//    Setting USE_ADV_FEATURES[9] to 1 enables prog_empty flag; Default value of this bit is 1
//    Setting USE_ADV_FEATURES[10] to 1 enables rd_data_count; Default value of this bit is 1
//    Setting USE_ADV_FEATURES[11] to 1 enables almost_empty flag; Default value of this bit is 0
//    Setting USE_ADV_FEATURES[12] to 1 enables data_valid flag; Default value of this bit is 0

module xpmwrap_fifo_async #(
    parameter FIFO_WRITE_DEPTH = 2048,
    parameter WRITE_DATA_WIDTH = 32,
    parameter READ_DATA_WIDTH = 32,
    parameter PROG_EMPTY_THRESH = 10,
    parameter PROG_FULL_THRESH = 10,
    parameter ASYMETRIC_MODE = 0,
    parameter READ_MODE_FWFT = 0,
    parameter USE_ADV_FEATURES = "0707"
) (
    // Read port
    output logic [(ASYMETRIC_MODE ? READ_DATA_WIDTH : WRITE_DATA_WIDTH)-1:0] dout,
    output logic data_valid,
    output logic underflow,
    output logic almost_empty,
    output logic prog_empty,
    output logic empty,
    output logic rd_rst_busy,
    output logic [$clog2(FIFO_WRITE_DEPTH):0] rd_data_count,
    input  logic rd_en,
    input  logic rd_clk,
    // Write port
    output logic overflow,
    output logic almost_full,
    output logic prog_full,
    output logic full,
    output logic wr_ack,
    output logic wr_rst_busy,
    output logic [$clog2(FIFO_WRITE_DEPTH):0] wr_data_count,
    input  logic [WRITE_DATA_WIDTH-1:0] din,
    input  logic wr_en,
    input  logic wr_clk,
    input  logic rst
);

logic dbiterr;
logic sbiterr;
logic injectdbiterr;
logic injectsbiterr;
logic sleep;
assign injectdbiterr = '0;
assign injectsbiterr = '0;
assign sleep = '0;

// xpm_fifo_async: Asynchronous FIFO
// Xilinx Parameterized Macro, version 2025.1

xpm_fifo_async #(
   .CASCADE_HEIGHT(0),            // DECIMAL
   .CDC_SYNC_STAGES(2),           // DECIMAL
   .DOUT_RESET_VALUE("0"),        // String
   .ECC_MODE("no_ecc"),           // String
   .EN_SIM_ASSERT_ERR("warning"), // String
   .FIFO_MEMORY_TYPE("auto"),     // String     "auto", "block", "distributed"
   .FIFO_READ_LATENCY(1),         // DECIMAL
   .FIFO_WRITE_DEPTH(FIFO_WRITE_DEPTH),       // DECIMAL
   .FULL_RESET_VALUE(0),          // DECIMAL
   .PROG_EMPTY_THRESH(PROG_EMPTY_THRESH),        // DECIMAL
   .PROG_FULL_THRESH(PROG_FULL_THRESH),         // DECIMAL
   .RD_DATA_COUNT_WIDTH($clog2(FIFO_WRITE_DEPTH)+1),       // DECIMAL
   .READ_DATA_WIDTH(ASYMETRIC_MODE ? READ_DATA_WIDTH : WRITE_DATA_WIDTH),          // DECIMAL
   .READ_MODE(READ_MODE_FWFT ? "fwft" : "std"),// String     "std", "fwft"
   .RELATED_CLOCKS(0),            // DECIMAL
   .SIM_ASSERT_CHK(0),            // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
   .USE_ADV_FEATURES("0707"),     // String
   .WAKEUP_TIME(0),               // DECIMAL
   .WRITE_DATA_WIDTH(WRITE_DATA_WIDTH),         // DECIMAL
   .WR_DATA_COUNT_WIDTH($clog2(FIFO_WRITE_DEPTH)+1)        // DECIMAL
)
xpm_fifo_async_inst (
   .almost_empty(almost_empty),   // 1-bit output: Almost Empty : When asserted, this signal indicates that only one more read can be performed
                                  // before the FIFO goes to empty.

   .almost_full(almost_full),     // 1-bit output: Almost Full: When asserted, this signal indicates that only one more write can be performed
                                  // before the FIFO is full.

   .data_valid(data_valid),       // 1-bit output: Read Data Valid: When asserted, this signal indicates that valid data is available on the
                                  // output bus (dout).

   .dbiterr(dbiterr),             // 1-bit output: Double Bit Error: Indicates that the ECC decoder detected a double-bit error and data in the
                                  // FIFO core is corrupted.

   .dout(dout),                   // READ_DATA_WIDTH-bit output: Read Data: The output data bus is driven when reading the FIFO.
   .empty(empty),                 // 1-bit output: Empty Flag: When asserted, this signal indicates that the FIFO is empty. Read requests are
                                  // ignored when the FIFO is empty, initiating a read while empty is not destructive to the FIFO.

   .full(full),                   // 1-bit output: Full Flag: When asserted, this signal indicates that the FIFO is full. Write requests are
                                  // ignored when the FIFO is full, initiating a write when the FIFO is full is not destructive to the contents of
                                  // the FIFO.

   .overflow(overflow),           // 1-bit output: Overflow: This signal indicates that a write request (wren) during the prior clock cycle was
                                  // rejected, because the FIFO is full. Overflowing the FIFO is not destructive to the contents of the FIFO.

   .prog_empty(prog_empty),       // 1-bit output: Programmable Empty: This signal is asserted when the number of words in the FIFO is less than
                                  // or equal to the programmable empty threshold value. It is de-asserted when the number of words in the FIFO
                                  // exceeds the programmable empty threshold value.

   .prog_full(prog_full),         // 1-bit output: Programmable Full: This signal is asserted when the number of words in the FIFO is greater than
                                  // or equal to the programmable full threshold value. It is de-asserted when the number of words in the FIFO is
                                  // less than the programmable full threshold value.

   .rd_data_count(rd_data_count), // RD_DATA_COUNT_WIDTH-bit output: Read Data Count: This bus indicates the number of words read from the FIFO.
   .rd_rst_busy(rd_rst_busy),     // 1-bit output: Read Reset Busy: Active-High indicator that the FIFO read domain is currently in a reset state.
   .sbiterr(sbiterr),             // 1-bit output: Single Bit Error: Indicates that the ECC decoder detected and fixed a single-bit error.
   .underflow(underflow),         // 1-bit output: Underflow: Indicates that the read request (rd_en) during the previous clock cycle was rejected
                                  // because the FIFO is empty. Under flowing the FIFO is not destructive to the FIFO.

   .wr_ack(wr_ack),               // 1-bit output: Write Acknowledge: This signal indicates that a write request (wr_en) during the prior clock
                                  // cycle is succeeded.

   .wr_data_count(wr_data_count), // WR_DATA_COUNT_WIDTH-bit output: Write Data Count: This bus indicates the number of words written into the
                                  // FIFO.

   .wr_rst_busy(wr_rst_busy),     // 1-bit output: Write Reset Busy: Active-High indicator that the FIFO write domain is currently in a reset
                                  // state.

   .din(din),                     // WRITE_DATA_WIDTH-bit input: Write Data: The input data bus used when writing the FIFO.
   .injectdbiterr(injectdbiterr), // 1-bit input: Double Bit Error Injection: Injects a double bit error if the ECC feature is used on block RAMs
                                  // or UltraRAM macros.

   .injectsbiterr(injectsbiterr), // 1-bit input: Single Bit Error Injection: Injects a single bit error if the ECC feature is used on block RAMs
                                  // or UltraRAM macros.

   .rd_clk(rd_clk),               // 1-bit input: Read clock: Used for read operation. rd_clk must be a free running clock.
   .rd_en(rd_en),                 // 1-bit input: Read Enable: If the FIFO is not empty, asserting this signal causes data (on dout) to be read
                                  // from the FIFO. Must be held active-low when rd_rst_busy is active high.

   .rst(rst),                     // 1-bit input: Reset: Must be synchronous to wr_clk. The clock(s) can be unstable at the time of applying
                                  // reset, but reset must be released only after the clock(s) is/are stable.

   .sleep(sleep),                 // 1-bit input: Dynamic power saving: If sleep is High, the memory/fifo block is in power saving mode.
   .wr_clk(wr_clk),               // 1-bit input: Write clock: Used for write operation. wr_clk must be a free running clock.
   .wr_en(wr_en)                  // 1-bit input: Write Enable: If the FIFO is not full, asserting this signal causes data (on din) to be written
                                  // to the FIFO. Must be held active-low when rst or wr_rst_busy is active high.

);

// End of xpm_fifo_async_inst instantiation

endmodule