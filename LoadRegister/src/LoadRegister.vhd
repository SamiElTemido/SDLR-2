library ieee;
use ieee.std_logic_1164.all;

entity LoadRegister is 
    generic (
        busWidth : integer := 8
    );
    port (
        CLK : in std_logic;
        RST : in std_logic;
        LDR : in std_logic;
        DIN : in std_logic_vector(busWidth-1 downto 0);
        DOUT : out std_logic_vector(busWidth-1 downto 0)
    );
end LoadRegister;
architecture Behavioral of LoadRegister is
    signal Qn, Qp : std_logic_vector(busWidth-1 downto 0);
begin
    Combinational : process(Qp, LDR, DIN)
    begin
        if LDR = '1' then
            Qn <= DIN;
        else
            Qn <= Qp;
        end if;
        DOUT <= Qp;
    end process Combinational;

    Sequential : process(CLK, RST)
    begin
        if RST = '0' then
            Qp <= (others => '0');
        elsif CLK'event and CLK = '1' then
            Qp <= Qn;
        end if;
    end process Sequential;
end Behavioral;