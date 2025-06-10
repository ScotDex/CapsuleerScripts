# Load the required assembly
Add-Type -AssemblyName System.Windows.Forms

# Function to simulate key press
function Press-Key {
    param (
        [Parameter(Mandatory = $true)]
        [System.Windows.Forms.Keys]$key
    )

    Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;
    public class Keyboard {
        [DllImport("user32.dll", CharSet = CharSet.Auto, ExactSpelling = true)]
        public static extern void keybd_event(byte bVk, byte bScan, int dwFlags, int dwExtraInfo);
    }
"@

    # Define key down and key up event constants
    $KEYEVENTF_KEYDOWN = 0x0000
    $KEYEVENTF_KEYUP = 0x0002

    # Press key down
    [Keyboard]::keybd_event([byte]$key, 0, $KEYEVENTF_KEYDOWN, 0)
    # Release key up
    [Keyboard]::keybd_event([byte]$key, 0, $KEYEVENTF_KEYUP, 0)
}

# Example of pressing the 'V' key every 10 seconds
while ($true) {
    Press-Key -key ([System.Windows.Forms.Keys]::V)
    Start-Sleep -Seconds 10
}

