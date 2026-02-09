library IEEE;
use ieee.std_logic_1164.all;
entity Blinky is
    port (
        CLK: in     std_logic;
        RST: in     std_logic;
        LED: out    std_logic;
    );
end entity Blink
architecture Structural of Blinky is
begin
    U1: entity work.Timer
        generic map (
            Ticks => 50000000
        )
        port map (
            CLK => CLK,
            RST => RST,
            EOT => SYN
        );
    U2: entity work.Toggle
        port map (
            CLK => CLK,
            RST => RST,
            TRG => SYN,
            OUT => LED
        );
end Structural;
