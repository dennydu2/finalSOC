`timescale 1ns / 1ps

module P2_BD_pongIP_AXI_S2026 #(
  parameter integer C_S00_AXI_DATA_WIDTH = 32,
  parameter integer C_S00_AXI_ADDR_WIDTH = 4
) (
  input  wire                        clk_25MHz,
  input  wire                        clk_125MHz,
  input  wire                        locked,
  input  wire                        rst_0_port_out,

  output wire                        hdmi_tx_0_tmds_clk_n_port_out,
  output wire                        hdmi_tx_0_tmds_clk_p_port_out,
  output wire [2:0]                  hdmi_tx_0_tmds_data_n_port_out,
  output wire [2:0]                  hdmi_tx_0_tmds_data_p_port_out,
  output wire [6:0]                  seven_seg_data_line_port_out,
  output wire [6:0]                  seven_seg_data_line2_port_out,
  output wire [1:0]                  seven_seg_enabler_port_out,

  output wire [4:0]                  sw_debug_port_out,

  input  wire                        s00_axi_aclk,
  input  wire                        s00_axi_aresetn,
  input  wire [C_S00_AXI_ADDR_WIDTH-1:0] s00_axi_awaddr,
  input  wire [2:0]                  s00_axi_awprot,
  input  wire                        s00_axi_awvalid,
  output reg                         s00_axi_awready,
  input  wire [C_S00_AXI_DATA_WIDTH-1:0] s00_axi_wdata,
  input  wire [(C_S00_AXI_DATA_WIDTH/8)-1:0] s00_axi_wstrb,
  input  wire                        s00_axi_wvalid,
  output reg                         s00_axi_wready,
  output reg  [1:0]                  s00_axi_bresp,
  output reg                         s00_axi_bvalid,
  input  wire                        s00_axi_bready,
  input  wire [C_S00_AXI_ADDR_WIDTH-1:0] s00_axi_araddr,
  input  wire [2:0]                  s00_axi_arprot,
  input  wire                        s00_axi_arvalid,
  output reg                         s00_axi_arready,
  output reg  [C_S00_AXI_DATA_WIDTH-1:0] s00_axi_rdata,
  output reg  [1:0]                  s00_axi_rresp,
  output reg                         s00_axi_rvalid,
  input  wire                        s00_axi_rready
);

  localparam integer ADDR_LSB = (C_S00_AXI_DATA_WIDTH/32) + 1;
  localparam integer OPT_MEM_ADDR_BITS = 0;

  reg [C_S00_AXI_ADDR_WIDTH-1:0] axi_awaddr;
  reg [C_S00_AXI_ADDR_WIDTH-1:0] axi_araddr;
  reg aw_en;
  integer byte_index;

  reg [C_S00_AXI_DATA_WIDTH-1:0] slv_reg0;
  wire slv_reg_wren;

  wire [4:0] sw_bits;
  assign sw_bits = slv_reg0[4:0];
  assign sw_debug_port_out = sw_bits;

  // Active-low 7-segment patterns {g,f,e,d,c,b,a}.
  // seven_seg_data_line_port_out  <= CTRL[3:0]
  // seven_seg_data_line2_port_out <= CTRL[7:4]
  // seven_seg_enabler_port_out    <= CTRL[9:8]
  reg [6:0] seven_seg_data_line_r;
  reg [6:0] seven_seg_data_line2_r;
  assign seven_seg_data_line_port_out = seven_seg_data_line_r;
  assign seven_seg_data_line2_port_out = seven_seg_data_line2_r;
  assign seven_seg_enabler_port_out = slv_reg0[9:8];

  function [6:0] hex_to_7seg;
    input [3:0] val;
    begin
      case (val)
        4'h0: hex_to_7seg = 7'b1000000;
        4'h1: hex_to_7seg = 7'b1111001;
        4'h2: hex_to_7seg = 7'b0100100;
        4'h3: hex_to_7seg = 7'b0110000;
        4'h4: hex_to_7seg = 7'b0011001;
        4'h5: hex_to_7seg = 7'b0010010;
        4'h6: hex_to_7seg = 7'b0000010;
        4'h7: hex_to_7seg = 7'b1111000;
        4'h8: hex_to_7seg = 7'b0000000;
        4'h9: hex_to_7seg = 7'b0010000;
        4'hA: hex_to_7seg = 7'b0001000;
        4'hB: hex_to_7seg = 7'b0000011;
        4'hC: hex_to_7seg = 7'b1000110;
        4'hD: hex_to_7seg = 7'b0100001;
        4'hE: hex_to_7seg = 7'b0000110;
        default: hex_to_7seg = 7'b0001110; // F
      endcase
    end
  endfunction

  always @(*) begin
    seven_seg_data_line_r  = hex_to_7seg(slv_reg0[3:0]);
    seven_seg_data_line2_r = hex_to_7seg(slv_reg0[7:4]);
  end

  assign slv_reg_wren = s00_axi_wready && s00_axi_wvalid && s00_axi_awready && s00_axi_awvalid;

  always @(posedge s00_axi_aclk) begin
    if (!s00_axi_aresetn) begin
      s00_axi_awready <= 1'b0;
      aw_en <= 1'b1;
    end else begin
      if (!s00_axi_awready && s00_axi_awvalid && s00_axi_wvalid && aw_en) begin
        s00_axi_awready <= 1'b1;
        aw_en <= 1'b0;
      end else if (s00_axi_bready && s00_axi_bvalid) begin
        aw_en <= 1'b1;
        s00_axi_awready <= 1'b0;
      end else begin
        s00_axi_awready <= 1'b0;
      end
    end
  end

  always @(posedge s00_axi_aclk) begin
    if (!s00_axi_aresetn) begin
      axi_awaddr <= {C_S00_AXI_ADDR_WIDTH{1'b0}};
    end else if (!s00_axi_awready && s00_axi_awvalid && s00_axi_wvalid && aw_en) begin
      axi_awaddr <= s00_axi_awaddr;
    end
  end

  always @(posedge s00_axi_aclk) begin
    if (!s00_axi_aresetn) begin
      s00_axi_wready <= 1'b0;
    end else begin
      if (!s00_axi_wready && s00_axi_wvalid && s00_axi_awvalid && aw_en) begin
        s00_axi_wready <= 1'b1;
      end else begin
        s00_axi_wready <= 1'b0;
      end
    end
  end

  always @(posedge s00_axi_aclk) begin
    if (!s00_axi_aresetn) begin
      slv_reg0 <= {C_S00_AXI_DATA_WIDTH{1'b0}};
    end else if (slv_reg_wren) begin
      case (axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB])
        1'h0: begin
          for (byte_index = 0; byte_index < (C_S00_AXI_DATA_WIDTH/8); byte_index = byte_index + 1) begin
            if (s00_axi_wstrb[byte_index]) begin
              slv_reg0[(byte_index*8) +: 8] <= s00_axi_wdata[(byte_index*8) +: 8];
            end
          end
        end
        default: slv_reg0 <= slv_reg0;
      endcase
    end
  end

  always @(posedge s00_axi_aclk) begin
    if (!s00_axi_aresetn) begin
      s00_axi_bvalid <= 1'b0;
      s00_axi_bresp <= 2'b00;
    end else begin
      if (s00_axi_awready && s00_axi_awvalid && !s00_axi_bvalid && s00_axi_wready && s00_axi_wvalid) begin
        s00_axi_bvalid <= 1'b1;
        s00_axi_bresp <= 2'b00;
      end else if (s00_axi_bvalid && s00_axi_bready) begin
        s00_axi_bvalid <= 1'b0;
      end
    end
  end

  always @(posedge s00_axi_aclk) begin
    if (!s00_axi_aresetn) begin
      s00_axi_arready <= 1'b0;
      axi_araddr <= {C_S00_AXI_ADDR_WIDTH{1'b0}};
    end else begin
      if (!s00_axi_arready && s00_axi_arvalid) begin
        s00_axi_arready <= 1'b1;
        axi_araddr <= s00_axi_araddr;
      end else begin
        s00_axi_arready <= 1'b0;
      end
    end
  end

  always @(posedge s00_axi_aclk) begin
    if (!s00_axi_aresetn) begin
      s00_axi_rvalid <= 1'b0;
      s00_axi_rresp <= 2'b00;
    end else begin
      if (s00_axi_arready && s00_axi_arvalid && !s00_axi_rvalid) begin
        s00_axi_rvalid <= 1'b1;
        s00_axi_rresp <= 2'b00;
      end else if (s00_axi_rvalid && s00_axi_rready) begin
        s00_axi_rvalid <= 1'b0;
      end
    end
  end

  always @(*) begin
    case (axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB])
      1'h0: s00_axi_rdata = slv_reg0;
      default: s00_axi_rdata = {C_S00_AXI_DATA_WIDTH{1'b0}};
    endcase
  end

  P2_BD_pongIP_S2026 u_pong (
    .clk_125MHz(clk_125MHz),
    .clk_25MHz(clk_25MHz),
    .hdmi_tx_0_tmds_clk_n(hdmi_tx_0_tmds_clk_n_port_out),
    .hdmi_tx_0_tmds_clk_p(hdmi_tx_0_tmds_clk_p_port_out),
    .hdmi_tx_0_tmds_data_n(hdmi_tx_0_tmds_data_n_port_out),
    .hdmi_tx_0_tmds_data_p(hdmi_tx_0_tmds_data_p_port_out),
    .i_Switch_0(sw_bits[0]),
    .i_Switch_1(sw_bits[1]),
    .i_Switch_2(sw_bits[2]),
    .i_Switch_3(sw_bits[3]),
    .i_Switch_4(sw_bits[4]),
    .locked(locked),
    .rst_0(rst_0_port_out)
  );

endmodule
