module thermometer (
    input wire i_Clk,
    input wire io_PMOD_1, // S1 (lowest)
    input wire io_PMOD_2, // S2
    input wire io_PMOD_3, // S3 (highest)
    input wire i_Switch_1, // reset (active low)

    output wire io_PMOD_7, // R
    output wire io_PMOD_8, // Y
    output wire io_PMOD_9, // G
    output wire io_PMOD_10, // B 

    output wire io_PMOD_11 // active buzzer 
);

    localparam CLOCK_CYCLE = 25'd6250000; // how many cycles = 1s

    //states
    localparam COLD = 2'b00, COOL = 2'b01, WARM = 2'b11, HOT = 2'b10; 
    reg [1:0] state, next_state;
    reg buzzing;

    // my variables :>
    wire s1, s2, s3, buzzer;
    assign s1 = io_PMOD_1;
    assign s2 = io_PMOD_2;
    assign s3 = io_PMOD_3;

    assign rst = i_Switch_1;

    // -------- setting up the clock!!! -------------
    reg [24:0] clk_counter; // counts clock cycles
    wire sec_tick;
    assign sec_tick = (clk_counter == CLOCK_CYCLE); // 1s has passed

     always @(posedge i_Clk) begin
        if (rst) begin // reset
            clk_counter <= 25'd0;
        end else if (clk_counter == CLOCK_CYCLE) begin // reset after 1 second
            clk_counter <= 25'd0; 
        end else begin
            clk_counter <= clk_counter + 1'b1; // count
        end
    end

    // -------- assign next bits/state (led + buzzing) based on transistion equations -----------
    assign next_state[0] = s1 & ~s3; // LSB
    assign next_state[1] = s2; //MSB

    assign buzzing = (state != next_state) & ~sec_tick;
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
    assign io_PMOD_11 = (buzzing);

endmodule