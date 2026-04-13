library IEEE;
use ieee.std_logic_1164.all;

entity SN74LS47	is
	port(
	CLK: in std_logic;
	RST: in std_logic;
	NIB: in std_logic_vector(3 downto 0);
	SEG: out std_logic_vector(6 downto 0)
	);								   
end SN74LS47;

architecture Behavioral of SN74LS47 is
signal Qn, Qp: std_logic_vector(6 downto 0);

begin  
	Combinational: process(NIB)
	begin
	case NIB is
		when "0000" => Qn <= "0111111";
		when "0001" => Qn <= "0000110";
		when "0010" => Qn <= "1011011";
		when "0011" => Qn <= "1001111";
		when "0100" => Qn <= "1100110";
		when "0101" => Qn <= "1101101";
		when "0110" => Qn <= "1111101";
		when "0111" => Qn <= "0000111";
		when "1000" => Qn <= "1111111";
		when "1001" => Qn <= "1101111";
		when "1010" => Qn <= "1110111";
		when "1011" => Qn <= "1111100";
		when "1100" => Qn <= "0111001";
		when "1101" => Qn <= "1011110";
		when "1110" => Qn <= "1111001";
		when "1111" => Qn <= "1110001";
		when others => Qn <= "0000000";
	end case;
	end process Combinational;
	Sequential: process(RST, CLK)
	begin
		if RST = '0' then
			Qp <= (others => '1');
		elsif CLK'event and CLK = '1' then
			Qp <= Qn;
		end if;
	end process Sequential;
	SEG <= Qp;
	
end Behavioral;
