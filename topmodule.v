module top_module(
    input clk,
    input reset,
    input ena,
    output pm,
    output reg  [7:0] hh,
    output [7:0] mm,
    output [7:0] ss); 
  
wire enass,enamm1,enamm2,enahh1,enahh2;
    wire load,loadH;
    wire [3:0] loadValue,loadValueH;




    
    
    assign enass=((ss[3:0]==4'b1001)  &ena)?1'b1:1'b0 ;
    
    assign enamm1=(((ss[7:4]==4'b0101)&(ss[3:0]==4'b1001)) & ena)?1'b1:1'b0;
    assign enamm2=((mm[3:0]==4'b1001) & enamm1)?1'b1:1'b0;
    
    assign enahh1=(((mm[7:4]==4'b0101) &enamm2) |reset)?1'b1:1'b0;
    assign enahh2=((hh[3:0]==4'b1001) &enahh1 )?1'b1:1'b0;
    
    BCD b0(clk,reset,ena,1'b0,4'b1,ss[3:0]);
    BCD b1(clk,(reset|( (ss[7:4]==4'b0101) &enass) ),enass,1'b0,4'b1,ss[7:4]);
    
    
    BCD b2(clk,reset,enamm1,1'b0,4'b1,mm[3:0]);
    BCD b3(clk,(reset| ( (mm[7:4]==4'b0101) &enamm2) ),enamm2,1'b0,4'b1,mm[7:4]);
    
    
    BCD b4(clk,(1'b0), enahh1,load,loadValue,hh[3:0]);

    always@(posedge clk)
        begin
            if(reset)
                pm<=0;
            else if(hh==8'h11 & mm==8'h59 & ss== 8'h59)
                pm<=~pm;
        end
        always@(hh,reset)
            begin
                if(reset)
                    begin
                        load=1'b1;
                    loadValue=4'd2;
                        loadH=1'b1;
                        loadValueH=4'b1;
                    end
                else if( ((hh[7:4]==4'b0001) & (hh[3:0]==4'b0010) ))
                    begin
                         load=1'b1;
                    loadValue=4'b1;
                          loadH=1'b0;
                    end
                else
                    begin
                    load=1'b0;
                  loadH=1'b0;
                    end
                
            end
    always@(posedge clk)
        begin
            
            if(reset | ((hh[3:0]==4'b1001) &enahh1))
                hh[7:4]<=4'b1;
            else if (((hh[7:4]==4'b0001) & (hh[3:0]==4'b0010)& (mm[7:4]==4'b0101)& (mm[3:0]==4'b1001)& enamm1))
                begin
                hh[7:4]<=4'b0;
                end
            
          
        end

endmodule
module BCD(
    input clk,
    input reset,
    input enable,
    input load,
    input [3:0]loadValue,
    output [3:0]count);
    always@(posedge clk)
        begin
            if(reset)
                count<=0;
            else if(enable)
                begin
                if(load)
                 begin
                     count<=loadValue;
                 end
                 else
                 begin
                       if(count==4'b1001)
                       count<=0;
                        else
                        count<=count+1;
                 end
             end
        end

   endmodule 
