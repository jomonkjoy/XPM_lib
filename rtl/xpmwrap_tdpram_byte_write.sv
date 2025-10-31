module xpmwrap_dpdistram_byte_write #(
    parameter ADDR_WIDTH_A = 6,
    parameter ADDR_WIDTH_B = 6,
    parameter READ_DATA_WIDTH_A = 32,
    parameter READ_DATA_WIDTH_B = 32,
    parameter WRITE_DATA_WIDTH_A = 32,
    parameter BYTE_WRITE_WIDTH_A = 8,
    parameter WRITE_DATA_WIDTH_B = 32,
    parameter BYTE_WRITE_WIDTH_B = 8,
    parameter CLOCKING_MODE = 0
) (
    // Port A
    output logic [READ_DATA_WIDTH_A-1:0] douta,
    input  logic [WRITE_DATA_WIDTH_A-1:0] dina,
    input  logic [ADDR_WIDTH_A-1:0] addra,
    input  logic [WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A-1:0] wea,
    input  logic ena,
    input  logic regcea,
    input  logic clka,
    input  logic rsta,
    // Port B
    output logic [READ_DATA_WIDTH_B-1:0] doutb,
    input  logic [WRITE_DATA_WIDTH_B-1:0] dinb,
    input  logic [ADDR_WIDTH_B-1:0] addrb,
    input  logic [WRITE_DATA_WIDTH_B/BYTE_WRITE_WIDTH_B-1:0] web,
    input  logic enb,
    input  logic regceb,
    input  logic clkb,
    input  logic rstb
);

localparam MEMORY_SIZE = ((2**ADDR_WIDTH_A) * WRITE_DATA_WIDTH_A);
logic dbiterra, dbiterrb;
logic sbiterra, sbiterrb;
logic injectdbiterra, injectdbiterrb;
logic injectsbiterra, injectsbiterrb;
logic sleep;

assign injectdbiterra = '0;
assign injectsbiterra = '0;
assign injectdbiterrb = '0;
assign injectsbiterrb = '0;
assign sleep = '0;

// xpm_memory_tdpram: True Dual Port RAM
// Xilinx Parameterized Macro, version 2025.1

xpm_memory_tdpram #(
   .ADDR_WIDTH_A(ADDR_WIDTH_A),               // DECIMAL
   .ADDR_WIDTH_B(ADDR_WIDTH_B),               // DECIMAL
   .AUTO_SLEEP_TIME(0),            // DECIMAL
   .BYTE_WRITE_WIDTH_A(BYTE_WRITE_WIDTH_A),        // DECIMAL
   .BYTE_WRITE_WIDTH_B(BYTE_WRITE_WIDTH_B),        // DECIMAL
   .CASCADE_HEIGHT(0),             // DECIMAL
   .CLOCKING_MODE(CLOCKING_MODE ? "independent_clock" : "common_clock"), // String
   .ECC_BIT_RANGE("7:0"),          // String
   .ECC_MODE("no_ecc"),            // String
   .ECC_TYPE("none"),              // String
   .IGNORE_INIT_SYNTH(0),          // DECIMAL
   .MEMORY_INIT_FILE("none"),      // String
   .MEMORY_INIT_PARAM("0"),        // String
   .MEMORY_OPTIMIZATION("true"),   // String
   .MEMORY_PRIMITIVE("block"),     // String    "auto", "block", "distributed", "mixed", "ultra"
   .MEMORY_SIZE(2048),             // DECIMAL
   .MESSAGE_CONTROL(0),            // DECIMAL
   .RAM_DECOMP("auto"),            // String
   .READ_DATA_WIDTH_A(32),         // DECIMAL
   .READ_DATA_WIDTH_B(32),         // DECIMAL
   .READ_LATENCY_A(2),             // DECIMAL
   .READ_LATENCY_B(2),             // DECIMAL
   .READ_RESET_VALUE_A("0"),       // String
   .READ_RESET_VALUE_B("0"),       // String
   .RST_MODE_A("SYNC"),            // String    "SYNC", "ASYNC"
   .RST_MODE_B("SYNC"),            // String    "SYNC", "ASYNC"
   .SIM_ASSERT_CHK(0),             // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
   .USE_EMBEDDED_CONSTRAINT(0),    // DECIMAL
   .USE_MEM_INIT(1),               // DECIMAL
   .USE_MEM_INIT_MMI(0),           // DECIMAL
   .WAKEUP_TIME("disable_sleep"),  // String    "disable_sleep", "use_sleep_pin"
   .WRITE_DATA_WIDTH_A(WRITE_DATA_WIDTH_A),        // DECIMAL
   .WRITE_DATA_WIDTH_B(WRITE_DATA_WIDTH_B),        // DECIMAL
   .WRITE_MODE_A("no_change"),     // String    "no_change", "read_first", "write_first"
   .WRITE_MODE_B("no_change"),     // String    "no_change", "read_first", "write_first"
   .WRITE_PROTECT(1)               // DECIMAL
)
xpm_memory_tdpram_inst (
   .dbiterra(dbiterra),             // 1-bit output: Status signal to indicate double bit error occurrence on the data output of port A.
   .dbiterrb(dbiterrb),             // 1-bit output: Status signal to indicate double bit error occurrence on the data output of port A.
   .douta(douta),                   // READ_DATA_WIDTH_A-bit output: Data output for port A read operations.
   .doutb(doutb),                   // READ_DATA_WIDTH_B-bit output: Data output for port B read operations.
   .sbiterra(sbiterra),             // 1-bit output: Status signal to indicate single bit error occurrence on the data output of port A.
   .sbiterrb(sbiterrb),             // 1-bit output: Status signal to indicate single bit error occurrence on the data output of port B.
   .addra(addra),                   // ADDR_WIDTH_A-bit input: Address for port A write and read operations.
   .addrb(addrb),                   // ADDR_WIDTH_B-bit input: Address for port B write and read operations.
   .clka(clka),                     // 1-bit input: Clock signal for port A. Also clocks port B when parameter CLOCKING_MODE is "common_clock".
   .clkb(CLOCKING_MODE ? clkb : '0),// 1-bit input: Clock signal for port B when parameter CLOCKING_MODE is "independent_clock". Unused when
                                    // parameter CLOCKING_MODE is "common_clock".

   .dina(dina),                     // WRITE_DATA_WIDTH_A-bit input: Data input for port A write operations.
   .dinb(dinb),                     // WRITE_DATA_WIDTH_B-bit input: Data input for port B write operations.
   .ena(ena),                       // 1-bit input: Memory enable signal for port A. Must be high on clock cycles when read or write operations
                                    // are initiated. Pipelined internally.

   .enb(enb),                       // 1-bit input: Memory enable signal for port B. Must be high on clock cycles when read or write operations
                                    // are initiated. Pipelined internally.

   .injectdbiterra(injectdbiterra), // 1-bit input: Controls double bit error injection on input data when ECC enabled (Error injection capability
                                    // is not available in "decode_only" mode).

   .injectdbiterrb(injectdbiterrb), // 1-bit input: Controls double bit error injection on input data when ECC enabled (Error injection capability
                                    // is not available in "decode_only" mode).

   .injectsbiterra(injectsbiterra), // 1-bit input: Controls single bit error injection on input data when ECC enabled (Error injection capability
                                    // is not available in "decode_only" mode).

   .injectsbiterrb(injectsbiterrb), // 1-bit input: Controls single bit error injection on input data when ECC enabled (Error injection capability
                                    // is not available in "decode_only" mode).

   .regcea(regcea),                 // 1-bit input: Clock Enable for the last register stage on the output data path.
   .regceb(regceb),                 // 1-bit input: Clock Enable for the last register stage on the output data path.
   .rsta(rsta),                     // 1-bit input: Reset signal for the final port A output register stage. Synchronously resets output port
                                    // douta to the value specified by parameter READ_RESET_VALUE_A.

   .rstb(rstb),                     // 1-bit input: Reset signal for the final port B output register stage. Synchronously resets output port
                                    // doutb to the value specified by parameter READ_RESET_VALUE_B.

   .sleep(sleep),                   // 1-bit input: sleep signal to enable the dynamic power saving feature.
   .wea(wea),                       // WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A-bit input: Write enable vector for port A input data port dina. 1 bit
                                    // wide when word-wide writes are used. In byte-wide write configurations, each bit controls the writing one
                                    // byte of dina to address addra. For example, to synchronously write only bits [15-8] of dina when
                                    // WRITE_DATA_WIDTH_A is 32, wea would be 4'b0010.

   .web(web)                        // WRITE_DATA_WIDTH_B/BYTE_WRITE_WIDTH_B-bit input: Write enable vector for port B input data port dinb. 1 bit
                                    // wide when word-wide writes are used. In byte-wide write configurations, each bit controls the writing one
                                    // byte of dinb to address addrb. For example, to synchronously write only bits [15-8] of dinb when
                                    // WRITE_DATA_WIDTH_B is 32, web would be 4'b0010.

);

// End of xpm_memory_tdpram_inst instantiation

endmodule