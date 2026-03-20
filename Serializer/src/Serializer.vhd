library ieee;
use ieee.std_logic_1164.all;

entity Serializar is 
    generic (
        busWidth : integer := 8
    );
    port (
        CLK : in std_logic;
        RST : in std_logic;
        DIN : in std_logic_vector(busWidth-1 downto 0);
        LDR : in std_logic;
        SHF : in std_logic;
        BOUT : out std_logic
    );
end Serializar;

architecture Behavioral of Serializar is
    signal Qn,QP : std_logic_vector(busWidth-1 downto 0);
begin
 combinational : process(Qn, LDR, SHF)
    begin
        if LDR = '1' then
            QP <= DIN;
        elsif SHF = '1' then
            QP <=   '1' & Qn(busWidth-1 downto 1); 
        else
            QP <= Qn;
        end if;
        BOUT <= Qn(0);

    end process;

    sequential : process(CLK, RST)
    begin
        if RST = '0' then
            Qn <= (others => '0');
        elsif CLK'event and CLK = '1' then
            Qn <= QP;
        end if;
    end process;
end Behavioral;