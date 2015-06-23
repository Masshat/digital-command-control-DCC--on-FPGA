library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity divclk is 
	Port ( clk_in:in STD_LOGIC; 
		   clk_out:out STD_LOGIC
		 );
end divclk;

architecture Behavioral of divclk is begin

process (clk_in)

     variable cpt:integer range 0 to 24: = 0;

begin 
	if rising_edge (clk_in) then 
		cpt: = cpt + 1;
	if cpt = 24 then 
		clk_out <= '1';
		cpt:= 0;
     	elsif cpt = 12 then 
		clk_out <= '0';
     	end if; 
	end if;
end process;

end Behavioral;
