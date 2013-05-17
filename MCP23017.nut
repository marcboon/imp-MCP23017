class MCP23017
{
    REG_ADDR = 
    {
        A = {
            IODIR = 0x00
            IOPOL = 0x02
            GPINTEN = 0x04
            DEFVAL = 0x06
            INTCON = 0x08
            IOCON = 0x0A
            GPPU = 0x0C
            INTF = 0x0E
            INTCAP = 0x10
            GPIO = 0x12
            OLAT = 0x14
        }
        B = {
            IODIR = 0x01
            IOPOL = 0x03
            GPINTEN = 0x05
            DEFVAL = 0x07
            INTCON = 0x09
            IOCON = 0x0B
            GPPU = 0x0D
            INTF = 0x0F
            INTCAP = 0x11
            GPIO = 0x13
            OLAT = 0x15
        }
    }
    i2cPort = null;
    i2cAddress = null;
    
    constructor(port, address)
    {
        if(port == I2C_12)
        {
            // Configure I2C bus on pins 1 & 2
            hardware.configure(I2C_12);
            i2cPort = hardware.i2c12;
        }
        else if(port == I2C_89)
        {
            // Configure I2C bus on pins 8 & 9
            hardware.configure(I2C_89);
            i2cPort = hardware.i2c89;
        }
        else
        {
            server.log("Invalid I2C port specified.");
        }
 
        i2cAddress = address << 1;
    }
    
    // Read a byte
    function read(reg)
    {
        local data = i2cPort.read(i2cAddress, format("%c", reg), 1);
        if(data == null)
        {
            server.log("I2C Read Failure");
            return -1;
        }
 
        return data[0];
    }
    
    // Write a byte
    function write(reg, data)
    {
        i2cPort.write(i2cAddress, format("%c%c", reg, data));
    }
    
    // Write a bit to a register
    function writeBit(reg, bitn, level)
    {
        local value = read(reg);
        value = (level == 0)?(value & ~(1<<bitn)):(value | (1<<bitn));
        write(reg, value);
    }
    
    function setValueForRegister(gpio, reg, port, value) {
        writeBit(REG_ADDR[port][reg], gpio&7, value);
    }
    
    function getValueForRegister(gpio, reg, port) {
        return (read(REG_ADDR[port][reg])&(1<<(gpio&7)))?1:0;
    }
    
    // Set a GPIO direction
    function setDir(gpio, port, input)
    {
        setValueForRegister(gpio, "IODIR", port, (input?1:0))
    }
    
    // Get a GPIO direction
    function getDir(gpio, port)
    {
        return getValueForRegister(gpio, "IODIR", port)
    }
    
    function setPolarity(gpio, port, reversed)
    {
        setValueForRegister(gpio, "IOPOL", port, reversed?1:0);
    }
    
    function getPolarity(gpio, port)
    {
        return getValueForRegister(gpio, "IOPOL", port)
    }
    
    function setInterrupt(gpio, port, do_interrupt)
    {
        setValueForRegister(gpio, "GPINTEN", port, do_interrupt?1:0);
    }
    
    function getInterrupt(gpio, port)
    {
        return getValueForRegister(gpio, "GPINTEN", port)
    }
    
    function setDefaultValue(gpio, port, default_value)
    {
        setValueForRegister(gpio, "DEFVAL", port, default_value?1:0);
    }
    
    function getDefaultValue(gpio, port)
    {
        return getValueForRegister(gpio, "DEFVAL", port)
    }
    
    function setInterruptCompare(gpio, port, against_default)
    {
        setValueForRegister(gpio, "INTCON", port, against_default?1:0);
    }
    
    function getInterruptCompare(gpio, port)
    {
        return getValueForRegister(gpio, "INTCON", port)
    }
    
    function setPullUp(gpio, port, pull_up)
    {
        setValueForRegister(gpio, "GPPU", port, pull_up?1:0);
    }
    
    function getPullUp(gpio, port)
    {
        return getValueForRegister(gpio, "GPPU", port)
    }
    
    function getInterruptCondition(gpio, port)
    {
        return getValueForRegister(gpio, "GPINTEN", port)
    }
    
    function getInterruptCapture(gpio, port)
    {
        return getValueForRegister(gpio, "INTCAP", port)
    }
    
    // Set a GPIO level
    function setPin(gpio, port, level)
    {
        setValueForRegister(gpio, "GPIO", port, level?1:0);
    }
    
    // Get a GPIO input pin level
    function getPin(gpio, port)
    {
        return getValueForRegister(gpio, "GPIO", port)
    }

    function setLatch(gpio, port, level)
    {
        setValueForRegister(gpio, "OLAT", port, level?1:0);
    }
    
    function getLatch(gpio, port)
    {
        return getValueForRegister(gpio, "OLAT", port)
    }
}
