--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:43:01 11/30/2014
-- Design Name:   
-- Module Name:   C:/COA/cpu301/test_clkgen.vhd
-- Project Name:  cpu301
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: CLK_GEN
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_clkgen IS
END test_clkgen;
 
ARCHITECTURE behavior OF test_clkgen IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT CLK_GEN
    PORT(
         Clk_base : IN  std_logic;
		 Rst : IN  std_logic;
         Clk : OUT  std_logic;
         Clk_x2 : OUT  std_logic;
         Clk_x4 : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Clk_base : std_logic := '0';
   signal Rst : std_logic := '0';

 	--Outputs
   signal Clk : std_logic;
   signal Clk_x2 : std_logic;
   signal Clk_x4 : std_logic;

   -- Clock period definitions
   constant Clk_base_period : time := 40 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CLK_GEN PORT MAP (
          Clk_base => Clk_base,
		  Rst => Rst,
          Clk => Clk,
          Clk_x2 => Clk_x2,
          Clk_x4 => Clk_x4
        );

   -- Clock process definitions
   Clk_base_process :process
   begin
		Clk_base <= '0';
		wait for Clk_base_period/2;
		Clk_base <= '1';
		wait for Clk_base_period/2;
   end process;

   -- Stimulus process
   stim_proc: process
   begin		
	  Rst <= '0';
      -- hold reset state for 100 ns.
      wait for 100 ns;	
	  Rst <= '1';

      wait for Clk_base_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
