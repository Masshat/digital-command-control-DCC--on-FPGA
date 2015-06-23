
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top_FPGA is
		port(Clk : in std_logic;
			ready : in std_logic;
			reset : in std_logic;
			toto : out std_logic;
			p_pulse : out std_logic			
			);
end Top_FPGA;

architecture Behavioral of Top_FPGA is

component sequenceur is
    port(go: in std_logic;
		reset : in std_logic;
		  consigne: in std_logic_vector(15 downto 0);
		  clk: in std_logic;
		  pulse: out std_logic;
		  toto: out std_logic);
   end component;
	
component divclk is
	 Port ( clk_in : in  STD_LOGIC;
           clk_out : out  STD_LOGIC );
	end component;
	
component commande is
	Port (Clk : in std_logic;
		reset : in std_logic;
		C : in std_logic;
		Go : out std_logic;
		Consigne :out std_logic_vector(15 downto 0)
		);
end component;

signal clk_out : std_logic;
signal clk_in : std_logic;
signal consigne : std_logic_vector (15 downto 0);

signal first_go : std_logic;

begin

	div_clk : divclk port map(clk_in=>Clk, clk_out => clk_out);
	seq : sequenceur port map (go => ready,reset=>reset, consigne => consigne, clk=> clk_out, pulse => p_pulse,toto=>toto);
	com : commande port map (Clk => Clk,reset=>reset, C => ready, Go => first_go,Consigne => consigne);
end Behavioral;
