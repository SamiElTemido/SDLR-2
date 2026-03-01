Library IEEE;
use IEEE.std_logic_1164.all;

entity PWMModule is 
	generic(
	frequency : integer := 24_000;
		NBITs : integer := 8
		);
	port(
		RST : in std_logic;
		CLK : in std_logic;
		DUTY : in std_logic_vector(NBITs-1 downto 0);
		PWM : out std_logic);
end PWMModule;
architecture Structural of PWMModule is	
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
signal SYN : std_logic;
signal CNT : std_logic_vector(NBITs-1 downto 0);
begin
	
	-- Instantiation of the "Timer(Behavioral)" 
	Timer_Inst : Timer
	generic map(
		Ticks => 5e7/(frequency*2**NBITs)
	)
	port map(
		CLK => CLK,
		RST => RST,
		EOT => SYN
	);
	-- Instantiation of the "FrCounter(Behavioral)" 
	FrCounter_Inst : FrCounter
	generic map(
		BusWhidht => NBITs
	)
	port map(
		CLK => CLK,
		RST => RST,
		INC => SYN,
		CNT => CNT
	);
	PWM <= '1' when CNT < DUTY else '0';
	
end Structural;
