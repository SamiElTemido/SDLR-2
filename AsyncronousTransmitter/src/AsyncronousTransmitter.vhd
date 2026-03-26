library ieee;
use ieee.std_logic_1164.all;

entity AsyncronousTransmitter is 
	generic(busWidth: integer :=8);
	port(
		CLK : in std_logic;
		RST : in std_logic;
		STR : in std_logic;
		DIN : in std_logic_vector (busWidth-1 downto 0);
		TXD : out std_logic;
		RDY : out std_logic
		
	);	 
end AsyncronousTransmitter;
architecture Structural of AsyncronousTransmitter is 

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
			-- Component declaration of the "RisingEd(Behavioral)" 
	component RisingEd
	port(
		CLk : in STD_LOGIC;
		RST : in STD_LOGIC;
		XIN : in STD_LOGIC;
		XRE : out STD_LOGIC
	);
	end component;
	for all: RisingEd use entity work.RisingEd(Behavioral);	
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
			-- Component declaration of the "Serializar(Behavioral)" 
	component Serializar
	generic(
		busWidth : INTEGER := 8
	);
	port(
		CLK : in STD_LOGIC;
		RST : in STD_LOGIC;
		DIN : in STD_LOGIC_VECTOR(busWidth-1 downto 0);
		LDR : in STD_LOGIC;
		SHF : in STD_LOGIC;
		BOUT : out STD_LOGIC
	);
	end component;
	for all: Serializar use entity work.Serializar(Behavioral);

	Signal XRE,EOC,ENA,SYN: std_logic; 
	Signal DIN_C :std_logic_vector(busWidth downto 0);
begin	 
	Label1 : RisingEd
	port map(
		CLk => CLk,
		RST => RST,
		XIN => STR,
		XRE => XRE
	);		
	Label2 : LatchSR
	port map(
		CLk => CLk,
		RST => RST,
		CLR => EOC,
		SET => XRE,
		SOUT => ENA
	);	 
	Label3 : Timer
	generic map(
		Ticks => 434
	)
	port map(
		CLK => CLK,
		RST => ENA	,
		EOT => SYN
	);		 
	Label4 : CountDown
	generic map(
		N => 9
	)
	port map(
		CLK => CLK,
		RST => ENA,
		DEC => SYN,
		RDY => EOC
	); 
	Label5: Serializar
	generic map(
		busWidth => busWidth+1
	)
	port map(
		CLK => CLK,
		RST => RST,
		DIN => DIN_C,
		LDR => STR,
		SHF => SYN,
		BOUT => TXD
	);
	
	DIN_C <= DIN & '0' ;	
	
	RDY <= not(ENA);
	
end Structural;

