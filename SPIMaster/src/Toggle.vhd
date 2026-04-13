library IEEE;
use IEEE.STD_LOGIC_1164.ALL;  

Entity Toggle is
	port(
	CLk: in		std_logic;
	RST: in		std_logic;
	TOG: in		std_logic; 
	TGS: out	std_logic
	);
end Toggle;

Architecture Behavioral of Toggle is 
signal Qn,Qp: std_logic;
begin				 
	Combinational: process(TOG,Qp)
	begin		  	   
		if TOG = '1' then
			Qn <= not Qp;
		else
			Qn <= Qp; 
		end if;
		TGS <= Qp;
	end process Combinational;

	Sequential: process(RST,CLk)
	begin 
		if RST = '0' then
			Qp<='0';
		elsif Clk'event and CLK ='1' then
			Qp<=Qn;
		end if;
	end process Sequential;

end architecture Behavioral;
