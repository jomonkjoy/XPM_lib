module shallow_fifo_sync #(
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 32,
    parameter PROG_FULL_THRESH = 8,
    parameter PROG_EMPTY_THRESH = 8
)(
    input  logic                  clk,
    input  logic                  rst_n,
    
    // Write interface
    input  logic                  wr_en,
    input  logic [DATA_WIDTH-1:0] wr_data,
    
    // Read interface
    input  logic                  rd_en,
    output logic [DATA_WIDTH-1:0] rd_data,
    
    // Status signals
    output logic                  full,
    output logic                  empty,
    output logic                  prog_full,
    output logic                  prog_empty,
    output logic [5:0]            count
);

    // Address width for 32-deep FIFO
    localparam ADDR_WIDTH = 5;
    
    // Internal signals
    logic [ADDR_WIDTH-1:0] wr_addr;
    logic [ADDR_WIDTH-1:0] rd_addr;
    logic [ADDR_WIDTH:0]   fifo_count;
    logic                  wren_internal;
    logic                  rden_internal;
    
    // Write enable generation (write only if not full and wr_en is asserted)
    assign wren_internal = wr_en & ~full;
    
    // Read enable generation (read only if not empty and rd_en is asserted)
    assign rden_internal = rd_en & ~empty;
    
    // Instantiate RAM32X1D for each bit of the data width
    genvar i;
    generate
        for (i = 0; i < DATA_WIDTH; i = i + 1) begin : ram_gen
            RAM32X1D #(
                .INIT(32'h00000000) // Initial contents of RAM
            ) RAM32X1D_inst (
                .DPO(rd_data[i]),        // Read-only 1-bit data output
                .SPO(),                  // R/W 1-bit data output (unused)
                .A0(wr_addr[0]),         // R/W address[0] input bit
                .A1(wr_addr[1]),         // R/W address[1] input bit
                .A2(wr_addr[2]),         // R/W address[2] input bit
                .A3(wr_addr[3]),         // R/W address[3] input bit
                .A4(wr_addr[4]),         // R/W address[4] input bit
                .D(wr_data[i]),          // Write 1-bit data input
                .DPRA0(rd_addr[0]),      // Read-only address[0] input bit
                .DPRA1(rd_addr[1]),      // Read-only address[1] input bit
                .DPRA2(rd_addr[2]),      // Read-only address[2] input bit
                .DPRA3(rd_addr[3]),      // Read-only address[3] input bit
                .DPRA4(rd_addr[4]),      // Read-only address[4] input bit
                .WCLK(clk),              // Write clock input
                .WE(wren_internal)       // Write enable input
            );
        end
    endgenerate
    
    // Write address pointer
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            wr_addr <= '0;
        else if (wren_internal)
            wr_addr <= wr_addr + 1'b1;
    end
    
    // Read address pointer
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            rd_addr <= '0;
        else if (rden_internal)
            rd_addr <= rd_addr + 1'b1;
    end
    
    // FIFO count logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            fifo_count <= '0;
        else begin
            case ({wren_internal, rden_internal})
                2'b10: fifo_count <= fifo_count + 1'b1;  // Write only
                2'b01: fifo_count <= fifo_count - 1'b1;  // Read only
                default: fifo_count <= fifo_count;        // Both or neither
            endcase
        end
    end
    
    // Status signals
    assign empty = (fifo_count == 0);
    assign full  = (fifo_count == FIFO_DEPTH);
    assign prog_empty = (fifo_count <= PROG_EMPTY_THRESH);
    assign prog_full  = (fifo_count >= (FIFO_DEPTH-PROG_FULL_THRESH));
    assign count = fifo_count;

endmodule
