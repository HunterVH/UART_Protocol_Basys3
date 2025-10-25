----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/07/2025 01:00:29 AM
-- Design Name: 
-- Module Name: FLIP_FLOP - Behavioral
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

entity FLIP_FLOP is
    generic(g_SIZE : integer := 8);
    Port(i_clk : in std_logic;
         i_en : in std_logic;
         i_rst : in std_logic;
         i_Data : in std_logic_vector(g_SIZE-1 downto 0);
         o_Data : out std_logic_vector(g_SIZE-1 downto 0));
end FLIP_FLOP;

architecture Behavioral of FLIP_FLOP is
-- Signal
signal r_Data : std_logic_vector(g_SIZE-1 downto 0);

begin
    process(i_clk) begin
        if rising_edge(i_clk) then
            if i_rst = '1' then
                r_Data <= (others => '0');
            elsif i_en = '1' then
                r_Data <= i_Data;
            else
                r_Data <= r_Data;
            end if;
        end if;
    end process;
    o_Data <= r_Data;    
end Behavioral;
