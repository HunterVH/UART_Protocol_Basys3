----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/16/2025 11:47:14 PM
-- Design Name: 
-- Module Name: transmitter - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity transmitter is
    generic(g_CYCLE_COUNT : integer := 868);
    port ( i_clk : in std_logic;
           i_rst : in std_logic;
           i_load : in std_logic;
           i_pdata : in std_logic_vector(7 downto 0);
           o_busy : out std_logic;
           o_sdata : out std_logic);
end transmitter;

architecture Behavioral of transmitter is
-- Types
type state_type is (IDLE, ACCEPTING, TX);

-- Signals
signal r_baud_counter : integer;
signal r_bit_counter : integer;
signal r_input_byte : std_logic_vector(9 downto 0);
signal r_output_bit : std_logic;
signal r_busy : std_logic;
signal r_curr_state : state_type;


begin

    process(i_clk) begin
        if rising_edge(i_clk) then
            if i_rst = '1' then
                r_curr_state <= IDLE;
                r_input_byte <= (others => '0');
                r_output_bit <= '0';
                r_baud_counter <= 0;
                r_bit_counter <= 0;
            else
                case r_curr_state is
                    when IDLE =>
                        if i_load = '0' then
                            r_output_bit <= '1';
                            r_busy <= '0';
                            r_curr_state <= IDLE;
                        else
                            r_busy <= '1';
                            r_curr_state <= ACCEPTING;
                        end if;
                    when ACCEPTING =>
                        r_output_bit <= '1';
                        r_input_byte <= '1' & i_pdata & '0'; -- Adds a start and stop bit
                        r_bit_counter <= 0;
                        r_baud_counter <= 0;
                        r_curr_state <= TX;
                    when TX =>
                        r_busy <= '1';
                        if r_bit_counter < 10 then
                            if r_baud_counter < g_CYCLE_COUNT-1 then
                                r_baud_counter <= r_baud_counter+1;
                            else
                                r_bit_counter <= r_bit_counter+1;
                                r_baud_counter <= 0;
                            end if;
                            r_output_bit <= r_input_byte(r_bit_counter);
                            r_curr_state <= TX;
                        else
                            r_curr_state <= IDLE; 
                        end if;
                end case;
            end if;
        end if;
    end process;
    
    o_sdata <= r_output_bit;
    o_busy <= r_busy;

end Behavioral;
