-- *************************************************
-- JOGO atire nos monstros 
-- INSTRUCOES:
-- As teclas W e S movimentam o Link
-- para cima e para baixo.
-- A tecla espaco atira uma flecha
-- 
-- O Objetivo eh matar os monstros
-- *************************************************
library IEEE;
use  IEEE.STD_LOGIC_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;
use  ieee.numeric_std.all;

ENTITY notepad IS

	PORT(
		clkvideo, clk, reset : IN	STD_LOGIC;	
		videoflag	: out std_LOGIC;
		vga_pos		: out STD_LOGIC_VECTOR(15 downto 0);
		vga_char		: out STD_LOGIC_VECTOR(15 downto 0);
		Reset_saida  : OUT	STD_LOGIC;
		key			: IN 	STD_LOGIC_VECTOR(7 DOWNTO 0);	-- teclado
		rd          : IN STD_LOGIC_VECTOR (31 downto 0)
		);

END  notepad ;

ARCHITECTURE a OF notepad IS

	-- Escreve na tela
	SIGNAL VIDEOE      : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL VIDEOE_FLAG_EXIT   : STD_LOGIC;
	-- Contador de tempo

	-- Link
	SIGNAL LINKPOS   : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL LINKPOSA  : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL LINKCHAR  : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL LINKCOR   : STD_LOGIC_VECTOR(3 DOWNTO 0);
	
	--Flecha
	SIGNAL FLECHAPOS   : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL FLECHAPOSA  : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL FLECHACHAR  : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL FLECHACOR   : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL FLECHASINAL : STD_LOGIC;
	
	--Enemy1
	SIGNAL ENEMY1POS     : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL ENEMY1POSA    : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL ENEMY1POSI     : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL ENEMY1CHAR    : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL ENEMY1COR     : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL ENEMY1SINAL    : STD_LOGIC;
	
	--Enemy2
	SIGNAL ENEMY2POS     : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL ENEMY2POSA    : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL ENEMY2POSI     : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL ENEMY2CHAR    : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL ENEMY2COR    : STD_LOGIC_VECTOR(3 DOWNTO 0);
	
	--Enemy2 Flecha
	SIGNAL ENEMY2FLECHAPOS   : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL ENEMY2FLECHAPOSA  : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL ENEMY2FLECHACHAR  : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL ENEMY2FLECHACOR   : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL ENEMY2FLECHASINAL       : STD_LOGIC;
	SIGNAL ENEMY2SINAL       : STD_LOGIC;
	
	--Enemy3
	SIGNAL ENEMY3POS     : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL ENEMY3POSI     : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL ENEMY3POSA    : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL ENEMY3CHAR    : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL ENEMY3COR     : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL ENEMY3VIDA    : STD_LOGIC_VECTOR(1 DOWNTO 0);     --3 de vida
	SIGNAL ENEMY3SINAL   : STD_LOGIC;

	--Delay do Link
	SIGNAL DELAY1      : STD_LOGIC_VECTOR(31 DOWNTO 0);
	--Delay da Flecha
	SIGNAL DELAY2      : STD_LOGIC_VECTOR(31 DOWNTO 0);
	--Delay do Enemy1
	SIGNAL DELAY3      : STD_LOGIC_VECTOR(31 DOWNTO 0);
	--Delay do Enemy2
	SIGNAL DELAY4      : STD_LOGIC_VECTOR(31 DOWNTO 0);
	--Delay do Enemy2Flecha
	SIGNAL DELAY5      : STD_LOGIC_VECTOR(31 DOWNTO 0);
	--Delay do Enemy3
	SIGNAL DELAY6      : STD_LOGIC_VECTOR(31 DOWNTO 0);

	SIGNAL LINKESTADO : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL FLECHAESTADO : STD_LOGIC_VECTOR(7 DOWNTO 0);
	--Estados dos Enemies
	SIGNAL ENEMY1ESTADO    : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL ENEMY2ESTADO    : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL ENEMY2FLECHAESTADO    : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL ENEMY3ESTADO    : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL ENDGAME1	: STD_LOGIC;
	SIGNAL ENDGAME2	: STD_LOGIC;
	SIGNAL ENDGAME3	: STD_LOGIC;
	SIGNAL ENDGAME4	: STD_LOGIC;
	
	--Menu
	SIGNAL SCHAR    : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL TCHAR    : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL ACHAR    : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL RCHAR    : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL PCHAR    : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL ECHAR    : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL CCHAR    : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL OCHAR    : STD_LOGIC_VECTOR(7 DOWNTO 0);
	
	SIGNAL S1POS    : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL S2POS    : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL S3POS    : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL S4POS    : STD_LOGIC_VECTOR(15 DOWNTO 0);	
	SIGNAL T1POS    : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL T2POS    : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL T3POS    : STD_LOGIC_VECTOR(15 DOWNTO 0);	
	SIGNAL A1POS    : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL A2POS    : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL R1POS    : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL R2POS    : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL P1POS    : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL P2POS    : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL E1POS    : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL E2POS    : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL CPOS    : STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	SIGNAL LETRACOR    : STD_LOGIC_VECTOR(3 DOWNTO 0);
	
	--T
	SIGNAL T_ENDPOS    : STD_LOGIC_VECTOR(15 DOWNTO 0);
	--H
	SIGNAL HCHAR    : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL H_ENDPOS    : STD_LOGIC_VECTOR(15 DOWNTO 0);
	--E
	SIGNAL E1_ENDPOS    : STD_LOGIC_VECTOR(15 DOWNTO 0);
	--E
	SIGNAL E2_ENDPOS    : STD_LOGIC_VECTOR(15 DOWNTO 0);
	--N
	SIGNAL N_ENDPOS    : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL NCHAR    : STD_LOGIC_VECTOR(7 DOWNTO 0);
	--D
	SIGNAL D_ENDPOS    : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL DCHAR    : STD_LOGIC_VECTOR(7 DOWNTO 0);
	
BEGIN

-- Menu
PROCESS (clk, reset)
	
	BEGIN
	
	IF RESET = '1' THEN
		SCHAR <= "00010100";
		TCHAR <= "00010101";
		ACHAR <= "00000010";
		RCHAR <= "00010011";
		PCHAR <= "00010001";
		ECHAR <= "00000101";
		CCHAR <= "00000100";
		OCHAR <= "00010000";
		GAMESTART <= '0';
		VIDEO_FLAG_EXIT <= '0';
	
	ELSIF (clk'event) and (clk = '1') and (GAMESTART = '0')THEN
		LETRACOR <= "0000";   --branco
		
		VIDEO_FLAG_EXIT <= '0';
	
		SCHAR <= "00010100";
		TCHAR <= "00010101";
		ACHAR <= "00000010";
		RCHAR <= "00010011";
		PCHAR <= "00010001";
		ECHAR <= "00000101";
		CCHAR <= "00000100";
		OCHAR <= "00010000";
		
		P1POS <= x"0126";
		R1POS <= x"0127";
		E1POS <= x"0128";
		S1POS <= x"0129";
		S2POS <= x"012A";
		
		S3POS <= x"012C";
		P2POS <= x"012D";
		A1POS <= x"012E";
		CPOS <= x"012F";
		E2POS <= x"0130";
		
		T1POS <= x"0132";
		OPOS <= x"0133";
		
		S4POS <= x"01A3";
		T2POS <= x"01A4";
		A2POS <= x"01A5";
		R2POS <= x"01A6";
		T3POS <= x"01A7";
		
		IF (key = "00") THEN
			GAMESTART <= '1';
			
			P1POS <= x"04BC";
			R1POS <= x"04BC";
			E1POS <= x"04BC";
			S1POS <= x"04BC";
			S2POS <= x"04BC";
			
			S3POS <= x"04BC";
			P2POS <= x"04BC";
			A1POS <= x"04BC";
			CPOS <= x"04BC";
			E2POS <= x"04BC";
			
			T1POS <= x"04BC";
			OPOS <= x"04BC";
			
			S4POS <= x"04BC";
			T2POS <= x"04BC";
			A2POS <= x"04BC";
			R2POS <= x"04BC";
			T3POS <= x"04BC";
			
			VIDEO_FLAG_EXIT <= '1';
		END IF;
		
	END IF;

END PROCESS;

-- Movimenta LINK
PROCESS (clk, reset)
	
	BEGIN
		
	IF RESET = '1' THEN
		LINKCHAR <= "01100000";
		LINKCOR <= "0010"; -- 10 verde
		LINKPOS <= x"025A"; --meio da segunda coluna
		DELAY1 <= x"00000000";
		LINKESTADO <= x"00";
		
	ELSIF (clk'event) and (clk = '1') THEN

		CASE LINKESTADO IS
			WHEN x"00" => -- Estado movimenta Sapo segundo Teclado
				IF (GAMESTART = '0') THEN
					LINKESTADO = x"01";
				ELSE	
					CASE key IS
						WHEN x"53" => -- (S) BAIXO
							IF (LINKPOS < 1159) THEN   -- nao esta' na ultima linha
								LINKPOS <= LINKPOS + x"28";  -- LINKPOS + 40
							END IF;
						WHEN x"57" => -- (W) CIMA
							IF (LINKPOS > 39) THEN   -- nao esta' na primeira linha
								LINKPOS <= LINKPOS - x"28";  -- LINKPOS - 40
							END IF;
						--WHEN x"41" => -- (A) ESQUERDA
							--IF (NOT((conv_integer(LINKPOS) MOD 40) = 0)) THEN   -- nao esta' na extrema esquerda
								--LINKPOS <= LINKPOS - x"01";  -- LINKPOS - 1
							--END IF;
						--WHEN x"44" => -- (D) DIREITA
							--IF (NOT((conv_integer(LINKPOS) MOD 40) = 39)) THEN   -- nao esta' na extrema direita
								--LINKPOS <= LINKPOS + x"01";  -- LINKPOS + 1
							--END IF;
						WHEN OTHERS =>
					END CASE;
				LINKESTADO <= x"01";
				END IF;

			WHEN x"01" => -- Delay para movimentar Link
			 
				IF DELAY1 >= x"00000FFF" THEN
					DELAY1 <= x"00000000";
					LINKESTADO <= x"00";
				ELSE
					DELAY1 <= DELAY1 + x"01";
				END IF;
				
			WHEN OTHERS =>
		END CASE;
	END IF;

END PROCESS;

--Flecha
PROCESS (clk, reset)

BEGIN
		
	IF RESET = '1' THEN
		FLECHACHAR <= "01100101";
		FLECHACOR <= "1111"; -- 1111 Branco
		FLECHAPOS <= x"04B0";  --fora da tela
		DELAY2 <= x"00000000";
		FLECHAESTADO <= x"00";
		FLECHASINAL <= '0';
		
	ELSIF (clk'event) and (clk = '1') THEN

		CASE FLECHAESTADO IS
			IF (GAMESTART = '0') THEN
				FLECHAESTADO = x"03";
			ELSE
				WHEN x"00" =>
					--Atirou flecha?
					IF (key = x"00" AND FLECHASINAL = '0') THEN    --espaco
						FLECHASINAL <= '1';
						FLECHAPOS <= LINKPOS; --Flecha comeca na frente do link
					END IF;
					
					FLECHAESTADO <= x"01";
					
				WHEN x"01" =>
					-- INCREMENTA A POS DA FLECHA
						IF ((NOT((conv_integer(FLECHAPOS) MOD 40) = 39)) AND FLECHASINAL = '1') THEN
							FLECHAPOS <= FLECHAPOS + x"01";
							FLECHAESTADO <= x"02";								
						ELSE
							FLECHASINAL <= '0';
							FLECHAPOS <= x"04B0";     --fora da tela
							FLECHAESTADO <= x"03";
						END IF;
						
				WHEN x"02" =>
					-- destroi flecha?
					IF ((ENEMY1POSA = FLECHAPOS) OR (ENEMY1POS = FLECHAPOS)) THEN    --FLECHA E ENEMY1
						FLECHASINAL <= '0';
						FLECHAPOS <= x"04B0";
					ELSIF ((ENEMY2POSA = FLECHAPOS) OR (ENEMY2POS = FLECHAPOS)) THEN    --FLECHA E ENEMY2
						FLECHASINAL <= '0';
						FLECHAPOS <= x"04B0";
					ELSIF ((ENEMY3POSA = FLECHAPOS) OR (ENEMY3POS = FLECHAPOS)) THEN    --FLECHA E ENEMY3
						FLECHASINAL <= '0';
						FLECHAPOS <= x"04B0";
					END IF;
						
					FLECHAESTADO <= x"03";
						
						
				WHEN x"03" =>  -- Delay da Flecha
			
					IF DELAY2 >= x"000000FFF" THEN 
						DELAY2 <= x"00000000";
						FLECHAESTADO <= x"00";
					ELSE
						DELAY2 <= DELAY2 + x"01";
					END IF;
				WHEN OTHERS =>
					FLECHAESTADO <= x"00";
			END IF;		
		END CASE;
	END IF;
	
END PROCESS;

--Enemy1
PROCESS (clk, reset)

BEGIN
		
	IF RESET = '1' THEN
		ENEMY1CHAR <= "01100001";
		ENEMY1COR <= "0001"; -- 0 VERMELHO
		ENEMY1POS <= x"04B0";  --fora da tela
		ENEMY1POSI <= x"013f";
		DELAY3 <= x"00000000";
		ENEMY1ESTADO <= x"00";
		ENEMY1SINAL <= '0';
		ENDGAME1 <= '0';
		
	ELSIF (clk'event) and (clk = '1') THEN

			CASE ENEMY1ESTADO IS
				IF (GAMESTART = '0') THEN
					ENEMY1SESTADO = x"03";
				ELSE	
					WHEN x"00" =>
						--Nao tem enemy1 na tela?
						IF (ENEMY1SINAL = '0') THEN    --esta fora tela
							ENEMY1SINAL <= '1';
							ENEMY1POS <= ENEMY1POSI;
						END IF;
						ENEMY1ESTADO <= x"01";
					WHEN x"01" =>
						-- INCREMENTA A POS DO ENEMY1
							IF ((ENEMY1POSA = FLECHAPOS + x"0001") OR (ENEMY1POS = FLECHAPOS + x"0001")) THEN    --FLECHA E ENEMY1
								ENEMY1SINAL <= '0';
								ENEMY1POS <= x"04B0";
								ENEMY1POSI <= ENEMY1POSI + x"0001";
								--Soma PONTO;
							ELSIF ((conv_integer(ENEMY1POS) MOD 40) = 0) THEN
								ENDGAME1 <= '1';
							ELSIF ENEMY1SINAL = '1' THEN
								ENEMY1POS <= ENEMY1POS - x"01";
							END IF;
							
							ENEMY1ESTADO <= x"02";
						
					WHEN x"02" =>  -- Delay da Flecha
			
						IF DELAY3 >= x"0000FFFF" THEN 
							DELAY3 <= x"00000000";
							ENEMY1ESTADO <= x"00";
							IF(ENEMY1POSI > x"04AF") THEN
								ENEMY1POSI <= x"013f"; --RAND AKI
							END IF;
						ELSE
							DELAY3 <= DELAY3 + x"01";
						END IF;
			
					WHEN OTHERS =>
						ENEMY1ESTADO <= x"00";
				END IF;	
			END CASE;
	END IF;
	
END PROCESS;

--Enemy2
PROCESS (clk, reset)

BEGIN
		
	IF RESET = '1' THEN
		ENEMY2CHAR <= "01100010";
		ENEMY2COR <= "0101"; -- 0 ROXO
		ENEMY2POS <= x"04B0";  --fora da tela
		ENEMY2POSI <= x"00C7";
		DELAY4 <= x"00000000";
		ENEMY2ESTADO <= x"00";
		ENEMY2SINAL <= '0';
		ENDGAME2 <= '0';
		
	ELSIF (clk'event) and (clk = '1') THEN

			CASE ENEMY2ESTADO IS7
				IF (GAMESTART = '0') THEN
					ENEMY2ESTADO = x"03";
				ELSE
					WHEN x"00" =>
						--Nao tem enemy2 na tela?
						IF (ENEMY2SINAL = '0') THEN    --nao esta fora tela
							ENEMY2SINAL <= '1';
							ENEMY2POS <= ENEMY2POSI;
						END IF;
						
						ENEMY2ESTADO <= x"01";

					WHEN x"01" =>
						-- INCREMENTA A POS DO ENEMY1
							IF ((ENEMY2POSA = FLECHAPOS + x"0001") OR (ENEMY2POS = FLECHAPOS + x"0001")) THEN    --FLECHA E ENEMY1
								ENEMY2SINAL <= '0';
								ENEMY2POS <= x"04B0";
								ENEMY2POSI <= ENEMY2POSI + x"0001";
								-- SOME PONTO
							ELSIF ((conv_integer(ENEMY2POS) MOD 40) = 0) THEN
								ENDGAME2 <= '1';
							ELSIF (ENEMY2SINAL = '1') THEN                 --FAZER com que ele e a flecha nao andem juntos
								ENEMY2POS <= ENEMY2POS - x"01";
							END IF;
							
							ENEMY2ESTADO <= x"02";
						
					WHEN x"02" =>  -- Delay    Fazer um delay dentro desse para o enemy, usar esse para a flecha
			
						IF DELAY4 >= x"0000FFFF" THEN 
							DELAY4 <= x"00000000";
							ENEMY2ESTADO <= x"00";
							IF(ENEMY2POSI> x"04AF") THEN
								ENEMY2POSI <= x"00C7"; --RAND AKI
							END IF;
						ELSE
							DELAY4 <= DELAY4 + x"01";
						END IF;
			
	
	
					WHEN OTHERS =>
						ENEMY2ESTADO <= x"00";
				END IF;	
			END CASE;
	END IF;
	
END PROCESS;

--Flecha ENEMY2FLECHA
PROCESS (clk, reset)

BEGIN
		
	IF RESET = '1' THEN
		ENEMY2FLECHACHAR <= "01100100";
		ENEMY2FLECHACOR <= "0110"; -- 0 X
		ENEMY2FLECHAPOS <= x"04B0";  --fora da tela
		DELAY5 <= x"00000000";
		ENEMY2FLECHAESTADO <= x"00";
		ENEMY2FLECHASINAL <= '0';
		ENDGAME4 <= '0';
		
	ELSIF (clk'event) and (clk = '1') THEN

			CASE ENEMY2FLECHAESTADO IS
				IF (GAMESTART = '0') THEN
					FLECHAESTADO = x"03";
				ELSE
					WHEN x"00" =>
						--Atirou flecha?
						IF (ENEMY2FLECHASINAL = '0') THEN
							ENEMY2FLECHASINAL <= '1';
							ENEMY2FLECHAPOS <= ENEMY2POS - x"0001"; --Flecha comeca na frente do enemy2
						END IF;
						
						ENEMY2FLECHAESTADO <= x"01";

					WHEN x"01" =>
						-- INCREMENTA A POS DA FLECHA
							IF (ENEMY2FLECHAPOS = LINKPOS) THEN
								ENDGAME4 <= '1';
							ELSIF ((NOT((conv_integer(ENEMY2FLECHAPOS) MOD 40) = 0)) AND ENEMY2FLECHASINAL = '1') THEN
								ENEMY2FLECHAPOS <= ENEMY2FLECHAPOS - x"0001";							
							ELSE
								ENEMY2FLECHAPOS <= x"04B0";     --fora da tela
								ENEMY2FLECHASINAL <= '0';
							END IF;
							
							ENEMY2FLECHAESTADO <= x"02";
						
					WHEN x"02" =>  -- Delay da Flecha
			
						IF DELAY5 >= x"00001FFF" THEN 
							DELAY5 <= x"00000000";
							ENEMY2FLECHAESTADO <= x"00";
						ELSE
							DELAY5 <= DELAY5 + x"01";
						END IF;
					WHEN OTHERS =>
						ENEMY2FLECHAESTADO <= x"00";
				END IF;
				
			END CASE;
	END IF;
	
END PROCESS;

--Enemy3
PROCESS (clk, reset)

BEGIN
		
	IF RESET = '1' THEN
		ENEMY3CHAR <= "01100011";
		ENEMY3COR <= "1011"; -- 1011 Amarelo
		ENEMY3POS <= x"04B0"; --fora da tela
		ENEMY3POSI <= x"03BF";
		DELAY6 <= x"00000000";
		ENEMY3ESTADO <= x"00";
		ENEMY3VIDA <= "11";
		ENEMY3SINAL <= '0';
		ENDGAME3 <= '0';
		
	ELSIF (clk'event) and (clk = '1') THEN

		CASE ENEMY3ESTADO IS
			IF (GAMESTART = '0') THEN
				FLECHAESTADO = x"03";
			ELSE
				WHEN x"00" =>
					--Nao tem enemy3 na tela?
					IF (ENEMY3SINAL = '0') THEN    --esta fora tela
						ENEMY3SINAL <= '1';
						ENEMY3POS <= ENEMY3POSI;
					END IF;
					
					ENEMY3ESTADO <= x"01";

				WHEN x"01" =>
					-- INCREMENTA A POS DO ENEMY3
						IF ((ENEMY3POSA = FLECHAPOS + x"0001") OR (ENEMY3POS = FLECHAPOS + x"0001")) THEN    --FLECHA E ENEMY3
							ENEMY3VIDA <= ENEMY3VIDA - "01";
							IF (ENEMY3VIDA = "00") THEN
								ENEMY3SINAL <= '0';
								ENEMY3POS <= x"04B0";
								ENEMY3POSI <= ENEMY3POSI + x"0001";
								ENEMY3VIDA <= "11";
							END IF;
						ELSIF ((conv_integer(ENEMY3POS) MOD 40) = 0) THEN
							ENDGAME3 <= '1';
						ELSIF ENEMY3SINAL = '1' THEN
							ENEMY3POS <= ENEMY3POS - x"01";
						END IF;
						
						ENEMY3ESTADO <= x"02";
					
				WHEN x"02" =>  -- Delay da Flecha
		
					IF DELAY6 >= x"0000FFFF" THEN 
						DELAY6 <= x"00000000";
						ENEMY3ESTADO <= x"00";
						IF(ENEMY3POSI > x"04AF") THEN
								ENEMY3POSI <= x"03BF"; --RAND AKI
						END IF;
					ELSE
						DELAY6 <= DELAY6 + x"01";
					END IF;
		
				WHEN OTHERS =>
					ENEMY3ESTADO <= x"00";
			END IF;	
		END CASE;
	END IF;
	
END PROCESS;

PROCESS (clk, reset)
	
BEGIN
	IF RESET = '1' THEN
		Reset_Saida <= '0';	
	ELSIF (ENDGAME1 = '1' or ENDGAME2 = '1' or ENDGAME3 = '1' or ENDGAME4 = '1')THEN
		--Reset_saida <= '1';
		
	END IF;
END PROCESS;

-- Escreve na Tela
PROCESS (clkvideo, reset)

	VARIABLE num: INTEGER := 0;
	VARIABLE num_end: INTEGER := 0;

BEGIN
	IF RESET = '1' THEN
		VIDEOE <= x"00";
		videoflag <= '0';
		LINKPOSA <= x"0000";
		ENEMY1POSA <= x"0000";
		ENEMY2POSA <= x"0000";
		ENEMY2FLECHAPOSA <= x"0000";
		ENEMY3POSA <= x"0000";
		FLECHAPOSA <= x"0000";
		LINKPOSA <= x"0000";
		
	ELSIF (clkvideo'event) and (clkvideo = '1') THEN
		IF (ENDGAME1 = '1' or ENDGAME2 = '1' or ENDGAME3 = '1' or ENDGAME4 = '1') THEN
			VIDEOE <= x"1C";
		END IF;
		CASE VIDEOE IS
			WHEN x"00" => -- Apaga Enemy1
				if(ENEMY1POSA = ENEMY1POS) then
					VIDEOE <= x"04";
				else
					vga_char(15 downto 12) <= "0000";
					vga_char(11 downto 8) <= "0000";
					vga_char(7 downto 0) <= "00000000";
					vga_pos(15 downto 0)	<= ENEMY1POSA;
					
					videoflag <= '1';
					VIDEOE <= x"01";
					
				end if;
			WHEN x"01" =>
				videoflag <= '0';
				VIDEOE <= x"02";
				
			WHEN x"02" => 				--Escreve Enemy1
				vga_char(15 downto 12) <= "0000";
				vga_char(11 downto 8) <= ENEMY1COR;
				vga_char(7 downto 0) <= ENEMY1CHAR;
				vga_pos(15 downto 0)	<= ENEMY1POS;
				
				ENEMY1POSA <= ENEMY1POS;   -- Pos Anterior = Pos Atual
				videoflag <= '1';
				VIDEOE <= x"03";
			WHEN x"03" =>
				videoflag <= '0';
				VIDEOE <= x"04";
				
			WHEN x"04" => -- Apaga ENEMY2
				if(ENEMY2POSA = ENEMY2POS) then
					VIDEOE <= x"08";
				else
					vga_char(15 downto 12) <= "0000";
					vga_char(11 downto 8) <= "0000";
					vga_char(7 downto 0) <= "00000000";
					vga_pos(15 downto 0)	<= ENEMY2POSA;
					
					videoflag <= '1';
					VIDEOE <= x"05";
					
				end if;
			WHEN x"05" =>
				videoflag <= '0';
				VIDEOE <= x"06";
				
			WHEN x"06" => 				
				vga_char(15 downto 12) <= "0000";
				vga_char(11 downto 8) <= ENEMY2COR;
				vga_char(7 downto 0) <= ENEMY2CHAR;
				vga_pos(15 downto 0)	<= ENEMY2POS;
				
				ENEMY2POSA <= ENEMY2POS;   -- Pos Anterior = Pos Atual
				videoflag <= '1';
				VIDEOE <= x"07";
			WHEN x"07" =>
				videoflag <= '0';
				VIDEOE <= x"08";
				
			WHEN x"08" => -- Apaga ENEMY3
				if(ENEMY3POSA = ENEMY3POS) then
					VIDEOE <= x"0C";
				else
					vga_char(15 downto 12) <= "0000";
					vga_char(11 downto 8) <= "0000";
					vga_char(7 downto 0) <= "00000000";
					vga_pos(15 downto 0)	<= ENEMY3POSA;
					
					videoflag <= '1';
					VIDEOE <= x"09";
					
				end if;
			WHEN x"09" =>
				videoflag <= '0';
				VIDEOE <= x"0A";
				
			WHEN x"0A" => 				
				vga_char(15 downto 12) <= "0000";
				vga_char(11 downto 8) <= ENEMY3COR;
				vga_char(7 downto 0) <= ENEMY3CHAR;
				vga_pos(15 downto 0)	<= ENEMY3POS;
				
				ENEMY3POSA <= ENEMY3POS;   -- Pos Anterior = Pos Atual
				videoflag <= '1';
				VIDEOE <= x"0B";
			WHEN x"0B" =>
				videoflag <= '0';
				VIDEOE <= x"0C";
					
			WHEN x"0C" => -- Apaga link
				if(LINKPOSA = LINKPOS) then
					VIDEOE <= x"10";
				else
									
					vga_char(15 downto 12) <= "0000";
					vga_char(11 downto 8) <= "0000";
					vga_char(7 downto 0) <= "00000000";
					
					vga_pos(15 downto 0)	<= LINKPOSA;
					
					videoflag <= '1';
					VIDEOE <= x"0D";
				end if;
			WHEN x"0D" =>
				videoflag <= '0';
				VIDEOE <= x"0E";
			WHEN x"0E" => -- Desenha Link
				
				vga_char(15 downto 12) <= "0000";
				vga_char(11 downto 8) <= LINKCOR;
				vga_char(7 downto 0) <= LINKCHAR;
				
				vga_pos(15 downto 0)	<= LINKPOS;
				
				LINKPOSA <= LINKPOS;
				videoflag <= '1';
				VIDEOE <= x"0F";
			WHEN x"0F" =>
				videoflag <= '0';
				VIDEOE <= x"10";	
			
			WHEN x"10" => -- Apaga Flecha link
				if(FLECHAPOSA = FLECHAPOS) then
					VIDEOE <= x"14";
				else
									
					vga_char(15 downto 12) <= "0000";
					vga_char(11 downto 8) <= "0000";
					vga_char(7 downto 0) <= "00000000";
					
					vga_pos(15 downto 0)	<= FLECHAPOSA;
					
					videoflag <= '1';
					VIDEOE <= x"11";
				end if;
			WHEN x"11" =>
				videoflag <= '0';
				VIDEOE <= x"12";
			WHEN x"12" => -- Desenha Flecha Link
				
				vga_char(15 downto 12) <= "0000";
				vga_char(11 downto 8) <= FLECHACOR;
				vga_char(7 downto 0) <= FLECHACHAR;
				
				vga_pos(15 downto 0)	<= FLECHAPOS;
				
				FLECHAPOSA <= FLECHAPOS;
				videoflag <= '1';
				VIDEOE <= x"13";
			WHEN x"13" =>
				videoflag <= '0';
				VIDEOE <= x"14";
				
			WHEN x"14" => -- Apaga flecha enemy2
				if(ENEMY2FLECHAPOSA = ENEMY2FLECHAPOS) then
					VIDEOE <= x"18";
				else
									
					vga_char(15 downto 12) <= "0000";
					vga_char(11 downto 8) <= "0000";
					vga_char(7 downto 0) <= "00000000";
					
					vga_pos(15 downto 0)	<= ENEMY2FLECHAPOSA;
					
					videoflag <= '1';
					VIDEOE <= x"15";
				end if;
			WHEN x"15" =>
				videoflag <= '0';
				VIDEOE <= x"16";
			WHEN x"16" => -- Desenha flecha enemy2
				
				vga_char(15 downto 12) <= "0000";
				vga_char(11 downto 8) <= ENEMY2FLECHACOR;
				vga_char(7 downto 0) <= ENEMY2FLECHACHAR;
				
				vga_pos(15 downto 0)	<= ENEMY2FLECHAPOS;
				
				ENEMY2FLECHAPOSA <= ENEMY2FLECHAPOS;
				videoflag <= '1';
				VIDEOE <= x"17";
			WHEN x"17" =>
				videoflag <= '0';
				VIDEOE <= x"00";
			WHEN x"18" =>   --Apaga menu
				vga_char(15 downto 12) <= "0000";
				vga_char(11 downto 8) <= "0000";
				vga_char(7 downto 0) <= "00000000";
					
				vga_pos(15 downto 0)	<= x"0000";
					
				videoflag <= '1';
				VIDEOE <= x"15";
			WHEN x"19" =>
				videoflag <= '0';
				VIDEOE <= x"1A";
			WHEN x"1A" => -- Desenha menu
				CASE num IS
					WHEN 0 =>		--P
						vga_char(15 downto 12) <= "0000";
						vga_char(11 downto 8) <= LETRACOR;
						vga_char(7 downto 0) <= PCHAR;
				
						vga_pos(15 downto 0)	<= P1POS
					WHEN 1 =>		--R
						vga_char(15 downto 12) <= "0000";
						vga_char(11 downto 8) <= LETRACOR;
						vga_char(7 downto 0) <= RCHAR;
				
						vga_pos(15 downto 0)	<= R1POS
					WHEN 2 =>		--E
						vga_char(15 downto 12) <= "0000";
						vga_char(11 downto 8) <= LETRACOR;
						vga_char(7 downto 0) <= ECHAR;
				
						vga_pos(15 downto 0)	<= E1POS
					WHEN 3 =>		--S
						vga_char(15 downto 12) <= "0000";
						vga_char(11 downto 8) <= LETRACOR;
						vga_char(7 downto 0) <= SCHAR;
				
						vga_pos(15 downto 0)	<= S1POS
					WHEN 4 =>		--S
						vga_char(15 downto 12) <= "0000";
						vga_char(11 downto 8) <= LETRACOR;
						vga_char(7 downto 0) <= SCHAR;
				
						vga_pos(15 downto 0)	<= S2POS
					WHEN 5 =>		--S
						vga_char(15 downto 12) <= "0000";
						vga_char(11 downto 8) <= LETRACOR;
						vga_char(7 downto 0) <= SCHAR;
				
						vga_pos(15 downto 0)	<= S3POS
					WHEN 6 =>		--P
						vga_char(15 downto 12) <= "0000";
						vga_char(11 downto 8) <= LETRACOR;
						vga_char(7 downto 0) <= PCHAR;
				
						vga_pos(15 downto 0)	<= P2POS
					WHEN 7 =>		--A
						vga_char(15 downto 12) <= "0000";
						vga_char(11 downto 8) <= LETRACOR;
						vga_char(7 downto 0) <= ACHAR;
				
						vga_pos(15 downto 0)	<= A1POS
					WHEN 8 =>		--C
						vga_char(15 downto 12) <= "0000";
						vga_char(11 downto 8) <= LETRACOR;
						vga_char(7 downto 0) <= CCHAR;
				
						vga_pos(15 downto 0)	<= CPOS
					WHEN 9 =>		--E
						vga_char(15 downto 12) <= "0000";
						vga_char(11 downto 8) <= LETRACOR;
						vga_char(7 downto 0) <= ECHAR;
				
						vga_pos(15 downto 0)	<= E1POS
					WHEN 10 =>		--T
						vga_char(15 downto 12) <= "0000";
						vga_char(11 downto 8) <= LETRACOR;
						vga_char(7 downto 0) <= TCHAR;
				
						vga_pos(15 downto 0)	<= T1POS
					WHEN 11 =>		--O
						vga_char(15 downto 12) <= "0000";
						vga_char(11 downto 8) <= LETRACOR;
						vga_char(7 downto 0) <= OCHAR;
				
						vga_pos(15 downto 0)	<= OPOS
					WHEN 12 =>		--S
						vga_char(15 downto 12) <= "0000";
						vga_char(11 downto 8) <= LETRACOR;
						vga_char(7 downto 0) <= SCHAR;
				
						vga_pos(15 downto 0)	<= S4POS
					WHEN 13 =>		--T
						vga_char(15 downto 12) <= "0000";
						vga_char(11 downto 8) <= LETRACOR;
						vga_char(7 downto 0) <= TCHAR;
				
						vga_pos(15 downto 0)	<= T2POS
					WHEN 14 =>		--A
						vga_char(15 downto 12) <= "0000";
						vga_char(11 downto 8) <= LETRACOR;
						vga_char(7 downto 0) <= ACHAR;
				
						vga_pos(15 downto 0)	<= A2POS
					WHEN 15 =>		--R
						vga_char(15 downto 12) <= "0000";
						vga_char(11 downto 8) <= LETRACOR;
						vga_char(7 downto 0) <= RCHAR;
				
						vga_pos(15 downto 0)	<= R2POS
					WHEN 16 =>		--T
						vga_char(15 downto 12) <= "0000";
						vga_char(11 downto 8) <= LETRACOR;
						vga_char(7 downto 0) <= TCHAR;
				
						vga_pos(15 downto 0)	<= T3POS
				END CASE;
				num := num + 1;
				IF num = 17 THEN
					num := 0;
				END IF;
				videoflag <= '1';
				VIDEOE <= x"1B";
				IF VIDEO_FLAG_EXIT = '1' THEN
					VIDEOE <= x"00";
				END IF;
			WHEN x"1B" =>
				videoflag <= '0';
				VIDEOE <= x"1A";
			WHEN x"1C" => --END GAME
				CASE num1 IS
					WHEN 0 =>		--T
						vga_char(15 downto 12) <= "0000";
						vga_char(11 downto 8) <= LETRACOR;
						vga_char(7 downto 0) <= TCHAR;
				
						vga_pos(15 downto 0)	<= T_ENDPOS
					WHEN 1 =>		--H
						vga_char(15 downto 12) <= "0000";
						vga_char(11 downto 8) <= LETRACOR;
						vga_char(7 downto 0) <= HCHAR;
				
						vga_pos(15 downto 0)	<= H_ENDPOS
					WHEN 2 =>		--E
						vga_char(15 downto 12) <= "0000";
						vga_char(11 downto 8) <= LETRACOR;
						vga_char(7 downto 0) <= ECHAR;
				
						vga_pos(15 downto 0)	<= E1_ENDPOS
					WHEN 3 =>		--E
						vga_char(15 downto 12) <= "0000";
						vga_char(11 downto 8) <= LETRACOR;
						vga_char(7 downto 0) <= ECHAR;
				
						vga_pos(15 downto 0)	<= E2_ENDPOS
					WHEN 4 =>		--N
						vga_char(15 downto 12) <= "0000";
						vga_char(11 downto 8) <= LETRACOR;
						vga_char(7 downto 0) <= NCHAR;
				
						vga_pos(15 downto 0)	<= N_ENDPOS
					WHEN 5 =>		--D
						vga_char(15 downto 12) <= "0000";
						vga_char(11 downto 8) <= LETRACOR;
						vga_char(7 downto 0) <= DCHAR;
				
						vga_pos(15 downto 0)	<= D_ENDPOS
				END CASE;
				num1 := num1 + 1;
				IF num1 = 6 THEN
					num1 := 0;
				END IF;
				videoflag <= '1';
				VIDEOE <= x"1B";
				
			WHEN OTHERS =>
				videoflag <= '0';
				VIDEOE <= x"00";
		END CASE;
	END IF;
END PROCESS;
	
--PROCESS (videoflag, video_set)
--BEGIN
--  IF video_set = '1' THEN video_ready <= '0';
--  ELSIF videoflag'EVENT and videoflag = '1' THEN video_ready <= '1';
--  END IF;
--END PROCESS;

END a;
