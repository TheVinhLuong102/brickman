/*
 * brickman -- Brick Manager for LEGO MINDSTORMS EV3/ev3dev
 *
 * Copyright 2015 David Lechner <david@lechnology.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301, USA.
 */

/* FileBrowserController.vala - File Browser controller */

using Linux.Input;

namespace BrickManager {

    /**
     * Program-defined LED states.
     *
     * Brickman uses the LEDs on the EV3 to provide feedback to the user using
     * these states.
     */
    public enum LedState {
        /**
         * Indicates that brickman is running normally (ready for input).
         */
        NORMAL,

        /**
         * Indicates that brickman is busy and will not respond to input.
         */
        BUSY,

        /**
         * Indicates that user program is running.
         */
        USER
    }

    /**
     * Object for hosting global instances of various managers used in brickman
     */
    public class GlobalManager : Object {
        bool have_ev3_leds = false;
        Ev3devKit.Devices.Led ev3_left_green_led;
        Ev3devKit.Devices.Led ev3_right_green_led;
        Ev3devKit.Devices.Led ev3_left_red_led;
        Ev3devKit.Devices.Led ev3_right_red_led;

        /**
         * Gets the device manager for interacting with hardware devices.
         */
        public Ev3devKit.Devices.DeviceManager device_manager { get; private set; }

        public GlobalManager () {
            device_manager = new Ev3devKit.Devices.DeviceManager ();
            if (Ev3devKit.Devices.Cpu.get_model ().has_prefix ("LEGO MINDSTORMS EV3")) {
                try {
                    ev3_left_green_led = device_manager.get_led (
                        Ev3devKit.Devices.Led.EV3_LEFT, "green");
                    ev3_right_green_led = device_manager.get_led (
                        Ev3devKit.Devices.Led.EV3_RIGHT, "green");
                    ev3_left_red_led = device_manager.get_led (
                        Ev3devKit.Devices.Led.EV3_LEFT, "red");
                    ev3_right_red_led = device_manager.get_led (
                        Ev3devKit.Devices.Led.EV3_RIGHT, "red");
                    have_ev3_leds = true;
                } catch (Error err) {
                    warning ("%s", err.message);
                }
            }
        }

        public void set_leds (LedState state) {
            if (!have_ev3_leds)
                return;
            try {
                switch (state) {
                case LedState.NORMAL:
                    ev3_left_green_led.set_trigger ("default-on");
                    ev3_right_green_led.set_trigger ("default-on");
                    ev3_left_red_led.set_trigger ("none");
                    ev3_left_red_led.set_brightness (0);
                    ev3_right_red_led.set_trigger ("none");
                    ev3_right_red_led.set_brightness (0);
                    break;
                case LedState.BUSY:
                    ev3_left_green_led.set_trigger ("none");
                    ev3_left_green_led.set_brightness (0);
                    ev3_right_green_led.set_trigger ("none");
                    ev3_right_green_led.set_brightness (0);
                    ev3_left_red_led.set_trigger ("default-on");
                    ev3_right_red_led.set_trigger ("default-on");
                    break;
                case LedState.USER:
                    ev3_left_green_led.set_trigger ("default-on");
                    ev3_right_green_led.set_trigger ("default-on");
                    ev3_left_red_led.set_trigger ("default-on");
                    ev3_right_red_led.set_trigger ("default-on");
                    break;
                }
            } catch (Error err) {
                critical ("%s", err.message);
            }
        }
    }
}
