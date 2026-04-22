library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity PhaseAngleControl is
    port (
        CLK : in std_logic;
        RST : in std_logic;
        DUTY : in std_logic_vector(7 downto 0);
        ZCR: in std_logic;
        GATE : out std_logic;
        DEBUG : out std_logic_vector(7 downto 0)
        );
end PhaseAngleControl;
architecture structural of PhaseAngleControl is	
	-- Component declaration of the "RisingEd(Behavioral)" unit defined in
	-- file: "../src/RisingEd.vhd"
	component RisingEd
	port(
		CLk : in STD_LOGIC;
		RST : in STD_LOGIC;
		XIN : in STD_LOGIC;
		XRE : out STD_LOGIC
	);
	end component;
	for all: RisingEd use entity work.RisingEd(Behavioral);
			-- Component declaration of the "LatchSR(Behavioral)" unit defined in
	-- file: "../src/LatchSR.vhd"
	component LatchSR
	port(
		CLk : in STD_LOGIC;
		RST : in STD_LOGIC;
		CLR : in STD_LOGIC;
		SET : in STD_LOGIC;
		SOUT : out STD_LOGIC
	);
	end component;
	for all: LatchSR use entity work.LatchSR(Behavioral);
			-- Component declaration of the "Timer(Behavioral)" unit defined in
	-- file: "../src/Timer.vhd"
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
			-- Component declaration of the "FrCounter(Behavioral)" unit defined in
	-- file: "../src/FrCounter.vhd"
	component FrCounter
	generic(
		BusWhidht : INTEGER := 16
	);
	port(
		CLK : in STD_LOGIC;
		RST : in STD_LOGIC;
		INC : in STD_LOGIC;
		CNT : out STD_LOGIC_VECTOR(BusWhidht-1 downto 0)
	);
	end component;
	for all: FrCounter use entity work.FrCounter(Behavioral);
signal RED, EOT, ENA, SYN, RSS : std_logic;
signal CNT : std_logic_vector(7 downto 0);
signal TON: std_logic_vector(7 downto 0);

begin 
    label1: RisingEd port map(CLK, RST, ZCR, RED); 
    label2: LatchSR port map(CLK, RST, EOT, RED, ENA);
    label3: Timer generic map(42000) port map(CLK, ENA, EOT);-- 40000 ticks at 50Mhz is 0.8ms, which is the time of one half period of a 50Hz signal	
	RSS <= RST AND NOT(EOT);
	label4: Timer generic map(1627) port map(CLK, RSS, SYN);
	label5: FrCounter generic map(8) port map(CLK, RSS, SYN, CNT);
	TON <= std_logic_vector(255 - unsigned(DUTY));
	GATE <= '1' when CNT > TON else '0';
	    
end structural;
