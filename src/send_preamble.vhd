library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity send_preamble is
  PORT(		start_p: in std_logic;
			reset : in std_logic;
			end_p: out std_logic :='0';
			clk: in std_logic;
			out_preamble: out std_logic :='0'
      );
end send_preamble;

architecture Behavioral of send_preamble is
begin

process(clk,start_p,reset)
variable cpt: integer range 0 to 116 :=0;
variable cptbit: integer range 0 to 14 := 0;
variable enable_pre: std_logic := '0';
begin
	if (reset='1') then
		end_p <= '0';
		out_preamble <= '0';
		cpt := 0;
		cptbit := 0;
		enable_pre :='0';
	
	elsif rising_edge(clk) then
		if start_p='1' then
				enable_pre := '1';
		end if;
  if (enable_pre='1') then
	 cpt := cpt + 1;
	 if cpt=58 then
	    out_preamble <= '1';
    elsif cpt=116 then
	    out_preamble <= '0';
		cpt := 0;
		
		cptbit := cptbit + 1;
    end if;
	 
	 if cptbit=14 and cpt=0 then
	    end_p <= '1';
	 elsif cptbit=14 and cpt=1 then
		 end_p <= '0';
		 cptbit := 0;
		 cpt := 0;
		 enable_pre := '0';
    end if;
	 	
	end if;
  end if;
  
end process;
end Behavioral;
