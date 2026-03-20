library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity DeathTimeGen is
	generic(
		DTCycles : integer := 3
	);
	port(
		CLK : in std_logic;
		RST : in std_logic;
		XIN : in std_logic;
		XOUT : out std_logic
	);
end DeathTimeGen;
architecture Behavioral of DeathTimeGen is
	SIGNAL Qn, Qp : std_logic_vector(DTCycles-1 downto 0);
	signal Qx : std_logic_vector(DTCycles-2 downto 0);
begin
	combinational : process(XIN, Qp, Qx)
	begin
		Qn <= XIN & Qp(DTCycles-1 downto 1); 
		
		Qx(0) <= Qp(0) and Qp(1);  
		
		for i in 1 to DTCycles-2 loop  
			Qx(i) <= Qx(i-1) and Qp(i+1);
		end loop;
	end process combinational;
	
	XOUT <= Qx(DTCycles-2)
	;
	Sequencial : process(CLK, RST)
	begin
	if RST = '0' then
		Qp <= (DTCycles-1 downto 0 => '0');
	elsif CLK'event and CLK = '1' then
		Qp <= Qn;
	end if;
	end process Sequencial;
	
end Behavioral;
