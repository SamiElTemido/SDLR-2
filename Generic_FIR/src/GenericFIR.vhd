Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity GenericFIR is
    generic (
        n: integer := 8;
        PFB: integer := 16
    );
    port(
        CLK: in std_logic;
        RST: in std_logic;
        STR: in std_logic;
        XIN : in std_logic_vector(n-1 downto 0);
        YOUT: out std_logic_vector((n+PFB)-1 downto 0)
    );
end GenericFIR;
Architecture structural of GenericFIR is  
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
			-- Component declaration of the "LoadRegister(Behavioral)" 
	component LoadRegister
	generic(
		busWidth : INTEGER := 8
	);
	port(
		CLK : in STD_LOGIC;
		RST : in STD_LOGIC;
		LDR : in STD_LOGIC;
		DIN : in STD_LOGIC_VECTOR(busWidth-1 downto 0);
		DOUT : out STD_LOGIC_VECTOR(busWidth-1 downto 0)
	);
	end component;
	for all: LoadRegister use entity work.LoadRegister(Behavioral);
			-- Component declaration of the "CoefficientROM(DataFlow)" 
	component CoefficientROM
	generic(
		n : INTEGER := 8;
		PFB : INTEGER := 16
	);
	port(
		CNT : in STD_LOGIC_VECTOR(n-1 downto 0);
		Bn : out STD_LOGIC_VECTOR(PFB-1 downto 0)
	);
	end component;
	for all: CoefficientROM use entity work.CoefficientROM(DataFlow); 
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

		
signal EOC, RUN,RSS: std_logic;
signal CNT: std_logic_vector(3 downto 0);
signal Bn: std_logic_vector(PFB-1 downto 0);
signal X0, X1, X2, X3, X4, X5, X6, X7, X8, X9, X10, X11, X12, X13, X14: std_logic_vector(n-1 downto 0);
signal XN: std_logic_vector(n-1 downto 0);
signal MULT: std_logic_vector((n+PFB)-1 downto 0);
signal SUM: std_logic_vector((n+PFB)-1 downto 0);
signal ACCUM: std_logic_vector((n+PFB)-1 downto 0);
begin

    latch: LatchSR port map(CLK, RST,EOC, STR, RUN);
    counterM: CounterMN generic map(Module => 15, NBits => 4) port map(CLK, RUN, '1', open, CNT);
	counterD: CountDown generic map(N => 15 ) port map(CLK, RUN, '1', EOC);
	ROM: CoefficientROM generic map(n => 4, PFB => PFB) port map(CNT, Bn);
	x0LR: LoadRegister generic map(busWidth => n) port map(CLK, RST, STR, XIN, X0);
	x1LR: LoadRegister generic map(busWidth => n) port map(CLK, RST, STR, X0, X1);
	x2LR: LoadRegister generic map(busWidth => n) port map(CLK, RST, STR, X1, X2);
	x3LR: LoadRegister generic map(busWidth => n) port map(CLK, RST, STR, X2, X3);
	x4LR: LoadRegister generic map(busWidth => n) port map(CLK, RST, STR, X3, X4);
	x5LR: LoadRegister generic map(busWidth => n) port map(CLK, RST, STR, X4, X5);
	x6LR: LoadRegister generic map(busWidth => n) port map(CLK, RST, STR, X5, X6);
	x7LR: LoadRegister generic map(busWidth => n) port map(CLK, RST, STR, X6, X7);
	x8LR: LoadRegister generic map(busWidth => n) port map(CLK, RST, STR, X7, X8);
	x9LR: LoadRegister generic map(busWidth => n) port map(CLK, RST, STR, X8, X9);
	x10LR: LoadRegister generic map(busWidth => n) port map(CLK, RST, STR, X9, X10);
	x11LR: LoadRegister generic map(busWidth => n) port map(CLK, RST, STR, X10, X11);
	x12LR: LoadRegister generic map(busWidth => n) port map(CLK, RST, STR, X11, X12);
	x13LR: LoadRegister generic map(busWidth => n) port map(CLK, RST, STR, X12, X13);
	x14LR: LoadRegister generic map(busWidth => n) port map(CLK, RST, STR, X13, X14);

	process(CNT, x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14)
	begin
		if CNT = "0000" then
			XN <= x0;
		elsif CNT = "0001" then
			XN <= x1;
		elsif CNT = "0010" then
			XN <= x2;
		elsif CNT = "0011" then
			XN <= x3;
		elsif CNT = "0100" then
			XN <= x4;
		elsif CNT = "0101" then
			XN <= x5;
		elsif CNT = "0110" then
			XN <= x6;
		elsif CNT = "0111" then
			XN <= x7;
		elsif CNT = "1000" then
			XN <= x8;
		elsif CNT = "1001" then
			XN <= x9;
		elsif CNT = "1010" then
			XN <= x10;
		elsif CNT = "1011" then
			XN <= x11;
		elsif CNT = "1100" then
			XN <= x12;
		elsif CNT = "1101" then
			XN <= x13;
		elsif CNT = "1110" then
			XN <= x14;
		else
			XN <= (others => '0');
		end if;
	end process;
	RSS <= RST and NOT(STR);
	MULT <= std_logic_vector(signed(XN) * signed(Bn));
	SUM <= std_logic_vector(signed(MULT) + signed(ACCUM));
	accumLR: LoadRegister generic map(busWidth => n+PFB) port map(CLK, RSS, RUN, SUM, ACCUM);
	outLR: LoadRegister generic map(busWidth => n+PFB) port map(CLK, RST, EOC, ACCUM, YOUT);
	



end structural;