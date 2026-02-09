library IEEE;
use ieee.std_logic_1164.all;

entity CountDown is	 
	
	generic(N: integer:= 10); 
	
	port(
	CLK: in		std_logic;
	RST: in		std_logic;
	DEC: in	   	std_logic;
	RDY: out   	std_logic
	);
end CountDown;

architecture Behavioral of CountDown is	
signal Cn,Cp : integer ;
begin  

	Combinational: process(Cp)
	begin  
		if DEC = '1' then
			if Cp > 0 then 
				Cn<= Cp-1;
			else
				Cn<= 0;
			end if;
		else
		if Cp > 0 then 
				RDY<='1';
			else
				RDY<='0'; 
		end if;
	end process Combinational;
	
	Sequential: process(RST,CLK,Cn)
	begin					   
		if RST = '0' then
			Cp<=N;
		elsif CLK'event and CLK='1'	then
			Cp<=Cn;	
		end if;	
	end process Sequential;
end behavioral;

