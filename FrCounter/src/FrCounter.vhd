library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.numeric_std.all;

entity FrCounter is
	generic (
		BusWhidht: integer := 16
	);
	Port(
	CLK: in 	std_logic;
	RST: in 	std_logic;
	INC: in 	std_logic;
	CNT: out	std_logic_vector(BusWhidht-1 downto 0)
	);
end FrCounter;

architecture Behavioral of FrCounter is
signal Cp, Cn : std_logic_vector(BusWhidht-1 downto 0);
begin
	
	combinational : process(INC,Cp)
	begin
		if INC = '1' then
			Cn <= std_logic_vector(unsigned(Cp)+1);
		else
			Cn <= Cp;
		end if;			   
		CNT<= Cp;
	end process combinational;

	sequential :process(RST, CLK)
	begin
		if RST = '0' then
			Cp <= (others => '0');
		elsif CLK'event and CLK = '1' then
			Cp <= Cn;
		end if;
	end process sequential;

end Behavioral;