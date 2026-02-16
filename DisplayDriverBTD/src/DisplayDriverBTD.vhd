library ieee;
use ieee.std_logic_1164.all;

entity DisplayDriverBTD is
	port (
		CLK : in std_logic;
		RST : in std_logic;
		DIN : in std_logic_vector(9 downto 0);
		SEG : out std_logic_vector(6 downto 0);
		ANO : out std_logic_vector(3 downto 0)
	);
	
end DisplayDriverBTD;

architecture Structural of DisplayDriverBTD is	 
	-- Component declaration of the "DisplayDriver(Structural)" 
	component DisplayDriver
	port(
		CLK : in STD_LOGIC;
		RST : in STD_LOGIC;
		DIG1 : in STD_LOGIC_VECTOR(3 downto 0);
		DIG2 : in STD_LOGIC_VECTOR(3 downto 0);
		DIG3 : in STD_LOGIC_VECTOR(3 downto 0);
		DIG4 : in STD_LOGIC_VECTOR(3 downto 0);
		SEG : out STD_LOGIC_VECTOR(6 downto 0);
		ANO : out STD_LOGIC_VECTOR(3 downto 0)
	);
	end component;
	for all: DisplayDriver use entity work.DisplayDriver(Structural); 
			-- Component declaration of the "BinaryToDecimal(Structural)" 
	component BinaryToDecimal
	port(
		CLK : in STD_LOGIC;
		RST : in STD_LOGIC;
		STR : in STD_LOGIC;
		DIN : in STD_LOGIC_VECTOR(15 downto 0);
		ONE : out STD_LOGIC_VECTOR(3 downto 0);
		TEN : out STD_LOGIC_VECTOR(3 downto 0);
		HUN : out STD_LOGIC_VECTOR(3 downto 0);
		THO : out STD_LOGIC_VECTOR(3 downto 0)
	);
	end component;
	for all: BinaryToDecimal use entity work.BinaryToDecimal(Structural);
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

signal ONE, TEN, HUN, THO : std_logic_vector(3 downto 0);
signal	EOT : std_logic;
begin
	-- Instantiation of the "DisplayDriver(Structural)" 
	DisplayDriver_1 : DisplayDriver
	port map(
		CLK => CLK,
		RST => RST,
		DIG1 => ONE,
		DIG2 => TEN,
		DIG3 => HUN,
		DIG4 => THO,
		SEG => SEG,
		ANO => ANO
	);	
	-- Instantiation of the "BinaryToDecimal(Structural)" 
	BinaryToDecimal_1 : BinaryToDecimal
	port map(
		CLK => CLK,
		RST => RST,
		STR => EOT,
		DIN => "000000" & DIN ,
		ONE => ONE,
		TEN => TEN,
		HUN => HUN,
		THO => THO
	);
	-- Instantiation of the "Timer(Behavioral)" 
	Timer_1 : Timer
	generic map(
		Ticks => 75_000
	)
	port map(
		CLK => CLK,
		RST => RST,
		EOT => EOT
	);
end Structural;
