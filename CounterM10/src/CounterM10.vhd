Library IEEE;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity CounterM10 is 
	port(
	CLK: in std_logic;
	RST: in std_logic;
	ENI: in std_logic;
	ENO: out std_logic;
	CNT: out std_logic_vector(3 downto 0)
	);	
end CounterM10;

Architecture Behavioral of CounterM10 is
signal Cp,Cn : out std_logic_vector(3 downto 0);
begin
	Combinational:process(ENI, Cp)
	begin
		if ENI = '1' then
			if Cp = "1001" then
				Cn <= "0000";
				ENO <= '1';
			else
				Cn <= std_logic_vector(unsigned(Cp) + 1);
				ENO <= '0';
			end if;	
		else
			Cn <= Cp;
			ENO <= '0';
		end if;
		CNT <= Cp;
	end process combinational; 



	Sequential:process(CLK, RST)
	begin
		if RST = '0' then
			Cp <= "0000";
		elsif CLK'event and CLK = '1' then
			Cp <= Cn;
		end if;
		
	end process Sequential;

end Behavioral;
