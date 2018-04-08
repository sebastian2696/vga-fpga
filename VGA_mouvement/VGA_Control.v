module VGA_Control(
	input clk50, 
	output [2:0] rout,
	output [2:0] gout,
	output [1:0] bout,
	output hsync,
	output vsync
	);
	
	
	reg clk25_int = 0;
	always@(posedge clk50)
	begin
		clk25_int <= ~clk25_int;
	end
	wire clk25;
	BUFG bufg_inst(clk25, clk25_int);
//http://www.xilinx.com/support/documentation/sw_manuals/xilinx11/sse_p_instantiating_clock_buffer.htm

	wire [9:0] xpos;
	wire [9:0] ypos;
	wire [2:0] red;
	wire [2:0] green;
	wire [1:0] blue;

	videosyncs videosyncs_inst(clk25, red, green, blue, rout, gout, bout, hsync, vsync, xpos, ypos);
	game game_inst(xpos, ypos, red, green, blue, clk50);

endmodule




module videosyncs (
   input wire clk,

   input wire [2:0] rin,
   input wire [2:0] gin,
   input wire [1:0] bin,

   output reg [2:0] rout,
   output reg [2:0] gout,
   output reg [1:0] bout,

   output reg hs,
   output reg vs,

   output wire [10:0] hc,
   output wire [10:0] vc
   );

   // VGA 640x480@60Hz,25MHz
	//Parameters are filled out by student
   parameter htotal = 800;			// total counts on x direction
   parameter vtotal = 525;			// total counts on y direction
   parameter hactive = 640;		// active area on x direction
   parameter vactive = 480;		// active area on y direction
   parameter hfrontporch = 16;	// front porch on x direction
   parameter hsyncpulse = 96;		// sync pulse on x direction
   parameter vfrontporch = 10;	// front porch on y direction
   parameter vsyncpulse = 2;		// sync pulse on y direction
   parameter hsyncpolarity = 0;	// polarity of pulse on x direction
   parameter vsyncpolarity = 0;	// polarity of pulse on y direction
   reg [9:0] hcont = 0;
   reg [9:0] vcont = 0;
   reg active_area;

    assign hc = hcont;
    assign vc = vcont;

   always @(posedge clk) 
	begin
      if (hcont == htotal-1) 
		begin
         // Add codes here
			hcont = 0;
         if (vcont == vtotal-1) 
			begin
            // Add codes here
				vcont = 0;
         end
         else 
			begin
            // Add codes here
				vcont = vcont +1;
         end
      end
      else 
		begin
         // Add codes here
			hcont = hcont + 1;
      end
   end

   always @* 
	begin
      if (hcont<=hactive && vcont<=vactive)
         active_area = 1'b1;
      else
         active_area = 1'b0;
      if (hcont>=(hactive+hfrontporch) && hcont<=(hactive+hfrontporch+hsyncpulse))
         hs = hsyncpolarity;
      else
         hs = ~hsyncpolarity;
      if (vcont>=(vactive+vfrontporch) && vcont<=(vactive+vfrontporch+vsyncpulse))
         vs = vsyncpolarity;
      else
         vs = ~vsyncpolarity;
    end

   always @* 
	begin
      if (active_area) 
		begin
         gout = gin;
         rout = rin;
         bout = bin;
      end
      else 
		begin
         gout = 3'b0;
         rout = 3'b0;
         bout = 2'b0;
      end
   end
endmodule   


/////////////////////////////////////////////////////////////////////////////
module game(xpos, ypos, red, green, blue, clk);
input [9:0] xpos;
input [9:0] ypos;
input clk;
output reg [2:0] red;
output reg [2:0] green;
output reg [1:0] blue;
reg [4:0] temp;

reg [30:0] clock_counter;
reg [30:0] i;

always @(clk)
begin
	clock_counter = clock_counter+1;
	
	if (clock_counter==50000000)
	begin
		i = (i+1)%256;
		clock_counter = 0;
	end
	
	if (clock_counter<50000000)
	begin
		if (i<128) green[0] = 1;
		else green[0] = 0;

		temp[0] = ((ypos>203+i && ypos <=206+i) && (xpos>=105+i&&xpos<=145+i || xpos>=150+i&&xpos<=190+i || xpos>=195+i&&xpos<=235+i));
		temp[1] = ((ypos>207+i && ypos <=221+i) && (xpos>=105+i&&xpos<=108+i || xpos>=150+i&&xpos<=153+i || xpos>=195+i&&xpos<=198+i));
		temp[2] = ((ypos>222+i && ypos <=225+i) && (xpos>=105+i&&xpos<=142+i || xpos>=150+i&&xpos<=153+i || xpos>=195+i&&xpos<=235+i));
		temp[3] = ((ypos>226+i && ypos <=241+i) && (xpos>=105+i&&xpos<=108+i || xpos>=150+i&&xpos<=153+i || xpos>=195+i&&xpos<=198+i));
		temp[4] = ((ypos>242+i && ypos <=245+i) && (xpos>=105+i&&xpos<=145+i || xpos>=150+i&&xpos<=190+i || xpos>=195+i&&xpos<=235+i));
		
		red[1] = temp[0]|temp[1]|temp[2]|temp[3]|temp[4];
		blue[0] = (red[1]|i)?0:1;
	end
end
endmodule