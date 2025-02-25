module tb;
    reg        clk;
    reg        resetn;     
    reg [3:0]  switch;    //input

    initial begin
        // 初始化所有信号
        clk    = 1'b0;
        resetn = 1'b0;  // 复位信号在 t=0 时拉低
        switch = 4'h0;  // switch 在 t=0 时初始化为 0

        // 100ns 后释放复位
        #100;
        resetn = 1'b1;

        // 设置 switch 的值
        #500;
        switch = 4'h8;  // ~switch: 7
        #100;
        switch = 4'h9;  // ~switch: 6
        #100;
        switch = 4'he;  // ~switch: 1
        #100;
        switch = 4'h2;  // ~switch: d
        #100;
        switch = 4'h0;  // ~switch: f
        #100;
        $finish; // 结束仿真
    end

    // 生成时钟信号
    always #5 clk = ~clk;

    // 实例化被测模块
    show_sw u_show_sw(
        .clk    (clk),          
        .resetn (resetn),     
        .switch (switch),    
        .num_csn(),   
        .num_a_g(),      
        .led    ()    
    );
endmodule