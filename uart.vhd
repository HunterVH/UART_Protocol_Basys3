library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart is
    port(i_clk, i_rst, i_sdata : in std_logic;
         o_busy, o_sdata : out std_logic;
         o_pdata : out std_logic_vector(7 downto 0));
end uart;

architecture Behavioral of uart is
-- Signals
signal w_RX_done : std_logic;
signal w_RX_byte : std_logic_vector(7 downto 0);

begin
    receiver : entity work.receiver
        generic map(g_CYCLE_COUNT => 868)
        port map(i_clk => i_clk,
                 i_rst => i_rst,
                 i_sdata => i_sdata,
                 o_ready => w_RX_done,
                 o_pdata => w_RX_byte);
    
    flip_flop_byte : entity work.FLIP_FLOP
        generic map(g_SIZE => 8)
        port map(i_clk => i_clk,
                 i_en => w_RX_done,
                 i_rst => i_rst,
                 i_Data => w_RX_byte,
                 o_Data => o_pdata);
                 
    transmitter : entity work.transmitter
        generic map(g_CYCLE_COUNT => 868)
        port map(i_clk => i_clk,
                 i_rst => i_rst,
                 i_load => w_RX_done,
                 i_pdata => w_RX_byte,
                 o_busy => o_busy,
                 o_sdata => o_sdata);

end Behavioral;
