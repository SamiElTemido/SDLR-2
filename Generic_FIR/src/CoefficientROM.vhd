library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity CoefficientROM is 
    generic (
        n: integer := 8;
        PFB: integer := 16
    );
    port(
        CNT:in std_logic_vector(n-1 downto 0);
        Bn :out std_logic_vector(PFB-1 downto 0)
    );
end CoefficientROM;
architecture DataFlow of CoefficientROM is
begin
    process(CNT)
    begin
        case to_integer(unsigned(CNT)) is
            when 0 => Bn <= "1111111110001010";
            when 1 => Bn <= "1111111101111010";
            when 2 => Bn <= "0000000000000000";
            when 3 => Bn <= "0000001010111000";		    
            when 4 => Bn <= "0000100010011101";
            when 5 => Bn <= "0001000010100001";
            when 6 => Bn <= "0001011110111010";
            when 7 => Bn <= "0001101010010011";
            when 8 => Bn <= "0001011110111010";
            when 9 => Bn <= "0001000010100001";
            when 10 => Bn <= "0000100010011101";
            when 11 => Bn <= "0000001010111000";
            when 12 => Bn <= "0000000000000000";
            when 13 => Bn <= "1111111101111010";
            when 14 => Bn <= "1111111110001010";
            when others => Bn <= (others => '0');
        end case;
    end process;
   
end DataFlow;