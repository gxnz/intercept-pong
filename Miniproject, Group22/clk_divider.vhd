----------------
--This file is the 1Hz clock divider of Intercept Pong Game
----------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

-- This divides the clock into 1Hz

entity clk_divider is
generic(N: integer := 12500000);
	port(clk_in : in std_logic;
			clk_out : out std_logic);
end entity clk_divider;

architecture behaviour of clk_divider is 
	signal temp_clk : std_logic := '0';
begin
	
	process(clk_in)
	variable temp_count : integer := 0;
	begin
		if (rising_edge(clk_in)) then
			if (temp_count < N) then
				temp_count := temp_count + 1;
			else
				temp_count := 0;
				temp_clk <= not temp_clk;
			end if;
		end if;
	end process;
	
	clk_out <= temp_clk;
	
end architecture behaviour;
		