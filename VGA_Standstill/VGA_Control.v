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
	game game_inst(xpos, ypos, red, green, blue);

endmodule

///////////////////////////////////////////////////////////////////////////////
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
   parameter htotal = 800;			// total counts on x direction
   parameter vtotal = 521;			// total counts on y direction
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

    // x => Horizontal
    // y => Vertical

   always @(posedge clk)
	begin
      if (hcont == htotal-1)  // checks if the x direction has reached the bound
		begin
         hcont = 0; // Need to loop around aka count again
         if (vcont == vtotal-1) // checks if the y direction has reached the nound
			begin
            vcont = 0; //Need to loop around aka count again
         end
         else
			begin
            vcont = vcont + 1; // y Counting
         end
      end
      else
		begin
         hcont = hcont + 1; // x Counting
      end
   end

   always @*
	begin
      if (hcont <= hactive && vcont <= vactive) // Maintainig bounds of 640p x 480p
         active_area = 1'b1;
      else
         active_area = 1'b0;
      // X Axis
      // Bounds for display area aka the active area
      if (hcont >= (hactive + hfrontporch) && hcont <= (hactive + hfrontporch + hsyncpulse))
         hs = hsyncpolarity;
      else
         hs = ~hsyncpolarity;
      // Y Axis
      // Bounds for display area aka the active area
      if (vcont >= (vactive + vfrontporch) && vcont <= (vactive + vfrontporch + vsyncpulse))
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
module game(xpos, ypos, red, green, blue);
input [9:0] xpos;
input [9:0] ypos;
output [2:0] red;
output [2:0] green;
output [1:0] blue;
wire [4:0] temp;

assign green[0] = 0;

assign temp[0] = ((ypos>203 && ypos <=206) && (xpos>=105&&xpos<=145 || xpos>=150&&xpos<=190 || xpos>=195&&xpos<=235));
assign temp[1] = ((ypos>207 && ypos <=221) && (xpos>=105&&xpos<=108 || xpos>=150&&xpos<=153 || xpos>=195&&xpos<=198));
assign temp[2] = ((ypos>222 && ypos <=225) && (xpos>=105&&xpos<=142 || xpos>=150&&xpos<=153 || xpos>=195&&xpos<=235));
assign temp[3] = ((ypos>226 && ypos <=241) && (xpos>=105&&xpos<=108 || xpos>=150&&xpos<=153 || xpos>=195&&xpos<=198));
assign temp[4] = ((ypos>242 && ypos <=245) && (xpos>=105&&xpos<=145 || xpos>=150&&xpos<=190 || xpos>=195&&xpos<=235));

assign red[1] = temp[0]|temp[1]|temp[2]|temp[3]|temp[4];
assign blue[0] = red[1]?0:1;
endmodule
