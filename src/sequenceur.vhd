
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sequenceur is
	port(go: in std_logic;
		  reset : in std_logic;
		  consigne: in std_logic_vector(15 downto 0);
		  clk: in std_logic;
		  pulse: out std_logic;
		  toto: out std_logic);
end sequenceur;

architecture Behavioral of sequenceur is
	type state is (S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13,S14,S15,S16,S17);
	signal EP : state := S0;
	signal EF : state := S0;
	signal end_1, end_0, end_p, end_b: std_logic;
    signal start_1, start_0, start_p, start_b: std_logic := '0';
	signal byte_s: std_logic_vector (7 downto 0);
	signal one_out, zero_out, out_preamble, out_octet: std_logic;
	
	component send_one is
    Port ( start_1 : in  STD_LOGIC;
				reset : std_logic;
		     clk : in STD_LOGIC;
           end_1 : out  STD_LOGIC := '0';
           one_out : out  STD_LOGIC := '0');
   end component;
	
	component send_zero is
    Port ( start_0 : in  STD_LOGIC;
				reset : in std_logic;
		     clk : in STD_LOGIC;
           end_0 : out  STD_LOGIC := '0';
           zero_out : out  STD_LOGIC := '0');
   end component;
	
	component send_preamble is
     Port(start_p: in std_logic;
			reset : in std_logic;
		    end_p: out std_logic :='0';
		    clk: in std_logic;
		    out_preamble: out std_logic :='0');
   end component;
	
	component send_octet is
     Port (start_b : in  STD_LOGIC;
				reset : in std_logic;
		     byte : in std_logic_vector(7 downto 0);
		     clk : in STD_LOGIC;
           end_b : out  STD_LOGIC := '0';
           out_octet : out  STD_LOGIC := '0');
   end component;

	signal end_compteur : boolean;
	signal compteur : integer;
	
begin

	toto<= out_preamble;

  one:    send_one port map(start_1=>start_1,reset=>reset, clk=>clk,end_1=>end_1,one_out=>one_out);
  zero:   send_zero port map(start_0=>start_0,reset=>reset, clk=>clk,end_0=>end_0,zero_out=>zero_out);
  preamb: send_preamble port map(start_p=>start_p,reset=>reset, end_p=>end_p,clk=>clk,out_preamble=>out_preamble);
  byte:   send_octet port map(start_b=>start_b,reset=>reset, byte=>byte_s, clk=>clk,end_b=>end_b,out_octet=>out_octet);
  
  end_compteur <= (compteur = 400);
  
  process(clk,reset)
  begin
  
	if (reset='1') then
		EP<=S0;
    elsif rising_edge(clk) then
	   EP <= EF;
	
      if EP=S1 then start_p <='1';
		elsif EP=S2 then start_p <='0';
		elsif EP=S3 then start_0 <= '1';
		elsif EP=S4 then start_0 <= '0';
		elsif EP=S5 then byte_s <= consigne(7 downto 0); start_b <= '1';
		elsif EP=S6  then start_b <= '0';
		elsif EP=S7 then start_0 <= '1';
		elsif EP=S8 then start_0 <= '0';
	    elsif EP=S9 then byte_s <= consigne(15 downto 8); start_b <= '1';
		elsif EP=S10  then start_b <= '0';
		elsif EP=S11 then start_0 <= '1';
		elsif EP=S12 then start_0 <= '0';
		elsif EP=S13 then byte_s <= (consigne(15 downto 8) xor consigne(7 downto 0)); start_b <= '1';
		elsif EP=S14  then start_b <= '0';
		elsif EP=S15 then start_1 <= '1';
		elsif EP=S16 then start_1 <= '0'; compteur <= 0;
		elsif EP=S17 then compteur <= compteur+1;
		end if;
	end if;
  end process;  
  
  process(EP, end_0, end_1, end_p, end_b, go) 
  begin

	case(EP) is
	   when S0 => EF <= S0;
		if go='1' then EF <= S1; end if;
	   when S1 => EF <= S2; 
		when S2 => EF <= S2; 
		if end_p='1' then EF <= S3; end if;
		when S3 => EF <= S4;
		when S4 => EF <= S4;
		if end_0='1' then EF <= S5; end if;
		when S5 => EF <= S6; 
		when S6 => EF <= S6;
		if end_b='1' then EF <= S7; end if;
		when S7 => EF <= S8; 
		when S8 => EF <= S8; 
		if end_0='1' then EF <= S9; end if;
		when S9 => EF <= S10; 
		when S10 => EF <= S10; 
		if end_b='1' then EF <= S11; end if;
		when S11 => EF <= S12; 
		when S12 => EF <= S12; 
		if end_0='1' then EF <= S13; end if;
		when S13 => EF <= S14;
		when S14 => EF <= S14; 
		if end_b='1' then EF <= S15; end if;
		when S15 => EF <= S16; 
		when S16 => EF <= S16; 
		if end_1='1' then EF <= S17; end if;
		when S17 => EF <= S17;
		if end_compteur then EF <= S0; end if;
	   when others => NULL;
	 end case;
  end process;
  
  pulse <= one_out or zero_out or out_preamble or out_octet;
  
end Behavioral;
