module thermometer (
    input wire i_Clk,
    input wire io_PMOD_3, // S1 (lowest)
    input wire io_PMOD_2, // S2
    input wire io_PMOD_1, // S3 (highest)
    input wire i_Switch_1, // reset (active low)

    output wire io_PMOD_7, // R
    output wire io_PMOD_8, // Y
    output wire io_PMOD_9, // G
    output wire io_PMOD_10, // B 

    output wire o_LED_1, // viewing received inputs
    output wire o_LED_2,
    output wire o_LED_3,
);

    localparam CLOCK_CYCLE = 25'd6250000; // how many cycles = 1s

    //states
    localparam COLD = 2'b00, COOL = 2'b01, WARM = 2'b11, HOT = 2'b10; 
    reg [1:0] state, next_state;

    // my variables :>
    wire s1, s2, s3, rst;
    assign s1 = io_PMOD_3;
    assign s2 = io_PMOD_2;
    assign s3 = io_PMOD_1;

    assign rst = i_Switch_1;

    // see which inputs are active
    assign o_LED_1 = io_PMOD_1;
    assign o_LED_2 = io_PMOD_2;
    assign o_LED_3 = io_PMOD_3;

    // -------- assign next bits + buzzing based on transistion equations -----------
    assign next_state[0] = s1 & ~s3; // LSB
    assign next_state[1] = s2; // MSB

    // -------- updating ---------------
    always @(posedge i_Clk) begin
        if (rst) begin
            state <= 2'b00;
        end else begin
            state <= next_state;
        end
    end

    // -------- output logic --------------
    assign io_PMOD_7 = (state == HOT);
    assign io_PMOD_8 = (state == WARM);
    assign io_PMOD_9 = (state == COOL);
    assign io_PMOD_10 = (state == COLD);

endmodule