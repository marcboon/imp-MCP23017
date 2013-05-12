/*
 Device address specified by data sheet
 (http://ww1.microchip.com/downloads/en/devicedoc/21952b.pdf)
 is 01000UUU where the "U"s are user defined bits.
 I am making the assumption that all of these bits are
 set to 0. The MCP23017 class constructor shifts the address over one to
 make room for the final bit, which specifies read vs write,
 so I am leaving this address one position to the right of where the
 final control bit will be
 */
io_address <- (1 << 5);
theio <- MCP23017(I2C_12, io_address);

// Blink between the lights on pins 0 and 1 on port A

// Output is 0, Input is 1
theio.setDir(0, "A", 0)
theio.setDir(1, "A", 0)
theio.setPin(0, "A", 1)
theio.setPin(1, "A", 0)
current_pin_state <- theio.getLatch(0, "A")
server.log("initial pin state is " + current_pin_state)
server.log("pin 1 direction is " + theio.getDir(1, "A"))

theio.setPolarity(0, "B", 1)
server.log("pin 0 port B polarity is " + theio.getPolarity(0, "B"))
server.log("pin 0 port A polarity is " + theio.getPolarity(0, "A"))

theio.setInterrupt(0, "B", 1)
server.log("pin 0 port B interrupt is " + theio.getInterrupt(0, "B"))
server.log("pin 0 port A interrupt is " + theio.getInterrupt(0, "A"))

theio.setDefaultValue(0, "B", 1)
server.log("pin 0 port B default is " + theio.getDefaultValue(0, "B"))
server.log("pin 0 port A default is " + theio.getDefaultValue(0, "A"))

theio.setInterruptCompare(0, "B", 1)
server.log(("pin 0 port B interrupt compare is " + (theio.getInterruptCompare(0, "B")?"default":"previous value")))
server.log(("pin 0 port A interrupt compare is " + (theio.getInterruptCompare(0, "A")?"default":"previous value")))

theio.setPullUp(0, "B", 1)
server.log("pin 0 port B pull up enabled is " + theio.getPullUp(0, "B"))
server.log("pin 0 port A pull up enabled is " + theio.getPullUp(0, "A"))

server.log("pin 0 port A interrupt condition is " + theio.getInterruptCondition(0, "A"))

function reverse_pin_state() {
    if (current_pin_state) {
        theio.setPin(0, "A", 0)
        theio.setPin(1, "A", 1)
        current_pin_state = 0
    } else {
        theio.setPin(0, "A", 1)
        theio.setPin(1, "A", 0)
        current_pin_state = 1
    }
}

for (local i = 100; i > 0; i--) {
    imp.sleep(0.1)
    reverse_pin_state()
}

