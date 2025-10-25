----------------------------------------------------------------------------------
-- Engineer: Hunter Van Horn
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity receiver is
    generic(g_CYCLE_COUNT : Integer := 868);            -- Baud Rate: 115200 based on a 100MHz Clock
    port(i_clk, i_rst, i_sdata : in std_logic;
         o_ready : out std_logic;
         o_pdata : out std_logic_vector(7 downto 0));
end receiver;

architecture Behavioral of receiver is
-- Types
Type state_type is (IDLE, START, RX, STOP);

-- Signals
signal r_input_bit : std_logic;
signal r_ready : std_logic;
signal r_output_byte : std_logic_vector(7 downto 0);
signal r_curr_state : state_type;
signal r_next_state : state_type;
signal r_baud_counter : integer;
signal r_bit_counter : integer;

begin
    r_input_bit <= i_sdata;

    process(i_clk) begin
        if rising_edge(i_clk) then                  -- Rst clears the 
            if i_rst = '1' then
                r_curr_state <= IDLE;
            end if;
            case r_curr_state is
                when IDLE =>
                    r_baud_counter <= 0;
                    r_bit_counter <= 0;
                    r_ready <= '0';
                    if r_input_bit = '0' then
                        r_curr_state <= START;
                    end if;
                when START =>
                    r_bit_counter <= 0;
                    if r_baud_counter >= g_CYCLE_COUNT/2 then   -- Sets to read from the middle of the signal
                        r_baud_counter <= 0;
                        r_bit_counter <= 0;
                        r_curr_state <= RX;
                    else
                        r_baud_counter <= r_baud_counter+1;
                    end if;
                when RX =>
                    if r_bit_counter >= 8 then
                        r_baud_counter <= 0;
                        r_curr_state <= STOP;
                    elsif r_baud_counter >= g_CYCLE_COUNT then     -- Waits one full cycle (determined by the generic) to read a value
                        r_baud_counter <= 0;
                        r_output_byte(r_bit_counter) <= r_input_bit;
                        r_bit_counter <= r_bit_counter+1;
                    else
                        r_baud_counter <= r_baud_counter+1;
                    end if;
                when STOP =>
                    r_ready <= '1';
                    if r_baud_counter > g_CYCLE_COUNT then
                        if r_input_bit = '1' then       -- A correct stop bit
                            r_ready <= '0';
                            r_curr_state <= IDLE;
                        else                            -- An incorrect stop bit(Could impliment error logic, for later)
                            r_curr_state <= IDLE;
                        end if;
                    else
                        r_baud_counter <= r_baud_counter+1;
                    end if;
            end case;
        end if;
    end process;
    
    o_ready <= r_ready;
    o_pdata <= r_output_byte;

end Behavioral;
