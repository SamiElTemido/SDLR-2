library ieee;
use ieee.std_logic_1164.all;
entity Deserializer is
    generic (
        busWidth : integer := 8
    );
    port (
        CLK : in std_logic;
        RST : in std_logic;
        BIN : in std_logic;
        SHF : in std_logic;
        DOUT : out std_logic_vector(busWidth-1 downto 0)
    );
end Deserializer;
architecture Behavioral of Deserializer is
    signal Qn,Qp : std_logic_vector(busWidth-1 downto 0);
begin
    combinational : process(BIN, Qn,SHF)
    begin
        if SHF = '1' then
            Qp <= BIN & Qn(busWidth-1 downto 1);
        else
            Qp <= Qn;
        end if;
        DOUT <= Qn;
    end process combinational;

    sequiential : process(CLK, RST)
    begin
        if RST = '0' then
            Qn <= (others => '0');
        elsif Clk'event and Clk = '1' then
            Qn <= Qp;
        end if;
    end process sequiential;
end Behavioral;