class MCP23008
{
    REG_ADDR =
    {
        IODIR = 0x00
        IOPOL = 0x01
        GPINTEN = 0x02
        DEFVAL = 0x03
        INTCON = 0x04
        IOCON = 0x05
        GPPU = 0x06
        INTF = 0x07
        INTCAP = 0x08
        GPIO = 0x09
        OLAT = 0x0A
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
    
    function setValueForRegister(gpio, reg, value) {
        writeBit(REG_ADDR[reg], gpio&7, value);
    }
    
    function getValueForRegister(gpio, reg) {
        return (read(REG_ADDR[reg])&(1<<(gpio&7)))?1:0;
    }
    
    // Set a GPIO direction
    function setDir(gpio, input)
    {
        setValueForRegister(gpio, "IODIR", (input?1:0))
    }
    
    // Get a GPIO direction
    function getDir(gpio)
    {
        return getValueForRegister(gpio, "IODIR")
    }
    
    function setPolarity(gpio, reversed)
    {
        setValueForRegister(gpio, "IOPOL", reversed?1:0);
    }
    
    function getPolarity(gpio)
    {
        return getValueForRegister(gpio, "IOPOL")
    }
    
    function setInterrupt(gpio, do_interrupt)
    {
        setValueForRegister(gpio, "GPINTEN", do_interrupt?1:0);
    }
    
    function getInterrupt(gpio)
    {
        return getValueForRegister(gpio, "GPINTEN")
    }
    
    function setDefaultValue(gpio, default_value)
    {
        setValueForRegister(gpio, "DEFVAL", default_value?1:0);
    }
    
    function getDefaultValue(gpio)
    {
        return getValueForRegister(gpio, "DEFVAL")
    }
    
    function setInterruptCompare(gpio, against_default)
    {
        setValueForRegister(gpio, "INTCON", against_default?1:0);
    }
    
    function getInterruptCompare(gpio)
    {
        return getValueForRegister(gpio, "INTCON")
    }
    
    function setPullUp(gpio, pull_up)
    {
        setValueForRegister(gpio, "GPPU", pull_up?1:0);
    }
    
    function getPullUp(gpio)
    {
        return getValueForRegister(gpio, "GPPU")
    }
    
    function getInterruptCondition(gpio)
    {
        return getValueForRegister(gpio, "GPINTEN")
    }
    
    function getInterruptCapture(gpio)
    {
        return getValueForRegister(gpio, "INTCAP")
    }
    
    // Set a GPIO level
    function setPin(gpio, level)
    {
        setValueForRegister(gpio, "GPIO", level?1:0);
    }
    
    // Get a GPIO input pin level
    function getPin(gpio)
    {
        return getValueForRegister(gpio, "GPIO")
    }

    function setLatch(gpio, level)
    {
        setValueForRegister(gpio, "OLAT", level?1:0);
    }
    
    function getLatch(gpio)
    {
        return getValueForRegister(gpio, "OLAT")
    }
}
