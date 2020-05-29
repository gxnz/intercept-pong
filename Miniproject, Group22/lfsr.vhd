----------------
--This file is the Randomized number generator(LFSR) of Intercept Pong Game
----------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE  IEEE.STD_LOGIC_ARITH.all;

entity lfsr is
Port ( clock : in STD_LOGIC;
       reset : in STD_LOGIC;
       Q : out STD_LOGIC_VECTOR (10 downto 0);
       check: out STD_LOGIC);
end lfsr;

architecture Behavioral of lfsr is
signal Qt: STD_LOGIC_VECTOR(7 downto 0) := x"01";
signal en: STD_LOGIC := '1';
signal Q11: STD_LOGIC_VECTOR(10 downto 0) := "00000000000";
begin

PROCESS(clock)
variable tmp : STD_LOGIC := '0';
BEGIN

IF rising_edge(clock) THEN
   IF (reset='1') THEN
   -- be reset to all 0's, as you will enter an invalid state
      Qt <= x"01"; 
   --ELSE Qt <= seed;
   ELSIF en = '1' THEN
      tmp := Qt(4) XOR Qt(3) XOR Qt(2) XOR Qt(0);
      Qt <= tmp & Qt(7 downto 1);
   END IF;

END IF;
END PROCESS;
check <= Qt(7);
Q11 <= '0' & Qt & "00";

PROCESS(clock, Q11)
variable previous : STD_LOGIC_VECTOR(10 downto 0) := "01010000000";

BEGIN

Q <= Q11;

END PROCESS;

end Behavioral;