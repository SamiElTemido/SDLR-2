Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PWMServo is
    generic(
        step : integer := 10;	--4
        ofsfset : integer := 450  --1000
    );
    port(
        CLK : in std_logic;
        RST : in std_logic;
        DUTY : in std_logic_vector(7 downto 0);
        PWM_OUT : out std_logic
    );
end PWMServo;
architecture structural of PWMServo is
	-- Componente: Timer
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
			-- Component declaration of the "CounterMN(Behavioral)" 
	component CounterMN
	generic(
		Module : INTEGER := 18000;--
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
		
signal EOT : std_logic; -- fin del Timer de 1 us
signal CNT : std_logic_vector(15 downto 0); -- contador de 0..19999 
signal duty_cycle : std_logic_vector(15 downto 0); -- ancho del pulso en ticks
begin 
	TIMER1US: Timer
    generic map(
        Ticks => 55 -- 1 us
    )
    port map(
        CLK => CLK,
        RST => RST,
        EOT => EOT
    );
    CONTADORMODULO20_000: CounterMN
    generic map(
        Module => 18000,
        NBits => 16
    )
    port map(
        CLK => CLK,
        RST => RST,
        ENI => EOT,
        ENO => open,
        CNT => CNT
    );
     -- Escala DUTY (0-255) a (0-102022)  multiplica por step y suma offset.
     duty_cycle <= std_logic_vector(unsigned(DUTY) * step + ofsfset);
     pwm_out <= '1' when unsigned(CNT) < unsigned(duty_cycle) else '0';

end structural;