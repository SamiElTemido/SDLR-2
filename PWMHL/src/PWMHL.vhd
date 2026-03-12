Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity PWMHL is
    Generic(
        frequency : INTEGER := 24000;
        NBITs : INTEGER := 8;
        DTCycles : INTEGER := 20
    );
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           DUTY_CYCLE : in STD_LOGIC_VECTOR (NBITs-1 downto 0);
           PWM_OUTH : out STD_LOGIC;
           PWM_OUTL : out STD_LOGIC
           );
end PWMHL;
architecture Structural of PWMHL is	
	-- Component declaration of the "PWMModule(Structural)" 
	component PWMModule
	generic(
		frequency : INTEGER := 24000;
		NBITs : INTEGER := 8
	);
	port(
        CLK : in STD_LOGIC;
		RST : in STD_LOGIC;
		DUTY : in STD_LOGIC_VECTOR(NBITs-1 downto 0);
		PWM : out STD_LOGIC
	);
	end component;
	for all: PWMModule use entity work.PWMModule(Structural);	 
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
    -- Signal declaration
    signal pwm_xin : STD_LOGIC;
	signal pwm_xin_n : STD_LOGIC;
    signal pwm_xout : STD_LOGIC;
    signal pwm_xoutn : STD_LOGIC;	
	
begin
	Label1 : PWMModule
	generic map(
		frequency => frequency,
		NBITs => NBITs
	)
	port map(
        CLK => CLK,
		RST => RST,
		DUTY => DUTY_CYCLE,
		PWM => pwm_xin
	);
	pwm_xin_n <= not(pwm_xin);
	Label2 : DeathTimeGen
	generic map(
		DTCycles => DTCycles+1
	)
	port map(
		CLK => CLK,
		RST => RST,
		XIN => pwm_xin,
		XOUT => pwm_xout
	);
	label3 : DeathTimeGen
	generic map(
		DTCycles => DTCycles
	)
	port map(
		CLK => CLK,
		RST => RST,
		XIN => pwm_xin_n,
		XOUT => pwm_xoutn
	);
	PWM_OUTH <= pwm_xout;
	PWM_OUTL <= pwm_xoutn;
end Structural;