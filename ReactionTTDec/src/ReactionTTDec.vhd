  library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ReactionTTDec is
    port(				 	
        CLK : in std_logic;
        RST : in std_logic;
        BTN : in std_logic;
        ALRM : out std_logic;
        SEG : out std_logic_vector(6 downto 0);
        ANO : out std_logic_vector(3 downto 0)
    );
end ReactionTTDec;
architecture Structural of ReactionTTDec is	
	-- Component declaration of the "ReactionTT(Structural)" 
	component ReactionTT
	generic(
		Ticks10s : INTEGER := 500000000;
		Ticks1ms : INTEGER := 50000;
		Nbits : INTEGER := 10
	);
	port(
		CLK : in STD_LOGIC;
		RST : in STD_LOGIC;
		BTN : in STD_LOGIC;
		ALRM : out STD_LOGIC;
		TIEMPO : out STD_LOGIC_VECTOR(Nbits-1 downto 0)
	);
	end component;
	for all: ReactionTT use entity work.ReactionTT(Structural);	
		-- Component declaration of the "DisplayDriverBTD(Structural)" 
	component DisplayDriverBTD
	port(
		CLK : in STD_LOGIC;
		RST : in STD_LOGIC;
		DIN : in STD_LOGIC_VECTOR(15 downto 0);
		SEG : out STD_LOGIC_VECTOR(6 downto 0);
		ANO : out STD_LOGIC_VECTOR(3 downto 0)
	);
	end component;
	for all: DisplayDriverBTD use entity work.DisplayDriverBTD(Structural);
    SIGNAL TIEMPO: std_logic_vector(15 downto 0); 
	 signal LEDS: std_logic;

	
   begin
	   
        UT1: ReactionTT
        generic map(
            Ticks10s => 500_000_000,
            Ticks1ms => 50_000,
            Nbits => 16
        )
        port map(
            CLK => CLK,
            RST => RST,
            BTN => BTN,
            ALRM => ALRM,
            TIEMPO => TIEMPO
        );	
		 --ALRM<=(others=>LEDS); 
		
        UT2: DisplayDriverBTD
        port map(
            CLK => CLK,
            RST => RST,
            DIN => TIEMPO,
            SEG => SEG,
            ANO => ANO
        );

end Structural;