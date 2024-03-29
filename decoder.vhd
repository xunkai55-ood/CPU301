----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:51:38 12/02/2014 
-- Design Name: 
-- Module Name:    DECODER - RTL 
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

entity DECODER is
    Port ( Inst : in  STD_LOGIC_VECTOR (15 downto 0);
           PC_branch : out  STD_LOGIC_VECTOR (2 downto 0);
           Imm : out  STD_LOGIC_VECTOR (15 downto 0);
           MEM_op : out  STD_LOGIC_VECTOR (1 downto 0);
           REG_des : out  STD_LOGIC_VECTOR (3 downto 0);
           ALU_src_a : out  STD_LOGIC_VECTOR (3 downto 0);
           ALU_src_b : out  STD_LOGIC_VECTOR (3 downto 0);
           REG_src_b : out  STD_LOGIC_VECTOR (3 downto 0);
           ALU_op : out  STD_LOGIC_VECTOR (3 downto 0));
end DECODER;

architecture RTL of DECODER is
	signal rx, ry, rz : STD_LOGIC_VECTOR(2 downto 0);
	signal immediate : STD_LOGIC_VECTOR(7 downto 0);
begin
	rx <= Inst(10 downto 8);
	ry <= Inst(7 downto 5);
	rz <= Inst(4 downto 2);
	immediate <= Inst(7 downto 0);

	process (Inst) begin
		case Inst(15 downto 11) is
			when "00010"=>	--B
				PC_branch <= "001";
				Imm <= STD_LOGIC_VECTOR(RESIZE(SIGNED(rx&immediate), Imm'length));
				MEM_op <= (others => '0');
				REG_des <= (others => '0');
				ALU_src_a <= (others => '0');
				ALU_src_b <= (others => '0');
				REG_src_b <= (others => '0');
				ALU_op <= (others => '0');
			when "00100"=>	--BEQZ
				PC_branch <= "010";
				Imm <= STD_LOGIC_VECTOR(RESIZE(SIGNED(immediate), Imm'length));
				MEM_op <= (others => '0');
				REG_des <= (others => '0');
				ALU_src_a <= "1"&rx;
				ALU_src_b <= (others => '0');
				REG_src_b <= (others => '0');
				ALU_op <= (others => '0');
			when "00101"=>	--BNEZ
				PC_branch <= "011";
				Imm <= STD_LOGIC_VECTOR(RESIZE(SIGNED(immediate), Imm'length));
				MEM_op <= (others => '0');
				REG_des <= (others => '0');
				ALU_src_a <= "1"&rx;
				ALU_src_b <= (others => '0');
				REG_src_b <= (others => '0');
				ALU_op <= (others => '0');
			when "00110"=>	--SLL SRA
				PC_branch <= (others => '0');
				Imm <= STD_LOGIC_VECTOR(RESIZE(UNSIGNED(rz), Imm'length));
				MEM_op <= (others => '0');
				REG_des <= "1"&rx;
				ALU_src_a <= "1"&ry;
				ALU_src_b <= "0111";
				REG_src_b <= "0111";
				case immediate(1 downto 0) is
					when "00"=>	--SLL
						ALU_op <= "0110";
					when "11"=>	--SRA
						ALU_op <= "1000";
					when others=>
						ALU_op <= (others => '0');
				end case;
			when "01000"=>	--ADDIU3
				PC_branch <= (others => '0');
				Imm <= STD_LOGIC_VECTOR(RESIZE(SIGNED(immediate(3 downto 0)), Imm'length));
				MEM_op <= (others => '0');
				REG_des <= "1"&ry;
				ALU_src_a <= "1"&rx;
				ALU_src_b <= "0111";
				REG_src_b <= "0111";
				ALU_op <= "0000";
			when "01001"=>	--ADDIU
				PC_branch <= (others => '0');
				Imm <= STD_LOGIC_VECTOR(RESIZE(SIGNED(immediate), Imm'length));
				MEM_op <= (others => '0');
				REG_des <= "1"&rx;
				ALU_src_a <= "1"&rx;
				ALU_src_b <= "0111";
				REG_src_b <= "0111";
				ALU_op <= "0000";
			when "01100"=>	--ADDSP BTEQZ MTSP
				Imm <= STD_LOGIC_VECTOR(RESIZE(SIGNED(immediate), Imm'length));
				MEM_op <= (others => '0');
				case rx is
					when "000"=>	--BTEQZ
						PC_branch <= "010";
						REG_des <= (others => '0');
						ALU_src_a <= "0010";
						ALU_src_b <= (others => '0');
						REG_src_b <= (others => '0');
						ALU_op <= (others => '0');
					when "011"=>	--ADDSP
						PC_branch <= (others => '0');
						REG_des <= "0001";
						ALU_src_a <= "0001";
						ALU_src_b <= "0111";
						REG_src_b <= "0111";
						ALU_op <= "0000";
					when "100"=>	--MTSP
						PC_branch <= (others => '0');
						REG_des <= "0001";
						ALU_src_a <= "1"&ry;
						ALU_src_b <= (others => '0');
						REG_src_b <= (others => '0');
						ALU_op <= (others => '0');
					when others=>
						PC_branch <= (others => '0');
						REG_des <= (others => '0');
						ALU_src_a <= (others => '0');
						ALU_src_b <= (others => '0');
						REG_src_b <= (others => '0');
						ALU_op <= (others => '0');
				end case;
			when "01101"=>	--LI
				PC_branch <= (others => '0');
				Imm <= STD_LOGIC_VECTOR(RESIZE(UNSIGNED(immediate), Imm'length));
				MEM_op <= (others => '0');
				REG_des <= "1"&rx;
				ALU_src_a <= "0000";
				ALU_src_b <= "0111";
				REG_src_b <= (others => '0');
				ALU_op <= (others => '0');
			when "01110"=>	--CMPI
				PC_branch <= (others => '0');
				Imm <= STD_LOGIC_VECTOR(RESIZE(SIGNED(immediate), Imm'length));
				MEM_op <= (others => '0');
				REG_des <= "0010";
				ALU_src_a <= "1"&rx;
				ALU_src_b <= "0111";
				REG_src_b <= "0111";
				ALU_op <= "0010";
			when "10010"=>	--LW_SP
				PC_branch <= (others => '0');
				Imm <= STD_LOGIC_VECTOR(RESIZE(SIGNED(immediate), Imm'length));
				MEM_op <= "10";
				REG_des <= "1"&rx;
				ALU_src_a <= "0001";
				ALU_src_b <= "0111";
				REG_src_b <= "0111";
				ALU_op <= "0000";
			when "10011"=> -- LW
				PC_branch <= (others => '0');
				Imm <= STD_LOGIC_VECTOR(RESIZE(SIGNED(immediate(4 downto 0)), Imm'length));
				MEM_op <= "10";
				REG_des <= "1"&ry;
				ALU_src_a <= "1"&rx;
				ALU_src_b <= "0111";
				REG_src_b <= "0111";
				ALU_op <= "0000";
			when "11010"=>	--SW_SP
				PC_branch <= (others => '0');
				Imm <= STD_LOGIC_VECTOR(RESIZE(SIGNED(immediate), Imm'length));
				MEM_op <= "11";
				REG_des <= (others => '0');
				ALU_src_a <= "0001";
				ALU_src_b <= "0111";
				REG_src_b <= "1"&rx;
				ALU_op <= "0000";
			when "11011"=> -- SW
				PC_branch <= (others => '0');
				Imm <= STD_LOGIC_VECTOR(RESIZE(SIGNED(immediate(4 downto 0)), Imm'length));
				MEM_op <= "11";
				REG_des <= (others => '0');
				ALU_src_a <= "1"&rx;
				ALU_src_b <= "0111";
				REG_src_b <= "1"&ry;
				ALU_op <= "0000";
			when "11100"=>	--ADDU SUBU
				PC_branch <= (others => '0');
				Imm <= (others => '0');
				MEM_op <= (others => '0');
				REG_des <= "1"&rz;
				ALU_src_a <= "1"&rx;
				ALU_src_b <= "1"&ry;
				REG_src_b <= "1"&ry;
				case immediate(1 downto 0) is
					when "01"=>	--ADDU
						ALU_op <= "0000";
					when "11"=>	--SUBU
						ALU_op <= "0011";
					when others=>
						ALU_op <= (others => '0');
				end case;
			when "11101"=>	--AND CMP JR MFPC NEG NOT OR SLLV SRAV
				Imm <= (others => '0');
				MEM_op <= (others => '0');
				case immediate(4 downto 0) is
					when "01100"=>	--AND
						PC_branch <= (others => '0');
						REG_des <= "1"&rx;
						ALU_src_a <= "1"&rx;
						ALU_src_b <= "1"&ry;
						REG_src_b <= "1"&ry;
						ALU_op <= "0001";
					when "01010"=>	--CMP
						PC_branch <= (others => '0');
						REG_des <= "0010";
						ALU_src_a <= "1"&rx;
						ALU_src_b <= "1"&ry;
						REG_src_b <= "1"&ry;
						ALU_op <= "0010";
					when "00000"=>	--JR MFPC
						case ry is
							when "000"=>	--JR
								PC_branch <= "100";
								REG_des <= (others => '0');
								ALU_src_a <= "1"&rx;
								ALU_src_b <= (others => '0');
								REG_src_b <= (others => '0');
								ALU_op <= (others => '0');
							when "010"=>	--MFPC
								PC_branch <= (others => '0');
								REG_des <= "1"&rx;
								ALU_src_a <= "0101";
								ALU_src_b <= (others => '0');
								REG_src_b <= (others => '0');
								ALU_op <= (others => '0');
							when others=>
								PC_branch <= (others => '0');
								REG_des <= (others => '0');
								ALU_src_a <= (others => '0');
								ALU_src_b <= (others => '0');
								REG_src_b <= (others => '0');
								ALU_op <= (others => '0');
						end case;
					when "01011"=>	--NEG
						PC_branch <= (others => '0');
						REG_des <= "1"&rx;
						ALU_src_a <= (others => '0');
						ALU_src_b <= "1"&ry;
						REG_src_b <= "1"&ry;
						ALU_op <= "0011";
					when "01111"=>	--NOT
						PC_branch <= (others => '0');
						REG_des <= "1"&rx;
						ALU_src_a <= "1"&ry;
						ALU_src_b <= (others => '0');
						REG_src_b <= (others => '0');
						ALU_op <= "0100";
					when "01101"=>	--OR
						PC_branch <= (others => '0');
						REG_des <= "1"&rx;
						ALU_src_a <= "1"&rx;
						ALU_src_b <= "1"&ry;
						REG_src_b <= "1"&ry;
						ALU_op <= "0101";
					when "00100"=>	--SLLV
						PC_branch <= (others => '0');
						REG_des <= "1"&ry;
						ALU_src_a <= "1"&ry;
						ALU_src_b <= "1"&rx;
						REG_src_b <= "1"&rx;
						ALU_op <= "0111";
					when "00111"=>	--SRAV
						PC_branch <= (others => '0');
						REG_des <= "1"&ry;
						ALU_src_a <= "1"&ry;
						ALU_src_b <= "1"&rx;
						REG_src_b <= "1"&rx;
						ALU_op <= "1001";
					when others=>
						PC_branch <= (others => '0');
						REG_des <= (others => '0');
						ALU_src_a <= (others => '0');
						ALU_src_b <= (others => '0');
						REG_src_b <= (others => '0');
						ALU_op <= (others => '0');
				end case;
			when "11110"=>	--MFIH MTIH
				PC_branch <= (others => '0');
				Imm <= (others => '0');
				MEM_op <= (others => '0');
				ALU_src_b <= (others => '0');
				REG_src_b <= (others => '0');
				ALU_op <= (others => '0');
				case immediate is
					when "00000000"=>	--MFIH
						REG_des <= "1"&rx;
						ALU_src_a <= "0100";
					when "00000001"=>	--MTIH
						REG_des <= "0100";
						ALU_src_a <= "1"&rx;
					when others=>
						REG_des <= (others => '0');
						ALU_src_a <= (others => '0');
				end case;
			when others=>
				PC_branch <= (others => '0');
				Imm <= (others => '0');
				MEM_op <= (others => '0');
				REG_des <= (others => '0');
				ALU_src_a <= (others => '0');
				ALU_src_b <= (others => '0');
				REG_src_b <= (others => '0');
				ALU_op <= (others => '0');
		end case;
	end process;

end RTL;
