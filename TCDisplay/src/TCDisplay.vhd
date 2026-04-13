library ieee;
use ieee.std_logic_1164.all;
entity TCDisplay is
    generic (
        CLK_FREQ : integer := 1_000_000; -- 1mhz
        NBITS : integer := 16
    );
    port (
        CLK : in std_logic;
        RST : in std_logic;
        MISO : in std_logic;
        CSE : out std_logic;
        SCK : out std_logic;
        ANO : out std_logic_vector(3 downto 0);
        SEG : out std_logic_vector(6 downto 0);
        DEBUG : out std_logic_vector(9 downto 0)
    );
end TCDisplay;
architecture Structural of TCDisplay is
	-- Component declaration of the "DisplayDriverBTD(Structural)" 
	component DisplayDriverBTD
	port(
		CLK : in STD_LOGIC;
		RST : in STD_LOGIC;
		DIN : in STD_LOGIC_VECTOR(9 downto 0);
		SEG : out STD_LOGIC_VECTOR(6 downto 0);
		ANO : out STD_LOGIC_VECTOR(3 downto 0)
	);
	end component;
	for all: DisplayDriverBTD use entity work.DisplayDriverBTD(Structural);	
			-- Component declaration of the "SPIMaster(Structural)"
	component SPIMaster
	generic(
		CLK_FREQ : INTEGER := 1000000;
		NBITS : INTEGER := 16
	);
	port(
		CLK : in STD_LOGIC;
		RST : in STD_LOGIC;
		STR : in STD_LOGIC;
		MISO : in STD_LOGIC;
		CSE : out STD_LOGIC;
		SCK : out STD_LOGIC;
		DOUTS : out STD_LOGIC_VECTOR(9 downto 0);
		RDY : out STD_LOGIC
	);
	end component;
	for all: SPIMaster use entity work.SPIMaster(Structural);
			-- Component declaration of the "Timer(Behavioral)" 
	component Timer
	generic(
		Ticks : INTEGER := 100
	);
	port(
		CLK : in STD_LOGIC;
		RST : in STD_LOGIC;
		EOT : out STD_LOGIC
	);
	end component;
	for all: Timer use entity work.Timer(Behavioral);
	Signal EOT, RDY:std_logic;
    Signal DIN:std_logic_vector(9 downto 0);
	
begin 
	Label0 : Timer
	generic map(
		Ticks => 5e7
	)
	port map(
		CLK => CLK,
		RST => RST,
		EOT => EOT
	);
	Label1 : SPIMaster
	generic map(
		CLK_FREQ => CLK_FREQ,
		NBITS => NBITS
	)
	port map(
		CLK => CLK,
		RST => RST,
		STR => EOT,
		MISO => MISO,
		CSE => CSE,
		SCK => SCK,
		DOUTS => DIN,
		RDY => RDY
	); 
	Label2 : DisplayDriverBTD
	port map(
		CLK => CLK,
		RST => RST,
		DIN => DIN,
		SEG => SEG,
		ANO => ANO
	);
	
	
end Structural;
