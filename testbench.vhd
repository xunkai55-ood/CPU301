----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:12:37 12/04/2014 
-- Design Name: 
-- Module Name:    TEST_BENCH - RTL 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TEST_BENCH is
	Port ( Clk_in : in  STD_LOGIC;
		   Rst : in  STD_LOGIC;
		   COM_rdn : out  STD_LOGIC;
		   COM_wrn : out  STD_LOGIC;
           RAM1_we : out  STD_LOGIC;
           RAM1_oe : out  STD_LOGIC;
           RAM1_en : out  STD_LOGIC;
           RAM1_addr : out  STD_LOGIC_VECTOR (17 downto 0);
           RAM1_data : inout  STD_LOGIC_VECTOR (15 downto 0);
           RAM2_we : out  STD_LOGIC;
           RAM2_oe : out  STD_LOGIC;
           RAM2_en : out  STD_LOGIC;
           RAM2_addr : out  STD_LOGIC_VECTOR (17 downto 0);
           RAM2_data : inout  STD_LOGIC_VECTOR (15 downto 0);
		   LED : out  STD_LOGIC_VECTOR (15 downto 0);
		   SSD_h : out  STD_LOGIC_VECTOR (6 downto 0);
		   SSD_l : out  STD_LOGIC_VECTOR (6 downto 0));
end TEST_BENCH;

architecture RTL of TEST_BENCH is

component SEVEN_SEG_DISPLAY is
    Port ( Data : in  STD_LOGIC_VECTOR (7 downto 0);
           Output_l : out  STD_LOGIC_VECTOR (6 downto 0);
		   Output_h : out  STD_LOGIC_VECTOR (6 downto 0));
end component;

component CLK_BASE_GEN is 
    Port ( Clk_in : in  STD_LOGIC;
           Rst : in  STD_LOGIC;
           Clk_base : out  STD_LOGIC);
end component;

component CLK_GEN is
    port ( Clk_base : in  STD_LOGIC;
		   Rst : in  STD_LOGIC;
           Clk : out  STD_LOGIC;
           Clk_x2 : out  STD_LOGIC;
           Clk_x4 : out  STD_LOGIC);
end component;

component MEMORY is
    Port ( Clk : in  STD_LOGIC;
		   Rst : in  STD_LOGIC;
           RAM1_we : out  STD_LOGIC;
           RAM1_oe : out  STD_LOGIC;
           RAM1_en : out  STD_LOGIC;
           MEMop : in  STD_LOGIC_VECTOR (1 downto 0);
		   addr : in  STD_LOGIC_VECTOR (15 downto 0);
		   data : in  STD_LOGIC_VECTOR (15 downto 0);
           memout : out  STD_LOGIC_VECTOR (15 downto 0);
           Clk2 : in  STD_LOGIC;
           RAM1_addr : out  STD_LOGIC_VECTOR (17 downto 0);
           RAM1_data : inout  STD_LOGIC_VECTOR (15 downto 0));
end component;

signal Clk, Clk_x2, Clk_x4, Clk_base : STD_LOGIC;
signal Mem_op : STD_LOGIC_VECTOR (1 downto 0);
signal addr, data, Mem_out : STD_LOGIC_VECTOR (15 downto 0);

begin

	Clk_base_c : CLK_BASE_GEN port map (
		Clk_in => Clk_in,
		Rst => Rst,
		Clk_base => Clk_base);
	Clk_gen_c : CLK_GEN port map (
		Clk_base => Clk_base,
		Rst => Rst,
		Clk => Clk,
		Clk_x2 => Clk_x2,
		Clk_x4 => Clk_x4);
	Memory_c : MEMORY port map (
		Clk => Clk,
		Clk2 => Clk_x2,
		Rst => Rst,
		RAM1_we => RAM1_we,
		RAM1_oe => RAM1_oe,
		RAM1_en => RAM1_en,
		MEMop => Mem_op,
		addr => addr,
		data => data,
		memout => Mem_out,
		RAM1_addr => RAM1_addr,
		RAM1_data => RAM1_data);
	
	ssd_c : SEVEN_SEG_DISPLAY port map (
		Data => Mem_out(7 downto 0),
		Output_l => SSD_l,
		Output_h => SSD_h);
	
	LED(7 downto 0) <= addr(7 downto 0);
	LED(15) <= Clk;
	LED(14) <= Clk_x2;
	LED(13 downto 8) <= (others => '0');
	RAM2_data <= (others => 'Z');
	RAM2_addr <= (others => '0');
	RAM2_oe <= '1';
	RAM2_we <= '1';
	RAM2_en <= '1';
	COM_rdn <= '1';
	COM_wrn <= '1';
	
	process (Clk, Rst) begin
		if (Rst = '0') then
			addr <= (others => '0');
			data <= (others => '0');
		elsif (Clk = '1' and Clk'event) then
			addr <= STD_LOGIC_VECTOR(UNSIGNED(addr) + 1);
			data <= STD_LOGIC_VECTOR(UNSIGNED(data) + 3);
			Mem_op <= "11";
		end if;
	end process;

end RTL;