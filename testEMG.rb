require "serialport"

port_eeg = "/dev/tty.usbmodem1411"
port_emg = "/dev/tty.usbmodem1421"

eeg = SerialPort.new(port_eeg, 9600, 8, 1, SerialPort::NONE)
emg = SerialPort.new(port_emg, 9600, 8, 1, SerialPort::NONE)

$max = 0.00

while (j = emg.gets.chomp) do       # see note 2
  x = j.to_f
  if x > $max
    $max = x
    puts $max
  end
end
emg.close
