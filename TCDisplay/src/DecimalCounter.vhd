Library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;
Entity DecimalCounter is
    Port( 
        CLK : in  STD_LOGIC;
        RST : in  STD_LOGIC;
        INC: in  STD_LOGIC;
        ONES : out  STD_LOGIC_VECTOR (3 downto 0);
        TENS : out  STD_LOGIC_VECTOR (3 downto 0);
        HUN : out  STD_LOGIC_VECTOR (3 downto 0);
        THO : out  STD_LOGIC_VECTOR (3 downto 0))
        ;
end DecimalCounter;
architecture structural of DecimalCounter is  
	-- Component declaration of the "CounterM10(Behavioral)" 
	component CounterM10
	port(
		CLK : in STD_LOGIC;
		RST : in STD_LOGIC;
		ENI : in STD_LOGIC;
		ENO : out STD_LOGIC;
		CNT : out STD_LOGIC_VECTOR(3 downto 0)
	);
	end component;
	for all: CounterM10 use entity work.CounterM10(Behavioral);
 signal ENO1, ENO2, ENO3, ENO4 : STD_LOGIC;
begin
		DIG1 : CounterM10
	port map(
		CLK => CLK,
		RST => RST,
		ENI => INC,
		ENO => ENO1,
		CNT => ONES
	);
		DIG2 : CounterM10
	port map(
		CLK => CLK,
		RST => RST,
		ENI => ENO1,
		ENO => ENO2,
		CNT => TENS
	);
		DIG3 : CounterM10
	port map(
		CLK => CLK,
		RST => RST,
		ENI => ENO2,
		ENO => ENO3,
		CNT => HUN
	);
		DIG4 : CounterM10	
	port map(
		CLK => CLK,
		RST => RST,
		ENI => ENO3,
		ENO => ENO4,
		CNT => THO
	);

end structural;

