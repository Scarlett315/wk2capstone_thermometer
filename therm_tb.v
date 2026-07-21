`timescale 1ns / 1ps // Simulation time unit is 1 ns; precision is 1 ps.

module thermometer_tb;
    // These are driven by the testbench.
    reg clk = 0;
    reg rst = 0;
    reg[2:0] s_in = 3'b000; // s3 s2 s1
    wire [1:0] buzzer = 0;
    

    // Instantiate the design under test and connect each port by name.

    thermometer dut (
        .i_Clk(clk),
        .io_PMOD_1(s_in[0]),
        .io_PMOD_2(s_in[1]),
        .io_PMOD_3(s_in[2]),
        .i_Switch_1(~rst),
        .io_PMOD_7(bz)
    );

    // Toggle the clock every 5 ns, making a 10 ns clock period.
    always #5 clk = ~clk;

    initial begin
        // Write a waveform file that GTKWave can open.
        $dumpvars(0, thermometer_tb);
    
        // Release reset after a little more than one clock edge.
        #12 rst = 1;

        // Drive 1 + 2, wait one clock, then check the registered result.
        #10 s_in = 3'b000;

        #10 s_in = 3'b001;

        #10 s_in = 3'b011;

        #10 s_in = 3'b111;

        #10;

        #10 s_in = 3'b011;

        #10 s_in = 3'b001;

        #10 s_in = 3'b000;

        #10;
        // End a passing simulation.
        $finish;
    end
endmodule