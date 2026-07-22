module thermometer_fin (
    input  wire io_PMOD_1, // S1
    input  wire io_PMOD_2, // S2
    input  wire io_PMOD_3, // S3

    output wire io_PMOD_7,  // R  - all three on
    output wire io_PMOD_8,  // Y  - S1 and S2 on
    output wire io_PMOD_9,  // G  - S1 only
    output wire io_PMOD_10  // B  - none on
);

    assign io_PMOD_7  =  io_PMOD_1 &  io_PMOD_2 &  io_PMOD_3;
    assign io_PMOD_8  =  io_PMOD_1 &  io_PMOD_2 & ~io_PMOD_3;
    assign io_PMOD_9  =  io_PMOD_1 & ~io_PMOD_2 & ~io_PMOD_3;
    assign io_PMOD_10 = ~io_PMOD_1 & ~io_PMOD_2 & ~io_PMOD_3;

endmodule