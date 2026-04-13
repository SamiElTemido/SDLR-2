library ieee;
use ieee.std_logic_1164.all;
entity SPIMaster is
    generic (
        CLK_FREQ : integer := 1_000_000; -- 1mhz
        NBITS : integer := 16
    );
    port (
        CLK : in std_logic;
        RST : in std_logic;
        STR: in std_logic;
        MISO : in std_logic;
        CSE: out std_logic;
        SCK: out std_logic;
        DOUTS: out std_logic_vector(9 downto 0);
        RDY: out std_logic
    );
end SPIMaster;
architecture Structural of SPIMaster is	  
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
	 	-- Component declaration of the "Deserializer(Behavioral)" 
	component Deserializer
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
	for all: Deserializer use entity work.Deserializer(Behavioral);
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

	signal EOC, ENA, SYN, SHF, TOG, NSTR,XRE : std_logic;
	signal DOUT: std_logic_vector(NBITS-1 downto 0);
begin  
	Label0 : RisingEd
	port map(
		CLk => CLk,
		RST => RST,
		XIN => NSTR,
		XRE => XRE
	);
	Label1 : LatchSR port map( CLk => CLk, RST => RST, CLR => EOC, SET =>XRE , SOUT => ENA );

	Label2 : Timer generic map( Ticks => 50 ) port map( CLK => CLK, RST => ENA, EOT => SYN ); 	

	Label3 : Toggle port map( CLk => CLK, RST => ENA, TOG => SYN, TGS => TOG );

	Label4 : Deserializer  generic map( busWidth => NBITS ) port map( CLK => CLK, RST => RST, BIN => MISO, SHF => SHF, DOUT =>DOUT);

	Label5 : CountDown generic map( N => NBITS ) port map( CLK => CLK, RST => ENA, DEC => SHF, RDY => EOC );
	
	NSTR<= not STR;
	CSE <= not ENA;
	RDY <= not ENA;
	SCK <= TOG;
	SHF <= SYN AND NOT(TOG);
	DOUTS <= DOUT(14 downto 5);
end Structural;		  
