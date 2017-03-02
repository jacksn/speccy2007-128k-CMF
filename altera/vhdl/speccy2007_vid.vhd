library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity speccy2007_vid is
	port(
		CLK			: in std_logic;
		nCPU_Reset	: in std_logic;
        
		CLK_CPU	: out std_logic := '1';
--		WAIT_CPU : out std_logic := '1';

		WR_BUF	: out std_logic := '0';
		nRD_BUF_EN	: out std_logic := '1';
		nWR_GATE_EN	: out std_logic := '1';
		
		INT		: out std_logic := '1';

		RD			: in std_logic;
		WR			: in std_logic;
		IOREQ		: in std_logic;
		MREQ		: in std_logic;
		M1			: in std_logic;

		nADR_GATE_EN	: out std_logic := '1';
        
		mA		: inout std_logic_vector(13 downto 0) := "ZZZZZZZZZZZZZZ";
		mD		: in std_logic_vector(7 downto 0) := "ZZZZZZZZ";

		mRD	: out std_logic := '1';
		mWR	: out std_logic := '1';

		A14	: in std_logic;
		A15	: in std_logic;

		ROM_CS	: out std_logic := '1';

		ROM_A14 : out std_logic := '0';
		ROM_A15 : out std_logic := '0';
		
		RAM_A14 : out std_logic := '0';
		RAM_A15 : out std_logic := '0';
		RAM_A16 : out std_logic := '0';

		SYNC    : out std_logic := '1';     
		Red       : out std_logic := '0';
		Green       : out std_logic := '0';
		Blue       : out std_logic := '1';   
		Bright       : out std_logic := '0';     
 
		AVR_NOINT	: in std_logic;
		AVR_PROM		: in std_logic;
		AVR_WAIT		: in std_logic;
		TAPE_IN 		: in std_logic;
		
		AVR_INT		: out std_logic := '1';
		AVR_TRDOS	: out std_logic  := '0';
		
		SPEAKER	: out std_logic := '1';
		AY_CLK	: out std_logic;
		AY_BC1	: out std_logic;
		AY_BDIR	: out std_logic
	);
end speccy2007_vid;

architecture rtl of speccy2007_vid is

	signal Tick     : std_logic := '0';
	signal Invert   : unsigned(4 downto 0) := "00000";

	signal ChrC_Cnt : unsigned(2 downto 0) := "000";    -- Character column counter
	signal Hor_Cnt  : unsigned(5 downto 0) := "000000"; -- Horizontal counter
	signal ChrR_Cnt : unsigned(2 downto 0) := "000";    -- Character row counter
	signal Ver_Cnt  : unsigned(5 downto 0) := "000000"; -- Vertical counter

	signal Attr     : std_logic_vector(7 downto 0);
	signal Shift    : std_logic_vector(7 downto 0);
    
	signal Paper_r  : std_logic;
	signal blank_r  : std_logic;
	signal Attr_r   : std_logic_vector(7 downto 0);
	signal Shift_r  : std_logic_vector(7 downto 0);

	signal BorderAttr: std_logic_vector(2 downto 0) := "000";
	signal P_7ffd	: std_logic_vector(5 downto 0);
	signal AY_PORT	: std_logic := '0';
        
	signal VBUS_REQ		: std_logic := '1';
	signal VBUS_ACK		: std_logic := '1';
	signal VBUS_MODE	: std_logic := '1';	
	signal VBUS_RDY	: std_logic := '1';
	
	signal VidRD	: std_logic := '0';
	
	signal paper     : std_logic;
	signal hsync     : std_logic;
	signal vsync1    : std_logic;
	signal vsync2    : std_logic;

	signal pport_wait     : std_logic := '0';

	signal ROMADR	 : std_logic;
	signal VRAM_ACC		: std_logic;

	signal AVR_PORT  : std_logic := '0';

	signal TRDOS_TGL : std_logic := '0';
	signal TRDOS_FLG : std_logic := '0';

	signal PROM_TGL		: std_logic := '0';
	signal PROM_FLG		: std_logic := '0';	
	
	signal ROMSEL	 	: std_logic;
	
	signal RAM     : std_logic := '1';
	signal RAM_PAGE	: std_logic_vector(2 downto 0) := "000";

	signal ROM     : std_logic := '1';
	signal ROM_PAGE	: std_logic_vector(1 downto 0) := "00";
	
	signal SOUND_OUT : std_logic := '0';

begin
	ROMADR <= '0' when A15 = '0' and A14 = '0' else '1';
	
	ROM <= '0' when MREQ = '0' and ROMADR = '0' and TRDOS_TGL = '0' and PROM_TGL = '0' else '1';
	RAM <= '0' when MREQ = '0' and ROMADR = '1' else '1';

	ROMSEL <= P_7ffd(4);

	ROM_PAGE <=	"11" when TRDOS_FLG = '1' else
					"10" when PROM_FLG = '1' else
					"01" when ROMSEL = '1' else
					"00";

	RAM_PAGE <=	"000" when A15 = '0' and A14 = '0' else
					"101" when A15 = '0' and A14 = '1' else
					"010" when A15 = '1' and A14 = '0' else
					P_7ffd(2 downto 0);

	ROM_CS <= ROM;

	ROM_A14 <= ROM_PAGE(0);
	ROM_A15 <= ROM_PAGE(1);

	RAM_A14 <= RAM_PAGE(0) when VBUS_MODE = '0' else '1';
	RAM_A15 <= RAM_PAGE(1) when VBUS_MODE = '0' else P_7ffd(3);
	RAM_A16 <= RAM_PAGE(2) when VBUS_MODE = '0' else '1';

	VBUS_REQ <= '0' when ( MREQ = '0' or IOREQ = '0' ) and ( WR = '0' or RD = '0' ) else '1';
	VBUS_RDY <= '0' when Tick = '0' or ChrC_Cnt(0) = '0' else '1';
	nADR_GATE_EN <= VBUS_MODE;
	
	nRD_BUF_EN <= '0' when RAM = '0' and RD = '0' else '1';	
	nWR_GATE_EN <= '0' when VBUS_MODE = '0' and ((RAM = '0' or (IOREQ = '0' and M1 = '1')) and WR = '0') else '1';
	
	mRD <= '0' when (VBUS_MODE = '1' and VBUS_RDY = '0') or (VBUS_MODE = '0' and RD = '0' and MREQ = '0') else '1';  
	mWR <= '0' when VBUS_MODE = '0' and RAM = '0' and WR = '0' and ChrC_Cnt(0) = '0' else '1';

	paper <= '0' when Hor_Cnt(5) = '0' and Ver_Cnt(5) = '0' and ( Ver_Cnt(4) = '0' or Ver_Cnt(3) = '0' ) else '1';      

	hsync <= '0' when Hor_Cnt(5 downto 2) = "1010" else '1';
	vsync1 <= '0' when Hor_Cnt(5 downto 1) = "00110" or Hor_Cnt(5 downto 1) = "10100" else '1';
	vsync2 <= '1' when Hor_Cnt(5 downto 2) = "0010" or Hor_Cnt(5 downto 2) = "1001" else '0';

	TRDOS_TGL <= '1' when VBUS_MODE = '0' and M1 = '0' and RD = '0' and MREQ = '0' and (
								( TRDOS_FLG = '0' and ROMSEL = '1' and A15 = '0' and A14 = '0' and mA(13 downto 8) = "111101" ) -- enter TRDOS condition
								--or ( TRDOS_FLG = '0' and MAGIC = '1' )
								or ( TRDOS_FLG = '0' and AVR_PROM = '0' and ROMSEL = '1' and A15 = '0' and A14 = '0' and mA(13 downto 0) = "00000001100110" )
								or ( TRDOS_FLG = '1' and ( A15 = '1' or A14 = '1' or PROM_FLG = '1' ) ) )                           -- return from TRDOS
								else '0';

	PROM_TGL <= '1' when VBUS_MODE = '0' and M1 = '0' and RD = '0' and MREQ = '0' and PROM_FLG = not AVR_PROM else '0';

	AVR_INT <= not AVR_PORT;
	AVR_TRDOS <= TRDOS_FLG;
	pport_wait <= '1' when AVR_WAIT = not AVR_PORT or TRDOS_TGL = '1' else '0';

	SPEAKER <= SOUND_OUT xor TAPE_IN;

	AY_CLK	<= ChrC_Cnt(1);
	AY_PORT	<= '0' when WR = '1' and RD = '1' else
					'1' when VBUS_MODE = '0' and mA(1 downto 0) = "01" else
					'0' when VBUS_MODE = '0' else
					AY_PORT;
	AY_BC1	<= '1' when AY_PORT = '1' and M1 = '1' and IOREQ = '0' and A14 = '1' and A15 = '1' else '0';
	AY_BDIR	<= '1' when AY_PORT = '1' and M1 = '1' and IOREQ = '0' and A15 = '1' and WR = '0' else '0';

	WR_BUF <= '1' when VBUS_MODE = '0' and ChrC_Cnt(0) = '0' else '0';
	
	-- generate Z80 CLOCK 3.5 MHz

	process( CLK )
	begin
	-- rising edge of CLK
		if CLK'event and CLK = '1' then
			if Tick = '1' then
				if ChrC_Cnt(0) = '0' then 
					if pport_wait = '0' then
						CLK_CPU <= '0';
					end if;
				else
					CLK_CPU <= '1';
				end if;
			end if;
		end if;     
	end process;

	process( CLK )
	begin
		if CLK'event and CLK = '1' then
        
			if Tick = '1' then
            
				if ChrC_Cnt = 7 then
                
					if Hor_Cnt = 55 then
						Hor_Cnt <= (others => '0');
					else
						Hor_Cnt <= Hor_Cnt + 1;
					end if;
                    
					if Hor_Cnt = 39 then                    
						if ChrR_Cnt = 7 then
							if Ver_Cnt = 39 then
								Ver_Cnt <= (others => '0');
								Invert <= Invert + 1;
							else
								Ver_Cnt <= Ver_Cnt + 1;
							end if;                         
						end if;                     
						ChrR_Cnt <= ChrR_Cnt + 1;
					end if;
				end if;
                
				if ChrC_Cnt = 7 then
                    
				if not ( Ver_Cnt = 31 ) then
					SYNC <= hsync;
				elsif ChrR_Cnt = 3 or ChrR_Cnt = 4 or ( ChrR_Cnt = 5 and ( Hor_Cnt >= 40 or Hor_Cnt < 12 ) ) then
					SYNC <= vsync2;
				else
					SYNC <= vsync1;
				end if;
                    
				end if;
            
				if ChrC_Cnt = 6 and Hor_Cnt(2 downto 0) = "111" then
					if Ver_Cnt = 29 and ChrR_Cnt = 7 and Hor_Cnt(5 downto 3) = "100" then
						INT <= '0';
					else
						INT <= '1';
					end if;

				end if;
				ChrC_Cnt <= ChrC_Cnt + 1;
			end if;
			Tick <= not Tick;
		end if;
	end process;

	process( CLK )
	begin
		if CLK'event and CLK = '1' then 
			if ChrC_Cnt(0) = '1' and Tick = '0' then
			
				if VBUS_MODE = '1' then
					if VidRD = '0' then
						Shift <= mD;
					else
						Attr  <= mD;
					end if;
				end if;				
				
				if VBUS_REQ = '0' and VBUS_ACK = '1' then
					VBUS_MODE <= '0';
				else
					VBUS_MODE <= '1';
					VidRD <= not VidRD;
				end if;	
				VBUS_ACK <= VBUS_REQ;
			end if;
		end if;
	end process;
    
	mA <= ( others => 'Z' ) when VBUS_MODE = '0' else
											std_logic_vector( "0" & Ver_Cnt(4 downto 3) & ChrR_Cnt & Ver_Cnt(2 downto 0) & Hor_Cnt(4 downto 0) ) when VidRD = '0' else
											std_logic_vector( "0110" & Ver_Cnt(4 downto 0) & Hor_Cnt(4 downto 0) );

	process( CLK )
	begin
		if CLK'event and CLK = '1' then
			if Tick = '1' then
				if paper_r = '0' then           
					if( Shift_r(7) xor ( Attr_r(7) and Invert(4) ) ) = '1' then
						Blue <= Attr_r(0);
						Red <= Attr_r(1);
						Green <= Attr_r(2);
					else
						Blue <= Attr_r(3);
						Red <= Attr_r(4);
						Green <= Attr_r(5);
					end if;
				else
					if blank_r = '0' then
						Blue <= 'Z';
						Red <= 'Z';
						Green <= 'Z';
					else
						Blue <= BorderAttr(0);
						Red <= BorderAttr(1);
						Green <= BorderAttr(2);
					end if;
				end if;
			end if;             

		end if;
	end process;

	process( CLK )
	begin
		if CLK'event and CLK = '1' then
			if Tick = '1' then
				if paper_r = '0' and Attr_r(6) = '1' then
--					Bright <= 'Z';
					Bright <= '1';
				else
					Bright <= '0';
				end if;
			end if;			

		end if;
	end process;

	process( CLK )
	begin
		if CLK'event and CLK = '1' then
			if Tick = '1' then
				if ChrC_Cnt = 7 then
					Attr_r <= Attr;
					Shift_r <= Shift;

					if ((Hor_Cnt(5 downto 0) > 38) and (Hor_Cnt(5 downto 0) < 48)) or Ver_Cnt(5 downto 1) = 15 then
						blank_r <= '0';
					else 
						blank_r <= '1';
					end if;
                    
					paper_r <= paper;
				else
					Shift_r(7 downto 1) <= Shift_r(6 downto 0);
					Shift_r(0) <= '0';
				end if;

			end if;
		end if;
	end process;

	process( CLK )
	begin
		if CLK'event and CLK = '1' then

			if nCPU_Reset = '0' then
				P_7ffd <= "000000";
				SOUND_OUT <= '0';
			elsif Tick = '1' and ChrC_Cnt(0) = '0' and VBUS_MODE = '0' and IOREQ = '0' and M1 = '1' then
				
				if WR = '0' and mA(1) = '0' and A15 = '0' and P_7ffd(5) = '0' then
					P_7ffd <= mD(5 downto 0);
				end if;
				
				if WR = '0' and mA(7 downto 0) = "11111110" then
					BorderAttr <= mD(2 downto 0);
					SOUND_OUT <= mD(4);                    
				end if;
			end if;             
		end if;
	end process;

	process( CLK )
	begin
		if CLK'event and CLK = '1' then
			if Tick = '1' then

				if TRDOS_TGL = '1' then
					TRDOS_FLG <= not TRDOS_FLG;
				end if;
				
				if PROM_TGL = '1' then
					PROM_FLG <= not PROM_FLG;
				end if;

				if IOREQ = '0' then
					if VBUS_MODE = '0' and ChrC_Cnt(0) = '0' then
						if RD = '0' and mA(7 downto 0) = "11111110" and AVR_NOINT = '1' then
							AVR_PORT <= '1';
						elsif ( RD = '0' or WR = '0' ) and mA(7 downto 0) = "00011111" then
							AVR_PORT <= '1';
						else 
							AVR_PORT <= '0';
						end if;
					end if;
				else
					AVR_PORT <= '0';		
				end if;

			end if;
		end if;
	end process;

end;
