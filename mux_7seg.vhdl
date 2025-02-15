library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_7seg is
    Port ( bcd_unidades : in STD_LOGIC_VECTOR (3 downto 0);
           bcd_dezenas : in STD_LOGIC_VECTOR (3 downto 0);
           bcd_centenas : in STD_LOGIC_VECTOR (3 downto 0);
           bcd_milhares : in STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           an : out STD_LOGIC_VECTOR (3 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           dp : out STD_LOGIC);
end mux_7seg;

architecture Behavioral of mux_7seg is

     component driver_bcd_7 is
        port(sw : in STD_LOGIC_VECTOR (3 downto 0);
             seg : out STD_LOGIC_VECTOR (6 downto 0));
    end component;
    
    signal clk_dividido : STD_LOGIC:='0';
    signal counter: integer range 1 to 100_000:= 1;
    signal seletor_display : integer range 1 to 4:=1; 
    signal s_an, bcd_now : STD_LOGIC_VECTOR (3 downto 0);
    
begin

   --------------divisor de clock-----------
   
   divisor_clk : process(clk)
   begin
   
        if rising_edge(clk) then      
            if counter =100_000 then 
                counter <= 1;
                clk_dividido <= not clk_dividido;
            else
                counter <= counter + 1;            
            end if;
        end if;
   end process;
   
   
   ---------------multiplexação do display-----------------
   multiplexacacao: process(clk_dividido)
   begin
         if rising_edge (clk_dividido) then
            
            case seletor_display is
                when 1 => s_an <= "1110"; bcd_now <= bcd_unidades;
                when 2 => s_an <= "1101"; bcd_now <= bcd_dezenas;
                when 3 => s_an <= "1011"; bcd_now <= bcd_centenas;
                when 4 => s_an <= "0111"; bcd_now <= bcd_milhares;
                when others => null;
            end case;
            seletor_display <= seletor_display +1;
         end if; 
   end process;


    an <= s_an;
    dr_bcd: driver_bcd_7 port map (sw => bcd_now, seg=> seg);
    dp <= '1';
end Behavioral;
