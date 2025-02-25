module show_sw (
    input             clk,          
    input             resetn,     

    input      [3 :0] switch,    //input

    output     [7 :0] num_csn,   //new value   
    output     [6 :0] num_a_g,      

    output     [3 :0] led        //previous value
);

reg [3:0] show_data;
reg [3:0] show_data_r;
reg [3:0] prev_data;

// Capture inverted switch input
always @(posedge clk) begin
    show_data <= ~switch;
end

// Store previous show_data value
always @(posedge clk) begin
    show_data_r <= show_data;
end

// Update previous data when value changes
always @(posedge clk) begin
    if (!resetn) begin
        prev_data <= 4'd0;
    end
    else if (show_data_r != show_data) begin
        prev_data <= show_data_r;
    end
end

// LED shows previous switch value (non-inverted)
assign led = ~prev_data;

// Instantiate display module
show_num u_show_num(
    .clk        (clk),
    .resetn     (resetn),
    .show_data  (show_data),
    .num_csn    (num_csn),
    .num_a_g    (num_a_g)
);

endmodule

//----------------------------{digital number}------------------------//
module show_num (
    input             clk,          
    input             resetn,     

    input      [3 :0] show_data,
    output     [7 :0] num_csn,      
    output reg [6 :0] num_a_g      
);

assign num_csn = 8'b0111_1111;  // Activate only the first digit

wire [6:0] nxt_a_g;

// Segment value register
always @(posedge clk) begin
    if (!resetn) begin
        num_a_g <= 7'b0000000;
    end
    else begin
        num_a_g <= nxt_a_g;
    end
end

// Segment decoding with value retention
assign nxt_a_g = (show_data == 4'd0) ? 7'b1111110 :  // 0
                 (show_data == 4'd1) ? 7'b0110000 :  // 1
                 (show_data == 4'd2) ? 7'b1101101 :  // 2
                 (show_data == 4'd3) ? 7'b1111001 :  // 3
                 (show_data == 4'd4) ? 7'b0110011 :  // 4
                 (show_data == 4'd5) ? 7'b1011011 :  // 5
                 (show_data == 4'd6) ? 7'b1011111 :  // 6 (added missing case)
                 (show_data == 4'd7) ? 7'b1110000 :  // 7
                 (show_data == 4'd8) ? 7'b1111111 :  // 8
                 (show_data == 4'd9) ? 7'b1111011 :  // 9
                 num_a_g;  // Keep previous value if >=10

endmodule
//----------------------------{digital number}------------------------//