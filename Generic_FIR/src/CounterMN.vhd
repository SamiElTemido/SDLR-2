Library IEEE;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity CounterMN is 
	generic(
		Module: integer := 20000;
		NBits: integer := 16
	);
	port(
	CLK: in std_logic;
	RST: in std_logic;
	ENI: in std_logic;
	ENO: out std_logic;
	CNT: out std_logic_vector(NBits-1 downto 0)
	);	
end CounterMN;

Architecture Behavioral of CounterMN is
signal Cp,Cn : std_logic_vector(NBits-1 downto 0);
begin
	Combinational:process(ENI, Cp)
	begin
		if ENI = '1' then
			if Cp = std_logic_vector(to_unsigned(Module-1, NBits)) then
				Cn <= (others => '0');
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
			Cp <= (others => '0');
		elsif CLK'event and CLK = '1' then
			Cp <= Cn;
		end if;
		
	end process Sequential;

end Behavioral;
