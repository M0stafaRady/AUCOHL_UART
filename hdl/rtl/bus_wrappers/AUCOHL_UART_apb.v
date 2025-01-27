
/*
	Copyright 2024 Efabless Corp.

	Author: Mohamed Shalan (mshalan@efabless.com)

	This file is auto-generated by wrapper_gen.py on 2024-01-09

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

	    http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.

*/


`timescale			1ns/1ns
`default_nettype	none

`define		APB_BLOCK(name, init)		always @(posedge PCLK or negedge PRESETn) if(~PRESETn) name <= init;
`define		APB_REG(name, init, size)	`APB_BLOCK(name, init) else if(apb_we & (PADDR[15:0]==``name``_ADDR)) name <= PWDATA[``size``-1:0];
`define		APB_ICR(size)				`APB_BLOCK(ICR_REG, ``size``'b0) else if(apb_we & (PADDR[15:0]==ICR_REG_ADDR)) ICR_REG <= PWDATA[``size``-1:0]; else ICR_REG <= ``size``'d0;

module AUCOHL_UART_apb (
	input	wire 		rx,
	output	wire 		tx,
	input	wire 		PCLK,
	input	wire 		PRESETn,
	input	wire [31:0]	PADDR,
	input	wire 		PWRITE,
	input	wire 		PSEL,
	input	wire 		PENABLE,
	input	wire [31:0]	PWDATA,
	output	wire [31:0]	PRDATA,
	output	wire 		PREADY,
	output	wire 		irq
);
	localparam[15:0] RXDATA_REG_ADDR = 16'h0000;
	localparam[15:0] TXDATA_REG_ADDR = 16'h0004;
	localparam[15:0] CONTROL_REG_ADDR = 16'h0008;
	localparam[15:0] PRESCALER_REG_ADDR = 16'h000c;
	localparam[15:0] CONFIG_REG_ADDR = 16'h0010;
	localparam[15:0] FIFO_CONTROL_REG_ADDR = 16'h0014;
	localparam[15:0] RX_LEVEL_REG_ADDR = 16'h0018;
	localparam[15:0] MATCH_REG_ADDR = 16'h001c;
	localparam[15:0] TX_LEVEL_REG_ADDR = 16'h0020;
	localparam[15:0] ICR_REG_ADDR = 16'h0f00;
	localparam[15:0] RIS_REG_ADDR = 16'h0f04;
	localparam[15:0] IM_REG_ADDR = 16'h0f08;
	localparam[15:0] MIS_REG_ADDR = 16'h0f0c;
	localparam[15:0] CG_REG_ADDR = 16'h0f80;

	reg	[4:0]	CONTROL_REG;
	reg	[15:0]	PRESCALER_REG;
	reg	[13:0]	CONFIG_REG;
	reg	[15:0]	FIFO_CONTROL_REG;
	reg	[8:0]	MATCH_REG;
	reg	[9:0]	RIS_REG;
	reg	[9:0]	ICR_REG;
	reg	[9:0]	IM_REG;
	reg	[0:0]	CG_REG;

	wire[8:0]	rdata;
	wire[8:0]	RXDATA_REG	= rdata;
	wire		en	= CONTROL_REG[0:0];
	wire		tx_en	= CONTROL_REG[1:1];
	wire		rx_en	= CONTROL_REG[2:2];
	wire		loopback_en	= CONTROL_REG[3:3];
	wire		glitch_filter_en	= CONTROL_REG[4:4];
	wire[15:0]	prescaler	= PRESCALER_REG[15:0];
	wire[3:0]	data_size	= CONFIG_REG[3:0];
	wire		stop_bits_count	= CONFIG_REG[4:4];
	wire[2:0]	parity_type	= CONFIG_REG[7:5];
	wire[5:0]	timeout_bits	= CONFIG_REG[13:8];
	wire[3:0]	txfifotr	= FIFO_CONTROL_REG[3:0];
	wire[3:0]	rxfifotr	= FIFO_CONTROL_REG[11:8];
	wire[3:0]	rx_level;
	wire[7:0]	RX_LEVEL_REG	= rx_level;
	wire[8:0]	match_data	= MATCH_REG[8:0];
	wire[3:0]	tx_level;
	wire[7:0]	TX_LEVEL_REG	= tx_level;
	wire		tx_empty;
	wire		_TX_EMPTY_FLAG_	= tx_empty;
	wire		rx_full;
	wire		_RX_FULL_FLAG_	= rx_full;
	wire		tx_level_below;
	wire		_TX_LEVEL_BELOW_FLAG_	= tx_level_below;
	wire		rx_level_above;
	wire		_RX_LEVEL_ABOVE_FLAG_	= rx_level_above;
	wire		break_flag;
	wire		_LINE_BREAK_FLAG_	= break_flag;
	wire		match_flag;
	wire		_MATCH_FLAG_	= match_flag;
	wire		frame_error_flag;
	wire		_FRAME_ERROR_FLAG_	= frame_error_flag;
	wire		parity_error_flag;
	wire		_PARITY_ERROR_FLAG_	= parity_error_flag;
	wire		overrun_flag;
	wire		_OVERRUN_FLAG_	= overrun_flag;
	wire		timeout_flag;
	wire		_TIMEOUT_FLAG_	= timeout_flag;
	wire[9:0]	MIS_REG	= RIS_REG & IM_REG;
	wire		apb_valid	= PSEL & PENABLE;
	wire		apb_we	= PWRITE & apb_valid;
	wire		apb_re	= ~PWRITE & apb_valid;
	wire		_clk_	= PCLK;
	wire		_gclk_;
	wire		_rst_	= ~PRESETn;
	wire		rd	= (apb_re & (PADDR[15:0]==RXDATA_REG_ADDR));
	wire		wr	= (apb_we & (PADDR[15:0]==TXDATA_REG_ADDR));
	wire[8:0]	wdata	= PWDATA[8:0];

	assign _gclk_ = _clk_;

	AUCOHL_UART inst_to_wrap (
		.clk(_gclk_),
		.rst_n(~_rst_),
		.prescaler(prescaler),
		.en(en),
		.tx_en(tx_en),
		.rx_en(rx_en),
		.rd(rd),
		.wr(wr),
		.wdata(wdata),
		.data_size(data_size),
		.stop_bits_count(stop_bits_count),
		.parity_type(parity_type),
		.txfifotr(txfifotr),
		.rxfifotr(rxfifotr),
		.match_data(match_data),
		.timeout_bits(timeout_bits),
		.loopback_en(loopback_en),
		.glitch_filter_en(glitch_filter_en),
		.tx_empty(tx_empty),
		.tx_level(tx_level),
		.tx_level_below(tx_level_below),
		.rdata(rdata),
		.rx_full(rx_full),
		.rx_level(rx_level),
		.rx_level_above(rx_level_above),
		.break_flag(break_flag),
		.match_flag(match_flag),
		.frame_error_flag(frame_error_flag),
		.parity_error_flag(parity_error_flag),
		.overrun_flag(overrun_flag),
		.timeout_flag(timeout_flag),
		.rx(rx),
		.tx(tx)
	);

	`APB_REG(CONTROL_REG, 0, 5)
	`APB_REG(PRESCALER_REG, 0, 16)
	`APB_REG(CONFIG_REG, 0, 14)
	`APB_REG(FIFO_CONTROL_REG, 0, 16)
	`APB_REG(MATCH_REG, 0, 9)
	`APB_REG(IM_REG, 0, 10)
	`APB_REG(CG_REG, 0, 1)

	`APB_ICR(10)

	always @(posedge PCLK or negedge PRESETn)
		if(~PRESETn) RIS_REG <= 10'd0;
		else begin
			if(_TX_EMPTY_FLAG_) RIS_REG[0] <= 1'b1; else if(ICR_REG[0]) RIS_REG[0] <= 1'b0;
			if(_RX_FULL_FLAG_) RIS_REG[1] <= 1'b1; else if(ICR_REG[1]) RIS_REG[1] <= 1'b0;
			if(_TX_LEVEL_BELOW_FLAG_) RIS_REG[2] <= 1'b1; else if(ICR_REG[2]) RIS_REG[2] <= 1'b0;
			if(_RX_LEVEL_ABOVE_FLAG_) RIS_REG[3] <= 1'b1; else if(ICR_REG[3]) RIS_REG[3] <= 1'b0;
			if(_LINE_BREAK_FLAG_) RIS_REG[4] <= 1'b1; else if(ICR_REG[4]) RIS_REG[4] <= 1'b0;
			if(_MATCH_FLAG_) RIS_REG[5] <= 1'b1; else if(ICR_REG[5]) RIS_REG[5] <= 1'b0;
			if(_FRAME_ERROR_FLAG_) RIS_REG[6] <= 1'b1; else if(ICR_REG[6]) RIS_REG[6] <= 1'b0;
			if(_PARITY_ERROR_FLAG_) RIS_REG[7] <= 1'b1; else if(ICR_REG[7]) RIS_REG[7] <= 1'b0;
			if(_OVERRUN_FLAG_) RIS_REG[8] <= 1'b1; else if(ICR_REG[8]) RIS_REG[8] <= 1'b0;
			if(_TIMEOUT_FLAG_) RIS_REG[9] <= 1'b1; else if(ICR_REG[9]) RIS_REG[9] <= 1'b0;

		end

	assign irq = |MIS_REG;

	assign	PRDATA = 
			(PADDR[15:0] == CONTROL_REG_ADDR) ? CONTROL_REG :
			(PADDR[15:0] == PRESCALER_REG_ADDR) ? PRESCALER_REG :
			(PADDR[15:0] == CONFIG_REG_ADDR) ? CONFIG_REG :
			(PADDR[15:0] == FIFO_CONTROL_REG_ADDR) ? FIFO_CONTROL_REG :
			(PADDR[15:0] == MATCH_REG_ADDR) ? MATCH_REG :
			(PADDR[15:0] == RIS_REG_ADDR) ? RIS_REG :
			(PADDR[15:0] == ICR_REG_ADDR) ? ICR_REG :
			(PADDR[15:0] == IM_REG_ADDR) ? IM_REG :
			(PADDR[15:0] == CG_REG_ADDR) ? CG_REG :
			(PADDR[15:0] == RXDATA_REG_ADDR) ? RXDATA_REG :
			(PADDR[15:0] == RX_LEVEL_REG_ADDR) ? RX_LEVEL_REG :
			(PADDR[15:0] == TX_LEVEL_REG_ADDR) ? TX_LEVEL_REG :
			(PADDR[15:0] == MIS_REG_ADDR) ? MIS_REG :
			32'hDEADBEEF;


	assign PREADY = 1'b1;

endmodule
