module xpmwrap_spram_byte_write #(
    parameter ADDR_WIDTH_A = 6,
    parameter READ_DATA_WIDTH_A = 32,
    parameter WRITE_DATA_WIDTH_A = 32,
    parameter BYTE_WRITE_WIDTH_A = 8,
    parameter WAKEUP_TIME = 0,
    parameter ECC_MODE = 0
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
    // miscellaneous
    output logic dbiterra,
    output logic sbiterra,
    input  logic injectdbiterra,
    input  logic injectsbiterra,
    input  logic sleep
);

localparam MEMORY_SIZE = ((2**ADDR_WIDTH_A) * WRITE_DATA_WIDTH_A);

// xpm_memory_spram: Single Port RAM
// Xilinx Parameterized Macro, version 2025.1

xpm_memory_spram #(
   .ADDR_WIDTH_A(ADDR_WIDTH_A),              // DECIMAL
   .AUTO_SLEEP_TIME(0),           // DECIMAL
   .BYTE_WRITE_WIDTH_A(BYTE_WRITE_WIDTH_A),       // DECIMAL
   .CASCADE_HEIGHT(0),            // DECIMAL
   .ECC_BIT_RANGE("7:0"),         // String
   .ECC_MODE(ECC_MODE ? "en_ecc" : "no_ecc"), // String 	"no_ecc", "en_ecc"
   .ECC_TYPE("none"),             // String
   .IGNORE_INIT_SYNTH(0),         // DECIMAL
   .MEMORY_INIT_FILE("none"),     // String
   .MEMORY_INIT_PARAM("0"),       // String
   .MEMORY_OPTIMIZATION("true"),  // String
   .MEMORY_PRIMITIVE("block"),    // String     "auto", "block", "distributed", "mixed", "ultra"
   .MEMORY_SIZE(MEMORY_SIZE),     // DECIMAL
   .MESSAGE_CONTROL(0),           // DECIMAL
   .RAM_DECOMP("auto"),           // String
   .READ_DATA_WIDTH_A(READ_DATA_WIDTH_A),        // DECIMAL
   .READ_LATENCY_A(2),            // DECIMAL
   .READ_RESET_VALUE_A("0"),      // String
   .RST_MODE_A("SYNC"),           // String     "SYNC", "ASYNC"
   .SIM_ASSERT_CHK(0),            // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
   .USE_MEM_INIT(1),              // DECIMAL
   .USE_MEM_INIT_MMI(0),          // DECIMAL
   .WAKEUP_TIME(WAKEUP_TIME ? "use_sleep_pin" : "disable_sleep"), // String     "disable_sleep", "use_sleep_pin"
   .WRITE_DATA_WIDTH_A(WRITE_DATA_WIDTH_A),       // DECIMAL
   .WRITE_MODE_A("read_first"),   // String     "read_first", "no_change", "write_first"
   .WRITE_PROTECT(1)              // DECIMAL
)
xpm_memory_spram_inst (
   .dbiterra(dbiterra),             // 1-bit output: Status signal to indicate double bit error occurrence on the data output of port A.
   .douta(douta),                   // READ_DATA_WIDTH_A-bit output: Data output for port A read operations.
   .sbiterra(sbiterra),             // 1-bit output: Status signal to indicate single bit error occurrence on the data output of port A.
   .addra(addra),                   // ADDR_WIDTH_A-bit input: Address for port A write and read operations.
   .clka(clka),                     // 1-bit input: Clock signal for port A.
   .dina(dina),                     // WRITE_DATA_WIDTH_A-bit input: Data input for port A write operations.
   .ena(ena),                       // 1-bit input: Memory enable signal for port A. Must be high on clock cycles when read or write operations
                                    // are initiated. Pipelined internally.

   .injectdbiterra(ECC_MODE ? injectdbiterra : '0), // 1-bit input: Controls double bit error injection on input data when ECC enabled (Error injection capability
                                    // is not available in "decode_only" mode).

   .injectsbiterra(ECC_MODE ? injectsbiterra : '0), // 1-bit input: Controls single bit error injection on input data when ECC enabled (Error injection capability
                                    // is not available in "decode_only" mode).

   .regcea(regcea),                 // 1-bit input: Clock Enable for the last register stage on the output data path.
   .rsta(rsta),                     // 1-bit input: Reset signal for the final port A output register stage. Synchronously resets output port
                                    // douta to the value specified by parameter READ_RESET_VALUE_A.

   .sleep(WAKEUP_TIME ? sleep : '0),// 1-bit input: sleep signal to enable the dynamic power saving feature.
   .wea(wea)                        // WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A-bit input: Write enable vector for port A input data port dina. 1 bit
                                    // wide when word-wide writes are used. In byte-wide write configurations, each bit controls the writing one
                                    // byte of dina to address addra. For example, to synchronously write only bits [15-8] of dina when
                                    // WRITE_DATA_WIDTH_A is 32, wea would be 4'b0010.

);

// End of xpm_memory_spram_inst instantiation

endmodule