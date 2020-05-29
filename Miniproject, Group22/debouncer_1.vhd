----------------
--This file is a debouncer of button_1
----------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity debouncer_1 is
		port( clock              : in std_logic;
				pb					  : in std_logic;
				pb_out_1			  : out std_logic
				);
				
end debouncer_1;

architecture behaviour of debouncer_1 is
	signal dbcount : std_logic_vector(3 downto 0) := x"0";
	signal db : std_logic:='0';
	signal db_prev : std_logic:='0';
	begin
	debouncer:process(clock,pb)
	begin
		if rising_edge(clock) then
			db <= '0';
			if pb = '0' then
				if dbcount = x"F" then
					db <= '1';					----It checks for a while if the button pressed
													----It change db to one only if the dbcount equal x"F"(which is a while)
				else
				dbcount <= dbcount + 1;
				end if;
			else
				dbcount<=(others => '0');
			end if;
		end if;
	end process;
	
	output:process(clock, db)
		begin	
			if rising_edge(clock) then
				pb_out_1 <= '1';
				db_prev <=db;
				if db_prev ='0' and db = '1' then	--change output to '0'  (active low) when db change to 1
					pb_out_1 <= '0';						--turn the pb_out_1 on(active low) for 1 clk cycle
				end if;
			end if;
		end process;
end architecture;