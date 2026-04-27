library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity PureSineInverter is
    port (
        CLK : in std_logic;
        RST : in std_logic;
		SD: out std_logic;
        PWM_OUT1H : out std_logic;
		PWM_OUT1L: out std_logic;
        PWM_OUT2H : out std_logic;
		PWM_OUT2L:out std_logic
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
 
		-- Component declaration of the "DeathTimeGen(Behavioral)"
	component DeathTimeGen
	generic(
		DTCycles : INTEGER := 10
	);
	port(
		CLK : in STD_LOGIC;
		RST : in STD_LOGIC;
		XIN : in STD_LOGIC;
		XOUT : out STD_LOGIC
	);
	end component;
	for all: DeathTimeGen use entity work.DeathTimeGen(Behavioral);

	signal SYN,DIR : std_logic;
    signal FULL_ANGLE : std_logic_vector(7 downto 0); -- AHORA ES DE 8 BITS
    signal SIN, CNT : std_logic_vector(11 downto 0);
	signal pwm_aux, pwm_auxN,pwmd,pwmNd : std_logic; -- SeÃ±ales auxiliares para PWM
		
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

-- El bit 7  nos da el cambio de polaridad a los 180 
DIR <= FULL_ANGLE(7); 
-- Generamos las señales PWM comparando el contador con el valor de la lut
	pwm_aux <= '1' when CNT < SIN else '0'; -- pwm sin dt 
	pwm_auxN <= not pwm_aux; -- complemento sin dt

	Label1 : DeathTimeGen
	generic map(
		DTCycles => 50
	)
	port map(
		CLK => CLK,
		RST => RST,
		XIN => pwm_aux,
		XOUT => pwmd
	);
	label2 : DeathTimeGen
	generic map(
		DTCycles => 50
	)
	port map(
		CLK => CLK,
		RST => RST,
		XIN => pwm_auxN,
		XOUT =>pwmNd
	);

PWMproces: process(CNT, SIN, DIR)
begin
	if DIR = '1' then
		PWM_OUT1H <= pwmd; 
		PWM_OUT1L <= pwmNd;
		PWM_OUT2H <= '0';
		PWM_OUT2L <= '1'; 
	
	else
		PWM_OUT1H <= '0';
		PWM_OUT1L <= '1'; 
		PWM_OUT2H <= pwmd;
		PWM_OUT2L <= pwmNd;

	end if;
end process;

--SHUTDOWN PIN 
SD <=not RST; 


end Structural;
