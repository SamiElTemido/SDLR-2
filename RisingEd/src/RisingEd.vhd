library IEEE;
use IEEE.STD_LOGIC_1164.ALL;  

entity RisingEd is
Port( 
	CLk: in		std_logic;
	RST: in		std_logic;
	XIN: in 	std_logic;
	XRE: out 	std_logic
	);
end RisingEd;

architecture Behavioral of RisingEd is	
signal Qn,Qp: std_logic_vector(4 downto 0);
begin
	combinational: process(XIN,Qp)  
	begin
	Qn<=Qp(3 downto 0) & XIN;
	XRE <= '1' when Qp = "11110" else '0';
		
	end process combinational;
	sequentia: process(CLK,RST)
	begin
		if RST = '0' then
		Qp <= (others=>'0')	;
		elsif Clk'event and CLK ='1' then
		Qp <= Qn;
		end if;
		
	end process;
end Behavioral;
