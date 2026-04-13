library IEEE;
use ieee.std_logic_1164.all;

entity AnodeDecoder is
	port(
	CLK: in std_logic;
	RST: in std_logic;
	SEL: in std_logic_vector(1 downto 0);
	ANO: out std_logic_vector(3 downto 0)
	);
end AnodeDecoder;
											 							 
architecture Behavioral of AnodeDecoder is
signal Qn, Qp: std_logic_vector(3 downto 0);
begin
	Combinational: process(SEL)
	begin
	case SEL is
		when "00" => Qn <= "0001";
		when "01" => Qn <= "0010";
		when "10" => Qn <= "0100";
		when "11" => Qn <= "1000";
		when others => Qn <= "0000";
	end case; 
	end process Combinational;
	
	Sequential: process(RST, CLK)
	begin 
		if RST = '0' then
			Qp <= (others => '0');
		elsif CLK'event and CLK = '1' then
			Qp <= Qn;
		end if;
	end process Sequential;
	
	ANO <=Qp;

end Behavioral;
