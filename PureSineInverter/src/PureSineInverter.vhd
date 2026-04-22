library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity PureSineInverter is
    port (
        CLK : in std_logic;
        RST : in std_logic;
		DIR : out std_logic;
        PWM_OUT1 : out std_logic;
        PWM_OUT2 : out std_logic
    );
end PureSineInverter;
Architecture Structural of PureSineInverter is 
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
			-- Component declaration of the "FrCounter(Behavioral)"
	component FrCounter
	generic(
		BusWidth : INTEGER := 16
	);
	port(
		CLK : in STD_LOGIC;
		RST : in STD_LOGIC;
		INC : in STD_LOGIC;
		CNT : out STD_LOGIC_VECTOR(BusWidth-1 downto 0)
	);
	end component;
	for all: FrCounter use entity work.FrCounter(Behavioral);
			-- Component declaration of the "CounterMN(Behavioral)"
	component CounterMN
	generic(
		Module : INTEGER := 20000;
		NBits : INTEGER := 16
	);
	port(
		CLK : in STD_LOGIC;
		RST : in STD_LOGIC;
		ENI : in STD_LOGIC;
		ENO : out STD_LOGIC;
		CNT : out STD_LOGIC_VECTOR(NBits-1 downto 0)
	);
	end component;
	for all: CounterMN use entity work.CounterMN(Behavioral);
			-- Component declaration of the "SineLUT(DataFlow)" 
	component SineLUT
	port(
		ANGLE : in STD_LOGIC_VECTOR(6 downto 0);
		SIN : out STD_LOGIC_VECTOR(11 downto 0)
	);
	end component;
	for all: SineLUT use entity work.SineLUT(DataFlow);
    signal SYN : std_logic;
    signal FULL_ANGLE : std_logic_vector(7 downto 0); -- AHORA ES DE 8 BITS
    signal SIN, CNT : std_logic_vector(11 downto 0);
begin

Timer1: Timer
generic map(
    Ticks => 3255  -- Mantenemos 3255 para cuadrar a 60Hz con 256 pasos
)   
port map(
    CLK => CLK,
    RST => RST,
    EOT => SYN
);

-- Cambiamos el ancho de bus a 8 bits
eightbitscounter: FrCounter
generic map(
    BusWidth => 8 
)
port map(
    CLK => CLK,
    RST => RST,
    INC => SYN,
    CNT => FULL_ANGLE
);

-- Pasamos solo los 7 bits inferiores (6 downto 0) a la LUT
seno: SineLUT
port map(
    ANGLE => FULL_ANGLE(6 downto 0), 
    SIN => SIN
);

counter: CounterMN
generic map(
    Module => 3255,
    NBits => 12
)
port map(
    CLK => CLK,
    RST => RST,
    ENI => '1',
    ENO => open,
    CNT => CNT
);   

-- El bit 7 (MSB) nos da el cambio de polaridad a los 180 grados exactos
DIR <= FULL_ANGLE(7); 

PWM_OUT1 <= '1' when unsigned(SIN) > unsigned(CNT) else '0';
PWM_OUT2 <= '0';

end Structural;
