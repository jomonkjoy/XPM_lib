module xpmwrap_sdpram_byte_write #(
    parameter ADDR_WIDTH_A = 6,
    parameter ADDR_WIDTH_B = 6,
    parameter READ_DATA_WIDTH_B = 32,
    parameter WRITE_DATA_WIDTH_A = 32,
    parameter BYTE_WRITE_WIDTH_A = 8,
    parameter ASYMETRIC_MODE = 0,
    parameter CLOCKING_MODE = 0
) (
    // Port A
    input  logic [WRITE_DATA_WIDTH_A-1:0] dina,
    input  logic [ADDR_WIDTH_A-1:0] addra,
    input  logic [WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A-1:0] wea,
    input  logic ena,
    input  logic clka,
    // Port B
    output logic [(ASYMETRIC_MODE ? READ_DATA_WIDTH_B : WRITE_DATA_WIDTH_A)-1:0] doutb,
    input  logic [(ASYMETRIC_MODE ? ADDR_WIDTH_B : ADDR_WIDTH_A)-1:0] addrb,
    input  logic enb,
    input  logic regceb,
    input  logic clkb,
    input  logic rstb
);

localparam MEMORY_SIZE = ((2**ADDR_WIDTH_A) * WRITE_DATA_WIDTH_A);
logic dbiterrb;
logic sbiterrb;
logic injectdbiterra;
logic injectsbiterra;
logic sleep;

assign injectdbiterra = '0;
assign injectsbiterra = '0;
assign sleep = '0;

// xpm_memory_sdpram: Simple Dual Port RAM
// Xilinx Parameterized Macro, version 2025.1

xpm_memory_sdpram #(
   .ADDR_WIDTH_A(ADDR_WIDTH_A),               // DECIMAL
   .ADDR_WIDTH_B(ASYMETRIC_MODE ? ADDR_WIDTH_B : ADDR_WIDTH_A),               // DECIMAL
   .AUTO_SLEEP_TIME(0),            // DECIMAL
   .BYTE_WRITE_WIDTH_A(BYTE_WRITE_WIDTH_A),        // DECIMAL
   .CASCADE_HEIGHT(0),             // DECIMAL
   .CLOCKING_MODE(CLOCKING_MODE ? "independent_clock" : "common_clock"), // String
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
   .READ_DATA_WIDTH_B(ASYMETRIC_MODE ? READ_DATA_WIDTH_B : WRITE_DATA_WIDTH_A),         // DECIMAL
   .READ_LATENCY_B(2),             // DECIMAL
   .READ_RESET_VALUE_B("0"),       // String
   .RST_MODE_A("SYNC"),            // String    "SYNC", "ASYNC"
   .RST_MODE_B("SYNC"),            // String    "SYNC", "ASYNC"
   .SIM_ASSERT_CHK(0),             // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
   .USE_EMBEDDED_CONSTRAINT(0),    // DECIMAL
   .USE_MEM_INIT(1),               // DECIMAL
   .USE_MEM_INIT_MMI(0),           // DECIMAL
   .WAKEUP_TIME("disable_sleep"),  // String    "disable_sleep", "use_sleep_pin"
   .WRITE_DATA_WIDTH_A(WRITE_DATA_WIDTH_A),        // DECIMAL
   .WRITE_MODE_B("no_change"),     // String    "no_change", "read_first", "write_first"
   .WRITE_PROTECT(1)               // DECIMAL
)
xpm_memory_sdpram_inst (
   .dbiterrb(dbiterrb),             // 1-bit output: Status signal to indicate double bit error occurrence on the data output of port B.
   .doutb(doutb),                   // READ_DATA_WIDTH_B-bit output: Data output for port B read operations.
   .sbiterrb(sbiterrb),             // 1-bit output: Status signal to indicate single bit error occurrence on the data output of port B.
   .addra(addra),                   // ADDR_WIDTH_A-bit input: Address for port A write operations.
   .addrb(addrb),                   // ADDR_WIDTH_B-bit input: Address for port B read operations.
   .clka(clka),                     // 1-bit input: Clock signal for port A. Also clocks port B when parameter CLOCKING_MODE is "common_clock".
   .clkb(CLOCKING_MODE ? clkb : '0),// 1-bit input: Clock signal for port B when parameter CLOCKING_MODE is "independent_clock". Unused when
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