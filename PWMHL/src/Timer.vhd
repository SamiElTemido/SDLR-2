Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Timer is
	generic( Ticks : integer := 100);
	
	port(
	CLK : in	std_logic;
	RST : in	std_logic;
	EOT : out 	std_logic
	);
end  Timer;
architecture Behavioral of Timer is	
signal Cp,Cn : integer range 0 to Ticks;
begin	
	Combinational: process(Cp)
	begin
		if Cp = Ticks-1  then
			Cn<= 0;
			EOT<='1';
		else
			Cn<=Cp+1;
			EOT<='0';
		end if;
	end process combinational;
	
	Sequential: process(CLK,RST)
	begin 
		if RST ='0' then
			Cp <= 0;
		elsif CLK'event and CLk ='1' then
			Cp <= Cn;
		end if;
	end process Sequential;
	
end Behavioral;
