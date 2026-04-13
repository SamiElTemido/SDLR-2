library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity BinaryToDecimal is
    Port (
        CLK: in std_logic;
        RST: in std_logic;
		STR: in std_logic;
        DIN: in std_logic_vector(15 downto 0);
        ONE: out std_logic_vector(3 downto 0);
        TEN: out std_logic_vector(3 downto 0);
        HUN: out std_logic_vector(3 downto 0);
        THO: out std_logic_vector(3 downto 0)
    );
end BinaryToDecimal;
architecture Structural of BinaryToDecimal is 
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
		-- Component declaration of the "DecimalCounter(structural)"
	component DecimalCounter
	port(
		CLK : in STD_LOGIC;
		RST : in STD_LOGIC;
		INC : in STD_LOGIC;
		ONES : out STD_LOGIC_VECTOR(3 downto 0);
		TENS : out STD_LOGIC_VECTOR(3 downto 0);
		HUN : out STD_LOGIC_VECTOR(3 downto 0);
		THO : out STD_LOGIC_VECTOR(3 downto 0)
	);
	end component;
	for all: DecimalCounter use entity work.DecimalCounter(structural);

signal GTE,INC,RSS,ENA,NGTE: std_logic;
signal CNT: std_logic_vector(15 downto 0);
begin
    START: LatchSR
    port map(
        CLk => CLK,
        RST => RST,
        CLR => NGTE,
        SET => STR,
        SOUT => ENA
    );
    CONTADOR: FrCounter
    generic map(
        BusWhidht => 16
    )
    port map(
        CLK => CLK,
        RST => ENA,
        INC => '1',
        CNT => CNT
    );	
	NGTE<= not GTE;
    GTE <= '1' when unsigned(DIN) > unsigned(CNT) else '0';
    INC <= GTE and ENA;
    RSS <= RST and not(STR);
    CONTADORDECIMAL: DecimalCounter
    port map(
        CLK => CLK,
        RST => RSS,
        INC => INC,
        ONES => ONE,
        TENS => TEN,
        HUN => HUN,
        THO => THO
    );
        
end Structural;