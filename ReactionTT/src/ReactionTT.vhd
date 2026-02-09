Library IEEE;
use ieee.std_logic_1164.all;

entity ReactionTT is
	generic(
		Ticks10s: integer:=500_000_000;
		Ticks1ms: integer :=50_000;
		Nbits: integer := 9
	);
	port(
		CLK: in std_logic;
		RST: in std_logic;
		BTN:  in std_logic;
		ALRM: out std_logic;
		TIEMPO: out std_logic_vector(Nbits-1 downto 0)
	);
end ReactionTT;
												 
architecture Structural of ReactionTT is 
	-- Component declaration of the "FrCounter(Behavioral)"
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
			-- Component declaration of the "LatchSR(Behavioral)" unit defined in	
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
		signal EOTTEN,SOUT,EOTONE,SRES: std_logic;
	--	signal CNT
begin
	
   SRES<= NOT(EOTTEN) AND RST;
	ALRM<= SOUT;
	
	TENSEC : Timer
	generic map(
		Ticks => Ticks10s
	)
	port map(
		CLK => CLK,
		RST => RST,
		EOT => EOTTEN
	);
	Label2 : LatchSR
	port map(
		CLk => CLK,
		CLR => NOT(BTN),
		RST => RST,
		SET => EOTTEN,
		SOUT => SOUT
	);	
	ONEms : Timer
	generic map(
		Ticks => Ticks1ms
	)
	port map(
		CLK => CLK,
		RST => SOUT,
		EOT => EOTONE
	); 
	Label1 : FrCounter
	generic map(
		BusWhidht => Nbits
	)
	port map(
		CLK => CLK,
		RST => SRES,
		INC => EOTONE,
		CNT => TIEMPO
	);
	
end Structural;
