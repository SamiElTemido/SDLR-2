library ieee;
use ieee.std_logic_1164.all;
entity AsyncronousReceiver is 
    generic(busWidth: integer :=8);
port(
    CLK : in std_logic;
    RST : in std_logic;
    RXD : in std_logic;
    DOUT : out std_logic_vector (busWidth-1 downto 0);
    RDY : out std_logic
    );	 
end AsyncronousReceiver;	

architecture Structural of AsyncronousReceiver is
	-- Component declaration of the "CountDown(Behavioral)" 
	component CountDown
	generic(
		N : INTEGER := 10
	);
	port(
		CLK : in STD_LOGIC;
		RST : in STD_LOGIC;
		DEC : in STD_LOGIC;
		RDY : out STD_LOGIC
	);
	end component;
	for all: CountDown use entity work.CountDown(Behavioral);
			-- Component declaration of the "FallingEd(Behavioral)" 
	component FallingEd
	port(
		CLk : in STD_LOGIC;
		RST : in STD_LOGIC;
		XIN : in STD_LOGIC;
		XRE : out STD_LOGIC
	);
	end component;
	for all: FallingEd use entity work.FallingEd(Behavioral);
			-- Component declaration of the "LatchSR(Behavioral)" 
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
			-- Component declaration of the "Serializer(Behavioral)" 
	component Serializer
	generic(
		busWidth : INTEGER := 8
	);
	port(
		CLK : in STD_LOGIC;
		RST : in STD_LOGIC;
		BIN : in STD_LOGIC;
		SHF : in STD_LOGIC;
		DOUT : out STD_LOGIC_VECTOR(busWidth-1 downto 0)
	);
	end component;
	for all: Serializer use entity work.Serializer(Behavioral);
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
			-- Component declaration of the "Toggle(Behavioral)" 
	component Toggle
	port(
		CLk : in STD_LOGIC;
		RST : in STD_LOGIC;
		TOG : in STD_LOGIC;
		TGS : out STD_LOGIC
	);
	end component;
	for all: Toggle use entity work.Toggle(Behavioral);
signal
begin

end Structural;