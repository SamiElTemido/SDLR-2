library IEEE;
use IEEE.STD_LOGIC_1164.ALL;  

Entity LatchSR is
	port(
	CLk: in		std_logic;
	RST: in		std_logic;
	CLR: in		std_logic; 
	SET: in		std_logic;
	SOUT:out	Std_logic
	);
end LatchSR;

Architecture Behavioral of LatchSR is 
signal Qn,Qp: std_logic;
begin				 
	Combinational: process(SET,CLR,Qp)
	begin	
		if	SET ='1' then
			Qn<='1';  
		elsif CLR ='1'then
			Qn<= '0';
		else 
			Qn<=Qp;			  
		end if;	
		SOUT<= Qp;
	end process Combinational;	
	

	Sequential: process(RST,CLk)
	begin 
		if RST = '0' then
			Qp<='0';
		elsif Clk'event and CLK ='1' then
			Qp<=Qn;
		end if;
	end process Sequential;

end Behavioral;
