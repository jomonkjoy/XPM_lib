module xpmwrap_sdpram_coherent_read #(
    parameter ADDR_WIDTH = 6,
    parameter DATA_WIDTH = 32
) (
    // Port A
    input  logic [DATA_WIDTH-1:0] dina,
    input  logic [ADDR_WIDTH-1:0] addra,
    input  logic wea,
    input  logic ena,
    input  logic clka,
    // Port B
    output logic [DATA_WIDTH-1:0] doutb,
    input  logic [ADDR_WIDTH-1:0] addrb,
    input  logic ena,
    input  logic regceb,
    input  logic rstb
);

localparam MEMORY_SIZE = ((2**ADDR_WIDTH) * DATA_WIDTH);
logic dbiterrb;
logic sbiterrb;
logic injectdbiterra;
logic injectsbiterra;
logic sleep;
logic clkb;

assign injectdbiterra = '0;
assign injectsbiterra = '0;
assign sleep = '0;
assign clkb = '0;

// xpm_memory_sdpram: Simple Dual Port RAM
// Xilinx Parameterized Macro, version 2025.1

xpm_memory_sdpram #(
   .ADDR_WIDTH_A(ADDR_WIDTH),               // DECIMAL
   .ADDR_WIDTH_B(ADDR_WIDTH),               // DECIMAL
   .AUTO_SLEEP_TIME(0),            // DECIMAL
   .BYTE_WRITE_WIDTH_A(DATA_WIDTH),        // DECIMAL
   .CASCADE_HEIGHT(0),             // DECIMAL
   .CLOCKING_MODE("common_clock"), // String
   .ECC_BIT_RANGE("7:0"),          // String
   .ECC_MODE("no_ecc"),            // String
   .ECC_TYPE("none"),              // String
   .IGNORE_INIT_SYNTH(0),          // DECIMAL
   .MEMORY_INIT_FILE("none"),      // String
   .MEMORY_INIT_PARAM("0"),        // String
   .MEMORY_OPTIMIZATION("true"),   // String
   .MEMORY_PRIMITIVE("block"),     // String   "auto", "block", "distributed", "mixed", "ultra"
   .MEMORY_SIZE(MEMORY_SIZE),      // DECIMAL
   .MESSAGE_CONTROL(0),            // DECIMAL
   .RAM_DECOMP("auto"),            // String
   .READ_DATA_WIDTH_B(DATA_WIDTH),         // DECIMAL
   .READ_LATENCY_B(2),             // DECIMAL
   .READ_RESET_VALUE_B("0"),       // String
   .RST_MODE_A("SYNC"),            // String    "SYNC", "ASYNC"
   .RST_MODE_B("SYNC"),            // String    "SYNC", "ASYNC"
   .SIM_ASSERT_CHK(0),             // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
   .USE_EMBEDDED_CONSTRAINT(0),    // DECIMAL
   .USE_MEM_INIT(1),               // DECIMAL
   .USE_MEM_INIT_MMI(0),           // DECIMAL
   .WAKEUP_TIME("disable_sleep"),  // String    "disable_sleep", "use_sleep_pin"
   .WRITE_DATA_WIDTH_A(DATA_WIDTH),        // DECIMAL
   .WRITE_MODE_B("write_first"),   // String    "no_change", "read_first", "write_first"
   .WRITE_PROTECT(1)               // DECIMAL
)
xpm_memory_sdpram_inst (
   .dbiterrb(dbiterrb),             // 1-bit output: Status signal to indicate double bit error occurrence on the data output of port B.
   .doutb(doutb),                   // READ_DATA_WIDTH_B-bit output: Data output for port B read operations.
   .sbiterrb(sbiterrb),             // 1-bit output: Status signal to indicate single bit error occurrence on the data output of port B.
   .addra(addra),                   // ADDR_WIDTH_A-bit input: Address for port A write operations.
   .addrb(addrb),                   // ADDR_WIDTH_B-bit input: Address for port B read operations.
   .clka(clka),                     // 1-bit input: Clock signal for port A. Also clocks port B when parameter CLOCKING_MODE is "common_clock".
   .clkb(clkb),                     // 1-bit input: Clock signal for port B when parameter CLOCKING_MODE is "independent_clock". Unused when
                                    // parameter CLOCKING_MODE is "common_clock".

   .dina(dina),                     // WRITE_DATA_WIDTH_A-bit input: Data input for port A write operations.
   .ena(ena),                       // 1-bit input: Memory enable signal for port A. Must be high on clock cycles when write operations are
                                    // initiated. Pipelined internally.

   .enb(enb),                       // 1-bit input: Memory enable signal for port B. Must be high on clock cycles when read operations are
                                    // initiated. Pipelined internally.

   .injectdbiterra(injectdbiterra), // 1-bit input: Controls double bit error injection on input data when ECC enabled (Error injection capability
                                    // is not available in "decode_only" mode).

   .injectsbiterra(injectsbiterra), // 1-bit input: Controls single bit error injection on input data when ECC enabled (Error injection capability
                                    // is not available in "decode_only" mode).

   .regceb(regceb),                 // 1-bit input: Clock Enable for the last register stage on the output data path.
   .rstb(rstb),                     // 1-bit input: Reset signal for the final port B output register stage. Synchronously resets output port
                                    // doutb to the value specified by parameter READ_RESET_VALUE_B.

   .sleep(sleep),                   // 1-bit input: sleep signal to enable the dynamic power saving feature.
   .wea(wea)                        // WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A-bit input: Write enable vector for port A input data port dina. 1 bit
                                    // wide when word-wide writes are used. In byte-wide write configurations, each bit controls the writing one
                                    // byte of dina to address addra. For example, to synchronously write only bits [15-8] of dina when
                                    // WRITE_DATA_WIDTH_A is 32, wea would be 4'b0010.

);

// End of xpm_memory_sdpram_inst instantiation

endmodule